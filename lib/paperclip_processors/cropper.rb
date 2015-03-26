module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        original_command = super
        if original_command.include?('-crop')
          original_command.delete_at(super.index('-crop') + 1)
          original_command.delete_at(super.index('-crop'))
        end
        if original_command.include?('-resize')
          crop_command('square') + original_command
        else
          crop_command + original_command
        end
      else
        super
      end
    end

    def crop_command(dimensions = nil)
      target = @attachment.instance
      if target.cropping?
        case dimensions
        when 'square'
          if target.crop_w > target.crop_h
            crop_w = target.crop_w.to_i
            crop_h = target.crop_w.to_i
            crop_x = target.crop_x.to_i
            crop_y = target.crop_y.to_i - ((target.crop_w.to_i-target.crop_h.to_i)/2).to_i
            crop_x = 0 if crop_x < 0
            crop_y = 0 if crop_y < 0
          elsif target.crop_w < target.crop_h
            crop_w = target.crop_h.to_i
            crop_h = target.crop_h.to_i
            crop_x = target.crop_x.to_i - ((target.crop_h.to_i-target.crop_w.to_i)/2).to_i
            crop_y = target.crop_y.to_i
            crop_x = 0 if crop_x < 0
            crop_y = 0 if crop_y < 0
          else
            crop_w = target.crop_w.to_i
            crop_h = target.crop_h.to_i
            crop_x = target.crop_x.to_i
            crop_y = target.crop_y.to_i
          end
          ["-crop", "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}", "+repage"]
        else
          ["-crop", "#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}", "+repage"]
        end
      end
    end
  end
end
