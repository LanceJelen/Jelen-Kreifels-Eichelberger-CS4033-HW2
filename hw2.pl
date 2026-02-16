% Initial state
start([3,3,left]).

% Goal state
goal([0,0,right]).

safe([ML, CL, _]) :-
    % values in range
    ML >= 0, ML =< 3,
    CL >= 0, CL =< 3,

    % left bank safety
    ( ML =:= 0 ; ML >= CL ),

    % right bank counts
    MR is 3 - ML,
    CR is 3 - CL,

    % right bank safety
    ( MR =:= 0 ; MR >= CR ).


% Boat passenger combinations
boat(2,0).
boat(0,2).
boat(1,0).
boat(0,1).
boat(1,1).

move([ML, CL, left], [ML2, CL2, right], boat(M, C)) :-
    boat(M, C),

    % must have enough people on left bank
    ML >= M,
    CL >= C,

    % update counts
    ML2 is ML - M,
    CL2 is CL - C,

    % resulting state must be safe
    safe([ML2, CL2, right]).

move([ML, CL, right], [ML2, CL2, left], boat(M, C)) :-
    boat(M, C),

    % right bank counts
    MR is 3 - ML,
    CR is 3 - CL,

    % must have enough people on left bank
    MR >= M,
    CR >= C,

    % update counts
    ML2 is ML + M,
    CL2 is CL + C,

    % resulting state must be safe
    safe([ML2, CL2, left]).