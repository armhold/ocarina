require_relative 'util'

module Ocarina

  # a layer (i.e. input, hidden or output) of neurons
  #
  class Layer
    include Ocarina::Util

    attr_reader :outputs, :errors

    # we need num_neurons_next_layer in order to keep the total sum of our output weights < 1
    def initialize(num_neurons, num_neurons_next_layer)
      @num_neurons = num_neurons
      @outputs = [ ]
      @errors  = [ ]
      @weights = [ ]   # outgoing weights

      @num_neurons.times do |me|
        @weights[me] = [ ]

        num_neurons_next_layer.times do |neighbor|
          @weights[me][neighbor] = rand(0.8..0.9) / (@num_neurons * num_neurons_next_layer)
        end
      end
    end

    def feed_forward(from_layer)

    end


    # performs backpropagation of error for each neuron in this layer based on error from its peer layer.
    # ("peer" is meant to be the layer receiving output from this layer during feed-forward).
    #
    def calculate_error(layer_to_right)

    end

  end

end
