% Spec 4
% <-- Change the graph to satisfy the specification 4 -->
   
% (Cost) Probability Matrix P : intial probability all same
% Desired_state: r1 ~ r3 / Obstacles: o1 ~ o2
% index: 1~-9 / r1=1, r2=2, r3=3, o1=4, o2=5
%      1      2      3      4      5      
P = [ 1/5    1/5    1/5    1/5    1/5      ;    %1
      1/5    1/5    1/5    1/5    1/5      ;    %2
      1/5    1/5    1/5    1/5    1/5      ;    %3
      1/5    1/5    1/5    1/5    1/5      ;    %4
      1/5    1/5    1/5    1/5    1/5      ;    %5
    ];


% Read text file (LTL2BA)
cell_data = importdata('BA_Spec_4.txt');                      % read  file to string (this func. can store every lines
str = string(cell_data);                                  % convert data to string for later use
state_count  = 0;                                         % caculate how many states are there
for i=2:length(str)                                       % 1st line always comments
    if contains(str(i),"/*")
        state_count = state_count + 1;
    end
end

% Track how many conditions in each states
condition = strings([state_count,5]);               % row: num_state / col: num_condition
k=1;
for i=1:length(str)
    if contains(str(i),"/* init */")
        track(k)=i;
        k=k+1;
    elseif contains(str(i),"/* 1 */")
        track(k)=i;
        k=k+1;
    elseif contains(str(i),"/* 2 */")
        track(k)=i;
        k=k+1;
    end
end

% Extract the conditions from (str) each states
% condition(1,:) store all conditions in initial_state, vice versa
i=track(1); k=1;
for i=track(1):track(2)
   condition(1,k) = str(i);
   i = i+1; k=k+1;
end
i=track(2); k=1;
for i=track(2):track(3)
   condition(2,k) = str(i);
   i = i+1; k=k+1;
end
i=track(3); k=1;
for i=track(3):length(str)
   condition(3,k) = str(i);
   i = i+1; k=k+1;
end

% Transition system x Buchi Automaton  
% When satisfy the conditions, then change probability in P matrix
for i=1:state_count
    if any(contains (condition(i,:), "goto T0_init"))                   % any(): reduce logical arrays to single value
        P_new = BA_state_1;                                             % call function (end of the script)
    end
    if any(contains (condition(i,:), "goto accept_S2"))               
        P_new = BA_state_2;
    end
    if any(contains (condition(i,:), "goto accept_S3"))               
        P_new = BA_state_3;
    end
end


% Simulate TS in n steps
mc = dtmc(P_new);                               % mc = markov chain / dtmc = discrete-time mc
numSteps = 15;                  
disp("Randomly walk, and satisfy the specification 4: ")
random_path = (simulate(mc,numSteps))'      % observation / output trajectories
s0 = random_path(1);                        % initial state
S = random_path;                            % every transition states 
F = random_path(end);                       % accepting state
P_new;                                      % transition function

% Plot TS x BA ( Create Directed Graph )
% Edge color: prob of transition (red -> 1 / blue -> 0)
figure;
H = graphplot(mc,'ColorEdges',true);

% Hightlight states 
labelnode (H, [4], {'4 (o1)'})
highlight (H, [4],'NodeColor','magenta')
labelnode (H, [5], {'5 (o2)'})
highlight (H, [5],'NodeColor','magenta')

labelnode (H, [1], {'1 (r1)'})
highlight (H, [1],'NodeColor','yellow')
labelnode (H, [2], {'2 (r2)'})
highlight (H, [2],'NodeColor','yellow')
labelnode (H, [3], {'3 (r3)'})
highlight (H, [3],'NodeColor','yellow')



% Conditions Functions -> get new P
% < Function: Go to state 1 > 
function P_new = BA_state_1
    %      1      2      3      4      5      
    P = [ 1/5    1/5    1/5    1/5    1/5      ;    %1
          1/5    1/5    1/5    1/5    1/5      ;    %2
          1/5    1/5    1/5    1/5    1/5      ;    %3
          1/5    1/5    1/5    1/5    1/5      ;    %4
          1/5    1/5    1/5    1/5    1/5      ;    %5
        ];
    P_new = P;
end
% < Function: Go to state 2 > 
function P_new = BA_state_2
    %      1      2      3      4      5      
    P = [ 1/5    1/5    1/5    1/5    1/5      ;    %1
          1/5    1/5    1/5    1/5    1/5      ;    %2
          1/5    1/5    1/5    1/5    1/5      ;    %3
          1/5    1/5    1/5    1/5    1/5      ;    %4
          1/5    1/5    1/5    1/5    1/5      ;    %5
        ];
    
    P(1,:) = 0; P(1,2) = 1;             % r1 only goes to r2
    P_new = P;
end
% < Function: Go to state 3 (accepting state) > 
function P_new = BA_state_3
        %      1      2      3      4      5      
    P = [ 1/5    1/5    1/5    1/5    1/5      ;    %1
          1/5    1/5    1/5    1/5    1/5      ;    %2
          1/5    1/5    1/5    1/5    1/5      ;    %3
          1/5    1/5    1/5    1/5    1/5      ;    %4
          1/5    1/5    1/5    1/5    1/5      ;    %5
        ];
    P(1,:) = 0; P(1,2) = 1;             % r1 only goes to r2
    P(2,:) = 0; P(2,3) = 1;             % r2 only goes to r3
    P(3,:) = 0; P(3,1) = 1;             % r3 only goes to r1
    P_new = P;
end
