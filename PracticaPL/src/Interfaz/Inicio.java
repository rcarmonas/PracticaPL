package Interfaz;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;

public class Inicio {
	static int olor = 0;
	static int viento = 1;
	static int flecha = 2;
	static int ambrosia = 3;
	static int tesoro = 4;
	static int pozo = 5;
	static int wumpus = 6;
	static int jugador = 7;
	static int desconocido = 8;

	public JFrame ventana;
	public Jugador jJugador;
	ImagePanel matrizIP[][];
	int rejillaX, rejillaY;
	JLabel lblVidas;
	JLabel lblFlechas;
	public JTextField jtEntrada;
	public JTextArea jtConsola;

	public Inicio(int sizeX, int sizeY, int playerX, int playerY, int lives, int arrows){
		int i, j;
		this.rejillaX = sizeX;
		this.rejillaY = sizeY;

		jJugador = new Jugador(playerX, playerY, lives, arrows);

		matrizIP = new ImagePanel[sizeX][sizeY];

		//inicializacion del tablero
		for(i=0; i<sizeX; i++)
			for(j=0; j<sizeY; j++)
				matrizIP[i][j] = new ImagePanel();

		matrizIP[playerX][playerY].changeParameter(jugador, true);
		matrizIP[playerX][playerY].changeParameter(desconocido, false);
		
		//creacion de la ventana
		ventana = new JFrame();
		ventana.setTitle("Mundo Wumpus");
		if(sizeY*50+80<450)
			ventana.setBounds(100, 100, sizeX*50+300, 450);
		else
			ventana.setBounds(100, 100, sizeX*50+300, sizeY*50+80);
		ventana.setResizable(false);
		ventana.setLayout(null);
		ventana.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		for(i=0; i<sizeX; i++)
			for(j=0; j<sizeY; j++){
				ventana.add(matrizIP[i][j]);
				matrizIP[i][j].setBounds(i*50+30, j*50+30, 50, 50);
			}

		/**
		 * Panel de estado
		 */
		JPanel jpEstado = new JPanel();
		JLabel lblEstado = new JLabel("Estado");
		jpEstado.add(lblEstado);

		lblVidas = new JLabel("Vidas: " + jJugador.getVidas());
		jpEstado.add(lblVidas);

		lblFlechas = new JLabel("Flechas: " + jJugador.getFlechas());
		jpEstado.add(lblFlechas);

		jpEstado.setBounds(50*sizeX+100, getAlturaMenos(95), 100, 60);
		ventana.add(jpEstado);
		
		/**
		 * Panel de controles
		 */
		JPanel jpBotones = new JPanel();

		JLabel lblControles=new JLabel("Controles");
		jpBotones.add(lblControles);
		JButton JBArriba = new JButton("Arriba");
		jpBotones.add(JBArriba);
		JBArriba.setFocusable(false);
		
		JButton JBIzquierda = new JButton("<");
		jpBotones.add(JBIzquierda);
		JBIzquierda.setFocusable(false);
		
		JButton JBDerecha = new JButton(">");
		jpBotones.add(JBDerecha);
		JBDerecha.setFocusable(false);

		JButton JBAbajo = new JButton("Abajo");
		jpBotones.add(JBAbajo);
		JBAbajo.setFocusable(false);

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

		jpBotones.setBounds(50*sizeX+100, getAlturaMenos(80), 100, 120);
		ventana.add(jpBotones);
		
		/**
		 * Consola
		 */
		JLabel lblConsola=new JLabel("Consola");
		lblConsola.setBounds(50*sizeX+50, getAlturaMenos(45), 100, 20);
		ventana.add(lblConsola);

		jtConsola=new JTextArea();
		jtConsola.setEditable(false);
		jtConsola.setFocusable(false);
		jtConsola.getDocument().addDocumentListener(new DocumentListener() {
				@Override
				public void changedUpdate(DocumentEvent arg0) {
				}
				@Override
				public void insertUpdate(DocumentEvent arg0) {
					try{
						jtConsola.setCaretPosition(jtConsola.getLineStartOffset(jtConsola.getLineCount()-1));
					}catch(Exception ex){}
					
				}
				@Override
				public void removeUpdate(DocumentEvent arg0) {					
				}
		});
		JScrollPane jsScroll= new JScrollPane(jtConsola);
		jsScroll.setBounds(50*sizeX+50, getAlturaMenos(45)+25, 210, getAlturaMenos(75));
		ventana.add(jsScroll);
		
		jtEntrada=new JTextField();
		jtEntrada.setEditable(false);
		jtEntrada.setFocusable(false);
		jtEntrada.setBounds(50*sizeX+50, getAlturaMenos(45)+30+getAlturaMenos(75), 210, 20);
		ventana.add(jtEntrada);
		
		ventana.setVisible(true);
	}
	public int getAlturaMenos(int porcentaje)
	{
		return(ventana.getHeight()-porcentaje*ventana.getHeight()/100);
	}
	public boolean mover(int iMovX, int iMovY){

		return setPlayer(iMovX + jJugador.getX(), iMovY + jJugador.getY());
		
	}

