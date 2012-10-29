#!/usr/bin/env rake
require "bundler/gem_tasks"
require_relative "lib/ocarina.rb"
require 'powerbar'

namespace :ocarina do
  include Ocarina::Util

  desc "creates bitmaps to be used for training data"
  task :bitmaps do |t, args|

    generator = Ocarina::BitmapGenerator.new(config)

    Ocarina::CHARS.each_char do |char|
      generator.generate_reference_gif_for_char char
    end

    Ocarina::CHARS.each_char do |char|
      generator.generate_noise_gif_for_char char
    end

  end

  desc "builds and trains network using Letterpress board tiles"
  task :letterpress do |t, args|
    generator = Ocarina::BitmapGenerator.new(config)
    reference_image_hash = generator.generate_from_letterpress_images

    network = Ocarina::Network.new(config)

    training_iterations = 350
    pbar = PowerBar.new
    pbar.settings.tty.finite.template.barchar = '#'
    pbar.settings.tty.finite.template.padchar = '-'

    training_iterations.times do |i|
      reference_image_hash.each_pair do |char, tile|
        network.train tile, char
        pbar.show(msg: "current error: #{'%.10f' % network.current_error}", done: i + 1, total: training_iterations)
      end
    end

    puts "\nfinal training error: #{network.current_error}\n"

    file = "#{Ocarina::DATA_DIR}/train.bin"
    network.save_network_to_file file

    puts "trained network saved to: #{file}"

    puts "##### testing against reference images #####"
    stats = Ocarina::ErrorStats.new(config)

    reference_image_hash.each_pair do |char, tile|
      result = network.recognize tile
      stats.check_error char.ord, result
    end
    stats.report

  end

  desc "builds and trains the network"
  task :train do |t, args|
    network = Ocarina::Network.new(config)

    generator = Ocarina::BitmapGenerator.new(config)

    training_iterations = 100
    pbar = PowerBar.new
    pbar.settings.tty.finite.template.barchar = '#'
    pbar.settings.tty.finite.template.padchar = '-'

    training_iterations.times do |i|
      generator.reference_image_hash.each_pair do |char, tile|
        network.train tile, char
        pbar.show(msg: "current error: #{'%.10f' % network.current_error}", done: i + 1, total: training_iterations)
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
    generator = Ocarina::BitmapGenerator.new(config)

    puts "##### testing against reference images #####"
    stats = Ocarina::ErrorStats.new(config)

    generator.reference_image_hash.each_pair do |char, tile|
      result = network.recognize tile
      stats.check_error char.ord, result
    end
    stats.report

    puts
    puts "##### testing against noise images #####"

    stats = Ocarina::ErrorStats.new(config)

    generator.noise_image_hash.each_pair do |char, tile|
      result = network.recognize tile
      stats.check_error char.ord, result
    end
    stats.report
  end

  desc "prints letters from a letterpress game board"
  task :gameboard, [:board_file]  do |t, args|
    file = "#{Ocarina::DATA_DIR}/train.bin"
    network = Ocarina::Network.load_network_from_file file

    puts "reading letterpress board: #{args.board_file}..."

    board = Magick::Image.read(args.board_file).first

    cropper = Ocarina::LetterpressCropper.new(config)
    tile_rows = cropper.crop board

    result = ""

    tile_rows.each do |tile_row|
      tile_row.each do |tile|
        result << "\t#{network.recognize(tile).chr}"
      end

      result << "\n"
    end

    puts "result: \n#{result}"
  end

  def config
    @config ||= Ocarina::Config.new("ABCDEFGHIJKLMNOPQRSTUVWXYZ", 8, 16, 16)
  end


end
