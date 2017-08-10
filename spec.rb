require 'simplecov'
SimpleCov.start

require './game'
require './game_runner'
require 'test/unit'

class Spec < Test::Unit::TestCase
  def test_if_game_has_winner
    super_game = Game.new(:X, Array.new(9))
    assert_equal( super_game.winner, nil)
    super_game = Game.new(:X, [:X, nil, nil, nil, :X, nil, nil, nil, :X])
    assert_equal super_game.winner, :X
    super_game = Game.new(:X, [:O, :O, :O, nil, nil, nil, nil, nil, nil])
    assert_equal :O, super_game.winner
  end

  def test_the_entire_game
    # creating a projection instance to see if all the functions in projection works fine``
    projection = Projection.new
    initial_game_state = Game.new(:X, [:X, :O, nil, nil, nil, nil, nil, nil, nil])
    game_strategy = GameStrategy.new
    game_strategy.simulate_all_moves(initial_game_state)
    # since the player is x, it should be able to call it's next move and the first position of the board in the array is x
    # computer playing the next game, so this is not handled as part of the game. the client has the flexibility to choose
    next_game_state = initial_game_state.next_best_move
    projection.display_board(next_game_state)
    # next move would be close to the max index as close to the initial position.
    assert(next_game_state.board[6] == :X || next_game_state.board[8] == :X)
    # to revert back to this state
    assert(next_game_state.current_player == :O)
    assert_nil (projection.display_board(next_game_state))
    # user switching to second position
    next_game_state = next_game_state.get_node_in_move_tree(2)
    # confirming the player now is :X, this is repeatedly tested for readability
    assert(next_game_state.current_player == :X)
    # Since user moved to a wrong position (bad move from user), computer will now go to either 6 (if previous was 4)
    # or 8 if previous was
    next_game_state = next_game_state.next_best_move
    puts  ('testing the projection of the board during an intermediate move')
    assert_nil(projection.display_board(next_game_state))
    assert(next_game_state.board[6] == :X || next_game_state.board[8] == :X || next_game_state.board[4] == :X)
    # save this game state
    save_this_state = next_game_state
    # if user selects 5, computer will select 8 or 6 and win. If user selects 8, computer will select 5 or 6 and win
    next_game_state = next_game_state.get_node_in_move_tree(5)
    next_game_state = next_game_state.next_best_move
    puts('projecting as part of testing the final win')
    projection.display_board(next_game_state)
    assert(next_game_state.board[8] == :X || next_game_state.board[6] == :X)
    # switching back to the previous state
    puts ('switching back to a previous state of the board. This will be a nice test. Nice that it ended up working')
    next_game_state = save_this_state
    projection.display_board(next_game_state)
    next_game_state = next_game_state.get_node_in_move_tree(7)
    projection.display_board(next_game_state)
    next_game_state = next_game_state.next_best_move
    assert(next_game_state.board[5] == :X || next_game_state.board[6] == :X)
  end

  def test_an_intermediate_game
    game_strategy = GameStrategy.new
    board = [:O, nil, :X, :X, nil, nil, :X, :O, :O]
    fake_game = Game.new(:X, board)
    game_strategy.simulate_all_moves(fake_game)
    assert_equal [-1, 1, -1], fake_game.moves.map{|x|x.score}
  end

  def test_game_over
    board = (0 ... 9 ).map {|_| :X}
    game = Game.new(:X, board)
    assert_not_nil ( game.game_over?)
    super_game = Game.new(:X, [:O, :O, :O, nil, nil, nil, nil, nil, nil])
    assert_not_nil(false, super_game.game_over?)
  end

  def test_game_won
    board = [:X, nil, nil, nil, :X, nil, nil, nil, :X]
    game = Game.new(:X, board)
    assert (game.game_won? :X)
    board = [:X, nil, nil, nil, nil, nil, nil, nil, :X]
    game = Game.new(:X, board)
    assert (!game.game_won?(:X))
  end

  def test_create_future_games
    game_runner = GameStrategy.new
    assert_not_nil(game_runner.simulate)
  end
end