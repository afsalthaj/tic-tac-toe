require '../game/game.rb'
require '../player/player.rb'
require '../game/game_board.rb'
require '../player/player_combination_factory'
require '../strategy/minimax_strategy'
require 'test/unit'

class MinmaxStrategySpec < Test::Unit::TestCase
  def test_strategy_doesnt_change_the_game_if_game_over
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.board.fill(player_combination.player1.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    assert_equal(strategy.game.game_board.board.to_a, Array.new(9).fill("X"))
    assert_equal(strategy.game.current_player.to_s, player_combination.player1.to_s)
  end

  def test_strategy_tries_to_move_to_winning_position_given_a_game
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(0, player_combination.player1.to_s)
    game_board.play_the_board(4, player_combination.player1.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    game = strategy.next_move(nil)
    assert_equal(game.winner, "X")
  end

  def test_computer_tries_to_win_if_there_is_a_chance_to_win_than_blocking_human
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    board = ["O", "O", nil, nil, nil, nil, "X", nil, "X"]
    strategy = MiniMaxStrategy.new(player_combination, GameBoard.new(3).set_board(board))
    game = strategy.next_move(nil)
    assert_equal(game.game_board.board[7], player_combination.player1.to_s)
  end

  def test_computer_tries_to_win_if_it_has_two_consecutive_positions
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(0, player_combination.player1.to_s)
    game_board.play_the_board(4, player_combination.player1.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    game = strategy.next_move(nil)
    assert_equal(game.winner, player_combination.player1.to_s)
  end

  def test_computer_tries_to_block_human_with_two_consecutive_positions
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(6, player_combination.player2.to_s)
    game_board.play_the_board(7, player_combination.player2.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    game = strategy.next_move(nil)
    assert_equal(game.game_board.board[8], player_combination.player1.to_s)
  end

  def test_strategy_throws_board_exception_if_human_chooses_a_position_already_filled
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(6, player_combination.player2.to_s)
    game_board.play_the_board(7, player_combination.player1.to_s)
    game_board.play_the_board(8, player_combination.player2.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    strategy.next_move(nil)
    assert_raises BoardException do strategy.next_move(6) end
  end

  def test_strategy_throws_board_exception_if_human_chooses_a_position_not_in_game_board
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(6, player_combination.player2.to_s)
    game_board.play_the_board(7, player_combination.player1.to_s)
    game_board.play_the_board(8, player_combination.player2.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    # computer making its first move
    strategy.next_move(nil)
    # user making its move
    assert_raises BoardException do strategy.next_move(-1) end
    assert_raises BoardException do strategy.next_move(11) end
    assert_raises BoardException do strategy.next_move(9) end
    assert_raises BoardException do strategy.next_move(2000) end
    assert_raises BoardException do strategy.next_move(nil) end
  end

  def test_if_strategy_switches_current_player_of_game_after_every_move
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    # this is just a sample board
    game_board.play_the_board(6, player_combination.player2.to_s)
    game_board.play_the_board(7, player_combination.player1.to_s)
    game_board.play_the_board(8, player_combination.player2.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    game = strategy.next_move(nil)
    assert_equal(player_combination.player2.to_s, game.current_player.to_s)
  end
end