package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;

import java.util.HashMap;
import java.util.HashSet;
import java.util.PriorityQueue;
import java.util.ArrayList;
import java.util.Objects;
import tools.Vector2d;

/**
 * 
 * @author jrojas14
 */
public class Node implements Comparable<Node>{
    double g;                   // coste acumulado del nodo
    double h;                   // coste heuristico del nodo
    Node padre;                 // nodo padre
    Coordinates coordenadas;    // coordenadas del nodo
    
    /**
     * Constructor de la clase
     * @param coordenadas
     * @param padre
     */
    public Node(Coordinates coordenadas, Node padre) {
        this.g = 0.0f;
        this.h = 0.0f;
        this.coordenadas = coordenadas;
        this.padre = padre;
    }
    
    /**
     * Getter coste acumulado
     * @return valor de g
     */
    public double getg() {
    	return g;
    }

    /**
     * Getter coste heuristico
     * @return valor de h
     */
    public double geth() {
    	return h;
    }
    
    /**
     * Getter coste total
     * @return suma de los costes
     */
    public double getf() {
    	return (this.g + this.h);
    }

    /**
     * Setter coste acumulado
     * @param g valor del coste
     */
    public void setg(double g) {
        this.g = g;
    }
    
    /**
     * Setter coste heuristico
     * @param h valor heuristico
     */
    public void seth(double h) {
    	this.h = h;
    }

    /**
     * Comparador entre nodos en funcion de coste
     * @param node a comparar
     * @return this <>= node
     */
    @Override
    public int compareTo(Node node) {
    	if (this.getf() < node.getf()) {
            return -1;
        }
        if (this.getf() > node.getf()) {
            return 1;
        }
    	if (this.getg() < node.getg()) {
            return -1;
        }
    	if (this.getg() > node.getg()) {
            return 1;
        }
    	return 0;
    }
    
    /**
     * Codigo hash
     * @return codigo hash de coordenadas
     */
    @Override
    public int hashCode() {
            return Objects.hash(this.coordenadas);
    }
    
