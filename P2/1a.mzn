% conjunto de números
%array[int] of int: S = [1,1,2];
%array[int] of int: S = [1,2,3,4,5,6];
array[int] of int: S = [1,1,2,4,4,5,6,7,8];
int: n = length(S);

% para indicar qué elementos pertenecen a S1 y S2
array[1..n] of var bool: S1;
array[1..n] of var bool: S2;

% sumas de S1 y S2
var int: sumaS1 = sum(i in 1..n where S1[i]) (S[i]);
var int: sumaS2 = sum(i in 1..n where S2[i]) (S[i]);

% restricciones
constraint sumaS1 == sumaS2;
constraint forall(i in 1..n) (S1[i] + S2[i] == 1);

% búsqueda y solución
solve satisfy;

% salida de la solución
output ["S1: ", show([S[i] | i in 1..n where S1[i]]), "\n",
        "Suma S1: ", show(sumaS1), "\n",
        "S2: ", show([S[i] | i in 1..n where S2[i]]), "\n",
        "Suma S2: ", show(sumaS2), "\n",]