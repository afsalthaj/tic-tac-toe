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
    winning_sequences = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                         [0, 3, 6], [1, 4, 7], [2, 5, 8],
                         [0, 4, 8], [2, 4, 6]]
    winning_sequences.each {|sequence|
      if sequence.all? {|a| @board[a] == player}
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