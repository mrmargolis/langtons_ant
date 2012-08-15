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
    ant.turn_right!
    ant.facing.should == Ant::EAST
    ant.turn_right!
    ant.facing.should == Ant::SOUTH
    ant.turn_right!
    ant.facing.should == Ant::WEST
    ant.turn_right!
    ant.facing.should == Ant::NORTH
  end

  it 'can turn left to face a different direction' do
    ant.turn_left!
    ant.facing.should == Ant::WEST
    ant.turn_left!
    ant.facing.should == Ant::SOUTH
    ant.turn_left!
    ant.facing.should == Ant::EAST
    ant.turn_left!
    ant.facing.should == Ant::NORTH
  end

  it 'moves forward in the direction it is facing' do
    ant.move_forward!
    ant.position.should == [51, 50]
    ant.move_forward!
    ant.position.should == [52, 50]
    ant.turn_left!
    ant.move_forward!
    ant.position.should == [52, 49]
    ant.turn_left!
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
        board.white_cell_at?([row, col]).should be_true
      end
    end
  end

  it 'can toggle a cell' do
    pos = [1, 1]
    board.white_cell_at?(pos).should be_true
    board.toggle_cell!(pos)
    board.black_cell_at?(pos).should be_true
    board.toggle_cell!(pos)
    board.white_cell_at?(pos).should be_true
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
    board.black_cell_at?([50, 50]).should be_true
  end

  it 'detects when the ant is on the board' do
    simulation.ant_on_board?.should be_true
  end

  it 'detects when the ant is south of the board' do
    ant.stub(:position).and_return([-1, 20])
    simulation.ant_on_board?.should be_false
  end

  it 'detects when the ant is north of the board' do
    ant.stub(:position).and_return([100, 20])
    simulation.ant_on_board?.should be_false
  end

  it 'detects when the ant is east of the board' do
    ant.stub(:position).and_return([20, 100])
    simulation.ant_on_board?.should be_false
  end

  it 'detects when the ant is west of the board' do
    ant.stub(:position).and_return([20, -1])
    simulation.ant_on_board?.should be_false
  end

end