    /**
     * Comparador de objetos nodo
     * @param obj
     * @return si el objeto obj es el mismo que this
     */
    @Override
    public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (obj == null) {
                return false;
            }
            if (getClass() != obj.getClass()) {
                return false;
            }
            Node otro = (Node) obj;
            return Objects.equals(this.coordenadas, otro.coordenadas);
    }
	
    /**
     * Distancia manhattan
     * @param coordenadas
     * @return distancia de this.coordenadas a coordenadas
     */
    public double distanciaManhattan(Coordinates coordenadas) {
    	return Math.abs(this.coordenadas.x - coordenadas.x) + Math.abs(this.coordenadas.y - coordenadas.y);
    }

    /**
     * Vecinos (nodos) segun el algoritmo Dijkstra. El coste heuristico siempre es 0
     * @param inmovablePositions posiciones inaccesibles (muros, trampas...)
     * @return lista de nodos vecinos, expandidos arriba, abajo, izquierda y derecha
     */
    public ArrayList<Node> getVecinosDijkstra(HashSet<Vector2d> inmovablePositions) {
    	ArrayList<Node> vecinos = new ArrayList<Node>();
		
    	// nodo arriba
        Coordinates pos = new Coordinates(this.coordenadas.x, this.coordenadas.y - 1);
    	Node hijo = new Node(pos, this);
    	if ( Agente.coordenadas_correctas(pos) ) {
            hijo.setg(this.g + 1);
            vecinos.add(hijo);
        }
        
    	// nodo abajo
    	pos = new Coordinates(this.coordenadas.x, this.coordenadas.y + 1);
    	hijo = new Node(pos, this);
    	if ( Agente.coordenadas_correctas(pos) ) {
            hijo.setg(this.g + 1);
            vecinos.add(hijo);
        }
                
    	// nodo izq
    	pos = new Coordinates(this.coordenadas.x - 1, this.coordenadas.y);
    	hijo = new Node(pos, this);
    	if ( Agente.coordenadas_correctas(pos) ) {
            hijo.setg(this.g + 1);
            vecinos.add(hijo);
        }
                
    	// nodo derecho
    	pos = new Coordinates(this.coordenadas.x + 1, this.coordenadas.y);
    	hijo = new Node(pos, this);
    	if ( Agente.coordenadas_correctas(pos) ) {
            hijo.setg(this.g + 1);
            vecinos.add(hijo);
        }
    	
    	return vecinos;
    }
	
    /**
     * Vecinos (nodos) segun el algoritmo A*. Heuristica: distancia manhattan
     * @param inmovablePositions posiciones inaccesibles (muros, trampas...)
     * @param objetivo nodo objetivo, necesario para la heuristica
     * @return lista de nodos vecinos, expandidos arriba, abajo, izquierda y derecha
     */
    public ArrayList<Node> getVecinosAStar(HashSet<Vector2d> inmovablePositions, Node objetivo) {
        ArrayList<Node> vecinos = new ArrayList<Node>();
    	
        // nodo arriba
    	Coordinates pos = new Coordinates(this.coordenadas.x, this.coordenadas.y - 1);
    	Node hijo;
    	if ( Agente.coordenadas_correctas(pos) ) {
    		hijo = new Node(pos,this);
    		hijo.seth(hijo.distanciaManhattan(objetivo.coordenadas));
    		hijo.setg(this.g + 1);
    		vecinos.add(hijo);
    	}
    	
        // nodo abajo
    	pos = new Coordinates(this.coordenadas.x, this.coordenadas.y + 1);
    	if ( Agente.coordenadas_correctas(pos) ) {
    		hijo = new Node(pos,this);
    		hijo.seth(hijo.distanciaManhattan(objetivo.coordenadas));
    		hijo.setg(this.g + 1);
    		vecinos.add(hijo);
    	}
    	
        // nodo izq
    	pos = new Coordinates(this.coordenadas.x - 1, this.coordenadas.y);
    	if ( Agente.coordenadas_correctas(pos) ) {
    		hijo = new Node(pos,this);
    		hijo.seth(hijo.distanciaManhattan(objetivo.coordenadas));
    		hijo.setg(this.g + 1);
    		vecinos.add(hijo);
    	}
    	
        // nodo dcho
    	pos = new Coordinates(this.coordenadas.x + 1, this.coordenadas.y);
    	if ( Agente.coordenadas_correctas(pos) ) {
    		hijo = new Node(pos,this);
    		hijo.seth(hijo.distanciaManhattan(objetivo.coordenadas));
    		hijo.setg(this.g + 1);
    		vecinos.add(hijo);
    	}
    	
    	return vecinos;
    }
    
    /**
     * Mejor vecino (nodo) según el algoritmo RTA*. Este metodo tambien sirve para LRTA*
     * @param inmovablePositions posiciones inaccesibles (muros, trampas...)
     * @param tabla_hash tabla que almacena las heuristicas
     * @param vecinos vecinos expandidos
     * @param objetivo nodo objetivo
     * @return mejor vecino entre los vecinos expandidos
     */
    public Node getMejorVecinoRTAStar(HashSet<Vector2d> inmovablePositions, HashMap<Coordinates, Double> tabla_hash, PriorityQueue<Node> vecinos, Node objetivo) {
        // cada nueva iteracion se actualizan los vecinos
        vecinos.clear();
        
        // nodo arriba
        Coordinates pos = new Coordinates(this.coordenadas.x, this.coordenadas.y - 1);
        Node hijo = new Node(pos, this);
        double distancia = hijo.distanciaManhattan(objetivo.coordenadas);
        if (Agente.coordenadas_correctas(pos)) {
            // si no hemos almacenado la heuristica, se inicializa a la distancia
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            // si hemos almacenado la heuristica, inicializamos a ese valor
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // nodo abajo
        pos = new Coordinates(this.coordenadas.x, this.coordenadas.y + 1);
        hijo = new Node(pos, this);
        distancia = hijo.distanciaManhattan(objetivo.coordenadas);
        if (Agente.coordenadas_correctas(pos)) {
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // nodo izq
        pos = new Coordinates(this.coordenadas.x - 1, this.coordenadas.y);
        hijo = new Node(pos, this);
        distancia = hijo.distanciaManhattan(objetivo.coordenadas);
        if (Agente.coordenadas_correctas(pos)) {
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // nodo dcho
        pos = new Coordinates(this.coordenadas.x + 1, this.coordenadas.y);
        hijo = new Node(pos, this);
        distancia = hijo.distanciaManhattan(objetivo.coordenadas);
        if (Agente.coordenadas_correctas(pos)) {
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // devolvemos el mejor vecino y lo eliminamos de vecinos
        return vecinos.poll();
    }
    
    public Node getMejorVecinoCompeticion(HashSet<Vector2d> inmovablePositions, HashMap<Coordinates, Double> tabla_hash, PriorityQueue<Node> vecinos, Node objetivo) {
        // cada nueva iteracion se actualizan los vecinos
        vecinos.clear();
        
        // nodo arriba
        Coordinates pos = new Coordinates(this.coordenadas.x, this.coordenadas.y - 1);
        Node hijo = new Node(pos, this);
        double distancia = Math.sqrt(hijo.distanciaManhattan(objetivo.coordenadas));
        if (Agente.coordenadas_correctas(pos)) {
            // si no hemos almacenado la heuristica, se inicializa a la distancia
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            // si hemos almacenado la heuristica, inicializamos a ese valor
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // nodo abajo
        pos = new Coordinates(this.coordenadas.x, this.coordenadas.y + 1);
        hijo = new Node(pos, this);
        distancia = Math.sqrt(hijo.distanciaManhattan(objetivo.coordenadas));
        if (Agente.coordenadas_correctas(pos)) {
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // nodo izq
        pos = new Coordinates(this.coordenadas.x - 1, this.coordenadas.y);
        hijo = new Node(pos, this);
        distancia = Math.sqrt(hijo.distanciaManhattan(objetivo.coordenadas));
        if (Agente.coordenadas_correctas(pos)) {
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // nodo dcho
        pos = new Coordinates(this.coordenadas.x + 1, this.coordenadas.y);
        hijo = new Node(pos, this);
        distancia = Math.sqrt(hijo.distanciaManhattan(objetivo.coordenadas));
        if (Agente.coordenadas_correctas(pos)) {
            if (!tabla_hash.containsKey(pos)) {
                hijo.seth(distancia);
                vecinos.add(hijo);
            } else {
                hijo.seth(tabla_hash.get(pos));
                vecinos.add(hijo);
            }
        }
        
        // devolvemos el mejor vecino y lo eliminamos de vecinos
        return vecinos.poll();
    }
}