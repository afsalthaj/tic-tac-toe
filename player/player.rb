class Player
  attr_accessor :name

  def initialize(name)
    @name=name
  end

  def set_name(name)
    @name = name
  end
end

class ComputerPlayer < Player
  def initialize
    super(:X)
  end

  def to_s
    "Computer Player #{name}"
  end
end

# There can be multiple instances of human players, with or without the same name.
class HumanPlayer < Player
  def initialize
    super(:O)
  end

  def to_s
    "Human Player #{name}"
  end
end