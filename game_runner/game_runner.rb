require '../ui/user_interface'
require '../strategy/minimax_strategy'
require '../game/game_board'
require '../player/player_combination_factory'

#Game Runner acts as a middleware between UI and actual Game.

class GameRunner
  def initialize(ui, player_combination)
    @game_board = GameBoard.new(3)
    @ui = ui
    @strategy = MiniMaxStrategy.new(player_combination, @game_board)
    @game = @strategy.game
    @board_position = nil
  end

  def run_game
    @ui.display_board(@game.game_board)
    if @game.game_over?
      @ui.notify_game_over(@game.game_board, @game.winner)
    elsif @game.current_player.is_a?(HumanPlayer)
      @board_position = @ui.notify_move
      @game = @strategy.next_move(@board_position)
    else
      @game = @strategy.next_move(nil)
    end
    run_game
  end
end