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

	String imagen[] = {"olor", "viento", "flecha", "ambrosia", "tesoro", "pozo", "wumpus", "jugador", "desconocido"};
	public boolean bVector[] = {false, false, false, false, false, false, false, false, true};

	public ImagePanel(boolean vector[]) {
		bVector = vector;
	}

	public ImagePanel() {}

	void actualizaCasilla(int index, boolean value){
		this.bVector[index] = value;
	}

	public void cambiarImagen(boolean jugador){
		//quitas desconocido si es necesario
			this.bVector[8] = false;

		//activas/desactivas jugador
			this.bVector[7] = jugador;

		if(!jugador){
			bVector[2] = false;
			bVector[3] = false;
			bVector[4] = false;
		}

		//repintar
			paintComponent(getGraphics());
	}

	@Override
	protected void paintComponent(Graphics g) {
		super.paintComponent(g);
		try {
			g.drawImage(ImageIO.read(new File("img/fondo.png")), 0, 0, null);
			for(int iAux=0; iAux<=8; iAux++){
				if(bVector[iAux])
					g.drawImage(ImageIO.read(new File("img/" + imagen[iAux] + ".png")), 0, 0, null);
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}    
	}

	void changeParameter(int pos, boolean value){
		bVector[pos] = value;
	}
}