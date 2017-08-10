require './game'
require './game_runner'
require 'test/unit'

class Spec < Test::Unit::TestCase
  def test_if_game_is_winner
    super_game = Game.new(:X, Array.new(9))
    assert_equal( super_game.winner, nil)
    super_game = Game.new(:X, [:X, nil, nil, nil, :X, nil, nil, nil, :X])
    assert_equal super_game.winner, :X
    super_game = Game.new(:X, [:O, :O, :O, nil, nil, nil, nil, nil, nil])
    assert_equal :O, super_game.winner
  end

  def test_the_entire_game
    initial_game_state = Game.new(:X, Array.new(9))
    game_strategy = GameStrategy.new
    game_strategy.generate_moves(initial_game_state)
    assert(initial_game_state.current_player == :X)
    # since the player is x, it should be able to call it's next move and the first position of the board in the array is x
    next_game_state = initial_game_state.next_move
    # after the first move, deterministically the first move is the first position in the array.
    assert(next_game_state.board[0] == :X)
    # after the first move done by the computer the state of the game will have the current player as user.
    assert(next_game_state.current_player == :O)
    assert_not_nil(next_game_state.get_node_in_move_tree(1))
    # updating the game with the new move, which is made by the user
    next_game_state = next_game_state.get_node_in_move_tree(1)
    assert(next_game_state.board[1] == :O)
    # switch the player to computer
    assert(next_game_state.current_player == :X)
    # computer playing the next game, so this is not handled as part of the game. the client has the flexibility to choose
    next_game_state = next_game_state.next_move
    # next move would be close to the first position of X which was 0, 1 is already acquired by :O
    # the move will be either 3 or 4
    assert(next_game_state.board[3] == :X || next_game_state.board[4] == :X)
    # to revert back to this state
    # creating a projection instance to see if all the functions in projection works fine``
    projection = Projection.new
    assert(next_game_state.current_player == :O)
    assert_nil (projection.display_board(next_game_state))
    # user switching to second position
    next_game_state = next_game_state.get_node_in_move_tree(2)
    # confirming the player now is :X, this is repeatedly tested for readability
    assert(next_game_state.current_player == :X)
    # Since user moved to a wrong position (bad move from user), computer will now go to either 6 (if previous was 4)
    # or 8 if previous was
    next_game_state = next_game_state.next_move
    puts  ('testing the projection of the board during an intermediate move')
    assert_nil(projection.display_board(next_game_state))
    assert(next_game_state.board[6] == :X || next_game_state.board[8] == :X || next_game_state.board[4] == :X)
    # save this game state
    save_this_state = next_game_state
    # if user selects 5, computer will select 8 or 6 and win. If user selects 8, computer will select 5 or 6 and win
    next_game_state = next_game_state.get_node_in_move_tree(5)
    next_game_state = next_game_state.next_move
    puts('projecting as part of testing the final win')
    projection.display_board(next_game_state)
    assert(next_game_state.board[8] == :X || next_game_state.board[6] == :X)
    # switching back to the previous state
    puts ('switching back to a previous state of the board. This will be a nice test. Nice that it ended up working')
    next_game_state = save_this_state
    projection.display_board(next_game_state)
    next_game_state = next_game_state.get_node_in_move_tree(8)
    next_game_state = next_game_state.next_move
    assert(next_game_state.board[5] == :X || next_game_state.board[6] == :X)
  end
end
