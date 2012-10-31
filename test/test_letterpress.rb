require 'test/unit'
require 'ocarina'

class LetterpressTest < Test::Unit::TestCase


  def setup
    @network = Ocarina::Network.load_network_from_file "#{Ocarina::DATA_DIR}/letterpress-train.bin"
    @cropper = Ocarina::LetterpressCropper.new(@network.config)
  end

  def test_boards

    assert_equal [
                     %w(P R B R Z),
                     %w(T A V Z R),
                     %w(B D A K Y),
                     %w(G I G K F),
                     %w(R Y S J V)
                 ], @cropper.decipher_board(@network, read_board("board1.png"))

    assert_equal [
                     %w(Q D F P M),
                     %w(N E E S I),
                     %w(A W F M L),
                     %w(F R P T T),
                     %w(K C S S Y)
                 ], @cropper.decipher_board(@network, read_board("board2.png"))

    assert_equal [
                     %w(L H F L M),
                     %w(R V P U K),
                     %w(V O E E X),
                     %w(I N R I T),
                     %w(V N S I Q)
                 ], @cropper.decipher_board(@network, read_board("board3.png"))

    assert_equal [
                     %w(C U H S Z),
                     %w(N T V K I),
                     %w(E X K O S),
                     %w(B C U P N),
                     %w(W E E V E)
                 ], @cropper.decipher_board(@network, read_board("board4.png"))

    assert_equal [
                     %w(C Y M T I),
                     %w(P Z Y L Y),
                     %w(D W O H S),
                     %w(D W H A S),
                     %w(O Z X G K)
                 ], @cropper.decipher_board(@network, read_board("board5.png"))
  end

  def read_board(file)
    Magick::Image.read("#{Ocarina::DATA_DIR}/images/letterpress/#{file}").first
  end


end
