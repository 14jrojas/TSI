% número de marcas
%int: m = 3;
%int: m = 5;
%int: m = 7;
%int: m = 10;
%int: m = 12;
int: m = 12;

array[1..m] of var int: pos; % posiciones de las marcas

% restricciones
% empieza en 0
constraint pos[1] == 0;
% son crecientes
constraint forall(i in 1..m-1) (pos[i] < pos[i+1]);
% para cada par de marcas, distancias distintas
constraint forall(i,j,x,y in 1..m where i<j /\ i<x /\ x<y) (
  pos[j]-pos[i] != pos[y]-pos[x]
);

% busqueda y solución
solve minimize pos[m];

% output
output ["Posición de las marcas: ", show(pos), "\nPosición de la última marca: ", show(pos[m])];

% explicación de la codificación: pos es un array de tamaño m que indica la posición de las m marcas de la regla. La única restricción que tiene más complejidad es obtener distancias distintas para cada par de marcas. Para ello, escogemos el inicio de la primera distancia i, y el inicio de la segunda distancia, x, que debe ser i < x. Elegimos el final de la primera distancia, j, i < j y el final de la segunda, y, x < y, e imponemos que la distancia sea distinta para todos los posibles valores. No es necesario valor absoluto ya que siempre i < j y x < y. 