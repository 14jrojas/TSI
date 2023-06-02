set of int: trabajadores = 1..3; % trabajadores
enum tareas = {A, B, C, D, E, F, G, H, I, J}; % tareas
% duracion de cada tarea por cada trabajador
array[tareas,trabajadores] of int: duracion = array2d(tareas,trabajadores, [5,7,10,
                              3,5,7,
                              3,2,4,
                              2,5,8,
                              4,3,6,
                              3,2,1,
                              2,2,3,
                              1,3,5,
                              2,3,4,
                              3,2,1] );
% precedencia de tareas
array[tareas] of set of tareas: precedencia = [ {},
                                                {A},
                                                {B},
                                                {A},
                                                {C,D},
                                                {C,D,E},
                                                {C,D},
                                                {A},
                                                {F,H},
                                                {G,I} ];
% asignación de cada trabajador a cada tarea
array[tareas] of var trabajadores: asignacion;
% tiempo inicio de cada tarea
array[tareas] of var int: inicio;
% tiempo de fin de cada tarea
array[tareas] of var int: fin;

% restricciones
% tiempo positivo
constraint forall(t in tareas)(
  inicio[t] >= 0 /\ fin[t] >= 0
);

% tiempo de tareas consistente
constraint forall(t in tareas)(
  inicio[t] + duracion[t, asignacion[t]] == fin[t]
);

% precedencia de tareas
constraint forall(t in tareas, p in precedencia[t])(
  inicio[t] >= fin[p]
);

% trabajadores realizan una tarea al mismo tiempo
constraint forall(t1,t2 in tareas where t1 != t2)(
  if asignacion[t1] == asignacion[t2] then
    (inicio[t1] >= fin[t2]) \/ (inicio[t2] >= fin[t1])
  endif
);

% resolver: minimizamos la finalizacion
solve minimize max(fin);

% output
output ["Duración mínima: ", show(max(fin))];
output ["\nInicio de las tareas:", show(inicio)];
output ["\nFin de las tareas (-1):", show(fin)];
output ["\nAsignación de trabajadores:", show(asignacion)];
output ["\n"];


% he intentado de mil maneras sacar el diagrama por pantalla pero no he podido
% al final lo he hecho a mano en la memoria. La version que hay aquí se que está mal
output ["\n\n\nDía\t\t"];
output [show(i) ++ " " | i in 0..9];
output [show(i) ++ " " | i in 0..9];
output ["\n"];
output ["Trabajador 1\t"];
output [if fix(asignacion[t] == 1) then 
          if fix(inicio[t] <= i) /\ fix(i < fin[t]) then
             "\(t) "
          endif 
        else 
          if fix(inicio[t] <= i) /\ fix(i < fin[t]) then 
            " "
          endif 
        endif | t in tareas, i in 0..20];
output ["\n"];
output ["Trabajador 2\t"];
output [if fix(asignacion[t] == 2) then 
          if fix(inicio[t] <= i) /\ fix(i < fin[t]) then
             "\(t) "
          endif 
        else 
          if fix(inicio[t] <= i) /\ fix(i < fin[t]) then 
            "  "
          endif 
        endif | t in tareas, i in 0..20];
output ["\n"];
output ["Trabajador 3\t"];
output [if fix(asignacion[t] == 3) then 
          if fix(inicio[t] <= i) /\ fix(i < fin[t]) then
             "\(t) "
          endif 
        else 
          if fix(inicio[t] <= i) /\ fix(i < fin[t]) then 
            "  "
          endif 
        endif | t in tareas, i in 0..20];




