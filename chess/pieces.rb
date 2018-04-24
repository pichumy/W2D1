require 'singleton'

class Piece
  attr_reader :color 
  attr_accessor :pos 
  def initialize(color, board, pos)
    @color = color
    @board = board 
    @pos = pos
  end
  
  def valid_moves
    # probably useless 
    x, y = @pos 
    moves = [[x-1,y], [x,y-1], [x+1,y], [x, y+1]] 
  end
  
  def to_s
    return "P" 
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
  def initialize 
    super 
  end 
  
  def valid_moves
  
  end  
  
  def move_dirs 
  end 
  
end 

class Queen < Piece 
  def initialize 
    super 
  end 
  
  def valid_moves
  
  end
end 

class Rook < Piece 
  def initialize 
    super 
  end 
  
  def valid_moves
  
  end
end 

class King < Piece 
  def initialize 
    super 
  end 
  
  def valid_moves
  
  end
end 

class Knight < Piece 
  def initialize 
    super 
  end 
  
  def valid_moves
  
  end
end 

class Pawn < Piece 
  def initialize 
    super 
  end 
  
  def valid_moves
  
  end
end 



