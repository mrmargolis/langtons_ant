## The Challenge: 

Langton's ant models an ant sitting on a plane of cells, all of
which are white initially, facing in one of four directions. Each cell can
either be black or white. The ant moves according to the color of the cell it
is currently sitting in, with the following rules:

1. If the cell is black, it changes to white and the ant turns left; 
2. If the cell is white, it changes to black and the ant turns right; 
3. The Ant then moves forward to the next cell, and repeat from step 1.

This rather simple ruleset leads to an initially chaotic movement pattern, and
after about 10000 steps, a cycle appears where the ant moves steadily away
from the starting location in a diagonal corridor about 10 pixels wide.
Conceptually the ant can then travel to infinitely far away.

For this task, start the ant near the center of a 100 by 100 field of cells,
which is about big enough to contain the initial chaotic part of the movement.
Follow the movement rules for the ant, terminate when it moves out of the
region, and show the cell colors it leaves behind.


## How to Run
Run ants.rb with ENV RUN=true in order to display the graphical solution

