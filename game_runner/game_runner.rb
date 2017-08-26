require '../ui/user_interface'
require '../strategy/minimax_strategy'
require '../game/game_board'
require '../player/player_combination_factory'

#Game Runner acts as a middleware between UI and actual Game.

class GameRunners
  def initialize(ui, initial_player, player_combination)
    # currently game runner chooses the game dimension,
    # but this could be passed in as well as soon as we have strategies that supports more than size 3.
    puts initial_player
    puts player_combination.player2
    @game_board = GameBoard.new(3)
    @initial_player = initial_player
    @ui = ui
    @player_combination = player_combination
    @strategy = MiniMaxStrategy.new(initial_player, player_combination,game_board)
    @game = @strategy.game
    print @game.game_board
    @board_position = nil
  end

  def run_game
    @ui.display_board(@game.game_board)
    if @game.current_player.is_a?(HumanPlayer)
      @board_position = @ui.notify_move
    end
    @game = @strategy.first_move(@board_position)
    continue
  end

  def continue
    @ui.display_board(@game.game_board)
    if @game.game_over?
      @ui.notify_game_over(@game.game_board, @game.winner)
    elsif @game.current_player.is_a?(HumanPlayer)
      @board_position = ui.notify_move
      @game = @strategy.next_move(@board_position)
      @ui.display_board(@game.game_board)
    else
      @game = @strategy.next_move(nil)
      @ui.display_board(@game.game_board)
    end
    run_game
  end
end


class Runner
  strategy = MiniMaxStrategy.new(ComputerPlayer.new,
                          PlayerCombinationFactory.new.get_computer_and_human(nil, nil),
                          GameBoard.new(3))

  strategy.simulate
end
