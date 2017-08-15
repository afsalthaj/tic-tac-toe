require './game_v2.rb'

class GameStrategy
  # A computer's move is in fact dependent on the game that is produced by the movement of
  # human.
  def computer_move(game)
    raise NotImplementedError,
          'All strategies of game should have the next best move, where a move is a new state of the game'
  end

  # A human's move is in fact dependent on just the board index.
  def human_move(board_index)
    raise NotImplementedError,
          'All strategies should implement '
  end
end

class MiniMaxGameStrategy < GameStrategy


  class GameState

  end


  def initialize(game)
    # each game and set of moves corresponding to those games and scores
    @game_score = {}
    simulate_all_moves(game)
  end

  def simulate_all_moves(game)
    moves_and_scores = {}
    next_player = (game.current_player == :X ? :O : :X)
    game.board.each_with_index do |player, index|
      unless player
        next_board = game.board.dup
        next_board[index] = game.current_player
        next_game_state = GameV2.new(next_board, next_player)
        score(next_game_state)
        moves_and_scores.merge({next_game_state => score(next_game_state)})
        @game_score.merge ({game => moves_and_scores})
        simulate_all_moves(next_game_state)
      end
    end
  end

  def get_node_in_move_tree(position_in_board)
    @game_score.keys.select {|game_state| game_state.board[position_in_board] == :O}.first
  end

  def human_move(position_in_board)
    get_node_in_move_tree(position_in_board)
  end

  def computer_move
    result = @game_score.values
    result_max = result.each_with_index.max[1]
    @game_score[result_max]
  end


  def score(game)
    @score = final_score(game) || intermediate_score(game)
  end

  def final_score(game)
    if game.game_over?
      if game.draw?
        return 0
      end
      game.winner == :X ? 1 : -1
    end
  end

  def intermediate_score(game)
    scores = @game_score[game].values.keys.collect {|game_state| score(game_state)}
    if current_player == :X
      scores.max
    else
      scores.min
    end
  end

end

class NormalGameStrategy < GameStrategy
end

class RandomPickGameStrategy < GameStrategy
end