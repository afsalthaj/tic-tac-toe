class StrategyException < RuntimeError

end

# next_move and first_move returns a game.
class GameStrategy
  # all strategies should be able to identify whose move is next, and move the board accordingly.
  def next_move(position_in_board)
    raise NotImplementedError,
          'All strategies of game should have the next best move, where a move is a new state of the game'
  end

  # First move may or may not have
  # have different strategy compared to other moves. We always handle for the false case(not same),
  # hence first move is abstracted.
  def first_move(position_in_board)
    raise NotImplementedError,
          'All strategies should possibly have first_move that is to be defined'
  end
end