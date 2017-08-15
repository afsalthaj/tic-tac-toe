#!/usr/bin/env ruby

class Game
  attr_accessor :board
  attr_accessor :current_player

  def initialize(current_player, board)
    @current_player = current_player.clone
    @board = board.clone
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

  def game_over?
    winner || draw?
  end

  def draw?
    board.compact.size == 9 && winner.nil?
  end
end

class GameStrategy
  class GameState
    attr_accessor :score, :moves, :game
    def initialize(game)
      @game = game
      @moves = []
    end

    def score
      @score = final_score || intermediate_score
    end

    def intermediate_score
      scores = moves.collect {|game_state| game_state.score}
      if @game.current_player == :X
        scores.max
      else
        scores.min
      end
    end

    def final_score
      if @game.game_over?
        if @game.draw?
          return 0
        end
        @game.winner == :X ? 1 : -1
      end
    end

    def get_node_in_move_tree(position_in_board)
      @moves.select {|game_state| game_state.game.board[position_in_board] == :O}.first
    end

    def next_best_move
      result = moves.map {|x| x.score}
      result_max = result.each_with_index.max[1]
      moves[result_max]
    end
  end

  def simulate_all_moves(game_state)
    next_player = (game_state.game.current_player == :X ? :O : :X)
    game_state.game.board.each_with_index do |player, index|
      unless player
        next_board = game_state.game.board.dup
        next_board[index] = game_state.game.current_player
        new_game = Game.new(next_player, next_board)
        next_game_state = GameState.new(new_game)
        game_state.moves << next_game_state
        simulate_all_moves(next_game_state)
      end
    end
  end

  def simulate(player)
    board = Array.new(9)
    game = Game.new(player, board)
    game_state = GameState.new(game)
    simulate_all_moves(game_state)
    game_state
  end
end