require 'byebug'
module Stepable
  
  def moves
    results = [] 
    move_diffs.each do |position| 
      x, y = @pos
      d_x, d_y = position 
      new_pos = [x + d_x, y + d_y] 
      results.push(new_pos) if @board[new_pos] == NullPiece.instance || @board[new_pos].color != @color
    end   
    results 
  end 
   
end 