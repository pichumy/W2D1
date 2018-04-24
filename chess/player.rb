class HumanPlayer

  attr_reader :name, :color

  def initialize(name = "bob", color)
    @name = name
    @color = color
  end

  def make_move(cursor)
    cursor.get_input
  end


end
