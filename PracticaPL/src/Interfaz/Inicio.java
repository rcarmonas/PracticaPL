package Interfaz;

import java.awt.EventQueue;
import javax.swing.JFrame;
/*
 * Nomenclatura imagenes:
 * 	0 - Vacio
 * 	1 - Jugador
 * 	2 - Jugador-Viento
 * 	3 - Jugador-Olor
 * 	4 - Jugador-Viento-Olor
 * 	5 - Viento
 * 	6 - Olor
 * 	7 - Viento-Olor
 */

public class Inicio {
	public JFrame ventana;
	Jugador jugador;
	int matriz[][];
	ImagePanel matrizIP[][];

	public static void main(String args[]) {
		Runnable rAux = new Runnable() {
			public void run() {
					try {
						Inicio window = new Inicio(6, 6);
						window.ventana.setVisible(true);
					} catch (Exception e) {
						e.printStackTrace();
					}
			}
		};

		EventQueue.invokeLater(rAux);
	}

	public Inicio(int X, int Y){
		int i, j;
		
		//TODO parametros iniciales: tamaño matriz
		jugador = new Jugador();
		matriz = new int[X][Y];
		matrizIP = new ImagePanel[X][Y];

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++){
				matriz[i][j] = 0;
			}

		matriz[0][0] = 1;

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++)
				matrizIP[i][j] = new ImagePanel(matriz[i][j]);

		ventana = new JFrame();
		ventana.setTitle("Mundo Wumpus");
		ventana.setBounds(100, 100, 926, 575);
		ventana.setResizable(false);
		ventana.setLayout(null);

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++){
				ventana.add(matrizIP[i][j]);
				matrizIP[i][j].setBounds(i*50, j*50, 50, 50);
			}

/*		ImagePanel IP1;
		IP1 = new ImagePanel("img/vacio.png");
		ventana.add(IP1);

		ImagePanel IP2 = new ImagePanel("img/olor.png");
		ventana.add(IP2);

		IP1.setBounds(50, 0, 50, 50);*/
//		IP2.setBounds(50, 50, 50, 50);
	}

	boolean arriba(){
		jugador.setY(jugador.getY() + 1);
		
		return false;
	}
	boolean abajo(){

		return false;
	}
	boolean izquierda(){

		return false;
	}
	boolean derecha(){

		return false;
	}
}
