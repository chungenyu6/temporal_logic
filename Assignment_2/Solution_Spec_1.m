% Spec 1
   
% (Cost) Probability Matrix P : intial probability all same
% Desired_state: r1 ~ r3 / Obstacles: o1 ~ o2
% index: 1~-9 / r1=1, r2=6, r3=8, o1=4, o2=7
%      1      2      3      4      5      6      7      8      9 
P = [ 1/4    1/4     0     1/4     0      0      0      0      0  ;    %1
      1/4    1/4    1/4     0     1/4     0      0      0      0  ;    %2
       0     1/4    1/4     0      0     1/4     0      0      0  ;    %3
      1/4     0      0     1/4    1/4     0     1/4     0      0  ;    %4
       0     1/4     0     1/4    1/4    1/4     0     1/4     0  ;    %5      
       0      0     1/4     0     1/4    1/4     0      0     1/4 ;    %6       
       0      0      0     1/4     0      0     1/4    1/4     0  ;    %7      
       0      0      0      0     1/4     0     1/4    1/4    1/4 ;    %8
       0      0      0      0      0     1/4     0     1/4    1/4 ;    %9
    ];


% Read text file (LTL2BA)
cell_data = importdata('BA_Spec_1.txt');                      % read  file to string (this func. can store every lines
str = string(cell_data);                                  % convert data to string for later use
state_count  = 0;                                         % caculate how many states are there
for i=2:length(str)                                       % 1st line always comments
    if contains(str(i),"/*")
        state_count = state_count + 1;
    end
end

% Extract conditions from txt file
str_new = join(str);                                      % integrate every lines into 1 string 
condition_1(1) = extractBetween(str_new, "::", "::", "Boundaries", "exclusive");
condition_1(2) = extractBetween(str_new, "(r1 &&", "S2", "Boundaries", "inclusive");
condition_2(1) = extract(str_new, "(!o1 && !o2) -> goto accept_S2");

% Transition system x Buchi Automaton  
% When satisfy the conditions, then change probability in P matrix

for k=1:2
   if contains(str_new, condition_1(k))                 % if satisfy condition_1(1) (never go to obstacles)
       for m=1:9                                        % set probability that go to obstacles is 0
           if P(m,4)~= 0                    
               P(m,4) = 0;             
           end
           if P(m,7)~= 0
               P(m,7) = 0;
           end
           if P(m,1)~= 0                                % set prob(all paths go to r1) = 1, so eventually would get to r1             
               P(m,1) = 1;                  
           end
       end
       
       % ---- condition_2 ---- %
       if contains(str_new, condition_2(1)) && k==2     % only if satisfy condition_1(2), then have condition_2
           for a=1:9                                    % lower prob(paths go to others) 
               for b=1:9
                   if P(a,b)~= 0                    
                       P(a,b) = 0.001;
                   end
               end
           end
           for n=1:9                                    % set prob(paths go to r1) = 1, so eventually would get to r1
               if P(n,1)~= 0                    
                   P(n,1) = 1;
               end
           end
       end
       % ---- condition_2 ---- %
       
       P(4,7) = 0.001;                                  % since wanna make graph as rectangular,
       P(7,4) = 0.001;                                  % so give index 4 & 7 minimum prob for connection
       
   end
end


% Simulate TS in n steps
mc = dtmc(P);                               % mc = markov chain / dtmc = discrete-time mc
numSteps = 15;                  
disp("Randomly walk, and satisfy the specification 1: ")
random_path = (simulate(mc,numSteps))'      % observation / output trajectories
s0 = random_path(1);                        % initial state
S = random_path;                            % every transition states 
F = random_path(end);                       % accepting state
P_new;                                      % transition function

% Plot TS x BA
% Edge color: prob of transition (red -> 1 / blue -> 0)
figure;
H = graphplot(mc,'ColorEdges',true);

% Hightlight states & path
labelnode (H, [4], {'4 (o1)'})
highlight (H, [4],'NodeColor','magenta')
labelnode (H, [7], {'7 (o2)'})
highlight (H, [7],'NodeColor','magenta')

labelnode (H, [1], {'1 (r1)'})
highlight (H, [1],'NodeColor','yellow')
labelnode (H, [6], {'6 (r2)'})
highlight (H, [6],'NodeColor','yellow')
labelnode (H, [8], {'8 (r3)'})
highlight (H, [8],'NodeColor','yellow')

highlight (H, [2,3,5,9],'NodeColor','black')
