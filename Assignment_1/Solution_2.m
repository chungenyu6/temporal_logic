% I found out Grid_World_Function suits for this problem, and it can use
% reinforcement learning (toolbox) to find the shortest path. Yet, I think
% it's a bit far from what i learnt in class, so in Problem 3, I'll just use the
% Problem 1's method to get the shortest path.

% Create grid world environment (4x5 grid)
n = 4;
m = 5;
GW = createGridWorld(n,m,'Standard');
env = rlMDPEnv(GW);


% Set the perticular states
GW.CurrentState = "[4,1]";
GW.TerminalStates = "[1,5]";
GW.ObstacleStates = ["[1,3]";"[2,3]";"[4,4]"];


% Whatever states go to obstacles probability is 0
GW.T(:,state2idx(GW,"[1,3]"),:) = 0;
GW.T(:,state2idx(GW,"[2,3]"),:) = 0;
GW.T(:,state2idx(GW,"[4,4]"),:) = 0;

% Set the reward for desired states
% Yet this toolbox couldn't label/color the desired states on grid
nS = numel(GW.States);
nA = numel(GW.Actions);
GW.R = -1*ones(nS,nS,nA);
GW.R(:,state2idx(GW,"[1,4]"),:) = 5;               % desired state at [1,4]/go thru it reward 5
GW.R(:,state2idx(GW,"[2,5]"),:) = 5;               % desired state at [2,5]
GW.R(:,state2idx(GW,"[1,5]"),:) = 10;              % terminal state, prevent path take detour for rewards


T_obs = getObservationInfo(env);                  % obervation for all states
E=zeros();
obs_1=zeros();
obs_2=zeros();
obs_3=zeros();
obs_4=zeros();
for i=1:length(GW.States)
    if (i == 4)
        obs_1 = [GW.States(i)];                     % observation 1 = inital states
    elseif (i == 13 || i == 18)
        obs_2 = [obs_2, GW.States(i)];              % observation 2 = desired states
    elseif (i == 9 || i == 10 || i == 16)
        obs_3 = [obs_3, GW.States(i)];              % observation 3 = obstacles states
    elseif (i == 17)
        obs_4 = [GW.States(i)];                     % observation 4 = terminal states
    else
        E = [E, GW.States(i)];                      % observation E = free states
    end
end


plot(env)
