## Questions

### Part 1 

Consider a 2D environment with $0 \le x \le 10$ and $0 \le y \le 8$. Write a Matlab code that
will get an arbitrary integer input (*n,m*) and create an *n* x *m* grid on the environment. Allow actions
{ *up; right; down; left; stay* } on the grid and create a graph representation by creating a Matlab structure *T*,
where *T.states* will refer to the set of states based on the grid (i.e., each grid cell will be a state), *T.adj* will
be the adjacency matrix with a dimension of *nm* x *nm* and represent the feasible state transitions over the
graph.


### Part 2
Use your code from Part 1 to create a transition system based on a 5 x 4 grid. An example grid is
illustrated in Figure 1. You will modify the environment with the following items:

1. Put two obstacles, one occupying 2 x 1 grid cells and the other occupying 1 x 1 grid cell, at locations
you want. Prune your adjacency matrix based on the infeasible transitions due to the presence of the
obstacles. (i.e. red cells)
2. You will choose two grid cells to denote the desired regions. (i.e., green cells)
3. Consider the initial and final states as the leftmost bottom and rightmost top cells, respectively. (i.e.
orange-initial & gray-final)

![Figure 1](https://user-images.githubusercontent.com/80203709/157149887-b6f3c911-d76e-4fb9-87de-23a4570fd279.png)

Figure 1: An illustration of 5 x 4 grid that contains obstacles (red), regions of interest (green), final state
(gray), initial state (orange)


Let *O* = { $o_1, o_2, o_3, o_4, \epsilon $} be the set of observations with the following observation map: $o_1$ is the
observation of the initial state, $o_2$ is the observation of the desired regions, $o_3$ is the observation of the
obstacles, $o_4$ is the observation of the final state, and $\epsilon$ is the null observation for any other states (free
space). Create *T.obs* that is a vector keeping the observations of each state.

### Part 3

In your environment,

1. Find the shortest path from the initial state to final state (e.g. Dijkstra's algorithm). Visualize the
environment with the corresponding objects created in Part 2 and the trajectory by highlighting the
states with markers. Also, print the corresponding output word of this trajectory to the command window.
2. Choose one of the desired regions. Find the shortest path that is from the initial state to the final
state and then visits the chosen desired region. Visualize the environment with the corresponding
objects created in Part 2 and the trajectory by highlighting the states with markers. Also, print the
corresponding output word of this trajectory to the command window.



