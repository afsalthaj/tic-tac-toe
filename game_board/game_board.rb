#!/usr/bin/env ruby
# Please note first row second row or third row
# doesn't change as you increase the board size
# However, the design is focused on 3x3 matrix
# We could split dimension class separately, but that sounds over-designing to me.
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
  def initialize
    @board = Array.new(9)
  end

  def set_board(board)
    if @board.size == board.size
      @board = board
    else
      raise BoardException, "You have to ideally set a board with a size #{@board.size}"
    end
  end

  def play_the_board(index, name)
    if is_invalid_move?(index)
      raise BoardException, 'Invalid move, Please pick another position in the board'
    else
      @board[index] = name
    end
  end

  def is_invalid_move?(index)
    any_winning_sequence_complete? || board_complete? ||
        is_board_filled_in_the_index(index) || is_index_not_part_of_dimensions(index)
  end

  def winning_sequences
    [get_first_row, get_second_row, get_third_row,
     get_first_column, get_second_column, get_third_column,
     get_diagonal_left_to_right, get_diagonal_right_to_left]
  end

  def any_winning_sequence_complete?
    !winning_sequences.select {|sequence| sequence.same_values? && !sequence[0].nil?}.empty?
  end

  def board_complete?
    @board.all?{|value| !value.nil?}
  end

  def is_board_filled_in_the_index(index)
    ! @board[index].nil?
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

  def get_first_row
    get_elements_from_board(all_rows_indices[0])
  end

  def get_second_row
    get_elements_from_board(all_rows_indices[1])
  end

  def get_third_row
    get_elements_from_board(all_rows_indices[2])
  end

  def get_first_column
    get_elements_from_board(all_columns_indices[0])
  end

  def get_second_column
    get_elements_from_board(all_columns_indices[2])
  end

  def get_third_column
    get_elements_from_board(all_columns_indices[1])
  end

  def get_diagonal_left_to_right
    get_elements_from_board(diagonal_left_right_indices)
  end

  def get_diagonal_right_to_left
    get_elements_from_board(diagonal_right_left_indices)
  end

  def fill_indices_with_a_name(indices, player)
    indices.map {|index| play_the_board(index, player)}
  end

  def reset_board
    @board = Array.new(9)
  end
end