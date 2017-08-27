require '../game/game.rb'
require '../player/player.rb'
require '../game/game_board.rb'
require '../player/player_combination_factory'
require '../strategy/minimax_strategy'
require 'test/unit'

class MinmaxStrategySpec < Test::Unit::TestCase
  def test_strategy_doesnt_change_the_game_if_its_already_over
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    player_combination.set_initial_player(player_combination.player1)
    game_board = GameBoard.new(3)
    game_board.board.fill(player_combination.player1.to_s)
    strategy = MiniMaxStrategy.new(player_combination, game_board)
    game_board_doesnt_change = strategy.game.game_board.board = game_board.board
    game_board_doesnt_change = strategy.game.current_player == player_combination.player1
    assert(game_board_doesnt_change && game_board_doesnt_change)
  end
end