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

      cropper = LetterpressCropper.new
      tiles = cropper.crop board, character_map
      tiles.each { |char, tile| tile.write(filename_for_training_image(char, 'gif')) }
    end

  end

end
