package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.HashSet;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

/**
 * Clase agente generico. Todos los agentes heredan de Agente
 * @author jrojas14
 */
public class Agente extends AbstractPlayer {
    static HashSet<Vector2d> inmovablePositions = new HashSet<Vector2d>();  // posiciones inaccesibles
    Deque<Types.ACTIONS> camino = new ArrayDeque<Types.ACTIONS>();          // lista de acciones del camino
    long nodos_expandidos;     // metricas
    boolean camino_construido;
    static double cols, filas;                  // para dimensiones del mapa
    Node inicial, objetivo, solucion;           // informacion del juego
    Coordinates escala;                         // conversion a posiciones
    
    /**
     * Constructor de la clase
     * @param stateObs
     * @param elapsedTimer 
     */
    public Agente(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        this.nodos_expandidos = 0;
        this.camino_construido = false;
        // conversion a posiciones
        this.cols = stateObs.getObservationGrid().length;
        this.filas = stateObs.getObservationGrid()[0].length;
        this.escala = new Coordinates(stateObs.getWorldDimension().width / cols,
                                    stateObs.getWorldDimension().height / filas);
        // datos del juego
        this.inicial = new Node(new Coordinates(stateObs.getAvatarPosition().x / escala.x,
                                    stateObs.getAvatarPosition().y / escala.y), null);
        this.objetivo = new Node(new Coordinates(stateObs.getPortalsPositions()[0].get(0).position.x / escala.x,
                                    stateObs.getPortalsPositions()[0].get(0).position.y / escala.y), null);
        
        // datos del juego, posiciones inaccesibles
        for (Observation obs : stateObs.getImmovablePositions()[0]) {
            obs.position = new Coordinates(obs.position.x / escala.x, obs.position.y / escala.y);
            inmovablePositions.add(obs.position);
        }
        
        for (Observation obs : stateObs.getImmovablePositions()[1]) {
            obs.position = new Coordinates(obs.position.x / escala.x, obs.position.y / escala.y);
            inmovablePositions.add(obs.position);
        }
    }
    
    /**
     * Completa camino con la lista de acciones para llegar a objetivo
     * @param objetivo nodo objetivo
     */
    public void lista_acciones(Node objetivo) {
        Node actual = objetivo;
        Node padre;
        
        // mientras que padre no sea el nodo inicial
        while (actual.padre != null) {
            padre = actual.padre;
            
            // recuperamos la accion realizada
            if (actual.coordenadas.x > padre.coordenadas.x) {
                camino.addFirst(Types.ACTIONS.ACTION_RIGHT);
            } else if (actual.coordenadas.x < padre.coordenadas.x) {
                camino.addFirst(Types.ACTIONS.ACTION_LEFT);
            } else if (actual.coordenadas.y > padre.coordenadas.y) {
                camino.addFirst(Types.ACTIONS.ACTION_DOWN);
            } else if (actual.coordenadas.y < padre.coordenadas.y) {
                camino.addFirst(Types.ACTIONS.ACTION_UP);
            }
            
            actual = padre;
        }
    }
    
    /**
     * Comprueba si las coordenadas proporcionadas corresponden a una casilla correcta
     * @param c coordenadas
     * @return true si c no pisa ni muros ni trampas
     */
    static boolean coordenadas_correctas(Coordinates c) {
        return (c.x < cols && c.y < filas) && !inmovablePositions.contains(c);
    }

    /**
     * Ejecuta una accion. A implementar por los agentes que heredan de Agente
     * @param stateObs
     * @param elapsedTimer
     * @return 
     */
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        return Types.ACTIONS.ACTION_NIL;
    }
}
