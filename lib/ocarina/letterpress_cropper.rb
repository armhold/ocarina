require 'RMagick'

module Ocarina

  LETTERPRESS_TILES_ACROSS = 5
  LETTERPRESS_TILES_DOWN   = 5
  LETTERPRESS_TILE_PIXELS  = 128
  LETTERPRESS_HEIGHT_OFFSET = 496
  LETTERPRESS_EXPECTED_WIDTH = LETTERPRESS_TILES_ACROSS * LETTERPRESS_TILE_PIXELS  
  LETTERPRESS_EXPECTED_HEIGHT = 1136

  # creates tiles of character images from letterpress game boards
  #
  class LetterpressCropper
    include Ocarina::Util

    def initialize(config)
      @config = config
    end

    # crops the board into tiles, runs recognizer on each of the tiles,
    # and returns resulting array of array of chars
    #
    def decipher_board(network, board_image)
      tile_rows = crop board_image

      result = [ ]

      tile_rows.each do |tile_row|
        row = [ ]
        tile_row.each do |tile|
          row << network.recognize(tile).chr
        end

        result << row
      end

      result
    end


    # returns an N by N array of image tiles
    #
    def crop(image)
      if image.columns != LETTERPRESS_EXPECTED_WIDTH || image.rows != LETTERPRESS_EXPECTED_HEIGHT
        image = image.resize(LETTERPRESS_EXPECTED_WIDTH, LETTERPRESS_EXPECTED_HEIGHT)
      end

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
          min_bound_width = 0.75 * @config.char_width
          if box.width > min_bound_width
            tile = tile.crop(box.x - border, box.y - border, box.width + 2 * border, box.height + 2 * border, true)
          end

          tile.resize!(@config.char_width, @config.char_height)
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
