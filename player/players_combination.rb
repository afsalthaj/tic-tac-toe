require '../player/player.rb'

class PlayersCombinationException < RuntimeError
end

class PlayersCombination
  attr_accessor :initial_player
  attr_accessor :player1, :player2

  def initialize(player1, player2)
    if player1.name.to_s != player2.name.to_s
      @player1 = player1
      @player2 = player2
    else
      raise PlayersCombinationException,
            'Two players have the same name. Please change the name of one of the players'
    end
  end

  def set_initial_player(initial_player)
    if [@player1, @player2].include?(initial_player)
      @initial_player = initial_player
    else
      raise PlayersCombinationException,
            'The initial player is not amongst the combination of players selected'
    end
  end
end