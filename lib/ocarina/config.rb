require_relative 'util'

module Ocarina

  # OCR configuration
  #
  class Config
    include Ocarina::Util

    attr_reader :char_set, :num_outputs, :char_width, :char_height


    # chars_set   : the string of characters to be recognized
    # num_outputs : the number of output nodes for the network (# of bits to designate a recognized character)
    # char_width  : width in pixels of the input samples
    # char_height : height in pixels of the input samples
    #
    #
    def initialize(char_set, num_outputs, char_width, char_height)
      @char_set    = char_set
      @num_outputs = num_outputs
      @char_width  = char_width
      @char_height = char_height
    end

    # the number of inputs for the network
    #
    def num_inputs
      @char_width * @char_height
    end


  end

end
