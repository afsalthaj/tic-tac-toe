require './board.rb'
require 'test/unit'

class BoardSpec < Test::Unit::TestCase
  def test_dimensions_of_board
    board = Board.new
    assert_equal([0, 1, 2], board.first_column)
    assert_equal([3, 4, 5], board.second_column)
    assert_equal([6, 7, 8], board.third_column)
    assert_equal([0, 4, 8], board.diagonal_left_right)
    assert_equal([2, 4, 6], board.diagonal_right_left)
  end

  def test_winner_of_board
    board = Board.new

  end

  def test_next_move_in_the_board
    board = Board.new
    player = Player.new
    board.move_the_player
  end
end
