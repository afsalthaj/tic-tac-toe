#!/usr/bin/env ruby
# Separating the board validation is something that we can think of...hmmm... well..not now!

class Array
  def same_values?
    self.uniq.length == 1
  end
end

class BoardException < RuntimeError
end

class GameBoard
  attr_accessor :board
  def initialize(game_dimension)
    @board = Array.new(game_dimension * game_dimension)
  end

  def set_board(board)
    if @board.size == board.size
      @board = board
    else
      raise BoardException, "You have to ideally set a board with a size #{@board.size}"
    end
  end

  def play_the_board(index, player)
    if is_invalid_move?(index)
      raise BoardException, 'Invalid move, Please pick another position in the board'
    else
      @board[index] = player
    end
  end

  def is_invalid_move?(index)
    any_winning_sequence_complete? || no_more_positions_available? ||
        is_board_filled_in_the_index(index) || is_index_not_part_of_dimensions(index)
  end

  def winning_sequences
    all_rows_indices.concat(all_columns_indices) <<
        (diagonal_left_right_indices) << (diagonal_right_left_indices)
  end

  def any_winning_sequence_complete?
    winning_sequences.map{|x| get_elements_from_board(x)}
        .select {|sequence| sequence.same_values? && !sequence[0].nil?}[0]
  end

  def no_more_positions_available?
    @board.all?{|value| !value.nil?}
  end

  def is_board_filled_in_the_index(index)
    !@board[index].nil?
  end

  def is_index_not_part_of_dimensions(index)
    !(0 ... board.size).include?(index)
  end

  def all_rows_indices
    (0 ... @board.size).to_a.each_slice(Math.sqrt(@board.size)).to_a
  end

  def all_columns_indices
    (0 ... Math.sqrt(board.size)).map {|column_picker|
      (0 ... @board.size).to_a.select{|x| ((x + column_picker) % Math.sqrt(@board.size)) == 0 }}
  end

  def diagonal_left_right_indices
    (0 ... @board.size).to_a.select{|x| (x % (Math.sqrt(@board.size) + 1)) == 0}
  end

  def diagonal_right_left_indices
    (1 ... @board.size - 1).to_a.select{|x| (x % (Math.sqrt(@board.size) - 1)) == 0}
  end

  def get_elements_from_board(indices)
    indices.map {|index| @board[index]}
  end

  def fill_indices_with_a_name(indices, player)
    indices.map {|index| play_the_board(index, player)}
  end

  def reset_board
    @board = Array.new(@board.size)
  end
end