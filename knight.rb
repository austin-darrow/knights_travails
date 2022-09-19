class Knight
  attr_accessor :position, :previous
  attr_reader :icon

  def initialize(starting_coordinates)
    @previous = nil
    @position = starting_coordinates
    @icon = ' KNI '
  end
end
