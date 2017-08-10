require './game'

class Projection
  def display_board(game)
    board_to_display = []
    # fill in numbers for the user
    (0 ... 9).to_a.each { |index|
      board_to_display <<
          if game.board[index].nil?
            index
          else
            game.board[index]
          end
    }

    board_to_display.each_slice(3) do |row|
      print ' '
      puts row.join('|')
      puts '------------------'
    end
  end

  def announce_results(game)
    if game.draw?
      puts "Congrats! That's the best you can achieve"
    elsif game.winner == :X
      puts 'Computer wins!'
    else
      puts 'Congrats! That was a clever move from your side!'
    end
  end
end

class GameRunner
  attr_reader :game_state

  def initialize
    @game_state = GameStrategy.new.generate
    @permanent_state = @game_state
    @projection = Projection.new
  end

  def play_the_game
    if @game_state.game_over?
      @projection.announce_results(@game_state)
      @game_state = @permanent_state
      puts "Do you want to continue losing?! If yes 'y' else anything else!"
      fate = gets.chomp
      fate == 'y' ? play_the_game : Process.exit(0)
    end

    if @game_state.current_player == :X
      @game_state = @game_state.next_move
      puts "X's move:"
      @projection.display_board(@game_state)
      play_the_game
    else
      right_move_from_user
      puts "The result of your move:"
      @projection.display_board(@game_state)
      puts ""
      play_the_game
    end
  end

  def right_move_from_user
    puts 'Enter Number where you want to place O:'
    index = gets
    node_in_move_tree = @game_state.get_node_in_move_tree(index.to_i)
    if node_in_move_tree
      @game_state = node_in_move_tree
    else
      # this shows that the player has selected a wrong move as it is not found anywhere in the generated tree.1
      puts 'You have chosen a wrong move'
      right_move_from_user
    end
  end
end