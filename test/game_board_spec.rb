require '../game/game_board.rb'
require '../player/player.rb'
require 'test/unit'

class GameBoardSpec < Test::Unit::TestCase

  def test_initial_board_dimensions
    game_board = GameBoard.new(3)
    assert_equal [nil, nil, nil, nil, nil, nil, nil, nil, nil], game_board.board
  end

  def test_all_rows_indices
    game_board = GameBoard.new(3)
    assert_equal [[0, 1, 2], [3, 4, 5], [6, 7, 8]], game_board.all_rows_indices
  end

  def test_all_columns_indices
    game_board = GameBoard.new(3)
    assert_equal [[0, 3, 6], [2, 5, 8], [1, 4, 7]], game_board.all_columns_indices
  end

  def test_rows_columns_diagonals_indices_generation_3_3_board
    game_board = GameBoard.new(3)
    assert_equal [0, 1, 2], game_board.all_rows_indices[0]
    assert_equal [3, 4, 5], game_board.all_rows_indices[1]
    assert_equal [6, 7, 8], game_board.all_rows_indices[2]
    assert_equal [0, 3, 6], game_board.all_columns_indices[0]
    assert_equal [1, 4, 7], game_board.all_columns_indices[2]
    assert_equal [2, 5, 8], game_board.all_columns_indices[1]
    assert_equal [0, 4, 8], game_board.diagonal_left_right_indices
    assert_equal [2, 4, 6], game_board.diagonal_right_left_indices
  end

  def test_rows_columns_diagonals_indices_generation_4_4_board
    game_board = GameBoard.new(4)
    assert_equal [0, 1, 2, 3], game_board.all_rows_indices[0]
    assert_equal [4, 5, 6, 7], game_board.all_rows_indices[1]
    assert_equal [8, 9, 10, 11], game_board.all_rows_indices[2]
    assert_equal [12, 13, 14, 15], game_board.all_rows_indices[3]
    assert_equal [0, 4, 8, 12], game_board.all_columns_indices[0]
    assert_equal [2, 6, 10, 14], game_board.all_columns_indices[2]
    assert_equal [1, 5, 9, 13], game_board.all_columns_indices[3]
    assert_equal [3, 7, 11, 15], game_board.all_columns_indices[1]
    assert_equal [0, 5, 10, 15], game_board.diagonal_left_right_indices
    assert_equal [3, 6, 9, 12], game_board.diagonal_right_left_indices
  end

  def test_winning_sequence_for_a_4_4_game_board
    game_board = GameBoard.new(4)
    assert_equal [[0, 1, 2, 3], [4, 5, 6, 7],
                  [8, 9, 10, 11], [12, 13, 14, 15], [0, 4, 8, 12],
                  [3, 7, 11, 15], [2, 6, 10, 14], [1, 5, 9, 13],
                  [0, 5, 10, 15], [3, 6, 9, 12]], game_board.winning_sequences
  end

  def test_winning_sequence_for_a_3_3_game_board
    game_board = GameBoard.new(3)
    assert_equal [[0, 1, 2], [3, 4, 5],
                  [6, 7, 8], [0, 3, 6], [2, 5, 8], [1, 4, 7],
                  [0, 4, 8], [2, 4, 6]], game_board.winning_sequences
  end

  def test_simple_changing_the_board_board
    player = Player.new("X")
    game_board = GameBoard.new(3)
    game_board.play_the_board(0, player.name)
  end

  def test_if_an_empty_board_has_a_winner
    game_board = GameBoard.new(3)
    assert_equal nil, game_board.any_winning_sequence_complete?
  end

  def test_arbitrary_filling_of_board_has_no_winner
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player([0, 2, 4], :X)
    game_board.fill_indices_with_a_player([6, 8], :O)
    assert_equal nil, game_board.any_winning_sequence_complete?
  end

  def test_filling_of_nils_in_board_results_has_no_winner
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player([0, 1, 2], nil)
    assert_equal nil, game_board.any_winning_sequence_complete?
  end

  def test_board_has_winner_if_first_row_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.all_rows_indices[0], :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_board_has_winner_if_second_row_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.all_rows_indices[1], :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_board_has_winner_if_third_row_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.all_rows_indices[2], :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_board_has_winner_if_first_column_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.all_columns_indices[0], :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_board_has_winner_if_second_column_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.all_columns_indices[2], :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_board_has_winner_if_third_column_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.all_columns_indices[1], :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_board_has_winner_if_diagonal_left_right_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.diagonal_left_right_indices, :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_if_a_board_has_winner_if_diagonal_right_left_is_filled
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.diagonal_right_left_indices, :X)
    assert_equal [:X, :X, :X], game_board.any_winning_sequence_complete?
  end

  def test_board_exception_is_thrown_if_board_already_has_completed_winning
    game_board = GameBoard.new(3)
    game_board.fill_indices_with_a_player(game_board.all_rows_indices[0], :X)
    assert_raise BoardException do
      game_board.play_the_board(3, :O)
    end
  end

  def test_board_exception_is_thrown_if_board_index_is_wrong
    game_board = GameBoard.new(3)
    assert_raise BoardException do
      game_board.play_the_board(9, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(10, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(11, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(-1, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(-2, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(-11, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(-8, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(-9, :O)
    end
    assert_raise BoardException do
      game_board.play_the_board(nil, :O)
    end
    #not sure why, to be discussed with hamish
    #assert_raise BoardException  do game_board.play_the_board(1.1, :O) end
  end


  def test_fill_the_game_board_with_an_actual_player
    player1 = ComputerPlayer.new
    player2 = HumanPlayer.new
    game_board = GameBoard.new(3)
    game_board.play_the_board(3, player2)
    game_board.fill_indices_with_a_player(game_board.all_rows_indices[0], player1)
    assert(game_board.any_winning_sequence_complete?[0].is_a?(ComputerPlayer))
    assert_equal("X", game_board.any_winning_sequence_complete?[0].to_s)
  end
end