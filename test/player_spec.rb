require '../player/player.rb'
require 'test/unit'

class PlayerSpec < Test::Unit::TestCase
  def test_initialization_of_computer_player
    computer_player = ComputerPlayer.new
    assert_equal "X", computer_player.name
  end

  def test_initialization_of_human_player
    human_player = HumanPlayer.new
    assert_equal "O", human_player.name
  end

  def test_setting_human_names_directly
    human_player = HumanPlayer.new
    human_player.set_name(:X)
    assert_equal :X, human_player.name
  end

  def test_setting_computer_names_directly_throws_no_method_error
    computer_player = ComputerPlayer.new
    computer_player.set_name(:O)
    assert_equal :O,  computer_player.name
  end

  def test_using_string_version_of_computer_with_default_name
    computer_player = ComputerPlayer.new
    assert_equal "X",  computer_player.to_s
  end

  def test_using_string_version_of_computer_with_custom_name
    computer_player = ComputerPlayer.new
    computer_player.set_name(:O)
    assert_equal "O",  computer_player.to_s
  end

  def test_using_string_version_of_human_with_default_name
    human_player = HumanPlayer.new
    assert_equal "O",  human_player.to_s
  end

  def test_using_string_version_of_human_with_custom_name
    human_player = HumanPlayer.new
    human_player.set_name(:X)
    assert_equal "X",  human_player.to_s
  end
end