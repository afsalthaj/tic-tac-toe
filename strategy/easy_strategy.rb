require '../strategy/game_strategy'
require '../game/game'
require '../player/player'
require '../game/game_board'

class RandomPickGameStrategy < GameStrategy
  def initialize(initial_player, player_combination, game_board)
    @initial_player = initial_player
    @player_combination = player_combination
    @game_board = game_board
    @game = Game.new(initial_player, game_board)
  end

  def next_move(position_in_board)
    # simple strategy, is moving the board depending on current player
    # move the board, switch the player and return the game
    # this is to show interface for strategy works.
  end

end