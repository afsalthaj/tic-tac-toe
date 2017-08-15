# A game is nothing but a state of board and player
# Changing the game in terms of board and player is the responsibility of game strategy

class Game
  attr_accessor :board
  attr_accessor :current_player

  def initialize(current_player, board)
    @current_player = current_player.clone
    @board = board.clone
  end

  def game_won?(player)
    @board.winning_sequences.each {|sequence|
      if sequence.all? {|a| @board[a] == player.name}
        return true
      end
    }
    false
  end

  def winner
    @winner =
        if game_won? :X
          :X
        elsif game_won? :O
          :O
        else
          nil
        end
  end

  def game_over?
    winner || draw?
  end

  def draw?
    board.compact.size == 9 && winner.nil?
  end
end