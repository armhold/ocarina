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
      image = Magick::Image.read(filename_for_training_image(char, 'gif')).first
      #image = image.wave(10, 100)
      image = image.add_noise(Magick::PoissonNoise)
      #image = image.rotate(5)
      #image = image.resize_to_fit(Ocarina::IMAGE_WIDTH, Ocarina::IMAGE_HEIGHT)
      image.write(filename_for_noise_image(char, 'gif'))
    end

    # generate reference images from letterpress game boards
    #
    def generate_from_letterpress_images

      # board games were generated randomly by the game.
      # with these three game boards, we have the letters A-Z.

      write_letterpress_tiles("#{IMAGES_DIR}/letterpress/board1.png",
                              [
                                  [ 'P', 'R', 'B', 'R', 'Z' ],
                                  [ 'T', 'A', 'V', 'Z', 'R' ],
                                  [ 'B', 'D', 'A', 'K', 'Y' ],
                                  [ 'G', 'I', 'G', 'K', 'F' ],
                                  [ 'R', 'Y', 'S', 'J', 'V' ]
                              ])

      write_letterpress_tiles("#{IMAGES_DIR}/letterpress/board2.png",
                              [
                                  [ 'Q', 'D', 'F', 'P', 'M' ],
                                  [ 'N', 'E', 'E', 'S', 'I' ],
                                  [ 'A', 'W', 'F', 'M', 'L' ],
                                  [ 'F', 'R', 'P', 'T', 'T' ],
                                  [ 'K', 'C', 'S', 'S', 'Y' ]
                              ])

      write_letterpress_tiles("#{IMAGES_DIR}/letterpress/board3.png",
                              [
                                  [ 'L', 'H', 'F', 'L', 'M' ],
                                  [ 'R', 'V', 'P', 'U', 'K' ],
                                  [ 'V', 'O', 'E', 'E', 'X' ],
                                  [ 'I', 'N', 'R', 'I', 'T' ],
                                  [ 'V', 'N', 'S', 'I', 'Q' ]
                              ])
    end

    def write_letterpress_tiles(input_file, character_map)
      board = Magick::Image.read(input_file).first
      board = quantize_image(board)

      y_offset = LETTERPRESS_HEIGHT_OFFSET

      tiles = []

      border = 1

      0.upto(LETTERPRESS_TILES_ACROSS - 1) do |x|
        tiles[x] = []

        x_offset = 0

        0.upto(LETTERPRESS_TILES_ACROSS - 1) do |y|

          tiles[x][y] = board.crop(x_offset - border, y_offset + border, LETTERPRESS_TILE_PIXELS - border, LETTERPRESS_TILE_PIXELS - border, true)
          box = tiles[x][y].bounding_box
          min_bound_width = 0.75 * IMAGE_WIDTH
          #puts "char: #{character_map[x][y]}, box width: #{box.width}"
          if box.width > min_bound_width
            tiles[x][y] = tiles[x][y].crop(box.x - border, box.y - border, box.width + 2 * border, box.height + 2 * border, true)
          end

          tiles[x][y].resize!(IMAGE_WIDTH, IMAGE_HEIGHT)
          tiles[x][y].write(filename_for_training_image(character_map[x][y], 'gif'))

          x_offset += LETTERPRESS_TILE_PIXELS

        end

        y_offset += LETTERPRESS_TILE_PIXELS
      end

    end

  end

end
