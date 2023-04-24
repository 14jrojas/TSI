package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;

import core.game.StateObservation;
import java.util.HashMap;
import java.util.PriorityQueue;
import ontology.Types;
import tools.ElapsedCpuTimer;

/**
 * Clase que implementa el algortimo Dijkstra
 * @author jrojas14
 */
public class AgenteDijkstra extends Agente {
    
    /**
     * Constructor de la clase
     * @param so
     * @param elapsedTimer 
     */
    public AgenteDijkstra(StateObservation so, ElapsedCpuTimer elapsedTimer) {        
        super(so, elapsedTimer);
    }

    /**
     * Metodo de busqueda del algoritmo Dijkstra
     */
    public void busqueda() {
        // visitados (unas mismas coordenadas pueden tener dos costes distintos, dos maneras de llegar a dichas coordenadas)
        HashMap<Coordinates, Double> cerrados = new HashMap<Coordinates, Double>();
        // nodos por visitar
        PriorityQueue<Node> abiertos = new PriorityQueue<Node>();
        
        Node actual = inicial;
        
        do {
            nodos_expandidos++;
            // si llegamos al objetivo, paramos la busqueda
            if (actual.equals(objetivo)) {
                solucion = actual;
                break;
            }
            
            // metemos en cerrados
            cerrados.put(actual.coordenadas, actual.getg());
            
            // por cada vecino, si no esta en cerrados ni abiertos, añadimos a abiertos
            // y si esta en abiertos con una g menor, eliminamos el antiguo y añadimos el nuevo
            for (Node hijo : actual.getVecinosDijkstra(inmovablePositions)) {
                if (!hijo.equals(actual.padre)) {
                    boolean en_cerrados = cerrados.containsKey(hijo.coordenadas);
                    if (!en_cerrados && !abiertos.contains(hijo)) {
                        abiertos.add(hijo);
                    } else if (abiertos.contains(hijo) && hijo.getg() < abiertos.peek().getg()) {
                        abiertos.remove(hijo);
                        abiertos.add(hijo);
                    }
                }
            }
            
            // seleccionamos el siguiente nodo
            actual = abiertos.poll();
            
        } while (true);
        
        // construimos lista de acciones
        lista_acciones(solucion);
    }
    
    /**
     * Metodo que ejecuta una accion
     * @param stateObs
     * @param elapsedTimer
     * @return accion a ejecutar
     */
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        // si el camino no esta construido, lo construimos y evaluamos las metricas
        if (!camino_construido) {
            long t_ini = System.nanoTime();
            busqueda();
            long t_fin = System.nanoTime();
            long total = (t_fin - t_ini) / 1000000;
            System.out.println("Runtime (ms): " + total);
            System.out.println("Tamaño de la ruta: " + camino.size());
            System.out.println("Nodos expandidos: " + nodos_expandidos);
            camino_construido = true;
            return camino.poll();
        }
        // si esta costruido, ejecutamos la siguiente accion y la eliminamos de la lista
        return camino.poll();
    }
    
}
