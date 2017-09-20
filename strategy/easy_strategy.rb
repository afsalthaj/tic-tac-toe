require '../strategy/game_strategy'
require '../game/game'
require '../player/player'
require '../game/game_board'
require '../player/player_combination_factory'
require '../utils/utils'

class EasyStrategy < GameStrategy
  def initialize(player_combination, game)
    @player_combination = player_combination
    @game = game
  end

  def next_move(position_in_board)
    if @game.game_over?
      @game
    elsif @game.current_player.to_s == @player_combination.player1.to_s ||
      @game.current_player.is_a?(ComputerPlayer)
      @game.game_board.play_the_board(get_random_position_in_board, @game.current_player.to_s)
    else
      @game.game_board.play_the_board(position_in_board, @game.current_player.to_s)
    end
    @game.current_player=switch_player(@game.current_player)
    @game
  end

  def get_random_position_in_board
    @game.game_board.empty_indices.sample
  end

  def switch_player(current_player)
    current_player.to_s == @player_combination.player1.to_s ? @player_combination.player2 : @player_combination.player1
  end
end
