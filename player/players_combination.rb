require '../player/player.rb'

class PlayersCombinationException < RuntimeError
end

class PlayersCombination
  attr_accessor :player1, :player2, :initial_player

  def initialize(player1, player2)
    if player1.name != player2.name
      @player1 = player1
      @player2 = player2
    else
      raise PlayersCombinationException,
            'two players have the same name. Please change the name of one of the players'
    end

    def set_initial_player(initial_player)
      @initial_player =
          if [@player1, @player2].include?(initial_player)
            initial_player
          else
            raise PlayersCombinationException,
                  'the initial player should be one amongst the pair of players'

          end
    end
  end
end