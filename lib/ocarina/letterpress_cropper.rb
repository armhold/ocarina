require 'RMagick'

module Ocarina

  # creates tiles of character images from letterpress game boards
  #
  class LetterpressCropper
    include Ocarina::Util

    # returns an N by N array of image tiles
    #
    def crop(image)
      image = quantize_image(image)

      y_offset = LETTERPRESS_HEIGHT_OFFSET

      rows = [ ]

      border = 1

      0.upto(LETTERPRESS_TILES_DOWN - 1) do
        x_offset = 0
        row = [ ]

        0.upto(LETTERPRESS_TILES_ACROSS - 1) do

          tile = image.crop(x_offset - border, y_offset + border, LETTERPRESS_TILE_PIXELS - border, LETTERPRESS_TILE_PIXELS - border, true)
          box = tile.bounding_box
          min_bound_width = 0.75 * IMAGE_WIDTH
          if box.width > min_bound_width
            tile = tile.crop(box.x - border, box.y - border, box.width + 2 * border, box.height + 2 * border, true)
          end

          tile.resize!(IMAGE_WIDTH, IMAGE_HEIGHT)
          row << tile
          x_offset += LETTERPRESS_TILE_PIXELS

        end
        rows << row

        y_offset += LETTERPRESS_TILE_PIXELS
      end

      rows
    end
  end

end
