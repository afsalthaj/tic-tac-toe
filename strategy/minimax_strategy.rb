require '../strategy/game_strategy'
require '../game/game'
require '../player/player'
require '../game/game_board'
require '../player/player_combination_factory'

class MiniMaxStrategy < GameStrategy
  def initialize(initial_player, game_board)
    @initial_player = initial_player
    @game_board = game_board
    @game = Game.new(initial_player, game_board)
    @game_state = GameState.new(@game)
  end

  def simulate
    simulate_all_moves(@game_state)
  end

  def first_move(position_in_board)
    if @initial_player.is_a?(ComputerPlayer)
      next_move(nil)
    else
      @game_state = @game_state.get_node_in_move_tree(position_in_board)
    end
    return @game_state.game
  end

  def next_move(position_in_board)
    if @game_state.game.game_over?
      # upto the game_runner to see if game is over, as different strategies may or may not raise a game_over message.
      return @game_state.game
    elsif @game_state.game.current_player.is_a?(ComputerPlayer)
      @game_state = @game_state.next_best_move
    else
      @game_state = @game_state.get_node_in_move_tree(position_in_board)
    end
    @game_state.game
  end

  class GameState
    attr_accessor :score, :moves, :game
    def initialize(game)
      @game = game
      @moves = []
    end

    def score
      puts "m i here? 1"
      @score = final_score || intermediate_score
    end

    def intermediate_score
      puts "m i here? 2"
      scores = moves.collect {|game_state| game_state.score}
      if @game.current_player == "X"
        scores.max
      else
        scores.min
      end
    end

    def final_score
      puts "m i here 3"
      if @game.game_over?
        if @game.draw?
          return 0
        end
        @game.winner == "X" ? 1 : -1
      end
    end

    def get_node_in_move_tree(position_in_board)
      @moves.select {|game_state| game_state.game.game_board[position_in_board] == "O"}.first
    end

    def next_best_move
      result = moves.map {|x| x.score}
      result_max = result.each_with_index.max[1]
      moves[result_max]
    end
  end

  def simulate_all_moves(game_state)
    next_player = (game_state.game.current_player == "X" ? "O" : "X")
    #puts next_player
    #print game_state.game.game_board.board
    game_state.game.game_board.board.each_with_index do |player, index|
      unless player
        new_game_board = game_state.game.game_board.dup
        new_board = new_game_board.board.dup
        new_board[index] = game_state.game.current_player
        next_game_board = GameBoard.new(3, new_board)
        new_game = Game.new(next_player, next_game_board)
        next_game_state = GameState.new(new_game)
        game_state.moves << next_game_state
        simulate_all_moves(next_game_state)
      end
    end
  end
end



class Runner
  strategy = MiniMaxStrategy.new("X", GameBoard.new(3, nil))
  strategy.simulate
  puts state
end
