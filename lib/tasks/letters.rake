# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :bp1step do
  desc 'Create Letters from files in  SVK'
  # создание новых писем из файов в каталоге СВК
  task create_letters_from_files: :environment do
    PublicActivity.enabled = false # отключить протоколирование изменений
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :create_letters_from_files'

    nn = 0
    nf = 0
    files_copied = 0
    path_from_rps = Rails.root.join(Rails.configuration.x.letters.path_to_rps)
    logger.info path_from_rps.to_s

    # обход всех файлов в каталоге с файлами для писем
    Dir.glob(path_from_rps.join('*.*')).each do |file|
      nf += 1
      ext = File.extname(file).upcase
      fname = File.basename(file)                   # расширение файла
      name = fname[0..(fname.size - ext.size - 1)]  # только имя файла
      l_number, l_subject, l_sender = ''
      l_date = Date.current.strftime('%d.%m.%Y')
      l_source = 'СВК'

      next if ext == '.ARJ' # пока не умеем обрабатывать архивы
      next if ext.start_with?('.A0') # и их части

      case name.upcase
      when /\A(OD|ОД)\d{1,}\z/ # ODNNNN.PDF
        l_number = 'ОД-' + name[2..name.size]
        l_sender = 'ЦБ РФ'
        l_subject = 'Об отзыве лицензии / Об уточнении'
      when /\A(OD|ОД)(-)\d{1,}\z/ # OD-NNNN.*
        l_number = 'ОД-' + name[2..name.size]
        l_sender = 'ЦБ РФ'
        l_subject = 'Об отзыве лицензии / Об уточнении'
      when /\A\d{2,}\z/ # NNNN.PDF или NNNN.TIF
        l_number = name
        l_sender = 'Отделение по Пермскому краю ЦБ РФ'
        l_subject = ' ' + name
      when /\AВЕСТНИК БАНКА РОССИИ/ # вестник банка росии
        l_number = name[/№ \d{1,}.*\(.*\)/]
        l_date = name[/\d\d\.\d\d\.\d{1,4}/]
        l_sender = 'Банк России'
        l_subject = "Вестник Банка России #{l_number} от #{l_date}"
      when /\AGR-OT-\d+/                                  # gr-ot-MM.DOC
        l_number = name
        l_sender = 'Отделение по Пермскому краю ЦБ РФ'
        l_subject = 'График представления отчетности в виде электронных сообщений'
      when /\A\d+_U/                                      # Указание БР
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 2]}-У"
        l_sender = 'Банк России'
        l_subject = "Указание Банка России № #{l_number} от #{l_date}"
      when /\A\d+-У/                                      # Указание БР
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 1]}-У"
        l_sender = 'Банк России'
        l_subject = "Указание Банка России № #{l_number} от #{l_date}"
      when /\A\d+(-|_)(П|P)/ # Положение БР
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 1]}-П"
        l_sender = 'Банк России'
        l_subject = "Положение Банка России № #{l_number} от #{l_date}"
      when /\A\d+_MR/                                     # Методические рекомендации
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 2]}-МР"
        l_sender = 'Банк России'
        l_subject = "Методические рекомендации № #{l_number} от #{l_date}"
      when /\A\d+_IN\d+/                                  # Информационное письмо
        l_number = name[/\A\d+_?f?/]
        l_number = "ИН/#{l_number[0..l_number.size - 2]}"
        l_sender = 'Банк России'
        l_subject = "Информационное письмо № #{l_number} от #{l_date}"
      when /\AИН-\d+/ # Информационное письмо
        l_number = name[/\AИН-(\d+-\d+-\d+)/][1]
        l_sender = 'Банк России'
        l_subject = "Информационное письмо № #{l_number} от #{l_date}"
      # исключим справочник банков
      when /BIK_DB\d\d/
        next
      # исключим файлы протоколов
      when /\A(DEPOSIT_LETTERS|GUCB_LETTERS|UBIZI_LETTERS|RECEIPT_LETTERS|GUOST_LETTERS|GUOFORM_LETTERS|ANY_LETTERS)\z/
        next
      when /\AMONIT*/ # исключим файл мониторинга
        next
      when /\AINFSWIFT|INF-KGR\z/ # исключим известные файлы, котрые надо оставить в СВК
        next
      else
        if File.exist?(file) # скопируем в РЕМАРТ перенесем в архив
          # копируем в папку REMART для ручного разбора
          FileUtils.cp file, Rails.root.join('..', '..', 'remart', File.basename(file)).to_s
          # переносим в архив
          File.rename(file, File.join(File.dirname(file), 'ARC', File.basename(file)))
          files_copied += 1
          logger.info "copy #{fname} -> remart"
          next
        end
      end

      next if l_number.blank? # удалось идентифицировать файл

      letter = Letter.new(status: 0, number: l_number, sender: l_sender, subject: l_subject, source: l_source)
      letter.date = Time.current.strftime('%d.%m.%Y')
      letter.duedate = (Time.current + 10.days).strftime('%d.%m.%Y') # срок исполнения - даем 10 дней по умолчанию
      next unless letter.save! # письмо создали, теперь присоедним файл

      nn += 1
      logger.info "##{letter.id} #{name}: \t№#{l_number}\t[#{l_subject}]"
      letter_appendix = LetterAppendix.new(letter_id: letter.id)
      File.open file do |f|
        letter_appendix.appendix = f
        letter_appendix.save!
        letter_appendix.appendix.reprocess!
      end

      File.rename(file, File.join(File.dirname(file), 'ARC', File.basename(file))) if File.exist?(file) # перенесем в архив
    end
    logger.info "All: #{nf} files, created #{nn} letters, copied #{files_copied} files"
  end

  desc 'Сontrol of expiring duedate or soon deadline letters'
  task check_letters_duedate: :environment do # проверить письма, не исполненные в срок
    logger = Logger.new('log/bp1step.log') # протокол работы
    logger.info '===== ' + Time.current.strftime('%d.%m.%Y %H:%M:%S') + ' :check_overdue_letters'

    count = 0
    count_soon_deadline = 0
    letters = Letter.soon_deadline | Letter.overdue
    letters.each do |letter| # письма в статусе < Завершено с наступающим сроком исполнения или просроченные
      days = letter.duedate - Date.current
      emails = ''
      emails = letter.author.email.to_s if days.negative? && letter.author # автор
      users = ''
      letter.user_letter.each do |user_letter| # исполнители
        next unless user_letter.user

        emails += ', ' if emails.present?
        emails += user_letter.user.email.to_s
        users += user_letter.user.displayname.to_s
      end
      # emails = 'robb@bankperm.ru'
      if days.negative?
        count += 1
        logger.info "      ##{letter.id}\tсрок! #{letter.duedate.strftime('%d.%m.%y')}: #{(-days).to_i}\t#{emails}"
        LetterMailer.check_overdue_letters(letter, emails).deliver if emails.present?
      elsif [0, 1, 2, 5].include?(days)
        count_soon_deadline += 1
        logger.info "      ##{letter.id}\tскоро #{letter.duedate.strftime('%d.%m.%y')}: #{days.to_i}\t#{emails}"
        LetterMailer.soon_deadline_letters(letter, emails, days, users).deliver if emails.present?
      end
    end
    logger.info "      #{count} letters is duedate and #{count_soon_deadline} soon deadlineletters"
  end

  desc 'Check files in SVK'
  # првоерка обработки файов в каталоге СВК
  task check_files: :environment do
    nn = 0
    nf = 0
    path_from_rps = Rails.root.join(Rails.configuration.x.letters.path_to_rps)
    # path_from_rps =  Rails.root.join('svk_in') # current/ = releases/YYYYMMDDHHMMSS/
    puts path_from_rps.to_s

    # обход всех файлов в каталоге с файлами для писем
    Dir.glob(path_from_rps.join('*.*')).each do |file|
      nf += 1
      ext = File.extname(file).upcase
      fname = File.basename(file).upcase            # расширение файла
      name = fname[0..(fname.size - ext.size - 1)]  # только имя файла
      l_number, l_subject, l_sender = ''
      l_date = Date.current.strftime('%d.%m.%Y')
      l_source = 'СВК'

      next if ext == '.ARJ'

      case name.upcase
      when /\A(OD|ОД)\d{1,}\z/ # ODNNNN.PDF
        l_number = 'ОД-' + name[2..name.size]
        l_sender = 'ЦБ РФ'
        l_subject = 'Об отзыве лицензии / Об уточнении'
      when /\A(OD|ОД)(-)\d{1,}\z/ # OD-NNNN.*
        l_number = 'ОД-' + name[2..name.size]
        l_sender = 'ЦБ РФ'
        l_subject = 'Об отзыве лицензии / Об уточнении'
      when /\A\d{2,}\z/ # NNNN.PDF или NNNN.TIF
        l_number = name
        l_sender = 'Отделение по Пермскому краю ЦБ РФ'
        l_subject = ' ' + name
      # when /\AVES\d{6}_\d{1,}\(\d{1,}\)/
      when /\AVES\d{6}_+/                                 # вестник банка росии
        l_number = name[/_\d+\(?f?/]
        l_number = (l_number[1..l_number.size - 2]).to_s
        l_number = "#{l_number.to_i} #{name[/\(\d+\)?f?/]}"
        l_sender = 'Банк России'
        l_subject = "Вестник Банка России No #{l_number} от #{l_date}"
      when /\AGR-OT-\d+/                                  # gr-ot-MM.DOC
        l_number = name
        l_sender = 'Отделение по Пермскому краю ЦБ РФ'
        l_subject = 'График представления отчетности в виде электронных сообщений'
      when /\A\d+_U/                                      # Указание БР
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 2]}-У"
        l_sender = 'Банк России'
        l_subject = "Указание Банка России № #{l_number} от #{l_date}"
      when /\A\d+-У/                                      # Указание БР
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 1]}-У"
        l_sender = 'Банк России'
        l_subject = "Указание Банка России № #{l_number} от #{l_date}"
      when /\A\d+(-|_)(П|P)/ # Положение БР
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 1]}-П"
        l_sender = 'Банк России'
        l_subject = "Положение Банка России № #{l_number} от #{l_date}"
      when /\A\d+_MR/                                     # Методические рекомендации
        l_number = name[/\A\d+_?f?/]
        l_number = "#{l_number[0..l_number.size - 2]}-МР"
        l_sender = 'Банк России'
        l_subject = "Методические рекомендации № #{l_number} от #{l_date}"
      when /\A\d+_IN\d+/                                  # Информационное письмо
        l_number = name[/\A\d+_?f?/]
        l_number = "ИН/#{l_number[0..l_number.size - 2]}"
        l_sender = 'Банк России'
        l_subject = "Информационное письмо № #{l_number} от #{l_date}"
      # исключим справочник банков
      when /B\d\d\d\d_\d\d/
        next
      # исключим файлы протоколов
      when /\A(DEPOSIT_LETTERS|GUCB_LETTERS|UBIZI_LETTERS|RECEIPT_LETTERS|GUOST_LETTERS|GUOFORM_LETTERS|ANY_LETTERS)\z/
        next
      when /\AMONIT*/
        next
      else
        if File.exist?(file) # скопируем в РЕМАРТ перенесем в архив
          puts "copy #{fname} -> #{File.join('remart', fname)}"
          FileUtils.cp file, Rails.root.join('remart').to_s
          puts "move #{fname} -> #{File.join('ARC', File.basename(file))}"
          File.rename(file, File.join(File.dirname(file), 'ARC', File.basename(file)))
        end
      end

      next if l_number.blank? # удалось идентифицировать файл

      letter = Letter.new(status: 0, number: l_number, sender: l_sender, subject: l_subject, source: l_source)
      letter.date = Time.current.strftime('%d.%m.%Y')
      letter.duedate = (Time.current + 10.days).strftime('%d.%m.%Y') # срок исполнения - даем 10 дней по умолчанию
      nn += 1
      puts "+ ##{letter.id} #{name}: \t№#{l_number}\t[#{l_subject}] письмо создали, теперь присоедним файл "
      letter_appendix = LetterAppendix.new(letter_id: letter.id)
      File.open file do |f|
        letter_appendix.appendix = f
        puts "   + #{fname}"
      end

      puts "move #{fname} -> #{File.join('ARC', File.basename(file))}" if File.exist?(file) # перенесем в архив
      # File.rename(file, File.join(File.dirname(file), 'ARC', File.basename(file))) if File.exist?(file) # перенесем в архив
    end
    puts "All: #{nf} files, created #{nn} letters"
  end
end
# rubocop:enable Metrics/BlockLength
