module Paperclip
  class ConvertToPdf < Processor
 
    def initialize file, options = {}, attachment = nil
      @file = file
      @attachment = attachment
      @instance = options[:instance]
    end
 
    def make
      dst = File.open(File.expand_path(@file.path))
      params = "-f pdf #{File.expand_path(@file.path)}"
      begin
        success = Paperclip.run('unoconv', params)
        #dst = File.open(File.expand_path(@file.path) + '.pdf')
      rescue
        raise PaperclipError, "There was an error processing the file contents for #{@basename} - #{e}"
      end
      dst
    end
  end
end