#This is a solution for Langton's Ants.  I used ruby-processing and JRuby to
#create a graphical representation of the simulation.
#The simulation ends when the ant leaves the bounds of the 100x100 board

require 'ruby-processing'

class AntSimulation < Struct.new(:board, :ant)
  def tick!
    return unless ant_on_board?
    if board.black_cell_at?(ant.position)
      ant.turn_left!
    else
      ant.turn_right!
    end
    board.toggle_cell!(ant.position)
    ant.move_forward!
  end

  def ant_on_board?
    board.contains?(ant.position)
  end
end

class Board
  WIDTH = HEIGHT = 100
  WHITE = 1
  BLACK = -1 

  def initialize
    @cells = Array.new(HEIGHT) {|index| Array.new(WIDTH, 1) }
  end

  def white_cell_at?(position)
    color_at(position) == WHITE
  end

  def black_cell_at?(position)
    color_at(position) == BLACK
  end

  def toggle_cell!(position)
    x = position[0]
    y = position[1]
    @cells[x][y] *= -1
  end

  def contains?(position)
    position[0].between?(0, WIDTH - 1) && position[1].between?(0, HEIGHT - 1)
  end

  private
  def color_at(position)
    @cells[position[0]][position[1]]
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
  BOX_SIZE = 10 

  def setup
    frame_rate 30 
    stroke  100, 100, 100  #cell outline stroke
    @ant = Ant.new(50, 50)
    @board = Board.new
    @sim = AntSimulation.new(@board, @ant)
  end
  
  def draw
    if @sim.ant_on_board?
      Board::HEIGHT.times do |row|
        Board::WIDTH.times do |col|
          draw_cell(row, col)
        end
      end
      draw_ant
      draw_frame_rate
      50.times { @sim.tick! }
    else
      save("ants.png");
      exit
    end
  end

  private
  def draw_cell(row, col)
    if @board.white_cell_at?([row, col])
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

  def draw_frame_rate
    fill 0, 255, 255 
    rect(15, 900, 225, 20)
    fill 255, 0 , 0 
    text("Frame Rate: #{frame_rate}", 20, 915) 
  end
end

if ENV['RUN']
  length = AntSimulationDisplay::BOX_SIZE * 100
  AntSimulationDisplay.new :title => "ANTS!!!", :width => length, :height => length
end
