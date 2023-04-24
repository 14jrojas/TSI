package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;


import core.game.Observation;
import core.game.StateObservation;
import java.util.ArrayDeque;
import java.util.HashMap;
import java.util.PriorityQueue;
import ontology.Types;
import tools.ElapsedCpuTimer;
import static tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL.Agente.inmovablePositions;

/**
 * Clase que implementa el algoritmo A*
 * @author jrojas14
 */
public class AgenteCompeticion extends Agente {
    // cuando cambia el mapa, reprogramamos
    int n_inmovablePositions;
    
    /**
     * Constructor de la clase
     * @param so
     * @param elapsedTimer 
     */
    public AgenteCompeticion(StateObservation so, ElapsedCpuTimer elapsedTimer) {        
        super(so, elapsedTimer);
        // inicializamos al numero de casillas no permitidas actuales
        n_inmovablePositions = so.getImmovablePositions()[0].size() + so.getImmovablePositions()[1].size();
    }

    /**
     * Metodo de busqueda del algoritmo A*
     */
    public void busqueda() {
        // visitados
        HashMap<Coordinates, Double> cerrados = new HashMap<Coordinates, Double>();     
        // por visitar con funcion coste, se usa para actualizar los costes en lista de abiertos
        HashMap<Coordinates, Double> coordenadas_abiertos = new HashMap<Coordinates, Double>();
        // lista por visitar, ordenados por f=g+h
        PriorityQueue<Node> abiertos = new PriorityQueue<Node>();
        
        // inicializamos la heuristica
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
        // si el camino no esta construido o ha cambiado el mapa porque hemos pisado una casilla oculta, replanificamos
        if (!camino_construido || n_inmovablePositions < stateObs.getImmovablePositions()[0].size()+stateObs.getImmovablePositions()[1].size()) {
            n_inmovablePositions = stateObs.getImmovablePositions()[0].size() + stateObs.getImmovablePositions()[1].size();
            for (Observation obs : stateObs.getImmovablePositions()[0]) {
                obs.position = new Coordinates(obs.position.x / escala.x, obs.position.y / escala.y);
                inmovablePositions.add(obs.position);
            }
            for (Observation obs : stateObs.getImmovablePositions()[1]) {
                obs.position = new Coordinates(obs.position.x / escala.x, obs.position.y / escala.y);
                inmovablePositions.add(obs.position);
            }
            
            camino_construido = true;
            n_inmovablePositions = stateObs.getImmovablePositions()[0].size() + stateObs.getImmovablePositions()[1].size();
            inicial = new Node(new Coordinates(stateObs.getAvatarPosition().x / escala.x,
                                    stateObs.getAvatarPosition().y / escala.y), null);
            camino.clear();
            busqueda();

        }
        // si esta construido, ejecutamos la siguiente accion y la eliminamos de la lista
        return camino.poll();
    }
}