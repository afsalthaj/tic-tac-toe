class StrategyException < RuntimeError

end

# All strategies will give the current state of the game as return value to `next_move` and `first_move`
class GameStrategy
  # All strategies exposes the current game to the client.
  attr_accessor :game

  def next_move(position_in_board)
    raise NotImplementedError,
          'All strategies of game should define the next move, where a move is a new state of the game'
  end
end