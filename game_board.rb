require 'pry-byebug'

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
    puts "\n\nStarting position:"
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

  # def pathfinder(start, dest, paths = [], checked = [])
  #   start = find(start) if start.is_a?(String)
  #   checked << start
  #   dest = find(dest) if dest.is_a?(String)

  #   visited = []
  #   to_visit = []
  #   to_visit << start

  #   start.edges.each do |edge|
  #     pathfinder(edge, dest, paths, checked) unless checked.include?(edge)
  #   end

  #   until to_visit.empty?
  #     return paths if visited.length > 6
  #     current = to_visit.pop

  #     if current.value == destination
  #       paths << visited
  #     elsif current_node.edges.include?(destination_node)
  #       to_visit << destination_node
  #     else
  #       current_node.edges.each do |node|
  #         unless visited.include?(node)
  #           to_visit << node
  #         end
  #       end
  #     end
  #   end
  # end

  def select_closest(destination, to_visit)
    values = []
    val_integers = []
    to_visit.each { |node| values << node.value }
    values.each { |val| val_integers << val.split(',').join.to_i }
    destination = destination.split(',').join.to_i

    difference = 100
    closest = nil
    val_integers.each do |integer|
      if diff(integer, destination) < difference
        difference = diff(integer, destination)
        closest = integer.to_s.split('')
        closest.insert(1, ',')
      end
    end
    find(closest.join)
  end

  def shortest_path(start, destination)
    root_node = find(start)
    destination_node = find(destination)
    visited = []
    to_visit = []

    to_visit << root_node

    until to_visit.empty?
      current_node = select_closest(destination, to_visit)
      to_visit.delete(select_closest(destination, to_visit))
      # current_node = to_visit.pop
      visited << current_node

      if current_node.value == destination
        @knight.previous = @knight.position
        @knight.position = destination

        i = visited.find_index(current_node)
        visited = visited[0..i]
        # visited.each_with_index do |node_a, ind_a|
        #   visited.each_with_index do |node_b, ind_b|
        #     next unless ind_a < ind_b && node_a.edges.include?(node_b)

        #     visited = visited[0..ind_a] + visited[ind_b..]
        #   end
        # end

        puts "You made it in #{visited.size - 1} moves! Here's your path:"
        visited.each_with_index do |node, i|
          if i == 0
            print "[#{node.value}]"
          else
            print " -> [#{node.value}]"
          end
        end
        return puts ''
        # return board_display
      elsif current_node.edges.include?(destination_node)
        to_visit << destination_node
      else
        to_visit = []
        current_node.edges.each do |node|
          unless visited.include?(node)
            to_visit << node
          end
        end
      end
    end
  end
end

graph = Graph.new('1,1')
# graph.shortest_path('1,1', '8,2')
graph.nodes.each { |node| graph.shortest_path('1,1', node.value) }

# target = graph.find('2,8')
# target.edges.each { |edge| print "#{edge.value} | "}
puts ''
# graph.pathfinder('1,1', '8,1')

# puts graph.select_closest('1,1', ['1,1', '2,2', '3,3', '4,4'])
