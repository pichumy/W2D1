module SlidingPiece
  
  def horizontal
    [
      [-1,0],
      [0,1],
      [0,-1],
      [1,0]
    ] 
  end 
  
  def diagonal 
    [
      [-1,1],
      [1,1],
      [-1,-1],
      [1,-1] 
    ]
  end 
  
  def moves
    results = []
    directions = [] 
    directions.concat(horizontal) if move_dirs.include?(:horizontal) 
    directions.concat(diagonal) if move_dirs.include?(:diagonal)
    directions.each do |direction| 
      x , y = @pos 
      d_x, d_y = direction 
      invalid = false 
      until invalid 
        x, y = x + d_x, y + d_y 
        new_pos = [x, y]
        unless new_pos.all? {|point| point.between?(0,7)}
          invalid = true 
          next 
        end 
        if @board[new_pos] == NullPiece.instance 
          results.push(new_pos)
        elsif @board[new_pos].color == @color 
          invalid = true 
        else 
          results.push(new_pos)
          invalid = true 
        end  
      end 
    end
    results     
  end 
     
end 
