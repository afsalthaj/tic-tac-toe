class Game
  attr_accessor :game_board
  attr_accessor :current_player

  def initialize(current_player, game_board)
    @current_player = current_player.clone
    @game_board = game_board.clone
  end

  def set_game_board(game_board)
    @game_board = game_board
  end

  def set_current_player(current_player)
    @current_player = current_player
  end

  def winner
    winning_sequence = @game_board.any_winning_sequence_complete?
    unless winning_sequence.nil?
      @winner = winning_sequence.first
    end
  end

  def draw?
    @game_board.no_more_positions_available? && winner.nil?
  end

  def game_over?
    winner || draw?
  end
end

class GameException < RuntimeError
end