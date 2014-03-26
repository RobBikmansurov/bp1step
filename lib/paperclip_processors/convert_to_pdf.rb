module Paperclip
  class ConvertToPdf < Processor
 
    def initialize file, options = {}, attachment = nil
      @file = file
      @attachment = attachment
      @instance = options[:instance]
      @format = options[:format]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      puts "\n\n" + file.path
      #puts attachment[]

    end
 
    def make
      #cmd = "-f pdf"
      #dst = Tempfile.new(['temp_file', '.pdf'])
      dst = Tempfile.new([@basename, 'pdf'].compact.join("."))
      #dst = File.expand_path(@file.path) + '.pdf'
      puts dst.inspect
      #params = " -f pdf '#{fromfile}'"
      params = "-f pdf #{File.expand_path(@file.path)}"
      puts params
      dst.binmode
      begin
        success = Paperclip.run('unoconv', params)
      rescue
        puts "error!" 
        #raise PaperclipError, "There was an error processing the file contents for #{@basename} - #{e}" if @whiny
      end
      dst
    end
  end
end