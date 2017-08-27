require '../strategy/game_strategy'
require '../game/game'
require '../player/player'
require '../game/game_board'
require '../player/player_combination_factory'
require '../utils/utils'

# strategy where player combination is always going to be computer and human, and no other combination works
class MiniMaxStrategy < GameStrategy
  attr_accessor :game
  def initialize(player_combination, game_board)
    @player_combination = player_combination
    @game_board = game_board
    @game = Game.new(player_combination.initial_player, game_board)
    @game_state = GameState.new(@game, @player_combination)
    simulate_all_moves(@game_state)
  end

  def next_move(position_in_board)
    if @game_state.game.game_over?
      @game_state.game
    elsif @game_state.game.current_player.to_s == @player_combination.player1.to_s
      @game_state = @game_state.next_best_move
    else
      if @game_state.game.game_board.is_invalid_move?(position_in_board)
        # The strategy can raise board exception in different scenarios, hence they need to be explicitly handled
        raise BoardException
      else
        @game_state = @game_state.get_node_in_move_tree(position_in_board)
      end
    end
    @game_state.game
  end

  class GameState
    attr_accessor :score, :moves, :game
    def initialize(game, player_combination)
      @player_combination = player_combination
      @game = game
      @moves = []
    end

    def score
      @score = final_score || intermediate_score
    end

    def intermediate_score
      scores = moves.collect {|game_state| game_state.score}
      if @game.current_player.to_s == @player_combination.player1.to_s
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
        @game.winner == @player_combination.player1.to_s ? 1 : -1
      end
    end

    def get_node_in_move_tree(position_in_board)
      result = @moves.select {|game_state|
        human_in_board_position?(game_state.game.game_board, position_in_board)
      }.first
      if result.nil?
        # The strategy can raise board exception in different scenarios, hence they need to be explicitly handled
        raise BoardException
      else
        result
      end
    end

    def human_in_board_position?(game_board, position_in_board)
      game_board.board[position_in_board] == @player_combination.player2.to_s
    end

    def next_best_move
      result = moves.map {|x| x.score}
      result_max = result.each_with_index.max[1]
      moves[result_max]
    end
  end

  def simulate_all_moves(game_state)
    next_player = switch_player(game_state.game.current_player)
    game_state.game.game_board.board.each_with_index do |player, index|
      unless player
        new_game_board = Utils.deep_copy(game_state.game.game_board)
        new_game_board.board[index] = game_state.game.current_player.to_s
        new_game = Game.new(next_player, new_game_board)
        next_game_state = GameState.new(new_game, @player_combination)
        game_state.moves << next_game_state
        simulate_all_moves(next_game_state)
      end
    end
  end

  def switch_player(current_player)
    current_player.to_s == @player_combination.player1.to_s ? @player_combination.player2 : @player_combination.player1
  end
end
