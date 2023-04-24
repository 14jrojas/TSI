package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;


import core.game.StateObservation;
import java.util.HashMap;
import java.util.PriorityQueue;
import ontology.Types;
import tools.ElapsedCpuTimer;
import static tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL.Agente.inmovablePositions;

/**
 * Clase que implementa el algoritmo A*
 * @author jrojas14
 */
public class AgenteAStarP4 extends Agente {
    
    // visitados
    static HashMap<Coordinates, Double> cerrados = new HashMap<Coordinates, Double>();  
    // por visitar con funcion coste, se usa para actualizar los costes en lista de abiertos
    HashMap<Coordinates, Double> coordenadas_abiertos = new HashMap<Coordinates, Double>();
    // lista por visitar, ordenados por f=g+h
    PriorityQueue<Node> abiertos = new PriorityQueue<Node>();
    // inicializamos la heuristica
    
    /**
     * Constructor de la clase
     * @param so
     * @param elapsedTimer 
     */
    public AgenteAStarP4(StateObservation so, ElapsedCpuTimer elapsedTimer) {        
        super(so, elapsedTimer);
        this.inicial = new Node(new Coordinates(so.getAvatarPosition().x / escala.x,
                                    so.getAvatarPosition().y / escala.y), null);
        this.objetivo = new Node(new Coordinates(so.getPortalsPositions()[0].get(0).position.x / escala.x,
                                    so.getPortalsPositions()[0].get(0).position.y / escala.y), null);
        camino_construido = false;
    }

    /**
     * Metodo de busqueda del algoritmo A*
     */
    public void busqueda() {
        solucion = null;
        coordenadas_abiertos.clear();
        abiertos.clear();
        inicial.seth(inicial.distanciaManhattan(objetivo.coordenadas));
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
            
            // por cada vecino, si esta en cerrados, pero con una g mayor, eliminamos y actualizamos
            // si no esta en cerrados ni en abiertos, lo añadimos
            // si esta en abiertos con una g mayor, eliminamos y actualizamos
            for (Node hijo : actual.getVecinosAStar(inmovablePositions, objetivo)) {
                if (!hijo.equals(actual.padre)) {
                    boolean en_cerrados = cerrados.containsKey(hijo.coordenadas);
                    Double g;
                    if (en_cerrados && hijo.getg() < cerrados.get(hijo.coordenadas)) {
                        cerrados.remove(hijo.coordenadas);
                        abiertos.add(hijo);
                        coordenadas_abiertos.put(hijo.coordenadas, hijo.getg());
                    } else if (!en_cerrados && coordenadas_abiertos.putIfAbsent(hijo.coordenadas, hijo.getg()) == null) {
                        abiertos.add(hijo);
                    } else if ((g=coordenadas_abiertos.get(hijo.coordenadas)) != null && hijo.getg() < g) {
                        abiertos.remove(hijo);
                        abiertos.add(hijo);
                        coordenadas_abiertos.put(hijo.coordenadas, hijo.getg());
                    }
                }
            }
            // seleccionamos el siguiente nodo
            actual = abiertos.poll();
            // eliminamos de la tabla hash las coordenadas del nodo (va a cerrados)
            coordenadas_abiertos.remove(actual.coordenadas);
            
        } while (true);
        
        // construimos la lista de acciones
        lista_acciones(solucion);
    }
    
    /**
     * Metodo que ejecuta una accion
     * @param stateObs
     * @param elapsedTimer
     * @return 
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
        // si esta construido, ejecutamos la siguiente accion y la eliminamos de la lista
        return camino.poll();
    }
    
}

