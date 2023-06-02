enum asignaturas = {A1, A2, A3, A4, A5, A6, A7, A8, A9}; % asignaturas
set of int: horas = 1..5; % horas sin tutorias
enum dias = {Lunes, Martes, Miercoles, Jueves, Viernes}; % dias
enum prof = {Prof1, Prof2, Prof3, Prof4}; % profesores
% horas de las asignaturas
array[asignaturas] of int: horas_asignatura = [4, 2, 4, 4, 4, 2, 2, 2, 1];
% bloques de las asignaturas
array[asignaturas] of int: horas_bloque = [2,1,2,2,2,1,1,2,1];
% profesores de asignaturas
array[asignaturas] of prof: asignaturas_prof = [Prof1, Prof4, Prof1, Prof2, Prof2, Prof3, Prof4, Prof4, Prof3];

% horario
array[dias, horas] of var asignaturas: horario;

% restricciones
% se cumplen todas las horas de las asignaturas
constraint forall(a in asignaturas)(
  sum([1 | d in dias, h in horas where horario[d,h] == a]) == horas_asignatura[a]
);

% maximo de horas por bloque
constraint forall(a in asignaturas, d in dias)(
  sum([1 | h in horas where horario[d,h] == a]) <= horas_bloque[a]
);

% maximo un bloque de asignatura por dia
constraint forall(d in dias, h in horas where horas_bloque[horario[d,h]] == 2)(
  if h == horas[1] then horario[d,h] == horario[d,h+1]
  elseif h == horas[card(horas)] then horario[d,h-1] == horario[d,h]
  else horario[d,h-1] == horario[d,h] \/ horario[d,h] == horario[d,h+1]
  endif
);

% maximo un profe por bloque por dia (menos prof4)
constraint forall(d in dias)(forall (i,j in horas)(
  if (i != j /\ horario[d,i] != horario[d,j]) then asignaturas_prof[horario[d,i]] != asignaturas_prof[horario[d,j]] \/ (asignaturas_prof[horario[d,i]] == Prof4 /\ asignaturas_prof[horario[d,j]] == Prof4) endif
));

% cuarta hora tutoria: no se puede partir una asignatura
constraint forall(d in dias)(
  horario[d,3] != horario[d,4]
);

% horario profesores
constraint forall(d in dias, h in horas)(
  if h != 4 /\ h != 5 then asignaturas_prof[horario[d,h]] != Prof1 endif
);
constraint forall(d in dias, h in horas)(
  if h != 1 /\ h != 2 /\ h != 3 then asignaturas_prof[horario[d,h]] != Prof2 endif
);
constraint forall(d in dias, h in horas)(
  if h != 3 then asignaturas_prof[horario[d,h]] != Prof3 endif
);

% dias asignaturas
constraint forall(d in dias, h in horas)(
  if d != Lunes /\ d != Martes then horario[d,h] != A1 endif
);
constraint forall(d in dias, h in horas)(
  if d != Miercoles /\ d != Jueves then horario[d,h] != A3 endif
);
constraint forall(d in dias, h in horas)(
  if d != Lunes /\ d != Martes then horario[d,h] != A4 endif
);
constraint forall(d in dias, h in horas)(
  if d != Jueves /\ d != Viernes then horario[d,h] != A5 endif
);
constraint forall(d in dias, h in horas)(
  if d != Miercoles /\ d != Viernes then horario[d,h] != A6 endif
);
constraint forall(d in dias, h in horas)(
  if d != Martes /\ d != Viernes then horario[d,h] != A7 endif
);
constraint forall(d in dias, h in horas)(
  if d != Miercoles then horario[d,h] != A8 endif
);
constraint forall(d in dias, h in horas)(
  if d != Lunes then horario[d,h] != A9 endif
);

% resolver
solve satisfy;

% output
output ["Horario:"];
output [if d == dias[1] then "\n" else "\t" endif ++ show(horario[d, h]) ++ " " | h in 1..3, d in dias];
output [if d == dias[1] then "\n" else "\t" endif ++ "T" ++ " " | d in dias];
output [if d == dias[1] then "\n" else "\t" endif ++ show(horario[d, h]) ++ " " | h in 4..5, d in dias];


% explicación de la codificación: la solución de este problema es un array bidimensional de dias x horas. En este caso, he decidido implementar las restricciones de asignaturas por separado: si una asignatura solo puede darse el lunes, si el horario en el día d no es lunes, entonces no puede aparecer dicha asignatura en el horario de ese dia. Idem para el horario de profesores. El resto de restricciones son intuitivas: se deben impartir todas las horas de las asignaturas, una asignatura en un dia no puede superar el máximo de horas del bloque, si en un dia se imparte una asignatura de dos horas, las dos horas deben ir seguidas, un profesor no puede dar dos asignaturas el mismo día (exceto el profesor 4)...





















                                           