require_relative 'display'
require_relative 'player'

class Game

  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @board = Board.new
    @current_turn = @player1
  end

  def play
    display = Display.new(@board)
    until @board.checkmate?(@player1.color) || @board.checkmate?(@player2.color)
      begin
      display.render
      start_pos = nil
      until start_pos
        start_pos = @current_turn.make_move(display.cursor)
        display.render
      end
      piece = @board[start_pos]
      raise "Error, you can't move that piece" if piece.color != @current_turn.color
      valid_move = piece.valid_moves
      display.valid_moves = valid_move
      display.render
      end_pos = nil
      until end_pos
        end_pos = @current_turn.make_move(display.cursor)
        display.render
      end
      display.valid_moves = []
      @board.move_piece(start_pos, end_pos)
      switch_players
    rescue RuntimeError => e
      p e.message
      sleep(1.5)
      retry
    end
    end
  end
  def switch_players
    @current_turn == @player1 ? (@current_turn = @player2) : (@current_turn = @player1)
  end

end




if __FILE__ == $0
  player1 = HumanPlayer.new("Bob", :white)
  player2 = HumanPlayer.new("Jim", :black)
  game = Game.new(player1, player2)
  game.play
end
