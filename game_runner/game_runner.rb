require '../ui/user_interface'
require '../strategy/minimax_strategy'
require '../game/game_board'
require '../player/player_combination_factory'

#Game Runner acts as a middleware between UI and actual Game.

class GameRunner
  def initialize(ui, strategy, game)
    @ui = ui
    @strategy = strategy
    @game = game
  end

  def run_game
    @ui.display_board(@game.game_board)
    if @game.game_over?
      @ui.notify_game_over(@game.game_board, @game.winner)
    else
      handle_board_movements
      run_game
    end
  end

  def handle_board_movements
    if @game.current_player.is_a?(HumanPlayer)
      handle_human_move
    else
      @game = @strategy.next_move(nil)
    end
  end

  def handle_human_move
    board_position = @ui.notify_move_and_return_position
    begin
      @game = @strategy.next_move(board_position)
    rescue BoardException => ex
      @ui.handle_wrong_moves
    end
  end
end