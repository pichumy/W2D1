require_relative 'pieces.rb'

class Board
  attr_reader :grid
  def initialize(grid = nil)
    # if grid.nil?
    #   @grid = nil
    #   setup
    # else
    #   @grid = grid
    # end
    grid.nil? ? (@grid = setup) : (@grid = grid)
  end

  def setup
    null_board = Array.new(8) { Array.new(8) { NullPiece.instance } }
    @grid = null_board

    8.times { |col| null_board[1][col] = Pawn.new(:white, self, [1, col]) }
    8.times { |col| null_board[6][col] = Pawn.new(:black, self, [6, col]) }

    null_board[0][1] = Knight.new(:white, self, [0,1])
    null_board[0][6] = Knight.new(:white, self, [0,6])
    null_board[7][1] = Knight.new(:black, self, [7,1])
    null_board[7][6] = Knight.new(:black, self, [7,6])

    null_board[0][4] = King.new(:white, self, [0,4])
    null_board[7][4] = King.new(:black, self, [7,4])

    null_board[0][0] = Rook.new(:white, self, [0,0])
    null_board[0][7] = Rook.new(:white, self, [0,7])
    null_board[7][0] = Rook.new(:black, self, [7,0])
    null_board[7][7] = Rook.new(:black, self, [7,7])

    null_board[0][2] = Bishop.new(:white, self, [0,2])
    null_board[0][5] = Bishop.new(:white, self, [0,5])
    null_board[7][2] = Bishop.new(:black, self, [7,2])
    null_board[7][5] = Bishop.new(:black, self, [7,5])

    null_board[0][3] = Queen.new(:white, self, [0,3])
    null_board[7][3] = Queen.new(:black, self, [7,3])

    null_board
  end

  def move_piece(start_pos, end_pos)
    raise "There is no piece at that starting position" if self[start_pos] == NullPiece.instance

    piece = self[start_pos]

    moves = piece.moves
    raise 'Invalid move.' unless moves.include?(end_pos)
    valid = piece.valid_moves
    raise "That move places you in check" unless valid.include?(end_pos)
    move(start_pos, end_pos)
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    self[end_pos] = piece
    piece.pos = end_pos
    self[start_pos] = NullPiece.instance
  end

  def valid_pos?(pos)
    pos.all? { |point| point.between?(0,7) }
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def in_check?(color)
      king = find_king(color)
      enemies = find_opposing_pieces(color)
      enemies.any? { |enemy| enemy.moves.include?(king.pos) }
  end

  def find_king(color)
    @grid.each do |row|
      row.each do |piece|
        return piece if piece.class == King && piece.color == color
      end
    end
    raise "Cannot find #{color} King! What did you do!"
  end

  def find_opposing_pieces(color)
    result = []
    @grid.each do |row|
      row.each do |piece|
        result << piece if piece != NullPiece.instance && piece.color != color
      end
    end
    result
  end

  def checkmate?(color)
    enemy_color = :black if color == :white
    enemy_color = :white if color == :black
    if in_check?(color)
      my_pieces = find_opposing_pieces(enemy_color)
      my_pieces.each do |piece|
        return false if piece.valid_moves.length > 0
      end
      return true
    end
    false
  end

  def deep_dup
    duped_grid = @grid.map do |row|
      rows = []
      row.each { |piece| rows.push(piece.deep_dup) }
      rows
    end

    duped_board = Board.new(duped_grid)
    give_board(duped_board)
  end

  def give_board(board)
    board.grid.each { |row| row.each { |piece| piece.get_board(board) } }
    board
  end

  def inspect
    "big board"
  end

end
