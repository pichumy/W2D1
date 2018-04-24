require 'colorize'
require_relative 'board'
require_relative 'cursor'
require 'byebug'

class Display
    
    def initialize(board)
      @board = board
      @cursor = Cursor.new([0,0], @board) 
    end 
    
    def render
      system("clear")
      puts "  #{("0".."7").to_a.join(" ")}"
      
      @board.grid.each_with_index do |row, idx| 
        row_string = "#{idx} "
        row.each_with_index do |piece, col|
          if [idx,col] == @cursor.cursor_pos 
            row_string += "#{@board[[idx, col]]} ".colorize(:color => :white, :background => :black)
          else
            row_string += "#{@board[[idx, col]]} "
          end 
        end
        puts row_string
      end   
      nil 
    end 
    
    def inspect
      render 
      nil 
    end 
    
    def test_cursor
      done = false 
      until done  
        render 
        done = @cursor.get_input
        # puts("Selected starting position #{starting_position}")
        # ending_position = @cursor.get_input
      end  
      puts done 
    end 
    
end 

if __FILE__ == $0
  b = Board.new 
  display = Display.new(b)
  display.render 
  sleep(1)
  b.move_piece([6,3], [4,3])
  display.render
  sleep(1)
  b.move_piece([1,4], [3,4])
  display.render 
  sleep(1)
  b.move_piece([3,4], [4,3])
  display.render
  something = b.in_check?(:white) 
  puts something 
end  