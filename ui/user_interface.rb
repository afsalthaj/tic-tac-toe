# strategy shouldn't depend on a specific user interface.

class UserInterface
  def display_board(board)
    raise NotImplementedError,
          'All user interfaces should publish'
  end

  def notify_move
    raise NotImplementedError,
          'Asking the human player to move'
  end

  def handle_wrong_moves
    raise NotImplementedError,
          'Handle wrong moves from user, returning a new position'
  end

  def notify_game_over(board, winner)
    raise NotImplementedError,
          'Notfiying the human player and if need restart the game, or exit the process'
  end
end