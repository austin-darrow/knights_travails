class KnightMove
  attr_accessor :position, :parent, :previous

  MOVES = [[2, 1], [2, -1], [-2, 1], [-2, -1],
          [1, 2], [1, -2], [-1, 2], [-1, -2]]

  @@history = []
  @@start = nil
  @@destination = nil

  def initialize(position, parent = nil)
    @position = position
    @parent = parent
    @@history << position
  end

  def children
    MOVES.map { |move| [@position[0] + move[0], @position[1] + move[1]] }
         .keep_if { |e| KnightMove.valid?(e) }
         .reject { |e| @@history.include?(e) }
         .map { |e| KnightMove.new(e, self) }
  end

  def self.valid?(position)
    position[0].between?(1, 8) && position[1].between?(1, 8)
  end

  def self.display_parent(node, list = [])
    display_parent(node.parent, list) unless node.parent.nil?
    list << node.position
  end

  def self.knight_moves(start, destination)
    queue = []
    current_node = KnightMove.new(start)

    # Until destination node is found
    until current_node.position == destination
      current_node.children.each { |child| queue << child }
      current_node = queue.shift
    end

    # After distination node is found
    @@start = start
    @@destination = destination
    traversed = display_parent(current_node)
    board_display(traversed)
    puts "You made it in #{traversed.length - 1} moves! Here's your path:"
    traversed.each_with_index do |pos, i|
      if i == 0
        print pos
      else
        print " -> #{pos} "
      end
    end
    puts ''
  end

  def self.board_display(list)
    puts "\n|-----+-----+-----+-----+-----+-----+-----+-----|\n"
    y = 8
    8.times do
      print "|"
      x = 1
      8.times do
        if @@destination[0] == x && @@destination[1] == y
          print " END |"
        elsif @@start[0] == x && @@start[1] == y
          print "START|"
        elsif list.any? { |pos| pos[0] == x && pos[1] == y }
          print " ~X~ |"
        else
          print " #{x},#{y} |"
        end
        x += 1
      end
      puts "\n|-----+-----+-----+-----+-----+-----+-----+-----|\n"
      y -= 1
    end
    puts "\n"
  end
end

KnightMove.knight_moves([1, 1], [1, 8])
