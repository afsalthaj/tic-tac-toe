# A game is nothing but a state of board and player
# Changing the game in terms of board and player is the responsibility of game strategy

class GameV2
  attr_accessor :board, :player

  def initialize (board, player)
    @board = board
    @player = player
  end

  def set_board(board)
    @board = board
  end

  def set_player(player)
    @board = player
  end

  def game_over?
    winner || draw?
  end

  def draw?
    board.compact.size == 9 && winner.nil?
  end

  def winner

  end
end