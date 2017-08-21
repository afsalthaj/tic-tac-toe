class StrategyException < RuntimeError

end

# All strategies will give the current state of the game as return value to `next_move` and `first_move`
class GameStrategy
  def next_move(position_in_board)
    raise NotImplementedError,
          'All strategies of game should have the next best move, where a move is a new state of the game'
  end

  def first_move(position_in_board)
    raise NotImplementedError,
          'All strategies should possibly have first_move that is to be defined'
  end
end