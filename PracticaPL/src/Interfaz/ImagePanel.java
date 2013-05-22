package Interfaz;

import java.awt.Graphics;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.swing.JPanel;

/*
 * Nomenclatura imagenes:
 * 	0 - olor
 *  1 - viento
 *  2 - flecha - Especial
 *  3 - ambrosia - Especial
 *  4 - tesoro - Especial
 *  5 - pozo
 *  6 - wumpus
 *  7 - jugador
 *  8 - desconocido
 */

@SuppressWarnings("serial")
public class ImagePanel extends JPanel{

	String imagen[] = {"olor", "viento", "flecha", "ambrosia", "tesoro", "pozo", "wumpus", "mina", "puerta", "jugador", "desconocido"};
	public boolean bVector[] = {false, false, false, false, false, false, false, false, false, false, true};
	String strMod = "";
	boolean monty = false;

	public ImagePanel(boolean vector[]) {
		bVector = vector;
	}

	public ImagePanel(String aux) {
		if(!aux.isEmpty())
			strMod = aux + "/";

		if(aux.compareTo("Monty")==0)
			monty = true;
	}

	/**
	 * Hace desaparecer o aparecer la imagen del jugador
	 * @param jugador Indica si se desea que este o no el jugador
	 */
	public void cambiarImagen(boolean jugador){
		//quitas desconocido si es necesario
		this.bVector[Inicio.desconocido] = false;

		//activas/desactivas jugador
		this.bVector[Inicio.jugador] = jugador;

		if(!jugador){
			bVector[Inicio.flecha] = false;
			bVector[Inicio.ambrosia] = false;
			bVector[Inicio.tesoro] = false;
		}
		//repintar
		paintComponent(getGraphics());
	}

	@Override
	protected void paintComponent(Graphics g) {
		try {
			g.drawImage(ImageIO.read(new File("img/" + strMod + "fondo.png")), 0, 0, null);

			for(int iAux=0; iAux<=9; iAux++){
				if(bVector[iAux])
					g.drawImage(ImageIO.read(new File("img/" + strMod + imagen[iAux] + ".png")), 0, 0, null);
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}    
	}

	/**
	 * Cambia un parametro de una casilla
	 * @param pos Posicion en el vector
	 * @param value Valor que se le asignara
	 */
	void changeParameter(int pos, boolean value){
		bVector[pos] = value;
		if(!this.bVector[Inicio.desconocido])
			paintComponent(getGraphics());
	}
	
	/**
	 * Cambia un parametro de una casilla
	 * @param pos Posicion en el vector
	 * @param value Valor que se le asignara
	 */
	void initializeParameter(int pos, boolean value){
		bVector[pos] = value;
	}
}