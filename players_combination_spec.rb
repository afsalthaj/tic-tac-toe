require './players_combination.rb'
require './player.rb'
require 'test/unit'

class PlayersCombinationSpec < Test::Unit::TestCase

  def test_creating_different_players_combination_with_default_names
    player1 = ComputerPlayer.new
    player2 = HumanPlayer.new
    player_combination = PlayersCombination.new(player1, player2)
    assert player_combination.player1.is_a?(ComputerPlayer)
    assert player_combination.player2.is_a?(HumanPlayer)
  end

  def test_creating_different_players_combination_with_different_custom_names
    player1 = ComputerPlayer.new
    player1.set_name(:X)
    player2 = HumanPlayer.new
    player2.set_name(:O)
    players_combination = PlayersCombination.new(player1, player2)
    assert_equal :X, players_combination.player1.name
    assert_equal :O, players_combination.player2.name
  end

  def test_creating_different_players_combination_with_same_custom_names_throwing_exception
    player1 = ComputerPlayer.new
    player1.set_name(:X)
    player2 = HumanPlayer.new
    player2.set_name(:X)
    assert_raise PlayersCombinationException do PlayersCombination.new(player1, player2) end
  end

  def test_creating_different_players_combination_with_human_default_name_and_computer_custom_name
    player1 = ComputerPlayer.new
    player1.set_name(:X)
    player2 = HumanPlayer.new
    players_combination = PlayersCombination.new(player1, player2)
    assert_equal :X, players_combination.player1.name
    assert_equal :O, players_combination.player2.name
  end

  def test_creating_different_players_combination_with_computer_default_name_and_human_custom_name
    player1 = ComputerPlayer.new
    player2 = HumanPlayer.new
    player2.set_name(:O)
    players_combination = PlayersCombination.new(player1, player2)
    assert_equal :X, players_combination.player1.name
    assert_equal :O, players_combination.player2.name
  end

  def test_creating_different_players_combination_with_computer_default_name_and_human_custom_name_throwing_exception
    player1 = ComputerPlayer.new
    player2 = HumanPlayer.new
    player2.set_name(:X)
    assert_raise PlayersCombinationException do PlayersCombination.new(player1, player2) end
  end

  def test_creating_different_players_combination_with_human_default_name_and_computer_custom_name_throwing_exception
    player1 = ComputerPlayer.new
    player1.set_name(:O)
    player2 = HumanPlayer.new
    assert_raise PlayersCombinationException do PlayersCombination.new(player1, player2) end
  end

  def test_creating_computer_players_with_default_names_throwing_exception
    player1 = ComputerPlayer.new
    player2 = ComputerPlayer.new
    assert_raise PlayersCombinationException do PlayersCombination.new(player1, player2) end
  end

  def test_creating_computer_players_combination_with_same_custom_names_throwing_exception
    player1 = ComputerPlayer.new
    player1.set_name(:X)
    player2 = ComputerPlayer.new
    player2.set_name(:X)
    assert_raise PlayersCombinationException do PlayersCombination.new(player1, player2) end
  end

  def test_creating_computer_players_combination_with_different_custom_names
    player1 = ComputerPlayer.new
    player1.set_name(:X)
    player2 = ComputerPlayer.new
    player2.set_name(:O)
    players_combination = PlayersCombination.new(player1, player2)
    assert_equal :X, players_combination.player1.name
    assert_equal :O, players_combination.player2.name
  end

  def test_creating_human_players_combination_with_default_names_throwing_exception
    player1 = HumanPlayer.new
    player2 = HumanPlayer.new
    assert_raise PlayersCombinationException  do PlayersCombination.new(player1, player2) end
  end

  def test_creating_human_players_combination_with_same_custom_names_throwing_exception
    player1 = HumanPlayer.new
    player1.set_name(:O)
    player2 = HumanPlayer.new
    player1.set_name(:O)
    assert_raise PlayersCombinationException  do PlayersCombination.new(player1, player2) end
  end

  def test_creating_human_players_combination_with_different_custom_names
    player1 = HumanPlayer.new
    player1.set_name(:X)
    player2 = HumanPlayer.new
    player2.set_name(:O)
    players_combination = PlayersCombination.new(player1, player2)
    assert_equal :X, players_combination.player1.name
    assert_equal :O, players_combination.player2.name
  end
end