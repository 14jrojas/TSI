package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;

import java.util.Objects;
import tools.Vector2d;

/**
 * Clase que almacena las coordenadas de un nodo
 * @author jrojas14
 */
public class Coordinates extends Vector2d {
    public Coordinates() {
        super();
    }
    
    public Coordinates(double x, double y) {
        super(x,y);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(x,y);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!super.equals(obj)) {
            return false;
        }
        return obj instanceof Coordinates;
    }
    
}
