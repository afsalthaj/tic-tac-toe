require './players_combination.rb'

class PlayerCombinationFactory
  def set_name_if_not_nil(player_instance, name)
    unless name.nil?
      player_instance.send(:set_name, name)
    end
  end

  def get_a_player(name)
    instance = yield
    set_name_if_not_nil(instance, name)
    instance
  end

  def get_computer_player(name)
    get_a_player(name) {ComputerPlayer.new}
  end

  def get_human_player(name)
    get_a_player(name) {HumanPlayer.new}
  end

  def get_players_combination(player_one, player_two)
    PlayersCombination.new(player_one, player_two)
  end

  def get_computer_and_human(computer_name, human_name)
    player_one = get_computer_player(computer_name)
    player_two = get_human_player(human_name)
    get_players_combination(player_one, player_two)
  end

  def get_computer_and_computer(computer_one_name, computer_two_name)
    player_one, player_two = [computer_one_name, computer_two_name].map {|name| get_computer_player name}
    get_players_combination(player_one, player_two)
  end

  def get_human_and_human(human_one_name, human_two_name)
    player_one = get_human_player(human_one_name)
    player_two = get_human_player(human_two_name)
    get_players_combination(player_one, player_two)
  end
end