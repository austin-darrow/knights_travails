class Knight
  attr_accessor :position, :previous
  attr_reader :icon

  def initialize(starting_coordinates)
    @previous = nil
    @position = starting_coordinates
    @icon = ' KNI '
  end
end

class GraphNode
  attr_accessor :value, :edges

  def initialize(value)
    @value = value
    @edges = []
  end

  def add_edge(edge)
    @edges << edge
    end
end

class Graph
  attr_reader :nodes, :knight

  def initialize(starting_coordinates)
    @knight = Knight.new(starting_coordinates)
    @nodes = []
    generate_board
    assign_edges
    board_display
  end

  def add_node(value)
  @nodes << GraphNode.new(value)
  end

  def generate_board
    y = 1
    while y < 9 do
      x = 1
      while x < 8 do
        add_node("#{x},#{y}")
        x += 1
      end
      add_node("#{x},#{y}")
      y += 1
    end
  end

  def assign_edges
    @nodes.each do |current|
      current_x = current.value.split(',').first.to_i
      current_y = current.value.split(',').last.to_i
      @nodes.each do |other|
        other_x = other.value.split(',').first.to_i
        other_y = other.value.split(',').last.to_i
        if diff(current_x, other_x) == 1 && diff(current_y, other_y) == 2
          current.add_edge(other)
        elsif diff(current_x, other_x) == 2 && diff(current_y, other_y) == 1
          current.add_edge(other)
        end
      end
    end
  end

  def find(value)
    @nodes.each { |node| return node if node.value == value }
    return "Requested position not on the board"
  end

  def board_display
    puts "\n|-----+-----+-----+-----+-----+-----+-----+-----|\n"
    y = 8
    8.times do
      print "|"
      x = 1
      8.times do
        if @knight.position == "#{x},#{y}".to_s
          print "#{@knight.icon}|"
        elsif
          @knight.previous == "#{x},#{y}".to_s
          print " PRE |"
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

  def diff(num1, num2)
    (num1 - num2).abs
  end

  def shortest_path(start, destination)
    root_node = find(start)
    visited = []
    to_visit = []

    # add root node to visited list and to_visit queue
    visited << root_node
    to_visit << root_node

    until to_visit.empty?
      current_node = to_visit.shift
      if current_node.value == destination
        @knight.previous = @knight.position
        @knight.position = destination
        board_display

        puts "You made it in #{visited.size - 1} moves! Here's your path:"
        visited.each { |node| print " -> [#{node.value}]" }
        return puts ''
      end
      # node not found, add adjacent nodes to be visited if not already
      current_node.edges.each do |node|
        if !visited.include?(node)
          visited << node
          to_visit << node
        end
      end
    end
  end
end

graph = Graph.new('1,1')
graph.shortest_path('1,1', '3,3')
