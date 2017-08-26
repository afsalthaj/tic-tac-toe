class Player
  attr_accessor :name

  def initialize(name)
    @name=name
  end

  def set_name(name)
    @name = name
  end

  def to_s
    name.to_s
  end
end

class ComputerPlayer < Player
    def initialize
      super("X")
    end
end

class HumanPlayer < Player
  def initialize
    super("O")
  end
end