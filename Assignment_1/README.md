<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      processEscapes: true
    }
  });
</script>

## Questions
$a^{a}$

### Part 1 

Consider a 2D environment with 0 <script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>   x  10 and 0  y  8. Write a Matlab code that
will get an arbitrary integer input (n;m) and create an n  m grid on the environment. Allow actions
fup; right; down; left; stay on the grid and create a graph representation by creating a Matlab structure T,
where T:states will refer to the set of states based on the grid (i.e., each grid cell will be a state), T:adj will
be the adjacency matrix with a dimension of nm  nm and represent the feasible state transitions over the
graph.
