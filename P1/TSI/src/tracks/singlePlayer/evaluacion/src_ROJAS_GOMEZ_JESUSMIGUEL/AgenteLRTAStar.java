package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;

import core.game.Observation;
import core.game.StateObservation;
import java.util.HashMap;
import java.util.PriorityQueue;
import ontology.Types;
import tools.ElapsedCpuTimer;

/**
 * Clase que implementa el algoritmo de competicion
 * @author jrojas14
 */
public class AgenteLRTAStar extends Agente {
    HashMap<Coordinates, Double> tabla_hash = new HashMap<Coordinates, Double>();   // tabla para actualizar valor heuristico
    PriorityQueue<Node> vecinos = new PriorityQueue<Node>();                        // vecinos del nodo actual
    Node actual, mejor_vecino;      // nodo actual, mejor vecino de vecinos
    long tiempo_total;              // tiempo total empleado
    int n_inmovablePositions;

    /**
     * Constructor de la clase
     * @param stateObs
     * @param elapsedTimer 
     */
    public AgenteLRTAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        super(stateObs, elapsedTimer);
        // inicializamos la heuristica del nodo inicial con la distancia manhattan
        inicial.seth(inicial.distanciaManhattan(objetivo.coordenadas));
        // inicializamos mejor vecino a inicial (primera iteracion) e introducimos en la tabla
        mejor_vecino = inicial;
        tabla_hash.put(inicial.coordenadas, inicial.geth());
        // inicializamos tiempo
        tiempo_total = 0;
        // cambios de mapa
        n_inmovablePositions = stateObs.getImmovablePositions()[0].size() + stateObs.getImmovablePositions()[1].size();
    }
    
    /**
     * Calculo de la siguiente accion, segun actual y mejor vecino
     * @return 
     */
    public Types.ACTIONS siguiente_accion() {
        // si el mejor vecino esta a la derecha de actual, se mueve a la derecha...
        if (mejor_vecino.coordenadas.x > actual.coordenadas.x) {
            return Types.ACTIONS.ACTION_RIGHT;
        } else if (mejor_vecino.coordenadas.x < actual.coordenadas.x) {
            return Types.ACTIONS.ACTION_LEFT;
        } else if (mejor_vecino.coordenadas.y > actual.coordenadas.y) {
            return Types.ACTIONS.ACTION_DOWN;
        } else if (mejor_vecino.coordenadas.y < actual.coordenadas.y) {
            return Types.ACTIONS.ACTION_UP;
        }
        return Types.ACTIONS.ACTION_NIL;
    }
    
    /**
     * Busqueda del algortimo LRTA*
     * @return siguiente accion a ejecutar
     */
    public Types.ACTIONS busqueda() {
        nodos_expandidos++;
        // actualizamos el nodo actual
        actual = mejor_vecino;
        // obtenemos el mejor vecino del actual
        mejor_vecino = actual.getMejorVecinoRTAStar(inmovablePositions, tabla_hash, vecinos, objetivo);
        
        // diferencia con RTA*: actualizamos la heuristica al mejor vecino en lugar de al segundo
        tabla_hash.put(actual.coordenadas, Math.max(actual.geth(), mejor_vecino.geth()+1));
        
        // devolvemos la siguiente accion
        return siguiente_accion();
    }
    
    /**
     * Metodo que ejecuta la accion, segun LRTA*
     * @param stateObs
     * @param elapsedTimer
     * @return accion a ejecutar
     */
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        // añadido para laberinto extendido: cada vez que hay mas posiciones no permitidas, actualizamos
        if (n_inmovablePositions < stateObs.getImmovablePositions()[0].size() + stateObs.getImmovablePositions()[1].size()){
            n_inmovablePositions = stateObs.getImmovablePositions()[0].size() + stateObs.getImmovablePositions()[1].size();
            for (Observation obs : stateObs.getImmovablePositions()[0]) {
                obs.position = new Coordinates(obs.position.x / escala.x, obs.position.y / escala.y);
                inmovablePositions.add(obs.position);
            }
            for (Observation obs : stateObs.getImmovablePositions()[1]) {
                obs.position = new Coordinates(obs.position.x / escala.x, obs.position.y / escala.y);
                inmovablePositions.add(obs.position);
            }
        }
        
        // por cada accion, acumulamos el tiempo total
        long tini = System.nanoTime();
        Types.ACTIONS siguiente = busqueda();
        long tfin = System.nanoTime();
        tiempo_total += (tfin - tini) / 1000000;
        
        // si llegamos al objetivo, imprimimos las metricas
        if (mejor_vecino.equals(objetivo)) {
            System.out.println("Runtime (ms): " + tiempo_total);
            System.out.println("Tamaño de la ruta: " + nodos_expandidos);
            System.out.println("Nodos expandidos: " + nodos_expandidos);
        }
        
        // devolvemos la siguiente accion a ejecutar
        return siguiente;
    }
    
}
