require '../player/player_combination_factory'
require '../player/players_combination'
require '../player/player'
require 'test/unit'

class PlayersCombinationFactorySpec < Test::Unit::TestCase

  def test_creating_computer_human_player
    player_combination_factory = PlayerCombinationFactory.new
    player_combination = player_combination_factory.get_computer_and_human(nil, nil)
    assert player_combination.player1.is_a?(ComputerPlayer)
    assert player_combination.player2.is_a?(HumanPlayer)
  end

  def test_creating_computer_human_player_with_same_name_exception
    player_combination_factory = PlayerCombinationFactory.new
    assert_raises PlayersCombinationException do player_combination_factory.get_computer_and_human(:X, :X) end
  end

  def test_creating_computer_computer_player_with_same_name_exception
    player_combination_factory = PlayerCombinationFactory.new
    assert_raises PlayersCombinationException do player_combination_factory.get_computer_and_computer(nil, nil) end
    assert_raises PlayersCombinationException do player_combination_factory.get_computer_and_computer(:X, :X) end

  end

  def test_creating_human_human_player_with_same_name_exception
    player_combination_factory = PlayerCombinationFactory.new
    assert_raises PlayersCombinationException do player_combination_factory.get_human_and_human(nil, nil) end
    assert_raises PlayersCombinationException do player_combination_factory.get_human_and_human(:X, :X) end
  end

  def test_creating_computer_human_player_with_different_names
    player_combination_factory = PlayerCombinationFactory.new
    player_combination = player_combination_factory.get_computer_and_human(:X, :O)
    assert_equal :X,player_combination.player1.name
    assert_equal :O, player_combination.player2.name
  end

  def test_creating_computer_computer_player_with_different_names
    player_combination_factory = PlayerCombinationFactory.new
    player_combination = player_combination_factory.get_computer_and_computer(:X, :O)
    assert_equal :X, player_combination.player1.name
    assert_equal :O, player_combination.player2.name
  end

  def test_creating_human_human_player_with_different_names
    player_combination_factory = PlayerCombinationFactory.new
    player_combination = player_combination_factory.get_human_and_human(:X, :O)
    assert_equal :X,player_combination.player1.name
    assert_equal :O, player_combination.player2.name
  end
end