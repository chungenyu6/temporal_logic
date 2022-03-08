## Problem Statement

### Purpose
The purpose of this assignment is to use the energy function idea to synthesize an optimized control
strategy over a product automaton. 

### Problem
Consider a weighted transition system as illustrated in Figure 1. Suppose that the weights in this
transition system refer to a safety measure such that taking transitions resulting in states closer to obstacles
have higher cost weights. For example, the obstacles are located in states 15 and 11. Going to the states
adjacent to the obstacles (i.e. 14, 10, 6, 7, 8, 12, 16) and moving among these states have higher costs then
transitioning to (moving among) the remaining states (i.e. 1,2,3,4,5,9,13).

![image](https://user-images.githubusercontent.com/80203709/157159351-573452f0-fb76-45d7-a000-419f3209cb95.png)
Figure 1: Illustration of 4 x 4 grid that contains obstacles in states 15; 11 (red), regions of interest in states
14 and 16 (green), initial state (orange). The weights of transitions are illustrated with respect to the colored
edges such that blue edges have a weight of 3, red edges have a weight of 1, black edges have a weight of 1.

Consider a specification defined over this environment as follows:
\Visit state 14 infinitely often, and visit state 16 infinitely often, and if state 14 is visited, stay there for
one time step, and if state 16 is visited stay there for 2 time steps, and always avoid states 11 and 15."

### Deliverables 
- LTL of the specication
- Your code to synthesize a control strategy via energy function
- Find an accepting trajectory that minimizes the sum of energy of product automaton states.
- The visualization of the resulting trajectory, that is the projection of the accepting path 
on the transition system. (You can use the illustration codes from your previous assignments)
- The output word which is the projection of the optimal trajectory over the product automaton onto
the Buchi automaton.

