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
      @game_state = @game_state.get_node_in_move_tree(position_in_board)
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
      x = @moves.select {|game_state| game_state.game.game_board.board[position_in_board] == @player_combination.player2.to_s}.first
    end

    def next_best_move
      result = moves.map {|x| x.score}
      result_max = result.each_with_index.max[1]
      moves[result_max]
    end
  end

  def simulate_all_moves(game_state)
    next_player = (game_state.game.current_player.to_s == @player_combination.player1.to_s ?  @player_combination.player2 :  @player_combination.player1)
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
end

=begin
class Runner
  player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
  player_combination.set_initial_player(player_combination.player1)
  strategy = MiniMaxStrategy.new(player_combination,GameBoard.new(3))
  game = strategy.next_move(nil)
  print(game.game_board.board, "\n")
  game = strategy.next_move(7)
  print(game.game_board.board, "\n")
  game = strategy.next_move(nil)
  print(game.game_board.board, "\n")
  game = strategy.next_move(2)
  print(game.game_board.board, "\n")
  game = strategy.next_move(nil)
  print(game.game_board.board, "\n")
  game = strategy.next_move(1)
  print(game.game_board.board, "\n")
  game = strategy.next_move(nil)
  print(game.game_board.board, "\n")
 # strategy.simulate
 # puts state
end
=end
