require '../game/game_board.rb'
require '../player/player.rb'
require 'test/unit'

class GameBoardSpec < Test::Unit::TestCase

  def test_if_indices_are_right
    game_board = GameBoard.new
    assert_equal [0, 1, 2], game_board.all_rows_indices[0]
    assert_equal [3, 4, 5], game_board.all_rows_indices[1]
    assert_equal [6, 7, 8], game_board.all_rows_indices[2]
    assert_equal [0, 3, 6], game_board.all_columns_indices[0]
    assert_equal [1, 4, 7], game_board.all_columns_indices[2]
    assert_equal [2, 5, 8], game_board.all_columns_indices[1]
    assert_equal [0, 4, 8], game_board.diagonal_left_right_indices
    assert_equal [2, 4, 6], game_board.diagonal_right_left_indices
  end

  def test_initial_board_dimensions
    game_board = GameBoard.new
    assert_equal [nil, nil, nil], game_board.get_diagonal_right_to_left
    assert_equal [nil, nil, nil], game_board.get_diagonal_left_to_right
    assert_equal [nil, nil, nil], game_board.get_first_column
    assert_equal [nil, nil, nil], game_board.get_second_column
    assert_equal [nil, nil, nil], game_board.get_third_column
    assert_equal [nil, nil, nil], game_board.get_first_row
    assert_equal [nil, nil, nil], game_board.get_second_row
    assert_equal [nil, nil, nil], game_board.get_third_row
  end

  def test_simple_changing_board
    player = Player.new("X")
    game_board = GameBoard.new
    game_board.play_the_board(0, player.name)
    assert_equal ["X", nil, nil], game_board.get_first_row
    assert_equal [nil, nil, nil], game_board.get_second_row
    assert_equal [nil, nil, nil], game_board.get_third_row
    assert_equal [nil, nil, nil], game_board.get_diagonal_right_to_left
    assert_equal ["X", nil, nil], game_board.get_diagonal_left_to_right
    assert_equal ["X", nil, nil], game_board.get_first_column
    assert_equal [nil, nil, nil], game_board.get_second_column
    assert_equal [nil, nil, nil], game_board.get_third_column
  end

  def test_if_an_empty_board_has_a_winner
    game_board = GameBoard.new
    assert_equal false, game_board.any_winning_sequence_complete?
  end

  def test_arbitrary_filling_of_board_has_no_winner
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name([0, 2, 4], :X)
    game_board.fill_indices_with_a_name([6, 8], :O)
    assert_equal false,game_board.any_winning_sequence_complete?
  end

  def test_if_arbitrary_filling_of_board_results_in_winner
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name([0, 1, 2], nil)
    assert_equal false,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_first_row_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.all_rows_indices[0], :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_second_row_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.all_rows_indices[1], :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_third_row_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.all_rows_indices[2], :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_first_column_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.all_columns_indices[0], :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_second_column_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.all_columns_indices[2], :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_third_column_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.all_columns_indices[1], :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_diagonal_left_right_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.diagonal_left_right_indices, :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_diagonal_right_left_is_filled
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.diagonal_right_left_indices, :X)
    assert_equal true,game_board.any_winning_sequence_complete?
  end

    def test_board_exception_is_thrown_if_board_is_already_has_completed_winning
    game_board = GameBoard.new
    game_board.fill_indices_with_a_name(game_board.all_rows_indices[0], :X)
    assert_raise BoardException  do game_board.play_the_board(3, :O) end
  end

  def test_board_exception_is_thrown_if_board_is_complete
    game_board = GameBoard.new
    board = Array.new(9, :X)
    game_board.set_board(board)
    assert_raise BoardException  do game_board.play_the_board(3, :O) end
  end

  def test_board_exception_is_thrown_if_board_index_is_wrong
    game_board = GameBoard.new
    assert_raise BoardException  do game_board.play_the_board(9, :O) end
    assert_raise BoardException  do game_board.play_the_board(10, :O) end
    assert_raise BoardException  do game_board.play_the_board(11, :O) end
    assert_raise BoardException  do game_board.play_the_board(-1, :O) end
    assert_raise BoardException  do game_board.play_the_board(-2, :O) end
    assert_raise BoardException  do game_board.play_the_board(-11, :O) end
    assert_raise BoardException  do game_board.play_the_board(-8, :O) end
    assert_raise BoardException  do game_board.play_the_board(-9, :O) end
    #not sure why
    #assert_raise BoardException  do game_board.play_the_board(1.1, :O) end
  end
end