% conjunto de números
%array[int] of int: S = [99,14,82,47,82,50,77,45,23,92,52,90,46,57,29,25,74,25,30,70];
%array[int] of int: S = [35,82,97,30,38,78,18,39,35,93,49,47,30,57,43,21,92,51,89,80];
array[int] of int: S = [60,8,11,2,49,69,87,15,62,72,89,14,76,63,45,92,74,80,11,2];
int: n = length(S);

% para indicar qué elementos pertenecen a S1 y S2
array[1..n] of var bool: S1;
array[1..n] of var bool: S2;

% sumas de S1 y S2
var int: sumaS1 = sum(i in 1..n where S1[i]) (S[i]);
var int: sumaS2 = sum(i in 1..n where S2[i]) (S[i]);
var int: diferencia = abs(sumaS1 - sumaS2);

% restricciones
% el elemento i de S o pertenece a S1 o a S2
constraint forall(i in 1..n) (S1[i] + S2[i] == 1);

% búsqueda y solución
solve minimize diferencia;

% salida de la solución
output ["S1: ", show([S[i] | i in 1..n where S1[i]]), "\n",
        "Suma S1: ", show(sumaS1), "\n",
        "S2: ", show([S[i] | i in 1..n where S2[i]]), "\n",
        "Suma S2: ", show(sumaS2), "\n",
        "Diferencia: ", show(diferencia), "\n"];
               
% explicación de la codificación: S es un array de enteros de longitud n del enunciado del problema, S1, S2 son dos arrays de bool de tamaño n que indica si el elemento i del array S pertenece a S1 o a S2. Como un elemento no puede pertenecer al mismo tiempo a S1 y S2, y tiene que estar al menos en uno de los dos, la suma de la posición i de los elementos de S1 y S2 debe ser 1.
