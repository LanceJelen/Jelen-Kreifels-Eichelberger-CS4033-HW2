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

% BFS ALGORITHM

% solving using BFS
solve_bfs(Path) :-
    start(Start),
    bfs([[Start]], [], RevPath),
    reverse(RevPath, Path).

% checks if path is correct
bfs([[State|RestPath]|_], _, [State|RestPath]) :-
    goal(State).

% expands BFS search path
bfs([[State|RestPath]|OtherPaths], Visited, Solution) :-
    findall([NextState,State|RestPath],
        ( move(State,NextState,_),
          \+ member(NextState,[State|RestPath]),
          \+ member(NextState,Visited)
        ),
    NewPaths),
    append(OtherPaths, NewPaths, UpdatedQueue),
    bfs(UpdatedQueue, [State|Visited], Solution).


% runs bfs and prints the solution path
run(bfs) :-
    solve_bfs(Path),
    write('Solution Path:'), nl,
    print_path(Path),
    length(Path, L),
    Crossings is L - 1,
    write('Number of crossings: '), write(Crossings), nl.

% prints the bfs solution path   --also used by run(dfs)
print_path([]).
print_path([H|T]) :-
    write(H), nl,
    print_path(T).



% DFS Algorithm

% solving using DFS
solve_dfs(Path) :-
    start(Start),dfs([[Start]], [], RevPath),
    reverse(RevPath, Path).

% base case for DFS complete
dfs([[State|RestPath]|_], _, [State|RestPath]) :-
    goal(State).

dfs([[State|RestPath]|OtherPaths], Visited, Solution) :-
    findall([NextState,State|RestPath],
        ( move(State,NextState,_),
          \+ member(NextState,[State|RestPath]),
          \+ member(NextState,Visited)
        ),
    NewPaths),
    append(NewPaths, OtherPaths, UpdatedQueue),
    dfs(UpdatedQueue, [State|Visited], Solution).

% same code runs dfs and prints the solution path
run(dfs) :-
    solve_dfs(Path),
    write('Solution Path:'), nl,
    print_path(Path),
    length(Path, L),
    Crossings is L - 1,
    write('Number of crossings: '), write(Crossings), nl.
