#!/usr/bin/env ruby

class Game
  attr_accessor :current_player, :board, :moves, :rank

  def initialize(current_player, board)
    @current_player = current_player
    @board = board
    @moves = []
  end

  def score
    @score = final_state_rank || intermediate_state_rank
  end

  def next_move
    moves.max {|a, b| a.score <=> b.score}
  end

  def final_state_rank
    if game_over?
      return 0 if draw?
      winner == :X ? 1 : -1
    end
  end

  def game_over?
    winner || draw?
  end

  def draw?
    board.compact.size == 9 && winner.nil?
  end

  # this is intermediate state.
  def intermediate_state_rank
    scores = moves.collect {|game_state| game_state.score}
    if current_player == :X
      scores.max
    else
      scores.min
    end
  end

  def game_won?(player)
    winning_sequences = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                         [0, 3, 6], [1, 4, 7], [2, 5, 8],
                         [0, 4, 8], [2, 4, 6]]
    winning_sequences.each {|sequence|
      if sequence.all? {|a| @board[a] == player}
        return true
      end
    }
    false
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

  def get_node_in_move_tree(position_in_board)
    @moves.select {|game_state| game_state.board[position_in_board] == :O}.first
  end
end

class GameStrategy
  def generate_moves(game_state)
    next_player = (game_state.current_player == :X ? :O : :X)
    game_state.board.each_with_index do |player_at_position, position|
      unless player_at_position
        next_board = game_state.board.dup
        next_board[position] = game_state.current_player
        next_game_state = Game.new(next_player, next_board)
        game_state.moves << next_game_state
        generate_moves(next_game_state)
      end
    end
  end

  #beginning of a game is generating all possible combinations and nodes.
  # this tree is then used to track down the scores
  def generate
    initial_game_state = Game.new(:X, Array.new(9))
    generate_moves(initial_game_state)
    initial_game_state
  end
end