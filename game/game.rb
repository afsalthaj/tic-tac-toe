# A game is nothing but a state of board and player
# Changing the game in terms of board and player is the responsibility of game strategy

class Game
  attr_accessor :board
  attr_accessor :current_player

  def initialize(current_player, board)
    @current_player = current_player.clone
    @board = board.clone
  end

  def winner
    winning_sequence = @board.any_winning_sequence_complete?
    unless winning_sequence.nil?
      @winner = winning_sequence.first
    end
  end

  def game_over?
    winner || draw?
  end

  def draw?
    board.no_more_positions_available? && winner.nil?
  end
end