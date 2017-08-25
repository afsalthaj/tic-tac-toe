require '../ui/user_interface'
require '../game_runner/game_runner'
require '../player/player_combination_factory'

class CommandLine < UserInterface
  def trigger_game_runner
    puts "Do you want to play? 'y'"
    player_combination_factory = PlayerCombinationFactory.new
    player_combination = player_combination_factory.get_computer_and_human(nil, nil)
    status = gets.chomp
    initial_player = status == 'y' ? player_combination.player2 : player_combination.player1
    game_runner = GameRunner.new(self, initial_player, player_combination)
    game_runner.run_game
  end

  def notify_move
    puts 'Please enter your next position in the board'
    get_position_from_human_player
  end

  def get_position_from_human_player
    move = gets.chomp
    return move
  end

  def handle_wrong_moves
    puts 'You have made a wrong move, Choose a position which is empty'
    get_position_from_human_player
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
  end

  def notify_game_over(board, winner)
    puts 'Game over!'
    message = winner.nil? ? 'Its a draw' : "the winner is #{winner}"
    puts message
    display_board(board)
    puts 'Wanna play again? if so enter '
    status = gets.chomp
    if status ==  'y'
      trigger_game_runner
    else
      Process.exit(0)
    end
  end
end

CommandLine.new.trigger_game_runner