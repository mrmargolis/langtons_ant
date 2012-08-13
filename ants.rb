#This is a solution for Langton's Ants.  I used ruby-processing and JRuby to
#create a graphical representation of the simulation.
#The simulation ends when the ant leaves the bounds of the 100x100 board

require 'ruby-processing'

class AntSimulation < Struct.new(:board, :ant)
  def tick!
    return false if board.does_not_contain?(ant.position)
    if board.color_at(ant.position) == Board::BLACK
      ant.turn_left!
    else
      ant.turn_right!
    end
    board.toggle_cell!(ant.position)
    ant.move_forward!
  end
end

class Board
  WIDTH = HEIGHT = 100
  WHITE = 1
  BLACK = -1 

  def initialize
    @cells = Array.new(HEIGHT) {|index| Array.new(WIDTH, 1) }
  end

  def color_at(position)
    @cells[position[0]][position[1]]
  end

  def toggle_cell!(position)
    x = position[0]
    y = position[1]
    @cells[x][y] *= -1
  end

  def does_not_contain?(position)
    position.include?(-1) || position.include?(HEIGHT)
  end
end

class Ant
  NORTH = [1, 0]
  SOUTH = [-1, 0]
  EAST =  [0, 1]
  WEST =  [0, -1]

  FACING_MAP = { 0 => NORTH, 1 => EAST, 2 => SOUTH, 3 => WEST }

  LEFT = :left
  RIGHT = :right

  TURN_MAP = { LEFT => -1, RIGHT => 1 }

  attr_reader :position

  def initialize(x, y)
    @position = [x, y]
    @facing = 0
  end

  def facing
    FACING_MAP[@facing]
  end

  def turn_left!
    turn(Ant::LEFT)
  end

  def turn_right!
    turn(Ant::RIGHT)
  end

  def move_forward!
    move = FACING_MAP[@facing]
    @position = [@position[0] + move[0], @position[1] + move[1]] 
  end

  private
  def turn(direction)
    @facing = (@facing + TURN_MAP[direction]) % 4
  end

end

class AntSimulationDisplay < Processing::App
  BOX_SIZE = 12 

  def setup
    frame_rate 100 
    stroke  100, 100, 100  #cell outline stroke
    @ant = Ant.new(50, 50)
    @board = Board.new
    @sim = AntSimulation.new(@board, @ant)
  end
  
  def draw
    Board::HEIGHT.times do |row|
      Board::WIDTH.times do |col|
        draw_cell(row, col)
      end
    end
    draw_ant
    20.times { @sim.tick! }
  end

  private
  def draw_cell(row, col)
    if @sim.board.color_at([row, col]) == Board::WHITE
      fill 255 
    else
      fill 0, 0, 0
    end
    rect(row * BOX_SIZE, col * BOX_SIZE, BOX_SIZE, BOX_SIZE)
  end

  def draw_ant
    fill 230, 40, 0
    rect(@ant.position[0] * BOX_SIZE, @ant.position[1] * BOX_SIZE, BOX_SIZE, BOX_SIZE)
  end
end

if ENV['RUN']
  length = AntSimulationDisplay::BOX_SIZE * 100
  AntSimulationDisplay.new :title => "ANTS!!!", :width => length, :height => length
end
