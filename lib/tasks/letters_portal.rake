# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

namespace :bp1step do
  desc 'Create Letters from Portal CB RF'
  # создание новых писем из файлов, принятых и расшифрованных с Портала Банка России
  task letters_from_portal_cb: :environment do
    PublicActivity.enabled = false # отключить протоколирование изменений
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :letters_from_portal_cb'

    path_from_portal = Rails.root.join(Rails.configuration.x.letters.path_to_portal, 'in')
    logger.info path_from_portal.to_s
    ## puts path_from_portal.to_s

    # .select {|entry| File.directory? File.join('/your_dir',entry) and !(entry =='.' || entry == '..') }
    dirs = 0
    Dir.entries(path_from_portal).reject { |entry| ['..', '.'].include? entry }.each do |entry|
      next unless File.directory? path_from_portal.join(entry) # process only directories

      check_directory path_from_portal.join(entry)
      dirs += 1
    end
    logger.info "      #{dirs} directories processed"
  end

  desc 'Remove old directories with files from Portal CB RF'
  # удаление папок старых сообщений, принятых с Портала Банка России
  task letters_from_portal_cb_destroy_old_directories: :environment do
    PublicActivity.enabled = false # отключить протоколирование изменений
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info "===== #{Time.current.strftime('%d.%m.%Y %H:%M:%S')} :letters_from_portal_cb_destroy_old_directories"

    path_from_portal = Rails.root.join(Rails.configuration.x.letters.path_to_portal, 'in')
    logger.info path_from_portal.to_s
    dirs = 0
    deleted_dirs = 0
    Dir.entries(path_from_portal).reject { |entry| ['..', '.'].include? entry }.each do |entry|
      next unless File.directory? path_from_portal.join(entry) # process only directories

      message_id = File.basename entry
      directory_name = path_from_portal.join(entry)
      next unless File.file? directory_name.join(message_id + '.json') # отсутствует сообщение
      next unless File.file? directory_name.join(message_id + '.bp1step') # папка не обработана BP1Step

      letter = nil
      File.open directory_name.join(message_id + '.bp1step') do |f|
        letter = Letter.where(id: f.gets).first
      end

      next unless letter

      next unless letter.created_at < Time.zone.today - 6.days

      Dir.each_child(directory_name) { |file| File.delete directory_name.join(file) }
      Dir.each_child(directory_name) { |file| p file }
      Dir.entries(directory_name)
      deleted_dirs += 1
      Dir.delete directory_name
    end
    logger.info "      #{dirs} directories processed, #{deleted_dirs} old directories deleted"
  end

  private

  def check_directory(name)
    return unless File.file? name.join('flag.txt')

    message_id = File.basename name
    create_letter_from_json name, message_id unless ['.', '..'].include? message_id
  end

  def create_letter_from_json(name, id)
    json_file_name = name.join(id + '.json')
    return unless File.file? json_file_name # отсутствует сообщение
    return if File.file? name.join(id + '.bp1step') # папка уже обработана BP1Step

    json_file = File.read(json_file_name)
    json = JSON.parse json_file
    subject = json['Text']
    subject = json['Title'] if subject.nil?
    reg_number = json['RegNumber'] || '-'

    letter = Letter.new(status: 0, number: reg_number, sender: get_sender(name),
                        subject: subject[0..199], source: 'Портал5 БР')
    letter.date = Date.parse json['CreationDate'] || Time.current
    letter.duedate = (Time.current + 10.days).strftime('%d.%m.%Y') # срок исполнения - даем 10 дней по умолчанию
    letter_files = json['Files']
    letter.body = ''
    letter_files.each do |file|
      letter.body += file['Name'] + "\n" unless file_exclude? file['Name']
    end
    # print letter.inspect
    return unless letter.save! # письмо создали, теперь присоедним файлы

    letter_files.each do |file|
      # print file['Name']
      add_file_to_letter(letter.id, file, id) unless file_exclude? file['Name']
    end
    File.open(name.join(id + '.bp1step'), 'w') { |file| file.write(letter.id.to_s) } # признак обработки данного письма с портала
  end

  def add_file_to_letter(letter_id, file, message_id)
    file_name = file['Name']
    file_name = file_name[0..-9] if file_name.end_with? '.sig.enc'
    file_name = file_name[0..-5] if file_name.end_with? '.enc'
    return if file_name.downcase.start_with? 'список рассылки'

    path_from = Rails.root.join(Rails.configuration.x.letters.path_to_portal, 'in', message_id)
    letter_appendix = LetterAppendix.new(letter_id: letter_id)
    File.open path_from.join(file_name) do |f|
      letter_appendix.appendix = f
      letter_appendix.save!
      letter_appendix.appendix.reprocess!
    end
  end

  def file_exclude?(name)
    return true if name == 'passport.xml'
    return true if ['.sig'].include? File.extname(name).downcase
  end

  def get_sender(name)
    xml_file_name = name.join('passport.xml')
    sender = 'ЦБ ?'
    return 'Отделение Пермь' unless File.file? xml_file_name

    File.open xml_file_name do |f|
      xml = Nokogiri::XML(f)
      organization = xml.xpath('/passport/document/Author/Organization')
      sender = organization[0]['fullname'].to_s unless organization.empty?
    end
    sender
  end
end
# rubocop:enable Metrics/BlockLength
