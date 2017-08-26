require '../strategy/game_strategy'
require '../game/game'
require '../player/player'
require '../game/game_board'
require '../player/player_combination_factory'

class MiniMaxStrategy < GameStrategy
  def initialize(initial_player, player_combination, game_board)
    @initial_player = initial_player
    @player_combination = player_combination
    @game_board = game_board
    @game = Game.new(initial_player, game_board)
    @game_state = GameState.new(@game)
    simulate_all_moves(@game_state)
  end

  def first_move(position_in_board)
    puts @game_state.moves.size
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
      x = @moves.select {|game_state| game_state.game.game_board.board[position_in_board].is_a?(HumanPlayer)}.first
    end

    def next_best_move
      result = moves.map {|x| x.score}
      result_max = result.each_with_index.max[1]
      moves[result_max]
    end
  end

  def simulate_all_moves(game_state)
    next_player = (game_state.game.current_player.to_s == @player_combination.player1.to_s ?  @player_combination.player2 :  @player_combination.player1)
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
    # run your code here
  player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
  puts player_combination.player1
  puts player_combination.player2
  strategy =MiniMaxStrategy.new(player_combination.player1, player_combination,GameBoard.new(3, nil))
  game = strategy.first_move(nil)
  print(game.game_board.board)
  game = strategy.next_move(2)
  print (game.game_board.board)
  # strategy.simulate
 # puts state
end
