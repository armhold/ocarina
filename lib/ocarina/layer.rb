require_relative 'util'

module Ocarina

  # a layer (i.e. input, hidden or output) of neurons
  #
  class Layer
    include Ocarina::Util

    attr_reader :outputs, :errors, :num_neurons

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

    # calculate my outputs based on outputs * weights of previous layer
    #
    def feed_forward(from_layer)

      @num_neurons.times do |i|

        accum = 0
        from_layer.outputs.each.with_index do |from|
          accum += from_layer.outputs[from] * from_layer.weights[from]
        end

        @outputs[i] = accum
      end

    end

    # performs backpropagation of error for each neuron in this layer based on error from its peer layer.
    # ("peer" is meant to be the layer receiving output from this layer during feed-forward).
    #
    def calculate_error(layer_to_right)
      @num_neurons.times do |me|
        sum = 0

        layer_to_right.num_neurons.times do |neighbor|
          sum += layer_to_right.errors[neighbor] * @weights[me][neighbor]
        end

        @errors[me] = sum
      end
    end

    def adjust_weights(layer_to_right)
      @num_neurons.times do |me|
        layer_to_right.num_neurons.times do |neighbor|
          @weights[me][neighbor] += (@outputs[me] * layer_to_right.errors[neighbor])
        end
      end
    end

  end

end
