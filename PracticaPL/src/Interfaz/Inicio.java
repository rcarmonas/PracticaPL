package Interfaz;

import java.awt.EventQueue;
import javax.swing.JFrame;
/*
 * Nomenclatura imagenes:
 * 	0 - Jugador
 * 	1 - Jugador-Viento
 * 	2 - Jugador-Olor
 * 	3 - Jugador-Viento-Olor
 * 	4 - Vacio
 * 	5 - Viento
 * 	6 - Olor
 * 	7 - Viento-Olor
 * 	8 - Desconocido
 */

public class Inicio {
	public JFrame ventana;
	Jugador jugador;
	int matriz[][];
	ImagePanel matrizIP[][];

	int jugadorX, jugadorY;

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
		jugadorX = jugadorY = 0;

		jugador = new Jugador();
		matriz = new int[X][Y];
		matrizIP = new ImagePanel[X][Y];

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++){
				matriz[i][j] = 0;
			}

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++)
				matrizIP[i][j] = new ImagePanel(8);
		matrizIP[0][0] = new ImagePanel(0);

		ventana = new JFrame();
		ventana.setTitle("Mundo Wumpus");
//		ventana.setBounds(100, 100, 926, 575);
		ventana.setBounds(100, 100, X*50+70, Y*50+80);
		ventana.setResizable(false);
		ventana.setLayout(null);
		ventana.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++){
				ventana.add(matrizIP[i][j]);
				matrizIP[i][j].setBounds(i*50+30, j*50+30, 50, 50);
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
