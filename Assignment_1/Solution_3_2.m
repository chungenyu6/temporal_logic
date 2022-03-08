% Problem 3 - Part2

% Create grid world environment
n = 4;
m = 5;
GW = createGridWorld(n,m,'Standard');
env = rlMDPEnv(GW);


% transition states: T transform to B() for setup directed graph
T_states = GW.States;            % every transition states 
A = reshape(T_states,n, [])';
B = transpose(A);                % B is matrix of GW (string:"[1,1]")


% Set variables for creating transition states
i = 1;
j = 1;
B(i, j);                        % cell/state coord
k = state2idx(GW,B(i, j));      % states to index number 
s={};                           % source
t={};                           % target
 

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
                       


% Value Matrix : stay=3 / go=2 / obstacle=8 / reward=1 / terminal=1
% I set them manually, should have smarter way

%        1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
value1 = [3 2 0 0 2 0 0 0 0 0  0  0  0  0  0  0  0  0  0  0 ;    %1
          2 3 2 0 0 2 0 0 0 0  0  0  0  0  0  0  0  0  0  0 ;    %2
          0 2 3 2 0 0 2 0 0 0  0  0  0  0  0  0  0  0  0  0 ;    %3
          0 0 2 3 0 0 0 2 0 0  0  0  0  0  0  0  0  0  0  0 ;    %4
          2 0 0 0 3 2 0 0 8 0  0  0  0  0  0  0  0  0  0  0 ;    %5
          0 2 0 0 2 3 2 0 0 8  0  0  0  0  0  0  0  0  0  0 ;    %6         
          0 0 2 0 0 2 3 2 0 0  2  0  0  0  0  0  0  0  0  0 ;    %7         
          0 0 0 2 0 0 2 3 0 0  0  2  0  0  0  0  0  0  0  0 ;    %8         
          0 0 0 0 8 0 0 0 8 8  0  0  8  0  0  0  0  0  0  0 ;    %9         
          0 0 0 0 0 8 0 0 8 8  8  0  0  8  0  0  0  0  0  0 ;    %10         
          0 0 0 0 0 0 2 0 0 8  3  2  0  0  2  0  0  0  0  0 ;    %11         
          0 0 0 0 0 0 0 2 0 0  2  3  0  0  0  8  0  0  0  0 ;    %12         
          0 0 0 0 0 0 0 0 8 0  0  0  3  2  0  0  2  0  0  0 ;    %13         
          0 0 0 0 0 0 0 0 0 0  0  0  1  3  2  0  0  2  0  0 ;    %14         
          0 0 0 0 0 0 0 0 0 0  2  0  0  2  3  8  0  0  2  0 ;    %15         
          0 0 0 0 0 0 0 0 0 0  0  8  0  0  8  8  0  0  0  8 ;    %16         
          0 0 0 0 0 0 0 0 0 0  0  0  1  0  0  0  3  2  0  0 ;    %17         
          0 0 0 0 0 0 0 0 0 0  0  0  0  2  0  0  2  3  2  0 ;    %18         
          0 0 0 0 0 0 0 0 0 0  0  0  0  0  2  0  0  1  3  2 ;    %19         
          0 0 0 0 0 0 0 0 0 0  0  0  0  0  0  8  0  0  2  3 ;    %20
         ];
     
