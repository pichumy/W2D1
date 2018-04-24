require_relative 'display'
require_relative 'player'

class Game

  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @board = Board.new
    @current_turn = @player1
    @display = Display.new(@board)
    @cursor = @display.cursor
  end

  def play
    play_turn until won?
    switch_players #to know who the winner should be
    puts "Congratulations #{@current_turn.name}, you win!"
  end

  def play_turn
  begin
    @display.render
    start_pos, end_pos = nil, nil
    start_pos = get_input
    set_display_moves(@board[start_pos])
    end_pos = get_input
    reset_display_moves
    @board.move_piece(start_pos, end_pos)
    switch_players
  rescue RuntimeError => e
    p e.message
    sleep(1.5)
    retry
  end
  end

  def get_input
    pos = nil
    until pos
      pos = @current_turn.make_move(@cursor)
      @display.render
    end
    pos
  end

  def set_display_moves(piece)
    raise "Error, you can't move that piece" if piece.color != @current_turn.color
    raise "Error - This piece has no valid moves" if piece.valid_moves.empty?
    @display.valid_moves = piece.valid_moves
    @display.render
  end

  def reset_display_moves
    @display.valid_moves = []
  end

  def won?
    @board.checkmate?(@player1.color) || @board.checkmate?(@player2.color)
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
