require '../game/game.rb'
require '../player/player.rb'
require '../game/game_board.rb'
require '../player/player_combination_factory'
require 'test/unit'

class GameSpec < Test::Unit::TestCase
  def test_instantiation_of_game_provides_a_game_board_and_current_player
    game_board = GameBoard.new(3)
    game = Game.new(:X, game_board)
    assert(game.current_player == :X && game.game_board.board.size == 9)
  end

  def test_instantiation_of_game_with_an_actual_player_and_verifying_current_player_type
    game_board = GameBoard.new(3)
    game = Game.new(HumanPlayer.new, game_board)
    assert game.current_player.is_a?(HumanPlayer)
    game = Game.new(ComputerPlayer.new, game_board)
    assert game.current_player.is_a?(ComputerPlayer)
  end

  def test_instantiation_of_game_using_player_combination_gives_correct_players_as_current_player
    game_board = GameBoard.new(3)
    # factory method gives player1 as computer and player2 as human
    player_combination = PlayerCombinationFactory.new.get_computer_and_human(nil, nil)
    game = Game.new(player_combination.player1, game_board)
    assert (game.current_player.is_a?(ComputerPlayer))
    game = Game.new(player_combination.player2, game_board)
    assert (game.current_player.is_a?(HumanPlayer))
  end

  def test_if_game_has_a_winner_when_board_is_complete_and_nil_if_not_complete
    game_board = GameBoard.new(3)
    game_board.board.fill(:X)
    game = Game.new(:X, game_board)
    assert(game.winner == :X )
    game_board.board.fill(:Y)
    assert(game.winner == :Y)
    game_board.reset_board
    assert(game.winner ==  nil)
  end

  def test_if_game_is_a_draw_when_board_is_complete_and_there_is_no_winner
    game_board = GameBoard.new(3)
    game_board.set_board([:X, :O, :X, :O, :X, :O, :O , :X, :O])
    game = Game.new(:X, game_board)
    assert game.draw?
  end

  def test_complete_index_or_winner_results_in_game_over
    game_board = GameBoard.new(3)
    game_board.board.fill("X")
    game = Game.new("X", game_board)
    assert(game.game_over?)
    game_board.set_board([:X, :O, :X, :O, :X, :O, :O , :X, :O])
    assert(game.game_over?)
  end
end