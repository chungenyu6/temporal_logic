## Problem Statement

### Purpose
The purpose of this assignment is to create an object for the automaton of an LTL specification. You
will use an off-the-shelf tool, i.e. [LTL2BA](http://www.lsv.fr/~gastin/ltl2ba/) in order to 
construct the Buchi Automaton of an LTL. Please follow the instructions at this website to write your
LTL formula with the appropriate propositional symbols and boolean/temporal operators. Note that you
don't need to change any check marks in this webpage.

### Problem

The assignment requires to implement the following steps :
1. For each specification below, write the corresponding LTL formula $\phi$.
2. For each LTL from step 1, construct the Buchi automaton via LTL2BA, create a txt file, and copy/paste
the output of LTL2BA into the text file. (Please do not modify the output text of the LTL2BA.)
3. Write a generic code (in MATLAB) that reads the output of LTL2BA (.txt file) and generates an
object for the automaton. Note that this is not simply a graph object, containing the set of nodes
and the adjacency matrix. In addition to the node set and adjacency matrix, you need to store all the
labels of the transitions, initial states, accepting states. In other words, the object for the automaton
is supposed to contain all the information in the tuple $A_{\phi}=(S, s_0, O, \delta, F)$.
4. Plot the automaton as a graph with the corresponding edge labels and initial/final states. (You can
verify your code by comparing your visualization with the one in LTL2BA)
5. Generate 3 accepting words from each specication (note: remember the Buchi acceptance criteria)


### Deliverables 
- LTL of each specification
- For each specification, .txt file containing the ouptut of LTL2BA
- Your code to create and visualize an automaton object in Matlab
- .txt file containing 3 accepting words from each specification's automaton


### 4 Specifications

Suppose that a robot moves in an environment that contains three desired regions
labeled as *r1, r2, r3*, and two obstacles labeled as *o1, o2*.

1. The robot is supposed to visit r1 eventually, and the obstacles o1; o2 should never be visited.
2. The robot is supposed to visit r1 infinitely often, and the obstacle o1 should never be visited.
3. Once the robot visits r1, it is supposed to stay in r1 all the time, and the obstacle o1 should never be visited.
4. The robot is supposed to visit first r1, then r2, and then r3, innitely often.


