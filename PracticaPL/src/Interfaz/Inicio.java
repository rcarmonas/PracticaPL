package Interfaz;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
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
	int rejillaX, rejillaY;

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
		rejillaX = X;
		rejillaY = Y;

		jugador = new Jugador();
		matriz = new int[X][Y];
		matrizIP = new ImagePanel[X][Y];

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++){
				matriz[i][j] = 4;
			}

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++)
				matrizIP[i][j] = new ImagePanel(8);
		matrizIP[0][0] = new ImagePanel(0);

		ventana = new JFrame();
		ventana.setTitle("Mundo Wumpus");
		ventana.setBounds(100, 100, X*50+300, Y*50+80);
		ventana.setResizable(false);
		ventana.setLayout(null);
		ventana.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		for(i=0; i<X; i++)
			for(j=0; j<Y; j++){
				ventana.add(matrizIP[i][j]);
				matrizIP[i][j].setBounds(i*50+30, j*50+30, 50, 50);
			}

		JPanel jpBotones = new JPanel();

		JButton JBIzquierda = new JButton("<");
		jpBotones.add(JBIzquierda);

		JButton JBArriba = new JButton("^");
		jpBotones.add(JBArriba);

		JButton JBAbajo = new JButton("Abajo");
		jpBotones.add(JBAbajo);
		
		JButton JBDerecha = new JButton(">");
		jpBotones.add(JBDerecha);
		

		JBAbajo.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				mover(0, 1);
			}
		});
		JBArriba.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				mover(0, -1);
			}
		});

		JBDerecha.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				mover(1, 0);
			}
		});

		JBIzquierda.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				mover(-1, 0);
			}
		});

		jpBotones.setBounds(50*X+50, 20, 100, 100);
		ventana.add(jpBotones);
	}

	boolean mover(int iMovX, int iMovY){
		//TODO comprobar bordes

		if(jugadorX + iMovX >= 0 && jugadorX + iMovX < rejillaX && jugadorY + iMovY >= 0 && jugadorY + iMovY < rejillaY){
			ventana.remove(matrizIP[jugadorX][jugadorY]);
			matrizIP[jugadorX][jugadorY] = new ImagePanel(matriz[jugadorX][jugadorY]);
			ventana.add(matrizIP[jugadorX][jugadorY]);
			matrizIP[jugadorX][jugadorY].setBounds(jugadorX*50+30, jugadorY*50+30, 50, 50);
	
			jugadorX += iMovX;
			jugadorY += iMovY;

			ventana.remove(matrizIP[jugadorX][jugadorY]);
			matrizIP[jugadorX][jugadorY] = new ImagePanel(matriz[jugadorX][jugadorY] - 4);
			ventana.add(matrizIP[jugadorX][jugadorY]);
			matrizIP[jugadorX][jugadorY].setBounds(jugadorX*50+30, jugadorY*50+30, 50, 50);
		}
		else
			return false;

		return true;
	}
}
