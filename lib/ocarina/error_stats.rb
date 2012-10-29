require_relative 'util'

module Ocarina

  # keeps track of running errors during evaluations
  #
  class ErrorStats

    def initialize(config)
      @num_outputs = config.num_outputs

      @chars_seen  = 0
      @chars_wrong = 0
      @bits_seen   = 0
      @bits_wrong  = 0
    end

    # check and record the error from the expected and actual integers
    #
    def check_error(expected, actual)
      @chars_seen += 1
      @bits_seen += @num_outputs

      if expected != actual
        @chars_wrong +=1
        puts "char wrong, expected: #{expected.chr}, guessed: #{actual.chr}"

        expected_binary_string = int_to_binary_string expected
        actual_binary_string   = int_to_binary_string actual

        @bits_wrong += count_differences expected_binary_string, actual_binary_string

        #puts "expected: #{expected_binary_string}, decimal: #{expected}"
        #puts "actual  : #{actual_binary_string}, decimal: #{actual}"
      end

    end

    # assumes a.size == b.size
    def count_differences(a, b)
      a.split(//).each.with_index.inject(0) { |diffs, (char, i)| char == b[i] ? diffs : diffs + 1}
    end


    def report
      puts "total characters evaluated: #@chars_seen"
      puts "total characters wrong    : #@chars_wrong"
      puts "character accuracy        : #{'%.2f' % character_accuracy}"
      puts "bit accuracy              : #{'%.2f' % bit_accuracy}"
    end

    def character_accuracy
      (@chars_seen - @chars_wrong).to_f / @chars_seen * 100
    end

    def bit_accuracy
      (@bits_seen - @bits_wrong).to_f / @bits_seen * 100
    end

  end

end
