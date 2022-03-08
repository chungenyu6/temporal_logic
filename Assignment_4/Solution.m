%%%%%%%%%% Formal Methods, hw4 %%%%%%%%%%

%% Transition System
% Create grid world environment
% Set variables for creating transition states
s=[];  t=[];                            % source & target
n = 4;  m = 4;   k = 1; p = 1;
for i=1:n
    for j=1:m
        index(i,j) = p;
        p = p + 1;
    end
end
index = flipud(index);                  % to get index same as the pdf graph

% Create/Setup transition states (for rectangular graph)
for j=1:m
    for i=1:n
        
        if (i==1) && ((j-1)~=0) && (j~=m)          % upper boundary (side)
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k-n) (k+1) (k+n)];           
        elseif (i==n) && ((j-1)~=0) && (j~=m)      % lower boundary (side)
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k-n) (k-1) (k+n)];               
        elseif (i~=1) && (i~=n) && ((j-1)==0)      % left boundary (side)
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k+1) (k-1) (k+n)];                  
        elseif (i~=1) && (i~=n) && (j==m)          % right boundary (side)
            s = [s,k k k k];                       % 4 possible action (include stay)
            t = [t k (k+1) (k-1) (k-n)];                 
        elseif (i==1) && (j==1)                    % leftmost top (point)
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k+1) (k+n)];                       
        elseif (i==n) && (j==1)                    % leftmost buttom (point)
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k-1) (k+n)];                 
        elseif (i==1) && (j==m)                    % rightmost top (point)
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k-n) (k+1)];                 
        elseif (i==n) && (j==m)                    % rightmost buttom (point)
            s = [s,k k k];                         % 3 possible action (include stay)
            t = [t k (k-1) (k-n)];                 
        else
            s = [s,k k k k k];                     % 5 possible action (include stay)
            t = [t k (k-1) (k-n) (k+1) (k+n)];  
        end
        k = k+1;
    end
end
Graph_InitialTS = digraph(s,t);
Adj_InitialTS = adjacency(Graph_InitialTS);

% Initialize Weight table
Weight_TS = [];
for i=1:n*m
    for j=1:n*m
        if Adj_InitialTS(i,j) == 1
            Weight_TS(i,j) = 1;
        else
            Weight_TS(i,j) = 0;            
        end        
    end
end

% Set weights on edges of TS (1st set weight=3, then weight=inf)
for i=1:n*m
    for j=1:n*m
        if (j == 6) || (j == 7) || (j == 8) || (j == 9) || (j == 10) || (j == 12) || (j == 14) || (j == 16)  
            if Weight_TS(i,j) == 1
                Weight_TS(i,j) = 3;
            end
        end        
    end
end
for i=1:n*m
    for j=1:n*m
        if (j == 11) || (j == 15) || (i == 11) || (i == 15)  
            if Weight_TS(i,j) ~= 0
                Weight_TS(i,j) = inf;
            end
        end        
    end
end



%% Buchi Automaton (BA)

