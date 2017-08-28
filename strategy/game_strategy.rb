class StrategyException < RuntimeError

end

# All strategies will give the current state of the game as return value to `next_move` and `first_move`
class GameStrategy
  def next_move(position_in_board)
    raise NotImplementedError,
          'All strategies of game should define the next move, and returns a game'
  end
end