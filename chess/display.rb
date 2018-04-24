require 'colorize'
require_relative 'board'
require_relative 'cursor'
require 'byebug'

class Display
    attr_accessor :valid_moves
    attr_reader :cursor 
    def initialize(board)
      @board = board
      @cursor = Cursor.new([0,0], @board)
      @valid_moves = []
    end

    def render
      system("clear")
      puts "  #{("0".."7").to_a.join(" ")}"

      @board.grid.each_with_index do |row, idx|
        row_string = "#{idx} "
        row.each_with_index do |piece, col|
          if [idx,col] == @cursor.cursor_pos
            row_string += "#{@board[[idx, col]]} ".colorize(:color => :white, :background => :black)
          elsif @valid_moves.include?([idx,col])
            row_string += "#{@board[[idx, col]]} ".colorize(:background => :yellow)
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
  b.move_piece([6,4], [4,4])
  display.render
  sleep(1)
  # byebug
  b.move_piece([7,3], [3,7])
  display.render
  sleep(1)
  b.move_piece([1,5], [2,5])
  display.render
  sleep(1)
  # b.move_piece([3,7],[1,5]) #moves queen into checkmate
  # b.move_piece([0,4], [1,5]) #moves the king into check
  display.render
  something = b.checkmate?(:white)
  puts something
end
