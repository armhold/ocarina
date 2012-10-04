require 'RMagick'

module Ocarina

  NUM_OUTPUTS  = 8 # need 8 bits to represent 0..255 in binary
  IMAGE_WIDTH  = 16
  IMAGE_HEIGHT = 16
  DATA_DIR     = "#{File.dirname(__FILE__)}/../../data"
  IMAGES_DIR   = "#{DATA_DIR}/images"

  module Util

    def output(image, pixel_number)
      col = pixel_number_to_col(pixel_number, image)
      row = pixel_number_to_row(pixel_number, image)

      pixel = image.pixel_color(col, row)

      pixel_to_bit(pixel)
    end

    def image_to_binary_string(image)
      num_pixels = image.rows * image.columns

      result = ""

      num_pixels.times do |n|
        col = pixel_number_to_col(n, image)
        row = pixel_number_to_row(n, image)
        pixel = image.pixel_color(col, row)
        result << pixel_to_bit(pixel)
      end

      result
    end

    def image_to_binary_array(image)
      image_to_binary_string(image).split //
    end

    def int_to_binary_string(i)
      i.to_s(2).rjust(NUM_OUTPUTS, '0')
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

    # is there really no standard way to do this in Ruby?
    def is_lower?(c)
      c >= 'a' && c <= 'z'
    end

    def is_upper?(c)
      !is_lower(c)
    end

  end

end

