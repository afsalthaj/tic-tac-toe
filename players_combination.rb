require './player.rb'

class PlayersCombinationException < RuntimeError
end

class PlayersCombination
  attr_accessor :player1, :player2

  def initialize(player1, player2)
    if player1.name == player2.name
      raise PlayersCombinationException, 'two players have the same name. Please change the name of one of the players'
    end
    @player1 = player1
    @player2 = player2
  end
end