require 'RMagick'

module Ocarina

  # creates bitmap gif images for text characters
  #
  class BitmapGenerator
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

    # create and return reference images from letterpress game boards.
    # returns tiles as a hash of char -> image
    #
    def generate_from_letterpress_images

      # board games were generated randomly by the game.
      # with these three game boards, we have the letters A-Z.

      result = { }

      result.merge! create_letterpress_tiles("#{IMAGES_DIR}/letterpress/board1.png",
                              [
                                  [ 'P', 'R', 'B', 'R', 'Z' ],
                                  [ 'T', 'A', 'V', 'Z', 'R' ],
                                  [ 'B', 'D', 'A', 'K', 'Y' ],
                                  [ 'G', 'I', 'G', 'K', 'F' ],
                                  [ 'R', 'Y', 'S', 'J', 'V' ]
                              ])

      result.merge! create_letterpress_tiles("#{IMAGES_DIR}/letterpress/board2.png",
                              [
                                  [ 'Q', 'D', 'F', 'P', 'M' ],
                                  [ 'N', 'E', 'E', 'S', 'I' ],
                                  [ 'A', 'W', 'F', 'M', 'L' ],
                                  [ 'F', 'R', 'P', 'T', 'T' ],
                                  [ 'K', 'C', 'S', 'S', 'Y' ]
                              ])

      result.merge! create_letterpress_tiles("#{IMAGES_DIR}/letterpress/board3.png",
                              [
                                  [ 'L', 'H', 'F', 'L', 'M' ],
                                  [ 'R', 'V', 'P', 'U', 'K' ],
                                  [ 'V', 'O', 'E', 'E', 'X' ],
                                  [ 'I', 'N', 'R', 'I', 'T' ],
                                  [ 'V', 'N', 'S', 'I', 'Q' ]
                              ])

      result
    end


    # create character files from the given letterpress board image
    # returns tiles as a hash
    #
    def create_letterpress_tiles(input_file, character_map)
      board = Magick::Image.read(input_file).first

      cropper = LetterpressCropper.new(@config)
      tile_rows = cropper.crop board

      result = { }
      tile_rows.zip(character_map) do |tile_row, char_row|
        tile_row.zip(char_row) do |tile, char|
          result[char] = tile

          #puts "tile: #{tile.rows} x #{tile.columns}"
        end
      end

      result
    end

  end

end
