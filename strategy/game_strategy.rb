class GameStrategy
  # A computer's move is in fact dependent on the game that is produced by the movement of
  # human.
  def next_move(player)
    raise NotImplementedError,
          'All strategies of game should have the next best move, where a move is a new state of the game'
  end
end