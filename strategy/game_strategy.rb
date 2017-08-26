class StrategyException < RuntimeError

end

# A game strategy should have next move function implemented, the next move is a property of the strategy.
class GameStrategy
  def next_move(position_in_board)
    raise NotImplementedError,
          'All strategies of AI in tic-tac-toe should have the `next_move` implemented,
           where a move is a new state of the game'
  end
end