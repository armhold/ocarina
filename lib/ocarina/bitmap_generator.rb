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

    # generate reference images from letterpress game boards
    #
    def generate_from_letterpress_images
      board = Magick::Image.read("#{IMAGES_DIR}/letterpress/board1.png").first

      y_offset = LETTERPRESS_HEIGHT_OFFSET

      tiles = []

      0.upto(LETTERPRESS_TILES_ACROSS - 1) do |x|
        tiles[x] = []

        x_offset = 0

        0.upto(LETTERPRESS_TILES_ACROSS - 1) do |y|

          tiles[x][y] = board.crop(x_offset, y_offset, LETTERPRESS_TILE_PIXELS - 1, LETTERPRESS_TILE_PIXELS - 1)
          tiles[x][y].write("#{IMAGES_DIR}/letterpress/letter_#{x}-#{y}.png")

          x_offset += LETTERPRESS_TILE_PIXELS

        end

        y_offset += LETTERPRESS_TILE_PIXELS
      end
    end



  end

end
