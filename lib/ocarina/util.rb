require 'RMagick'

module Ocarina

  DATA_DIR     = "#{File.dirname(__FILE__)}/../../data"
  IMAGES_DIR   = "#{DATA_DIR}/images"

  module Util

    def int_to_binary_string(i)
      i.to_s(2).rjust(config.num_outputs, '0')
    end

    def char_to_binary_string(target_char)
      int_to_binary_string target_char.ord
    end

    # function that maps its input to a range between 0..1
    # mathematically it's supposed to be asymptotic, but large values of x will round up to 1
    def sigma(x)
      1.0/(1.0+Math.exp(-x))
    end

    def pixel_number_to_col(n, image)
      n % image.columns
    end

    def pixel_number_to_row(n, image)
      n / image.columns
    end

    def pixel_to_bit(pixel)
      pixel.red | pixel.green | pixel.black > 0 ? 1 : 0
    end


    # returns a Magick::Image, constructed from the reference gif file for the given character
    #
    def reference_image_for_char(char)
      Magick::Image.read(filename_for_training_image char, "gif").first
    end

    # returns a Magick::Image, constructed from the noise gif file for the given character
    #
    def noise_image_for_char(char)
      Magick::Image.read(filename_for_noise_image char, "gif").first
    end

    # returns filepath for the image for a given character
    #
    def filename_for_training_image(c, suffix)

      # the default OSX file system is case preserving, meaning that you cannot have
      # both "A.bitmap" and "a.bitmap" at the same time. So we map lowercase letters to
      # a special name.
      #
      is_lower?(c) ? "#{IMAGES_DIR}/reference/#{c}_lower.#{suffix}" : "#{IMAGES_DIR}/reference/#{c}.#{suffix}"
    end

    # returns filepath for the "noise" image for a given character
    #
    def filename_for_noise_image(c, suffix)

      # the default OSX file system is case preserving, meaning that you cannot have
      # both "A.bitmap" and "a.bitmap" at the same time. So we map lowercase letters to
      # a special name.
      #
      is_lower?(c) ? "#{IMAGES_DIR}/noise/#{c}_lower.#{suffix}" : "#{IMAGES_DIR}/noise/#{c}.#{suffix}"
    end

    def filename_for_quantized_image(c, suffix)

      is_lower?(c) ? "#{IMAGES_DIR}/quantized/#{c}_lower.#{suffix}" : "#{IMAGES_DIR}/quantized/#{c}.#{suffix}"
    end

    # kind of sad that this is not built into Ruby
    def is_lower?(c)
      !! /[[:lower:]]/.match(c)
    end

    def is_upper?(c)
      !! /[[:upper:]]/.match(c)
    end

    def quantize_image(image)
      image.white_threshold(Magick::MaxRGB * 0.35).quantize(2, Magick::GRAYColorspace)
    end

  end

end

