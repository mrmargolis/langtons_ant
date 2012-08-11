require 'rspec'
require_relative 'ants'

describe Ant do
  let(:ant) { Ant.new(50, 50) }
  it 'starts off facing north' do
    ant.facing.should == Ant::NORTH
  end

  it 'has a position' do
    ant.position.should == [50, 50]
  end

  it 'can turn right to face a different direction' do
    ant.turn(Ant::RIGHT)
    ant.facing.should == Ant::EAST
    ant.turn(Ant::RIGHT)
    ant.facing.should == Ant::SOUTH
    ant.turn(Ant::RIGHT)
    ant.facing.should == Ant::WEST
    ant.turn(Ant::RIGHT)
    ant.facing.should == Ant::NORTH
  end

  it 'can turn left to face a different direction' do
    ant.turn(Ant::LEFT)
    ant.facing.should == Ant::WEST
    ant.turn(Ant::LEFT)
    ant.facing.should == Ant::SOUTH
    ant.turn(Ant::LEFT)
    ant.facing.should == Ant::EAST
    ant.turn(Ant::LEFT)
    ant.facing.should == Ant::NORTH
  end

  it 'moves forward in the direction it is facing' do
    ant.move_forward!
    ant.position.should == [51, 50]
    ant.move_forward!
    ant.position.should == [52, 50]
    ant.turn(Ant::LEFT)
    ant.move_forward!
    ant.position.should == [52, 49]
    ant.turn(Ant::LEFT)
    ant.move_forward!
    ant.position.should == [51, 49]
  end
end

describe Board do
  let(:board) { Board.new }

  it 'is 100x100' do
    Board::WIDTH.should == 100
    Board::HEIGHT.should == 100
  end

  it 'starts off all white' do
    Board::HEIGHT.times do |row|
      Board::WIDTH.times do |col|
        board.color_at([row, col]).should == Board::WHITE
      end
    end
  end

  it 'can toggle a cell' do
    pos = [1, 1]
    board.color_at(pos).should == Board::WHITE
    board.toggle_cell!(pos)
    board.color_at(pos).should == Board::BLACK
    board.toggle_cell!(pos)
    board.color_at(pos).should == Board::WHITE
  end
end

describe AntSimulation do
  let(:board) { Board.new }
  let(:ant) { Ant.new(50, 50) }
  let(:simulation) { AntSimulation.new(board, ant) }
  it 'has a board'  do
    simulation.board.should be_kind_of(Board)
  end

  it 'has an ant' do
    simulation.ant.should be_kind_of(Ant)
  end

  it 'can tick through the simulation' do
    simulation.tick!
    ant.position.should == [50, 51]
    board.color_at([50, 50]).should == Board::BLACK
  end
end
