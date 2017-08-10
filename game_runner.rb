require './game'

class GameRunner
  attr_reader :game_state

  def initialize
    @game_state = GameStrategy.new.generate
    @permanent_state = @game_state
  end

  def play_the_game
    if @game_state.game_over?
      announce_results
      @game_state = @permanent_state
      puts "Do you want to continue losing?!If yes 'y' else anything else!"
      fate = gets.chomp
      fate == 'y' ? play_the_game : Process.exit(0)
    end

    if @game_state.current_player == :X
      @game_state = @game_state.next_move
      puts "X's move:"
      display_board
      play_the_game
    else
      right_move_from_user
      puts "The result of your move:"
      display_board
      puts ""
      play_the_game
    end
  end

  def display_board
    board_to_display = []
    # fill in numbers for the user
    (0 ... 9).to_a.each { |index|
      board_to_display <<
          if @game_state.board[index].nil?
            index
          else
            @game_state.board[index]
          end
    }

    board_to_display.each_slice(3) do |row|
      print ' '
      puts row.join('|')
      puts '------------------'
    end
  end


  def right_move_from_user
    puts 'Enter Number where you want to place O:'
    position = gets

    node_in_move_tree = @game_state.moves.select {|game_state| game_state.board[position.to_i] == :O}.first

    if node_in_move_tree
      @game_state = node_in_move_tree
    else
      # this shows that the player has selected a wrong move as it is not found anywhere in the generated tree.1
      puts 'You have chosen a wrong move'
      right_move_from_user
    end
  end

  def announce_results
    if @game_state.draw?
      puts "Congrats! That's the best you can achieve"
    elsif @game_state.winner == :X
      puts 'Computer wins!'
    else
      puts 'Congrats! That was a clever move from your side!'
    end
  end
end

GameRunner.new.play_the_game