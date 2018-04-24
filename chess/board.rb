require_relative 'pieces.rb'

class Board
  
  attr_reader :board
  
  def initialize
    @board = nil 
    setup
  end
  
  def setup
    null_board = Array.new(8) { Array.new(8) { NullPiece.instance } }
    
    @board = null_board
    
    2.times do |row|
      8.times do |col|
        null_board[row][col] = Piece.new(:white, @board, [row, col])
      end
    end
    
    2.times do |row|
      8.times do |col|
        null_board[row + 6][col] = Piece.new(:black, @board, [row + 6, col])
      end
    end
    
    null_board
  end
  
  def move_piece(start_pos, end_pos)
    raise "There is no piece at that starting position" if self[start_pos] == NullPiece.instance
    
    piece = self[start_pos]
    moves = piece.valid_moves
    raise "Invalid move." unless moves.include?(end_pos)
    
    if self[end_pos] == NullPiece.instance 
      self[end_pos] = piece
      piece.pos = end_pos
      self[start_pos] = NullPiece.instance 
    else 
      if piece.color == self[end_pos].color
        raise "Error, you can't attack your own pieces!"
      end 
      self[end_pos] = piece
      piece.pos = end_pos 
      self[start_pos] = NullPiece.instance 
    end 
    
  end
  
  def valid_pos?(pos)
    pos.all? { |point| point.between?(0,7) }
  end 
  
  def [](pos)
    x, y = pos
    @board[x][y]
  end 
  
  def []=(pos, value)
    x, y = pos 
    @board[x][y] = value
  end

  def inspect 
    "stop displaying a big ass board"
  end 
  
end
