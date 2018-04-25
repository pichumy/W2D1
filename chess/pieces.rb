require 'singleton'
require_relative 'stepable'
require_relative 'sliding'
require 'byebug'

UNICODES = {
  white: {
    king: "\u2654".encode('utf-8'),
    queen: "\u2655".encode('utf-8'),
    rook: "\u2656".encode('utf-8'),
    knight: "\u2658".encode('utf-8'),
    bishop: "\u2657".encode('utf-8'),
    pawn: "\u2659".encode('utf-8'),
  },
  black: {
    king: "\u265A".encode('utf-8'),
    queen: "\u265B".encode('utf-8'),
    rook: "\u265C".encode('utf-8'),
    knight: "\u265E".encode('utf-8'),
    bishop: "\u265D".encode('utf-8'),
    pawn: "\u265F".encode('utf-8'),
  }
}

class Piece
  attr_reader :color
  attr_accessor :pos
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def valid_moves
    moves.reject do |move|
      duped_board = @board.deep_dup
      duped_board.move(@pos, move)
      duped_board.in_check?(@color)
    end
  end

  def to_s
    UNICODES[@color][@symbol]
  end

  def inspect
    {'Type' => self.class, 'color' => @color, 'pos' => @pos}.inspect
  end

  def deep_dup
    deep_pos = @pos.dup
  end

  def get_board(board)
    @board = board
  end

  def is_null?(position)
    @board[position] == NullPiece.instance
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
  end

  def to_s
    return " "
  end

  def deep_dup
    self
  end
end

class Bishop < Piece
  include SlidingPiece

  def initialize(color, board, position)
    @symbol = :bishop
    super(color, board, position)
  end

  def move_dirs
    [:diagonal]
  end

  def deep_dup
    deep_pos = super
    Bishop.new(@color, nil, deep_pos)
  end

end

class Queen < Piece
  include SlidingPiece

  def initialize(color, board, position)
    @symbol = :queen
    super(color, board, position)
  end

  def move_dirs
    [:diagonal, :horizontal]
  end

  def deep_dup
    deep_pos = super
    Queen.new(@color, nil, deep_pos)
  end

end

class Rook < Piece
  include SlidingPiece

  def initialize(color, board, position)
    @symbol = :rook
    super(color, board, position)
  end

  def move_dirs
    [:horizontal]
  end

  def deep_dup
    deep_pos = super
    Rook.new(@color, nil, deep_pos)
  end

end

class King < Piece
  include Stepable
  def initialize(color, board, position)
    @symbol = :king
    super(color, board, position)
  end

  def move_diffs
    [[1,0], [1, 1], [0, 1], [-1 ,0], [0, -1], [-1, -1], [1, -1], [-1, 1]]
  end

  def deep_dup
    deep_pos = super
    King.new(@color, nil, deep_pos)
  end

end

class Knight < Piece
  include Stepable
  def initialize(color, board, position)
    @symbol = :knight
    super(color, board, position)
  end

  def move_diffs
    [[1, 2], [2, 1], [2, -1], [1, -2], [-1 ,2], [-2 ,1], [-2, -1], [-1, -2]]
  end

  def deep_dup
    deep_pos = super
    Knight.new(@color, nil, deep_pos)
  end

end

class Pawn < Piece
  def initialize(color, board, position)
    @symbol = :pawn
    @start_position = position
    super(color, board, position)
  end

  def moves
    results = []
    directions = move_dirs

    move_dirs.each do |move|
      x, y = @pos
      d_x, d_y = move
      new_pos = [x + d_x, y + d_y]
      next unless @board.valid_pos?(new_pos)
      if move.all? { |m| m.abs == 1 } #diagnols
        results.push(new_pos) if !is_null?(new_pos) && @board[new_pos].color != @color

      elsif move.include?(-2) || move.include?(2) #first move of 2 for black
        results.push(new_pos) if move_2?(new_pos)

      elsif is_null?(new_pos) #standard move
        results.push(new_pos)
      end
      # results += diagnols(new_pos)
    end
    results
  end

  # def diagnols(new_pos)
  #   moves = move_dirs.select {|move| move.all? {|m| m.abs == 1}}
  #   moves.select {|move| !is_null?(new_pos) && @board[new_pos].color != @color}
  # end

  def move_2?(new_pos)
    x, y = new_pos
    @color == :white ? (x -= 1) : (x += 1)
    @pos == @start_position && is_null?(new_pos) && is_null?([x, y])
  end

  def move_dirs
    dirs = [[1, 0], [2, 0], [1, -1], [1, 1]]
    @color == :white ? dirs : (dirs.map { |set| [set[0] * -1, set[1] * -1] })
  end

  def deep_dup
    deep_pos = super
    Pawn.new(@color, nil, deep_pos)
  end

end
