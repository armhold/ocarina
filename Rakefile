#!/usr/bin/env rake
require "bundler/gem_tasks"
require_relative "lib/ocarina.rb"
require 'progress_bar'

namespace :ocarina do
  include Ocarina::Util

  #INPUT_SET = Ocarina::CHARS.split(//).shuffle
  INPUT_SET = "ABCDEFGHIJKLMNOPQ".split(//).shuffle

  desc "creates bitmaps to be used for training data"
  task :bitmaps do |t, args|

    generator = Ocarina::BitmapGenerator.new

    Ocarina::CHARS.each_char do |char|
      generator.generate_reference_gif_for_char char
    end

    Ocarina::CHARS.each_char do |char|
      generator.generate_noise_gif_for_char char
    end

  end

  desc "builds and trains the network"
  task :train do |t, args|
    network = Ocarina::Network.new(Ocarina::IMAGE_WIDTH * Ocarina::IMAGE_HEIGHT)

    training_iterations = 100

    pbar = ProgressBar.new(training_iterations * INPUT_SET.count)

    training_iterations.times do
      INPUT_SET.each do |letter|
        network.train reference_image_for_char(letter), letter
        pbar.increment!
      end
    end

    puts "\nfinal training error: #{network.current_error}\n"

    # run with: ruby -I"lib:test" test/network_test.rb -n test_network

    file = "#{Ocarina::DATA_DIR}/train.bin"
    network.save_network_to_file file

    puts "trained network saved to: #{file}"
  end

  desc "runs the training images back through the network for evaluation"
  task :eval do |t, args|
    file = "#{Ocarina::DATA_DIR}/train.bin"
    network = Ocarina::Network.load_network_from_file file


    puts "##### testing against reference images #####"
    stats = Ocarina::ErrorStats.new

    INPUT_SET.each do |letter|
      result = network.recognize reference_image_for_char(letter)
      target_binary_string = network.char_to_binary_string letter

      stats.check_error letter.ord, result
    end
    stats.report

    puts
    puts "##### testing against noise images #####"

    stats = Ocarina::ErrorStats.new

    INPUT_SET.each do |letter|
      result = network.recognize noise_image_for_char(letter)
      target_binary_string = network.char_to_binary_string letter

      stats.check_error letter.ord, result
    end
    stats.report

  end

end