	public void setHole(int x, int y){
		if(x>0 && x<rejillaX && y>0 && y<rejillaY)
		{
			if(x<rejillaX-1)
				matrizIP[x+1][y].changeParameter(viento, true);
			if(x>0)
				matrizIP[x-1][y].changeParameter(viento, true);
			if(y<rejillaY-1)
				matrizIP[x][y+1].changeParameter(viento, true);
			if(y>0)
				matrizIP[x][y-1].changeParameter(viento, true);
	
			matrizIP[x][y].changeParameter(pozo, true);
		}
	}

	public void setWumpus(int x, int y){
		
		if(x>0 && x<rejillaX && y>0 && y<rejillaY)
		{
			if(x<rejillaX-1)
				matrizIP[x+1][y].changeParameter(olor, true);
			if(x>0)
				matrizIP[x-1][y].changeParameter(olor, true);
			if(y<rejillaY-1)
				matrizIP[x][y+1].changeParameter(olor, true);
			if(y>0)
				matrizIP[x][y-1].changeParameter(olor, true);
	
			matrizIP[x][y].changeParameter(wumpus, true);
		}
	}

	public void eraseWumpus(int x, int y){
		
		if(x>0 && x<rejillaX && y>0 && y<rejillaY)
		{
			if(x<rejillaX-1)
				matrizIP[x+1][y].changeParameter(olor, false);
			if(x>0)
				matrizIP[x-1][y].changeParameter(olor, false);
			if(y<rejillaY-1)
				matrizIP[x][y+1].changeParameter(olor, false);
			if(y>0)
				matrizIP[x][y-1].changeParameter(olor, false);
	
			matrizIP[x][y].changeParameter(wumpus, false);
		}
	}

	public void setArrow(int x, int y){
		if(x>0 && x<rejillaX && y>0 && y<rejillaY)
			matrizIP[x][y].changeParameter(flecha, true);
	}

	public void setTreasure(int x, int y){
		if(x>0 && x<rejillaX && y>0 && y<rejillaY)
			matrizIP[x][y].changeParameter(tesoro, true);
	}

	public void setAmbrosia(int x, int y){
		if(x>0 && x<rejillaX && y>0 && y<rejillaY)
			matrizIP[x][y].changeParameter(ambrosia, true);
	}
	
	public boolean setPlayer(int x, int y){
		
		ImagePanel ipAux = matrizIP[jJugador.getX()][jJugador.getY()];

		if(x >= 0 && x < rejillaX && y >= 0 && y < rejillaY){
			//Quita al jugador de la casilla donde estaba
			ipAux.cambiarImagen(false);

			//Mover
			jJugador.setX(x);
			jJugador.setY(y);
			
			ipAux = matrizIP[jJugador.getX()][jJugador.getY()];
			if(ipAux.bVector[flecha])
			{
				jJugador.setFlechas(jJugador.getFlechas() + 1);
				this.lblFlechas.setText("Flechas: " + jJugador.getFlechas());
			}
			if(ipAux.bVector[ambrosia])
			{
				jJugador.setVidas(jJugador.getVidas() + 1);
				this.lblVidas.setText("Vidas: " + jJugador.getVidas());
			}
			if(ipAux.bVector[tesoro])
			{
				if(jJugador.getVidas() != 0){
					jJugador.setVidas(jJugador.getVidas() - 1);
					this.lblVidas.setText("Vidas: " + jJugador.getVidas());
				}
				else
					this.lblVidas.setText("Vidas: Muerto");
			}
			
			//Pone al jugador en la nueva casilla
			ipAux.cambiarImagen(true);
		}
		else
			return false;

		return true;
	}
	
	/**
	 * Devuelve la información sobre una casilla codificada en un entero
	 * @param x Coordenada X
	 * @param y Coordenada Y
	 * @return Información sobre la casilla
	 */
	public int getInfoCasilla(int x, int y)
	{
		int aux=0;
		for(int i=0; i<9; i++)
			if(matrizIP[x][y].bVector[i])
				aux+=Math.pow(2, i);
		return aux;
	}
}
