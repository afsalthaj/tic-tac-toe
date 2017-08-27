# strategy shouldn't depend on a specific user interface.

class UserInterface
  def display_board(board)
    raise NotImplementedError,
          'All user interfaces should implement display board'
  end

  def notify_move_and_return_position
    raise NotImplementedError,
          'All user interfaces should be able to notify the user to move, and return the new position'
  end

  def handle_wrong_moves
    raise NotImplementedError,
          'All user interfaces should handle wrong moves from the user'
  end

  def notify_game_over(board, winner)
    raise NotImplementedError,
          'All user interfaces should notify if game is over, and either Exit or continue with game runner'
  end
end