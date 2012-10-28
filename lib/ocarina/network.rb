require_relative 'util'

module Ocarina

  # a network of neurons
  #
  class Network

    include Ocarina::Util

    attr_accessor :current_error

    # config is a list of ints that defines the layers of the network
    #
    # e.g. config = [ 10, 20, 20, 20, 5 ]
    #
    # defines a network with 10 inputs, three hidden layers with 20 neurons each, and
    # final output layer of 5 neurons.
    #
    def initialize(config)

      @layers = []

      config.each_with_index do |num_neurons, i|
        num_neurons_next_layer = config[i + 1] || 0
        @layers << Layer.new(num_neurons, num_neurons_next_layer)
      end

    end

    # Attempt to recognize the character displayed on the given image.
    # image should be an instance of Magick::Image.
    #
    # Returns the integer ASCII code for the recognized character.
    #
    def recognize(image)
      # quantize to two-color
      image = image.quantize(2, Magick::GRAYColorspace)

      # the binary string we expect to see from the output nodes
      assign_inputs image

      calculate_hidden_outputs
      calculate_final_outputs

      #@output_values.each.with_index { |v, i| puts "index: #{i} => #{v}" }

      # process results
      #
      binary_string = quantized_result.inject("") { |accum, bit| "#{accum}#{bit.to_s}" }
      binary_string.to_i(2)
    end

    # Train the network on the image, using target_char as the expected result.
    #
    # image should be an instance of Magick::Image.
    #
    def train(image, target_char)
      # quantize to two-color
      image = image.quantize(2, Magick::GRAYColorspace)

      # the binary string we expect to see from the output nodes
      @target_binary_string = char_to_binary_string(target_char)

      assign_inputs image

      calculate_hidden_outputs
      calculate_final_outputs
      calculate_output_errors
      calculate_hidden_errors

      # process results
      #
      adjust_output_weights
      adjust_input_weights
    end

    # persist the network
    #
    def save_network_to_file(filepath)
      File.open(filepath,'w') do|file|
        Marshal.dump(self, file)
      end
    end

    # load a previously-trained network
    #
    def self.load_network_from_file(filepath)
      File.open(filepath) do |file|
        Marshal.load(file)
      end
    end

    private

    def assign_inputs(image)

      num_pixels = image.rows * image.columns

      num_pixels.times do |n|
        col = pixel_number_to_col(n, image)
        row = pixel_number_to_row(n, image)

        pixel = image.pixel_color(col, row)

        @input_values[n] = pixel_to_bit(pixel)
      end

      #text = inputs_as_text image.columns
      #puts text
    end


    def assign_random_weights

      # input -> hidden weights
      #
      @num_inputs.times do |input|

        @input_weights[input] = [ ]

        @hidden_count.times do |hidden|

          # we want the overall sum of weights to be < 1
          weight = rand(0.8..0.9) / (@num_inputs * @hidden_count)
          @input_weights[input][hidden] = weight

          #puts "input_weights[#{input}][#{hidden}] => #{@input_weights[input][hidden]}"
        end

      end

      # hidden -> output weights
      #
      @hidden_count.times do |hidden|

        @output_weights[hidden] = [ ]

        NUM_OUTPUTS.times do |output|
          # we want the overall sum of weights to be < 1
          weight = rand(0.8..0.9) / (@hidden_count * NUM_OUTPUTS)
          @output_weights[hidden][output] = weight
        end

      end

    end

    def calculate_hidden_outputs

      @hidden_count.times do |hidden|
        sum = 0
        @input_values.count.times do |input|
          val = @input_values[input] * @input_weights[input][hidden]
          #puts "input: #{@input_values[input]} * weight: #{@input_weights[input][hidden]} = #{val}"

          sum += val
        end

        #puts "@hidden_outputs[#{hidden}] = #{sum} (before sigma)"
        sum = sigma(sum)
        #puts "@hidden_outputs[#{hidden}] = #{sum} (after sigma)"

        @hidden_outputs[hidden] = sum
        #puts "@hidden_outputs[#{hidden}] = #{@hidden_outputs[hidden]}"
      end

    end

    def calculate_final_outputs

      NUM_OUTPUTS.times do |output|
        sum = 0

        @hidden_count.times do |hidden|

          val = @hidden_outputs[hidden] * @output_weights[hidden][output]
          sum += val
        end

        #puts "output: #{sum}, sigma: #{sigma sum}"
        @output_values[output] = sigma sum
      end
    end

    def calculate_output_errors
      accum_error = 0

      NUM_OUTPUTS.times do |output|
        expected = @target_binary_string[output].to_i
        error = (expected - @output_values[output]) * (1.0 - @output_values[output]) * @output_values[output]

        #puts "expected: #{expected}"
        #puts "output: #{@output_values[output]}"
        #puts "error: #{'%.10f' % error}"
        accum_error += error ** 2
        @output_errors[output] = error
      end

      # TODO: @current_error only represents the error from the last trained character.
      # We should keep a running average for the current set of characters for each training "run".
      #
      @current_error = Math.sqrt(accum_error)
      #puts "@current_error: #{'%.10f' %  @current_error}"
    end

    def calculate_hidden_errors
      @hidden_count.times do |hidden|
        sum = 0
        NUM_OUTPUTS.times do |output|
          sum += (@output_errors[output] * @output_weights[hidden][output])
        end

        #puts "sum is: #{sum}"
        @hidden_errors[hidden] = @hidden_outputs[hidden] * (1 - @hidden_outputs[hidden]) * sum
        #puts "@hidden_errors[#{hidden}] = #{@hidden_errors[hidden]}"
      end

    end

    def adjust_output_weights
      @hidden_count.times do |hidden|
        NUM_OUTPUTS.times do |output|
          @output_weights[hidden][output] += (@output_errors[output] * @hidden_outputs[hidden])
        end
      end
    end

    def adjust_input_weights
      @num_inputs.times do |input|
        @hidden_count.times do |hidden|
          @input_weights[input][hidden] += @hidden_errors[hidden] * @input_values[input]
        end
      end
    end


    # quantize each of the output nodes to zero or one, return as array
    #
    def quantized_result
      @output_values.map { |output| output.round.to_i }
    end

    def to_s
      @layers.join ","
    end

  end

end
