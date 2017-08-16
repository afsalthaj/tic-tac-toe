require '../strategy/game_strategy'
require '../game/game'
require '../player/player'
require '../game/game_board'

class MiniMaxStrategy < GameStrategy
  def initialize(game_board)
    

  end

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
      if @game.current_player.is_a?(ComputerPlayer)
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
        @game.winner.is_a?(ComputerPlayer) ? 1 : -1
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