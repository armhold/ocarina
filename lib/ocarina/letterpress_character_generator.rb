require 'RMagick'

module Ocarina

  # creates bitmap images for characters using letterpress board game images
  #
  # We create the reference character images by cropping game board tiles for
  # three boards for which the letters are known ahead of time. Together, the three
  # boards provide images for all the letters of the alphabet.
  #
  class LetterpressCharacterGenerator < CharacterGenerator

    def initialize(config)
      @config = config

      # generate reference images
      #
      @reference_image_hash = process_letterpress_example_boards

      # generate noise images
      #
      @noise_image_hash = { }

      @config.char_set.each_char do |char|
        @noise_image_hash[char] = generate_noise_gif_for_char char
      end
    end

    private

    # create and return reference images from letterpress game boards.
    # returns tiles as a hash of char -> image
    #
    def process_letterpress_example_boards

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
        end
      end

      result
    end

  end

end
