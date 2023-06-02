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

% añadido b: trabajador extra
array[tareas] of var 0..1: extra;

% restricciones
% tiempo positivo
constraint forall(t in tareas)(
  inicio[t] >= 0 /\ fin[t] >= 0
);

% tiempo de tareas consistente
% añadido b: trabajador extra
constraint forall(t in tareas)(
  inicio[t] + duracion[t, asignacion[t]] - extra[t] == fin[t]
);

% precedencia de tareas
constraint forall(t in tareas, p in precedencia[t])(
  inicio[t] >= fin[p]
);

% trabajadores realizan una tarea al mismo tiempo, el trabajador extra también
constraint forall(t1,t2 in tareas where t1 != t2)(
  % añadido b: trabajador extra
  if asignacion[t1] == asignacion[t2] \/ (extra[t1] == 1 /\ extra[t2] == 1) then
    (inicio[t1] >= fin[t2]) \/ (inicio[t2] >= fin[t1])
  endif
);

% añadido b: trabajador extra
% extra solo ayuda en las tareas de mas de dos horas
constraint forall(t in tareas where duracion[t,asignacion[t]] < 2)(
  extra[t] == 0
);


% resolver: minimizamos la finalizacion
solve minimize max(fin);

% output
output ["Duración mínima: ", show(max(fin))];
output ["\nInicio de las tareas:", show(inicio)];
output ["\nFin de las tareas (-1):", show(fin)];
output ["\nAsignación de trabajadores:", show(asignacion)];
output ["\nTrabajador extra ayuda en las tareas:", show(extra)];


% explicación de la codificación: la asignación de tareas está codificada como un array de enteros cuyas posiciones son las tareas e indican que trabajador realiza qué tarea. Además, necesitaremos dos arrays del mismo tipo que indican cuando empieza la tarea y cuando termina (esto se debe considerar como [inicio, fin) ). Además, para este apartado necesitaremos codificar el trabajador extra, que es un array del mismo tipo pero que contiene 0 o 1 en función de si ayuda a la tarea o no. En cuanto a las restricciones, imponemos que el inicio de una tarea más la duración de la misma menos la ayuda del trabajor extra (si la tiene), debe coincidir con el fin de la misma, imponemos que si una tarea precede a otra, el inicio de la primera debe ser después de que se haya terminado la tarea precedente, imponemos que si dos tareas distintas están asignadas al mismo trabajador, no deben coincidir en los días en que se desarrollan (idem con el trabajador extra) e imponemos que el trabajador extra no ayuda en las tareas de menos de dos dias de duración. Para resolverlo, minimizamos el máximo de los valores de fin, es decir, minimizamos el fin de la última tarea.


% he intentado de mil maneras sacar el diagrama por pantalla pero no he podido al final lo he hecho a mano en la memoria. La version que hay aquí está mal pero la he dejado para que se vea que al menos lo he intentado
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





