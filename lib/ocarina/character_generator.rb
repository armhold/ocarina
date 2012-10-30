require 'RMagick'

module Ocarina

  # creates bitmap images for characters using RMagick's drawing canvas
  #
  class CharacterGenerator
    include Ocarina::Util

    attr_accessor :reference_image_hash, :noise_image_hash

    def initialize(config)
      @config = config

      # generate reference images
      #
      @reference_image_hash = { }

      @config.char_set.each_char do |char|
        @reference_image_hash[char] = generate_reference_gif_for_char char
      end

      # generate noise images
      #
      @noise_image_hash = { }

      @config.char_set.each_char do |char|
        @noise_image_hash[char] = generate_noise_gif_for_char char
      end
    end

    # save the reference and noise images to disk
    #
    def persist_tiles
      reference_image_hash.each_pair do |char, image|
        puts "saving to: #{filename_for_training_image(char, 'gif')}"

        image.write(filename_for_training_image(char, 'gif'))
      end

      noise_image_hash.each_pair do |char, image|
        image.write(filename_for_noise_image(char, 'gif'))
      end
    end

    # draws the image, but does not save it
    #
    def draw_image_for_char(char)
      canvas       = Magick::Image.new(@config.char_width, @config.char_height)
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
      draw_image_for_char char
    end

    # generate the gif image for the given character, but with added noise
    #
    def generate_noise_gif_for_char(char)
      image = @reference_image_hash[char]

      #image = image.wave(10, 100)
      image = image.add_noise(Magick::PoissonNoise)
      #image = image.rotate(5)
      #image = image.resize_to_fit(@config.char_width, @config.char_height)

      image
    end

  end

end
