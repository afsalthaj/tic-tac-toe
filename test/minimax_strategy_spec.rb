require '../game/game.rb'
require '../player/player.rb'
require '../game/game_board.rb'
require '../player/player_combination_factory'
require '../strategy/minimax_strategy'
require 'test/unit'
require '../utils/utils'

class MinmaxStrategySpec < Test::Unit::TestCase
  def test_strategy_tries_to_move_to_winning_position_given_a_game
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(0, player_combination.player1.to_s)
    game_board.play_the_board(4, player_combination.player1.to_s)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
    game = strategy.next_move(nil)
    assert_equal(game.winner, "X")
  end

  def test_computer_tries_to_win_if_there_is_a_chance_to_win_than_blocking_human
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    board = ["O", "O", nil, nil, nil, nil, "X", nil, "X"]
    game = Game.new(player_combination.initial_player, GameBoard.new(3).set_board(board))
    strategy = MiniMaxStrategy.new(player_combination, game)
    game = strategy.next_move(nil)
    assert_equal(game.game_board.board[7], player_combination.player1.to_s)
  end

  def test_computer_tries_to_win_if_it_has_two_consecutive_positions
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(0, player_combination.player1.to_s)
    game_board.play_the_board(4, player_combination.player1.to_s)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
    game = strategy.next_move(nil)
    assert_equal(game.winner, player_combination.player1.to_s)
  end

  def test_computer_tries_to_block_human_with_two_consecutive_positions
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.play_the_board(6, player_combination.player2.to_s)
    game_board.play_the_board(7, player_combination.player2.to_s)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
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
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
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
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
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
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
    game = strategy.next_move(nil)
    assert_equal(player_combination.player2.to_s, game.current_player.to_s)
  end

  def test_computer_always_win_or_draw_when_computer_plays_first_move
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    game_board = GameBoard.new(3)
    player_combination.set_initial_player(player_combination.player1)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
    iterate_all_games(game, strategy, player_combination)
  end

  def test_computer_always_win_or_draw_when_human_plays_first_move
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    game_board = GameBoard.new(3)
    # To reduce the time consumption in running all games.
    # It reduces the number of assertions from 681 to 118.
    game_board.play_the_board((0 ... 9).to_a.sample, player_combination.player1.to_s)
    player_combination.set_initial_player(player_combination.player2)
    game = Game.new(player_combination.initial_player, game_board)
    strategy = MiniMaxStrategy.new(player_combination, game)
    iterate_all_games(game, strategy, player_combination)
  end

  def iterate_all_games(game, strategy, player_combination)
    if game.game_over?
      assert(game.winner == player_combination.player1.to_s || game.draw?)
    elsif game.current_player.is_a?(ComputerPlayer)
      new_game = Utils.deep_copy(game)
      new_strategy=MiniMaxStrategy.new(player_combination, new_game)
      next_game = new_strategy.next_move(nil)
      iterate_all_games(next_game, new_strategy, player_combination)
    else
     game.game_board.board.each_with_index.select{|player, index|player.nil?}
     .map { |_, index|
        new_game = Utils.deep_copy(game)
        new_strategy=MiniMaxStrategy.new(player_combination, new_game)
        next_game=new_strategy.next_move(index)
        iterate_all_games(next_game, new_strategy, player_combination)
      }
    end
  end
end