%         1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
value2 = [3 2 0 0 2 0 0 0 0 0  0  0  0  0  0  0  0  0  0  0 ;    %1
          2 3 2 0 0 2 0 0 0 0  0  0  0  0  0  0  0  0  0  0 ;    %2
          0 2 3 2 0 0 2 0 0 0  0  0  0  0  0  0  0  0  0  0 ;    %3
          0 0 2 3 0 0 0 2 0 0  0  0  0  0  0  0  0  0  0  0 ;    %4
          2 0 0 0 3 2 0 0 8 0  0  0  0  0  0  0  0  0  0  0 ;    %5
          0 2 0 0 2 3 2 0 0 8  0  0  0  0  0  0  0  0  0  0 ;    %6         
          0 0 2 0 0 2 3 2 0 0  2  0  0  0  0  0  0  0  0  0 ;    %7         
          0 0 0 2 0 0 2 3 0 0  0  2  0  0  0  0  0  0  0  0 ;    %8         
          0 0 0 0 8 0 0 0 8 8  0  0  8  0  0  0  0  0  0  0 ;    %9         
          0 0 0 0 0 8 0 0 8 8  8  0  0  8  0  0  0  0  0  0 ;    %10         
          0 0 0 0 0 0 2 0 0 8  3  2  0  0  2  0  0  0  0  0 ;    %11         
          0 0 0 0 0 0 0 2 0 0  2  3  0  0  0  8  0  0  0  0 ;    %12         
          0 0 0 0 0 0 0 0 8 0  0  0  3  2  0  0  2  0  0  0 ;    %13         
          0 0 0 0 0 0 0 0 0 0  0  0  2  3  2  0  0  2  0  0 ;    %14         
          0 0 0 0 0 0 0 0 0 0  2  0  0  2  3  8  0  0  2  0 ;    %15         
          0 0 0 0 0 0 0 0 0 0  0  8  0  0  8  8  0  0  0  8 ;    %16         
          0 0 0 0 0 0 0 0 0 0  0  0  2  0  0  0  3  2  0  0 ;    %17         
          0 0 0 0 0 0 0 0 0 0  0  0  0  2  0  0  2  3  2  0 ;    %18         
          0 0 0 0 0 0 0 0 0 0  0  0  0  0  2  0  0  1  3  2 ;    %19         
          0 0 0 0 0 0 0 0 0 0  0  0  0  0  0  8  0  0  2  3 ;    %20
         ];


% Get short path & print out
[total_costs1 short_path1] = dijkstra(value1,4,17);         % from 4 -> 17
short_path_sort1 = flip(short_path1);
k1 = digraph(value1);
[total_costs2 short_path2] = dijkstra(value2,4,17);         % from 4 -> 17
short_path_sort2 = flip(short_path2);
k2 = digraph(value2);

% Plot 2 different desired paths
figure()    
H = plot(k1);
figure()
N = plot(k2);


fprintf("Shortest path through desired state 1 is: \t")
for i=1:length(short_path_sort1)
    fprintf("%d ", short_path_sort1(i))
end
fprintf("\n")

fprintf("Shortest path through desired state 2 is: \t")
for i=1:length(short_path_sort2)
    fprintf("%d ", short_path_sort2(i))
end
fprintf("\n")

% Hightlight states & path
labelnode (H, [17], {'Terminal'})
highlight (H, [17],'NodeColor','r')
labelnode (H, [4], {'Start'})
highlight (H, [4],'NodeColor','r')
labelnode (H, [9,10], {'Obstacle'})
highlight (H, [9,10],'NodeColor','magenta')
labelnode (H, [16], {'Obstacle'})
highlight (H, [16],'NodeColor','magenta')
labelnode (H, [11], {'Desired'})
highlight (H, [11],'NodeColor','yellow')
labelnode (H, [18], {'Desired'})
highlight (H, [18],'NodeColor','yellow')
highlight (H,short_path1,'NodeColor','g','EdgeColor','g')

labelnode (N, [17], {'Terminal'})
highlight (N, [17],'NodeColor','r')
labelnode (N, [4], {'Start'})
highlight (N, [4],'NodeColor','r')
labelnode (N, [9,10], {'Obstacle'})
highlight (N, [9,10],'NodeColor','magenta')
labelnode (N, [16], {'Obstacle'})
highlight (N, [16],'NodeColor','magenta')
labelnode (N, [11], {'Desired'})
highlight (N, [11],'NodeColor','yellow')
labelnode (N, [18], {'Desired'})
highlight (N, [18],'NodeColor','yellow')
highlight (N,short_path2,'NodeColor','g','EdgeColor','g')

