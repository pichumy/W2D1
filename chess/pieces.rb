require 'singleton'
require_relative 'stepable'
require_relative 'sliding'


class Piece
  attr_reader :color 
  attr_accessor :pos 
  def initialize(color, board, pos)
    @color = color
    @board = board 
    @pos = pos
  end
  
  def valid_moves
    moves
  end
  
  def to_s
    return "P" 
  end 
  
  def inspect
    {'Type' => self.class, 'color' => @color, 'pos' => @pos}.inspect  
  end 
end

class NullPiece < Piece
  include Singleton
  
  def initialize
  end
  
  def to_s 
    return " "
  end 
end

class Bishop < Piece
  include SlidingPiece
  
  def initialize(color, board, position)
    @symbol = :b
    super(color, board, position)
  end 
  
  def move_dirs 
    [:diagonal]
  end 
  
  def to_s 
    if @color == :white 
      "\u2657".encode('utf-8')
    else 
      "\u265D".encode('utf-8')
    end 
  end 
end 

class Queen < Piece 
  include SlidingPiece
  
  def initialize(color, board, position) 
    @symbol = :q
    super(color, board, position) 
  end 
  
  def move_dirs
    [:diagonal, :horizontal] 
  end
  
  def to_s
    if @color == :white 
      "\u2655".encode('utf-8')
    else 
      "\u265B".encode('utf-8')
    end 
  end 
end 

class Rook < Piece 
  include SlidingPiece
  
  def initialize(color, board, position) 
    @symbol = :r
    super(color, board, position) 
  end 
  
  def move_dirs
    [:horizontal]
  end
  
  def to_s 
    if @color == :white 
      "\u2656".encode('utf-8')
    else 
      "\u265C".encode('utf-8')
    end 
  end 
end 

class King < Piece 
  include Stepable  
  def initialize(color, board, position)
    @symbol = :k
    super(color, board, position) 
  end 
  
  def move_diffs 
    [ 
      [1,0], 
      [1,1],
      [0,1],
      [-1,0],
      [0,-1],
      [-1,-1],
      [1, -1],
      [-1, 1] 
    ]
  end
  
  def to_s
     if @color == :white 
       "\u2654".encode('utf-8')
     else 
       "\u265A".encode('utf-8')
     end 
  end 

end 

class Knight < Piece 
  include Stepable 
  def initialize(color, board, position)
    @symbol = :n 
    super(color, board, position) 
  end 
  
  def move_diffs
    [
      [1,2],
      [2,1],
      [2,-1],
      [1,-2],
      [-1,2],
      [-2,1],
      [-2,-1],
      [-1,-2] 
    ]
  end
  
  def to_s 
    if @color == :white 
      "\u2658".encode('utf-8')
    else 
      "\u265E".encode('utf-8')
    end 
  end 
end 

class Pawn < Piece 
  def initialize(color, board, position) 
    @symbol = :p
    @start_position = position
    super(color, board, position)
  end 
  
  def valid_moves
    results = []
    directions = move_dirs
     
    move_dirs.each do |move| 
      x, y = @pos
      d_x, d_y = move 
      new_pos = [x + d_x, y + d_y]
      if move.all? { |m| m.abs == 1 }
        if @board[new_pos] != NullPiece.instance && @board[new_pos].color != @color 
          results.push(new_pos)
        end 
      elsif move.include?(2)
        if @pos == @start_position && @board[new_pos] == NullPiece.instance && 
          @board[[x + 1, y + d_y]] == NullPiece.instance
          results.push(new_pos)
        end
      elsif move.include?(-2)
        if @pos == @start_position && @board[new_pos] == NullPiece.instance && 
          @board[[x + -1, y + d_y]] == NullPiece.instance
          results.push(new_pos)
        end 
      elsif @board[new_pos] == NullPiece.instance 
        results.push(new_pos)
      end 
    end 
    results  
  end
   
  def move_dirs
    if @color == :white 
      [
        [1, 0],
        [2, 0],
        [1,-1],
        [1,1]
      ]
    else 
      [
        [-1, 0],
        [-2, 0],
        [-1, 1],
        [-1, -1]
      ] 
    end 
  end 
  
  def to_s
    if @color == :white 
      "\u2659".encode('utf-8')
    else 
      "\u265F".encode('utf-8')
    end  
  end 
end 


