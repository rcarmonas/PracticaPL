package Interfaz;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;

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

public class Inicio {
	static int olor = 0;
	static int viento = 1;
	static int flecha = 2;
	static int jugador = 3;
	static int ambrosia = 4;
	static int tesoro = 5;
	static int desconocido = 6;

	public JFrame ventana;
	Jugador jJugador;
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

		jJugador = new Jugador(0,0);
		
		matrizIP = new ImagePanel[X][Y];
		
		//inicializacion del tablero
		for(i=0; i<X; i++)
			for(j=0; j<Y; j++)
				matrizIP[i][j] = new ImagePanel();
		

		matrizIP[0][0] = new ImagePanel(new boolean[]{false, false, false, false, false, false, false, true, false});

		//TODO borrar desde aquí
		matrizIP[0][1] = new ImagePanel(new boolean[]{false, false, false, false, false, false, false, false, true});
		matrizIP[0][2] = new ImagePanel(new boolean[]{false, false, false, false, false, false, false, false, true});
		matrizIP[0][3] = new ImagePanel(new boolean[]{false, false, false, false, false, false, false, false, true});
		matrizIP[0][4] = new ImagePanel(new boolean[]{false, false, false, false, false, false, false, false, true});

		matrizIP[1][1] = new ImagePanel(new boolean[]{true, false, false, false, false, false, false, false, true});
		matrizIP[1][2] = new ImagePanel(new boolean[]{true, true, false, false, false, false, false, false, true});
		matrizIP[1][3] = new ImagePanel(new boolean[]{true, false, false, false, false, false, false, false, true});
		matrizIP[1][4] = new ImagePanel(new boolean[]{false, true, false, false, false, false, false, false, true});

		matrizIP[2][1] = new ImagePanel(new boolean[]{false, true, false, false, false, false, false, false, true});
		matrizIP[2][2] = new ImagePanel(new boolean[]{false, true, false, false, false, false, false, false, true});
		matrizIP[2][3] = new ImagePanel(new boolean[]{false, true, false, false, false, false, false, false, true});
		matrizIP[2][4] = new ImagePanel(new boolean[]{false, true, false, false, false, false, false, false, true});

		matrizIP[3][1] = new ImagePanel(new boolean[]{true, true, false, false, false, false, false, false, true});
		matrizIP[3][2] = new ImagePanel(new boolean[]{true, true, false, false, false, false, false, false, true});
		matrizIP[3][3] = new ImagePanel(new boolean[]{true, true, false, false, false, false, false, false, true});
		matrizIP[3][4] = new ImagePanel(new boolean[]{true, true, false, false, false, false, false, false, true});

		matrizIP[4][1] = new ImagePanel(new boolean[]{false, false, true, false, false, false, false, false, true});
		matrizIP[4][2] = new ImagePanel(new boolean[]{false, false, true, false, false, false, false, false, true});
		matrizIP[4][3] = new ImagePanel(new boolean[]{false, false, true, false, false, false, false, false, true});
		matrizIP[4][4] = new ImagePanel(new boolean[]{false, false, true, false, false, false, false, false, true});

		matrizIP[5][1] = new ImagePanel(new boolean[]{false, false, false, true, false, false, false, false, true});
		matrizIP[5][2] = new ImagePanel(new boolean[]{false, false, false, true, false, false, false, false, true});
		matrizIP[5][3] = new ImagePanel(new boolean[]{false, false, false, true, false, false, false, false, true});
		matrizIP[5][4] = new ImagePanel(new boolean[]{false, false, false, true, false, false, false, false, true});

		matrizIP[6][1] = new ImagePanel(new boolean[]{false, false, false, false, true, false, false, false, true});
		matrizIP[6][2] = new ImagePanel(new boolean[]{false, false, false, false, true, false, false, false, true});
		matrizIP[6][3] = new ImagePanel(new boolean[]{false, false, false, false, true, false, false, false, true});
		matrizIP[6][4] = new ImagePanel(new boolean[]{false, false, false, false, true, false, false, false, true});

		matrizIP[7][1] = new ImagePanel(new boolean[]{false, false, false, false, false, true, false, false, true});
		matrizIP[7][2] = new ImagePanel(new boolean[]{false, false, false, false, false, true, false, false, true});
		matrizIP[7][3] = new ImagePanel(new boolean[]{false, false, false, false, false, true, false, false, true});
		matrizIP[7][4] = new ImagePanel(new boolean[]{false, false, false, false, false, true, false, false, true});

		matrizIP[8][1] = new ImagePanel(new boolean[]{false, false, false, false, false, false, true, false, true});
		matrizIP[8][2] = new ImagePanel(new boolean[]{false, false, false, false, false, false, true, false, true});
		matrizIP[8][3] = new ImagePanel(new boolean[]{false, false, false, false, false, false, true, false, true});
		matrizIP[8][4] = new ImagePanel(new boolean[]{false, false, false, false, false, false, true, false, true});
		//TODO borrar hasta aquí
		
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

		jpBotones.setBounds(50*X+100, 150, 100, 150);
		ventana.add(jpBotones);
		
		JPanel jpEstado = new JPanel();
		JLabel lblEstado = new JLabel("Estado");
		jpEstado.add(lblEstado);

		JLabel lblVidas = new JLabel("Vidas: " + jJugador.getVidas());
		jpEstado.add(lblVidas);

		JLabel lblFlechas = new JLabel("Flechas: " + jJugador.getFlechas());
		jpEstado.add(lblFlechas);

		jpEstado.setBounds(50*X+100, 20, 100, 150);
		ventana.add(jpEstado);
		
		JLabel lblConsola=new JLabel("Consola");
		lblConsola.setBounds(50*X+50, 300, 200, 50);
		ventana.add(lblConsola);
		
		JTextArea jtConsola=new JTextArea();
		jtConsola.setBounds(50*X+50, 350, 210, 170);
		ventana.add(jtConsola);
		
		KeyListener listener = new MiKeyListener(this);
		jtConsola.addKeyListener(listener);
	}

	boolean mover(int iMovX, int iMovY){

		ImagePanel ipAux = matrizIP[jJugador.getX()][jJugador.getY()];

		if(jJugador.getX() + iMovX >= 0 && jJugador.getX() + iMovX < rejillaX && jJugador.getY() + iMovY >= 0 && jJugador.getY() + iMovY < rejillaY){
			//Quita al jugador de la casilla donde estaba
			ipAux.cambiarImagen(false);

			//Mover
			jJugador.setX(jJugador.getX() + iMovX);
			jJugador.setY(jJugador.getY() + iMovY);

			ipAux = matrizIP[jJugador.getX()][jJugador.getY()];

			//Pone al jugador en la nueva casilla
			ipAux.cambiarImagen(true);
		}
		else
			return false;

		return true;
	}
}
