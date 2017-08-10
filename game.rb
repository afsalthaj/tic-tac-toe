#!/usr/bin/env ruby

class GameState
  attr_accessor :current_player, :board, :moves, :rank

  def initialize(current_player, board)
    @current_player = current_player
    @board = board
    @moves = []
  end

  def rank
    @rank = final_state_rank || intermediate_state_rank
  end

  def next_move
    moves.max{ |a, b| a.rank <=> b.rank }
  end

  def final_state_rank
    if final_state?
      return 0 if draw?
      winner == :X ? 1 : -1
    end
  end

  def final_state?
    winner || draw?
  end

  def draw?
    board.compact.size == 9 && winner.nil?
  end

  # this is intermediate state.
  def intermediate_state_rank
    ranks = moves.collect{ |game_state| game_state.rank }
    if current_player == :X
      ranks.max
    else
      ranks.min
    end
  end

  def game_won?(player)
    winning_sequences = [[0, 1, 2],
                         [3, 4, 5],
                         [6, 7, 8],
                         [0, 3, 6],
                         [1, 4, 7],
                         [2, 5, 8],
                         [0, 4, 8],
                         [2, 4, 6]]
    result = winning_sequences.each {|sequence|
      if sequence.all? {|a| @board[a] == player}
        return true
      end
    }
    # not sure if there is any other easy way, to get around the truthy nature of Ruby conditional statements
    if result == true
      true
    else
      false
    end
  end


  def winner
    @winner =
        if game_won? :X
          :X
        elsif game_won? :O
          :O
        else
          nil
        end
  end
end

class GameTree
  def generate_moves(game_state)
    next_player = (game_state.current_player == :X ? :O : :X)
    game_state.board.each_with_index do |player_at_position, position|
      unless player_at_position
        next_board = game_state.board.dup
        next_board[position] = game_state.current_player
        next_game_state = GameState.new(next_player, next_board)
        game_state.moves << next_game_state
        #print game_state.board
        generate_moves(next_game_state)
      end
    end
  end

  def generate
    initial_game_state = GameState.new(:X, Array.new(9))
    generate_moves(initial_game_state)
    initial_game_state
  end
end

class MainGame
  attr_reader :game_state

  def initialize
    @game_state = GameTree.new.generate
  end

  def play_the_game
    if @game_state.final_state?
      describe_final_game_state
      Process.exit(0)
    end

    if @game_state.current_player == :X
      @game_state = @game_state.next_move
      puts "X's move:"
      display_board
      play_the_game
    else
      get_human_move
      puts "The result of your move:"
      display_board
      puts ""
      play_the_game
    end
  end

  def display_board
    output = ""
    0.upto(8) do |position|
      output << " #{@game_state.board[position] || position} "
      case position % 3
        when 0, 1 then output << "|"
        when 2 then output << "\n-----------\n" if position != 8
      end
    end
    puts output
  end

  def get_human_move
    puts "Enter Number"
    position = gets

    move = @game_state.moves.find{ |game_state| game_state.board[position.to_i] == :O }

    if move
      @game_state = move
    else
      puts "That's not a valid move"
      get_human_move
    end
  end

  def describe_final_game_state
    if @game_state.draw?
      puts "It was a draw!"
    elsif @game_state.winner == :X
      puts "X won!"
    else
      puts "O won!"
    end
  end
end

MainGame.new.play_the_game