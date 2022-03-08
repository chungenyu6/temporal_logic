% Problem 1
% Create random inputs (n,m) to create grid
n = randi([1 10]);          % 0 <= x <= 10
m = randi([1 8]);           % 0 <= y <= 8


% Create grid world environment
GW = createGridWorld(n,m,'Standard');
env = rlMDPEnv(GW);


% transition states: T transform to B() for setup directed graph
T_states = GW.States;            % every transition states 
A = reshape(T_states,n, [])';
B = transpose(A);                % B is matrix of GW (string:"[1,1]")


% Set variables for creating transition states
i = 1;
j = 1;
B(i, j);                     % cell/state coord
k = state2idx(GW,B(i, j));   % states to index number 
s={};                        % source
t={};                        % target
 

% Create/Setup transition states (for rectangular graph)
for j=1:m
    for i=1:n
        
        if (i==1) && ((j-1)~=0) && (j~=m)          % upper boundary (side)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k-n) (k+1) (k+n)];           
        elseif (i==n) && ((j-1)~=0) && (j~=m)      % lower boundary (side)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k-n) (k-1) (k+n)];               
        elseif (i~=1) && (i~=n) && ((j-1)==0)      % left boundary (side)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k+1) (k-1) (k+n)];                  
        elseif (i~=1) && (i~=n) && (j==m)          % right boundary (side)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k+1) (k-1) (k-n)];                 
        elseif (i==1) && (j==1)                    % leftmost top (point)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k+1) (k+n)];                       
        elseif (i==n) && (j==1)                    % leftmost buttom (point)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k-1) (k+n)];                 
        elseif (i==1) && (j==m)                    % rightmost top (point)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k-n) (k+1)];                 
        elseif (i==n) && (j==m)                    % rightmost buttom (point)
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k-1) (k-n)];                 
        else
            k = state2idx(GW,B(i, j));             % index number 
            s = [s,k k k k k];                     % 5 possible action (include stay)
            t = [t k (k-1) (k-n) (k+1) (k+n)];  
        end        
    end
end

% Create Directed Graph 
G = digraph (cell2mat(s),cell2mat(t));           % transform cell array to numeric array
T_Adj = adjacency(G);                            % adjacency matrix
T_states = GW.States;                            % every transition states 
plot(G)

