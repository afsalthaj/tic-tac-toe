require '../ui/user_interface'
require '../strategy/minimax_strategy'
require '../game/game_board'

class GameRunner
  def initialize(ui, initial_player, player_combination)
    # currently game runner chooses the game dimension
    @board = GameBoard.new(3)
    @game = Game.new(@board, @initial_player)
    @initial_player = initial_player
    @ui = ui
    @player_combination = player_combination
    @strategy = MiniMaxStrategy.new(board, initial_player,player_combination)
    @board_position = nil
  end

  def play_initial_move
    ui.display_board
    if @game.current_player.is_a?(HumanPlayer)
      @board_position = ui.notify_move
    end
    @game = @strategy.first_move(@board_position)
  end

  def run_game
    ui.display_board(@game.game)
    if @game.game_over?
      ui.notify_game_over(@game.board, @game.winner)
    elsif @game.current_player.is_a?(HumanPlayer)
      @board_position = ui.notify_move
      @game = @strategy.next_move(@board_position)
      ui.display_board(@game.board)
    else
      @game = @strategy.next_move(nil)
      ui.display_board(@game.board)
    end
    run_game
  end
end