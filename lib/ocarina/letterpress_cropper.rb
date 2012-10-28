require 'RMagick'

module Ocarina

  # creates tiles of character images from letterpress game boards
  #
  class LetterpressCropper
    include Ocarina::Util

    # returns a hash of char -> image tile
    #
    def crop(image, character_map)
      image = quantize_image(image)

      y_offset = LETTERPRESS_HEIGHT_OFFSET

      tiles = { }

      border = 1

      0.upto(LETTERPRESS_TILES_ACROSS - 1) do |x|
        x_offset = 0

        0.upto(LETTERPRESS_TILES_ACROSS - 1) do |y|

          tile = image.crop(x_offset - border, y_offset + border, LETTERPRESS_TILE_PIXELS - border, LETTERPRESS_TILE_PIXELS - border, true)
          box = tile.bounding_box
          min_bound_width = 0.75 * IMAGE_WIDTH
          #puts "char: #{character_map[x][y]}, box width: #{box.width}"
          if box.width > min_bound_width
            tile = tile.crop(box.x - border, box.y - border, box.width + 2 * border, box.height + 2 * border, true)
          end

          tile.resize!(IMAGE_WIDTH, IMAGE_HEIGHT)
          #tile.write(filename_for_training_image(character_map[x][y], 'gif'))
          tiles[character_map[x][y]] = tile
          x_offset += LETTERPRESS_TILE_PIXELS

        end

        y_offset += LETTERPRESS_TILE_PIXELS
      end

      tiles
    end
  end


end
