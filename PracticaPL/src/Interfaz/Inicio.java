package Interfaz;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
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
	//int matriz[][];
	ImagePanel matrizIP[][];
	int rejillaX, rejillaY;

	public static void main(String args[]) {
		Runnable rAux = new Runnable() {
			public void run() {
				try {
					Inicio window = new Inicio(10, 10);
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
		this.rejillaX = X;
		this.rejillaY = Y;

		jugador = new Jugador(0,0);
		
		matrizIP = new ImagePanel[X][Y];
		
		//inicializacion del tablero
		for(i=0; i<X; i++)
			for(j=0; j<Y; j++)
				matrizIP[i][j] = new ImagePanel(8,4);
		matrizIP[0][0] = new ImagePanel(0,4);
		matrizIP[0][1]=new ImagePanel(8,5);
		
		//creacion de la ventana
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

		JLabel lblControles=new JLabel("Controles");
		jpBotones.add(lblControles);
		JButton JBArriba = new JButton("Arriba");
		jpBotones.add(JBArriba);
		
		JButton JBIzquierda = new JButton("<");
		jpBotones.add(JBIzquierda);
		
		JButton JBDerecha = new JButton(">");
		jpBotones.add(JBDerecha);

		JButton JBAbajo = new JButton("Abajo");
		jpBotones.add(JBAbajo);
		

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

		jpBotones.setBounds(50*X+100, 20, 100, 150);
		ventana.add(jpBotones);
	}

	boolean mover(int iMovX, int iMovY){

		ImagePanel aux=matrizIP[jugador.getX()][jugador.getY()];
		if(jugador.getX() + iMovX >= 0 && jugador.getX() + iMovX < rejillaX && jugador.getY() + iMovY >= 0 && jugador.getY() + iMovY < rejillaY){
			//quito al jugador de la casilla donde estaba
			aux.cambiarImagen(aux.getiValor());
			
			jugador.setX(jugador.getX()+iMovX);
			jugador.setY(jugador.getY()+iMovY);
			aux=matrizIP[jugador.getX()][jugador.getY()];
			
			//pongo al jugador en la nueva casilla
			aux.cambiarImagen(aux.getiValor()-4);
		}
		else
			return false;

		return true;
	}
}
