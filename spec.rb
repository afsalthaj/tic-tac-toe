require './game'
require 'test/unit'

class Spec < Test::Unit::TestCase
  def test_if_game_is_winner
    super_game = GameState.new(:X, Array.new(9))
    assert_equal( super_game.winner, nil)
    super_game = GameState.new(:X, [:X, nil, nil, nil, :X, nil, nil, nil, :X])
    assert_equal super_game.winner, :X
    super_game = GameState.new(:X, [:O, :O, :O, nil, nil, nil, nil, nil, nil])
    assert_equal :O, super_game.winner
  end

  def test_future_generation_moves
    mini_max_tree = GameTree.new
    board = [:X, :O, nil, :X, :X, :O, :O, nil, nil]
    initial_game_state = GameState.new(:X, board)
    mini_max_tree.generate_moves(initial_game_state)
    next_movee =  initial_game_state.next_move
    print next_movee.board
  end
end
