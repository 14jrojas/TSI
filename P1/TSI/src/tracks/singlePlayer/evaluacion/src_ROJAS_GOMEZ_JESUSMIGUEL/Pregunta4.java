package tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL;


import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import tools.Utils;
import tracks.ArcadeMachine;


/**
 *
 * @author jrojas14
 */
public class Pregunta4 {
    // Path del mapa que se va a modificar

    /**
     * Constructor público
     * @param none
     */
    public Pregunta4(){}

    public static void intercambiarPosicionAgente(String path) throws IOException {
        // leemos el mapa desde el archivo de texto
        BufferedReader br = new BufferedReader(new FileReader(path));
        ArrayList<String> lineas = new ArrayList<String>();
        String linea;
        int agenteFila = -1;
        int agenteColumna = -1;
        while ((linea = br.readLine()) != null) {
            lineas.add(linea);
            if (linea.contains("A")){
                agenteFila = lineas.size()-1;
                agenteColumna = linea.indexOf('A');
            }
        }
        br.close();
        
        // convertimos las líneas en una matriz de caracteres
        char[][] mapa = new char[lineas.size()][lineas.get(0).length()];
        for (int fila = 0; fila < lineas.size(); fila++) {
            linea = lineas.get(fila);
            for (int columna = 0; columna < linea.length(); columna++) {
                char casilla = linea.charAt(columna);
                mapa[fila][columna] = casilla;
            }
        }
        
        // cambiamos la casilla del agente por un '.' aleatorio
        Random rand = new Random();
        int nuevaFila;
        int nuevaColumna;
        do {
            nuevaFila = rand.nextInt(mapa.length);
            nuevaColumna = rand.nextInt(mapa[0].length);
        } while (mapa[nuevaFila][nuevaColumna] != '.');
        mapa[agenteFila][agenteColumna] = '.';
        mapa[nuevaFila][nuevaColumna] = 'A';
        
        // escribimos el mapa modificado en un nuevo archivo de texto
        BufferedWriter bw = new BufferedWriter(new FileWriter("examples/gridphysics/labyrinth_lvl6.txt"));
        for (int fila = 0; fila < mapa.length; fila++) {
            linea = new String(mapa[fila]);
            bw.write(linea);
            bw.newLine();
        }
        bw.close();
    }
    
    public static void saveHeatMap(double ancho, double alto, HashMap<Coordinates,Double> tabla_hash, String nombre){
        // matriz del heatmap
        String data = "";

        // Creamos la matriz de datos para pintar el heatmap
        for(int j=1; j <= alto; j++){
            for(int i=0; i < ancho; i++){
                Coordinates pos = new Coordinates(new Double(i), new Double(alto-j));
                if (!tabla_hash.containsKey(pos)) {
                    data += "0";
                } else {
                    data += tabla_hash.get(pos).toString();
                }
                if (i != ancho - 1){
                    data += "\t";
                }
            }
            data += "\n";
        }

        // Escribimos la matriz de datos en un archivo
        FileWriter fichero = null;
        PrintWriter pw = null;
        try {
            fichero = new FileWriter("data.dat");
            pw = new PrintWriter(fichero);

            pw.println(data);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (null != fichero)
                    fichero.close();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }

        try {
            // lanzamos el proceso de gnuplot
            Process gnuplotProcess = Runtime.getRuntime().exec("gnuplot");

            // obtenemos el flujo de salida para escribir los comandos
            BufferedWriter gnuplotWriter = new BufferedWriter(new OutputStreamWriter(gnuplotProcess.getOutputStream()));

            // comandos
            gnuplotWriter.write("set term png");
            gnuplotWriter.newLine();
            gnuplotWriter.write("set output 'src/tracks/singlePlayer/evaluacion/src_ROJAS_GOMEZ_JESUSMIGUEL/"+nombre+"'");
            gnuplotWriter.newLine();
            gnuplotWriter.write("set title '"+nombre+"'");
            gnuplotWriter.newLine();
            gnuplotWriter.write("unset key");
            gnuplotWriter.newLine();
            gnuplotWriter.write("set xrange [0:"+(ancho-1)+"]");
            gnuplotWriter.newLine();
            gnuplotWriter.write("set yrange [0:"+(alto-1)+"]");
            gnuplotWriter.newLine();
            gnuplotWriter.write("plot 'data.dat' matrix with image");
            gnuplotWriter.newLine();
            gnuplotWriter.write("exit");
            gnuplotWriter.close();
            // depuracion errores gnuplot
            BufferedReader gnuplotErrorReader = new BufferedReader(new InputStreamReader(gnuplotProcess.getErrorStream()));
            String line;
            while ((line = gnuplotErrorReader.readLine()) != null) {
                System.err.println(line);
            }
            gnuplotProcess.waitFor(); // Esperar a que el proceso de Gnuplot termine
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void main(String [] arg) throws IOException {

        String spGamesCollection =  "examples/all_games_sp.csv";
        String[][] games = Utils.readGames(spGamesCollection);

        int gameIdx = 58;
        int levelIdx = 6;
        String gameName = games[gameIdx][1];
        String game = games[gameIdx][0];

        String sampleAStarController = "tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL.AgenteAStarP4";
        String sampleRTAStarController = "tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL.AgenteRTAStarP4";
        String sampleLRTAStarController = "tracks.singlePlayer.evaluacion.src_ROJAS_GOMEZ_JESUSMIGUEL.AgenteLRTAStarP4";

        
        int M = 50;
        // RTAStar
        for (int i = 0; i < M; i++) {
            Pregunta4.intercambiarPosicionAgente("examples/gridphysics/labyrinth_lvl6.txt");
            String level1 = game.replace(gameName, gameName + "_lvl" + levelIdx);
            ArcadeMachine.runOneGame(game, level1, true, sampleRTAStarController, null, 0, 0);
        }
        Pregunta4.saveHeatMap(Agente.cols, Agente.filas, AgenteRTAStarP4.tabla_hash, "RTAStar.png");
        
        // LRTAStar
        for (int i = 0; i < M; i++) {
            Pregunta4.intercambiarPosicionAgente("examples/gridphysics/labyrinth_lvl6.txt");
            String level1 = game.replace(gameName, gameName + "_lvl" + levelIdx);
            ArcadeMachine.runOneGame(game, level1, true, sampleLRTAStarController, null, 0, 0);
        }
        Pregunta4.saveHeatMap(Agente.cols, Agente.filas, AgenteLRTAStarP4.tabla_hash, "LRTAStar.png");
        
        // AStar
        Pregunta4.intercambiarPosicionAgente("examples/gridphysics/labyrinth_lvl6.txt");
        String level1 = game.replace(gameName, gameName + "_lvl" + levelIdx);
        ArcadeMachine.runOneGame(game, level1, true, sampleAStarController, null, 0, 0);
        Pregunta4.saveHeatMap(Agente.cols, Agente.filas, AgenteAStarP4.cerrados, "AStar.png");
    }
}
