require '../strategy/game_strategy'
require '../game/game'
require '../player/player'
require '../game/game_board'

class MiniMaxStrategy < GameStrategy
  def initialize(game_board, initial_player, player_combination)
    @initial_player = initial_player
    game = Game.new(initial_player, game_board)
    @game_state = GameState.new(game)
    @player_combination = player_combination
    puts @game_state.game.game_board.is_a?(Array)
  end

  def fire
    simulate_all_moves(@game_state)
    @game_state
  end

  def game
    @game_state.game
  end

  def first_move(position_in_board)
    if @initial_player.is_a?(ComputerPlayer)
      next_move(nil)
    else
      @game_state.get_node_in_move_tree(position_in_board)
    end
    return @game_state.game
  end

  def next_move(position_in_board)
    if @game_state.game.game_over?
      # upto the game_runner to see if game is over, as different strategies may or may not raise a game_over message.
      return @game_state.game
    elsif @game_state.game.current_player.is_a?(ComputerPlayer)
      @game_state.next_best_move
    elsif
      @game_state.get_node_in_move_tree(position_in_board)
    end
    return @game_state.game
  end

  def simulate_all_moves(game_state)
    print game_state.game.current_player
    next_player = (game_state.game.current_player.is_a?(ComputerPlayer) ? HumanPlayer.new : ComputerPlayer.new)
    game_state.game.game_board.board.each_with_index do |player, index|
      unless player
        next_board = game_state.game.game_board.dup
        next_board.board[index] = game_state.game.current_player
        new_game = Game.new(next_player, next_board)
        next_game_state = GameState.new(new_game)
        game_state.moves << next_game_state
        simulate_all_moves(next_game_state)
      end
    end
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
      @moves.select {|game_state| game_state.game.game_board.board[position_in_board].is_a?(HumanPlayer)}.first
    end

    def next_best_move
      result = moves.map {|x| x.score}
      result_max = result.each_with_index.max[1]
      moves[result_max]
    end
  end
end