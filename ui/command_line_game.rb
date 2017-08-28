require '../ui/user_interface'
require '../game_runner/game_runner'
require '../player/player_combination_factory'

class CommandLineGame < UserInterface
  def trigger_game_runner
    puts "Do you want to play? 'y'"
    player_combination_factory = PlayerCombinationFactory.new
    player_combination = player_combination_factory.get_computer_and_human(nil, nil)
    status = gets.chomp
    set_initial_player(player_combination, status)
    @game_board = GameBoard.new(3)
    game = Game.new(player_combination.initial_player, @game_board)
    # We could ask user and set a difficulty level, and use the strategy
    strategy = MiniMaxStrategy.new(player_combination, game)
    game_runner = GameRunner.new(self, strategy, game)
    game_runner.run_game
  end

  def set_initial_player(player_combination, status)
    if status == 'y'
      player_combination.set_initial_player(player_combination.player2)
    else
      player_combination.set_initial_player(player_combination.player1)
    end
  end

  def notify_move_and_return_position
    puts 'Please enter your next position in the board'
    get_position_from_human_player
  end

  def set_game_difficulty
    puts "Choose the level of difficulty of game"
  end

  def get_position_from_human_player
    move = gets.chomp
    return move.to_i
  end

  def handle_wrong_moves
    puts 'You have made a wrong move, You must be choosing a position which is empty'
  end

  def display_board(game_board)
    board_to_display = []
    board_size = game_board.game_dimension * game_board.game_dimension
    (0 ... board_size).to_a.each { |index|
      board_to_display <<
          if  game_board.board[index].nil?
            index
          else
            game_board.board[index].to_s
          end
    }

    board_to_display.each_slice(game_board.game_dimension) do |row|
      print ' '
      puts row.join('|')
      puts '------------------'
    end
    puts "===================================================="
  end

  def notify_game_over(board, winner)
    puts 'Game over!'
    message = winner.nil? ? 'Its a draw' : "the winner is #{winner}"
    puts message
    display_board(board)
    puts "Do you want to play again? if so enter 'y'"
    status = gets.chomp
    if status ==  'y'
      trigger_game_runner
    else
      Process.exit(0)
    end
  end
end

CommandLineGame.new.trigger_game_runner