% Read specification text file (LTL2BA)
cell_data = importdata('Answer_specification.txt');                                         % read  file to string (this func. can store every lines
txt_everyline = string(cell_data);                                          % convert data to string for later use
state_count  = 0;                                                           % caculate how many states are there
for i=2:length(txt_everyline)                                               % 1st line always comments
    if contains(txt_everyline(i),"/*")
        state_count = state_count + 1;
        BA_states(2,state_count) = extractBefore(txt_everyline(i), " :");   % store BA state in txt
    end
end

% Store BA states (1st row: state_labels // 2nd row: for discriminant)
BA_states(1,1) = string('init');
for i=2:state_count
    BA_states(1,i) = string(i-1);
end

% Get index of how many conditions in each states
k = 1; 
for i=1:length(BA_states(1,:))
    a(i) = "/* " +BA_states(1,i)+ " */";
end
for i=1:length(txt_everyline)
    if contains(txt_everyline(i), a(k))
        index_condition(k) = i;                                         % know the bound of nth-row for conditions
        if k < state_count
            k = k + 1;
        end
    end
end

% Get accepting states 
k = 1;
for i=1:length(BA_states)
    if contains(BA_states(2,i),"accept")
        accept_states(1,k) = BA_states(1,i);
        accept_states(2,k) = BA_states(2,i);
        k = k + 1;
    end
end

% Extract conditions of each state
% Condition_1st layer: discriminants / 2nd layer: transitions
m = 1; n = 1;
for i=2:state_count                                                     
    for k = (index_condition(i-1)+2) : (index_condition(i)-2)       % bound for n-th row conditions           
        condition (m,n,1) = extractBetween(txt_everyline(k), "(", ")");
        condition (m,n,2) = extractAfter(txt_everyline(k), "goto ");
        n = n + 1;
    end
    m = m + 1; n = 1;
end
for k = (index_condition(i)) : (length(txt_everyline))                  % bound for last conditions 
    if contains(txt_everyline(k), "skip")                                   % 2 possible situations
        condition (m,n,1) = "1";
        condition (m,n,2) = BA_states(2,i);
    elseif contains(txt_everyline(k), "(")
        condition (m,n,1) = extractBetween(txt_everyline(k), "(", ")");
        condition (m,n,2) = extractAfter(txt_everyline(k), "goto ");
        n = n + 1;
    end
end

% Transform states lable, condition_3rd layer = 2nd layer (different at names)
for i=1:length(condition(:,1,2))
    for j=1:length(condition(1,:,2))
        for k=1:length(BA_states(1,:))
            if condition(i,j,2) == BA_states(2,k)
                condition(i,j,3) = BA_states(1,k);
            end
        end
    end
end

% Construct Buchi Automaton graph
s = []; t=[];
[m,n] = size(condition(:,:,1));
for i=1:m
   for j=1:n 
       if ~ismissing(condition(i,j,3))
           s = [s BA_states(1,i)];
           t = [t condition(i,j,3)];
       end
   end
end

% Create BA graph
G_BA = digraph(s, t);
figure(2)
H_BA = plot(G_BA);
title('Buchi Automaton Graph');

% Hightlight edge label of BA
[m,n] = size(condition(:,:,1));
condition_EdgeLabel = [];
for i=1:m
    for j=1:n
        if ~ismissing (condition(i,j,1))
            condition_EdgeLabel = [condition_EdgeLabel condition(i,j,1)];
        end
    end
end
labeledge(H_BA,s,t,condition_EdgeLabel);

% Hightlight node label of BA (mark accepting state)
condition_NodeLabel = [];
for i=1:length(BA_states(1,:))    
    TF = contains(accept_states(1,:), BA_states(1,i));
    if any(TF)
        condition_NodeLabel = [condition_NodeLabel BA_states(1,i)+" (accept)"];
    else
        condition_NodeLabel = [condition_NodeLabel BA_states(1,i)];
    end
    labelnode(H_BA, i, condition_NodeLabel(i));
end

%% TS & BA Trajectories for Prefix (Function for Prefix is at the end of the script)

TS_Prefix_Current = 1;                                                     % set initial state at 1
TS_Prefix_Next = 0;
BA_Prefix_Current = "init"; 
TS_Prefix_Trajectory = [];
BA_Prefix_Trajectory = [];
TS_Prefix_Trajectory = [TS_Prefix_Trajectory, TS_Prefix_Current];
BA_Prefix_Trajectory = [BA_Prefix_Trajectory, BA_Prefix_Current];

% Do random actions until get to accepting state (r1 / r2)
while 1
    Action = randi([1 5]);   
    % Call the DoAction function
    % 1: up/ 2: down/ 3: left/ 4:right/ 5: self
    if Action == 1 && (TS_Prefix_Current+4) <= 16
        n = 4;
        [n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current] = ...
            DoAction(n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current);

    elseif Action == 2 && (TS_Prefix_Current-4) > 0
        n = -4;
        [n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current] = ...
            DoAction(n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current);

    elseif Action == 3 && rem(TS_Prefix_Current,4) ~= 0
        n = 1;
        [n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current] = ...
            DoAction(n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current);

    elseif Action == 4 && rem(TS_Prefix_Current,4) ~= 1
        n = -1;
        [n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current] = ...
            DoAction(n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current);

    elseif Action == 5
        n = 0;
        [n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current] = ...
            DoAction(n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current);
    end
    
    % If reach one of the accepting state, then break the loop
    % As the specification, stays at r1 for 1 time step, r2 for 2 time steps
    if TS_Prefix_Current == 14 || TS_Prefix_Current == 16
        break
    end
end


%% TS & BA Trajectories for Suffix

% Use Dijkstra's Algorithm to find optimal cost & path 
% From TS state 14 -> 16
[Accepting_TotalCosts_1, TS_Accepting_1_unsort] = dijkstra(Weight_TS,14,16);         
TS_Accepting_1 = flip(TS_Accepting_1_unsort);
% From TS state 16 -> 14
[Accepting_TotalCosts_2, TS_Accepting_2_unsort] = dijkstra(Weight_TS,16,14);         
TS_Accepting_2 = flip(TS_Accepting_2_unsort);

% Get TS_Suffix 
% For relax complexity of code,
% Output of Suffix might seems unintuitive, but the meanings are the same
TS_Suffix_Trajectory = [];
if BA_Prefix_Current == "r1"
    TS_Suffix_Trajectory = [TS_Suffix_Trajectory TS_Accepting_1];
    TS_Suffix_Trajectory = [TS_Suffix_Trajectory 16 ];    
    TS_Suffix_Trajectory = [TS_Suffix_Trajectory TS_Accepting_2];
    % Add extra cost of 3 time step 
    Accepting_TotalCosts_1 = Accepting_TotalCosts_1 + 9;
    Accepting_TotalCosts = Accepting_TotalCosts_1 + Accepting_TotalCosts_2;
elseif BA_Prefix_Current == "r2"
    TS_Suffix_Trajectory = [16 ];
    TS_Suffix_Trajectory = [TS_Suffix_Trajectory TS_Accepting_2];
    TS_Suffix_Trajectory = [TS_Suffix_Trajectory TS_Accepting_1];
    % Add extra cost of 3 time step 
    Accepting_TotalCosts_1 = Accepting_TotalCosts_1 + 9;
    Accepting_TotalCosts = Accepting_TotalCosts_1 + Accepting_TotalCosts_2;
end

% Get BA_Suffix
BA_Suffix_Trajectory = [];
for i=1:length(TS_Suffix_Trajectory)
    if TS_Suffix_Trajectory(i) == 14
        BA_Suffix_Trajectory = [BA_Suffix_Trajectory "r1"];
    elseif TS_Suffix_Trajectory(i) == 16
        BA_Suffix_Trajectory = [BA_Suffix_Trajectory "r2"];
    else
        BA_Suffix_Trajectory = [BA_Suffix_Trajectory "arb"];
    end
end


%% Printout txt files

% TS & BA accepting trajectory printout
TS_Accepting_Trajectory_Printout = ["(", TS_Suffix_Trajectory, ")w"];
BA_Accepting_Trajectory_Printout = ["(", BA_Suffix_Trajectory, ")w"];

fileID = fopen('Answer_PA_Accepting_Path.txt','w');
fprintf(fileID,'Optimal path to satisfy specification (r1 <-> r2). \n\n');
fprintf(fileID,'TS: \n\t');
fprintf(fileID,'%s ',TS_Accepting_Trajectory_Printout);                            
fprintf(fileID,'\n\nBA: \n\t');
fprintf(fileID,'%s ',BA_Accepting_Trajectory_Printout);    
fprintf(fileID,'\n\n\n Total costs of accepting path: %d\n', Accepting_TotalCosts);
fclose(fileID);                                                           

% TS & BA whole trajectory printout
% For relax complexity of code,
% Output of trajectory might seems unintuitive, but the meanings are the same
TS_Whole_Trajectory_Printout = [TS_Prefix_Trajectory, TS_Accepting_Trajectory_Printout];
BA_Whole_Trajectory_Printout = [BA_Prefix_Trajectory, BA_Accepting_Trajectory_Printout];

fileID2 = fopen('Answer_PA_Whole_Path.txt','w');
fprintf(fileID2,'Random walk until arrived r1 or r2, then have optimal path to satisfy specification. \n\n');
fprintf(fileID2,'TS: \n\t');
fprintf(fileID2,'%s ',TS_Whole_Trajectory_Printout);                            
fprintf(fileID2,'\n\nBA: \n\t');
fprintf(fileID2,'%s ',BA_Whole_Trajectory_Printout);    
fclose(fileID2);    

%% Visualize accepting trajectory on TS 

% Graph the optimal path in TS graph
Graph_WeightTS = digraph(Weight_TS);
figure(1);
% plot(Graph_WeightTS,'EdgeLabel',Graph_WeightTS.Edges.Weight);            % check for weights (need to block H command line)
H = plot(Graph_WeightTS);
set(gca,'xdir','reverse');                                                 % flip the graph to make it same as on pdf 
title('Accepting Path on Transition System (start when in accepting state)');

% Hightlight states & accepting path
labelnode (H, 11, {'11 (o1)'})
highlight (H, 11,'NodeColor','red')
labelnode (H, 15, {'15 (o2)'})
highlight (H, 15,'NodeColor','red')
labelnode (H, 14, {'14 (r1)'})
highlight (H, 14,'NodeColor','green')
labelnode (H, 16, {'16 (r2)'})
highlight (H, 16,'NodeColor','green')
labelnode (H, 1, {'1 (init)'})
highlight (H, 1,'NodeColor','yellow')

highlight (H,TS_Suffix_Trajectory,'EdgeColor','g')

%% Prefix's Random-Step Function

% DoAction function: check action availbility, track the trajectories, do the acion
function [n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current] = ...
    DoAction(n, TS_Prefix_Current, TS_Prefix_Next, TS_Prefix_Trajectory, BA_Prefix_Trajectory, BA_Prefix_Current)
    
    % Start to do the action & judgement
    TS_Prefix_Next = TS_Prefix_Current + n;
    if TS_Prefix_Next == 14                                                % when action move to r1
        BA_Prefix_Current = "r1";
        TS_Prefix_Current = TS_Prefix_Current + n;
        TS_Prefix_Trajectory = [TS_Prefix_Trajectory, TS_Prefix_Current];
        BA_Prefix_Trajectory = [BA_Prefix_Trajectory, BA_Prefix_Current];
    elseif TS_Prefix_Next == 16                                            % when action move to r2
        BA_Prefix_Current = "r2";
        TS_Prefix_Current = TS_Prefix_Current + n;
        TS_Prefix_Trajectory = [TS_Prefix_Trajectory, TS_Prefix_Current];
        BA_Prefix_Trajectory = [BA_Prefix_Trajectory, BA_Prefix_Current];
    elseif TS_Prefix_Next == 11                                            % when action move to o1
        1;
    elseif TS_Prefix_Next == 15                                            % when action move to o2
        1;
    elseif TS_Prefix_Next == 1                                             % when action move to init
        BA_Prefix_Current = "init";
        TS_Prefix_Current = TS_Prefix_Current + n;
        TS_Prefix_Trajectory = [TS_Prefix_Trajectory, TS_Prefix_Current];
        BA_Prefix_Trajectory = [BA_Prefix_Trajectory, BA_Prefix_Current];
    else
        TS_Prefix_Current = TS_Prefix_Current + n;
        TS_Prefix_Trajectory = [TS_Prefix_Trajectory, TS_Prefix_Current];
        BA_Prefix_Trajectory = [BA_Prefix_Trajectory, "arb"];
    end
end



