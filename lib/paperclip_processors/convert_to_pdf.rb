# frozen_string_literal: true
module Paperclip
  class ConvertToPdf < Processor
    def initialize(file, options = {}, attachment = nil)
      @file = file
      @attachment = attachment
      @instance = options[:instance]
    end

    def make
      dst = File.open(File.expand_path(@file.path))
      params = "-f pdf #{File.expand_path(@file.path)}"
      begin
        success = Paperclip.run('unoconv', params)
        dst = File.open(File.expand_path(@file.path) + '.pdf')
      rescue
        puts  'error!'
      end
      dst
    end
  end
end
