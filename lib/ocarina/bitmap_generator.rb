require 'RMagick'

module Ocarina

  # creates bitmap gif images for text characters
  #
  class BitmapGenerator
    include Ocarina::Util

    # draws the image, but does not save it
    #
    def draw_image_for_char(char)
      canvas       = Magick::Image.new(Ocarina::IMAGE_WIDTH, Ocarina::IMAGE_HEIGHT)
      gc           = Magick::Draw.new
      gc.pointsize = 20.0
      #gc.font_family = "Helvetica"
      #gc.font_weight = Magick::BoldWeight

      gc.stroke('transparent')
      gc.fill('black')
      gc.gravity = Magick::CenterGravity
      gc.annotate(canvas, 0, 0, 0, 0, char)

      gc.draw(canvas)

      canvas
    end


    # generate the gif image for the given character
    #
    def generate_reference_gif_for_char(char)
      image = draw_image_for_char char
      image.write(filename_for_training_image(char, 'gif'))
    end

    # generate the gif image for the given character, but with added noise
    #
    def generate_noise_gif_for_char(char)
      image = draw_image_for_char char
      #image = image.wave(10, 100)
      image = image.add_noise(Magick::PoissonNoise)
      #image = image.rotate(5)
      #image = image.resize_to_fit(Ocarina::IMAGE_WIDTH, Ocarina::IMAGE_HEIGHT)
      image.write(filename_for_noise_image(char, 'gif'))
    end

  end

end
