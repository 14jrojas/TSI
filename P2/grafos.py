import numpy as np

# Función para generar un grafo aleatorio con N nodos y 4*N aristas
def randomgraph(N, seed):

	# Fijamos la semilla
	np.random.seed(seed)

	# Matriz de adyacencia
	adj = np.zeros((N,N),int)

	# Iteramos para cada arista
	for i in range(4*N):

		# Generamos dos nodos en [0,N)
		n1 = np.random.randint(0,N)
		n2 = np.random.randint(0,N)

		# Si son el mismo nodo, se re-genera
		while n1 == n2:
			n2 = np.random.randint(0,N)

		# Se actualiza la matriz de adyacencia
		adj [n1,n2]=1
		adj [n2,n1]=1

	# Se imprime
	print("int: N = ", N, ";")
	print("array [1..N,1..N] of 0..1: adyacencia = [|", end='')
	for i in range(N):
		for j in range(N-1):
			print(str(adj[i,j])+",", end='')
		print(str(adj [i,N-1])+"|", end='')
	print("];")
	print("")

seeds = [0,1,42]
N = [10,20,30,40,50,60]


for n in N:
	for s in seeds:
		randomgraph(n,s)
