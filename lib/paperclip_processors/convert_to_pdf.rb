module Paperclip
  class ConvertToPdf < Processor
 
    def initialize file, options = {}, attachment = nil
      @file = file
      puts "file=" + file.path.to_s
      puts "options=" + options.to_s
      puts "attachment=" + attachment.to_s
      @attachment = attachment
      @instance = options[:instance]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
    end
 
    def make
       begin
        parameters = []
        parameters << "-f pdf"
        parameters << @file.path.to_s
 
        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")
        puts parameters
        #success = Paperclip.run("unoconv", parameters)
      rescue PaperclipCommandLineError => e
        raise PaperclipError, "There was an error processing the thumbnail for #{@basename}" if @whiny
      end
      @file
    end
  end
end