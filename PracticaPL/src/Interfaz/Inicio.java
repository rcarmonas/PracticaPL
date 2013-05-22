package Interfaz;

import java.awt.Image;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;

public class Inicio {
	public static int olor = 0;
	public static int viento = 1;
	public static int flecha = 2;
	public static int ambrosia = 3;
	public static int tesoro = 4;
	public static int pozo = 5;
	public static int wumpus = 6;
	public static int mina = 7;
	public static int puerta = 8;
	public static int jugador = 9;
	public static int desconocido = 10;

	public boolean colisiones[] = {false, false, true, true, true, true, false, true, true, false, false};
	public JFrame ventana;
	public Jugador jJugador;
	public Wumpus jWumpus=null;
	ImagePanel matrizIP[][];
	public int rejillaX, rejillaY;
	JLabel lblVidas;
	JLabel lblFlechas;
	JLabel lblTesoro;
	public JTextField jtEntrada;
	public JTextArea jtConsola;
	public boolean resultado = false;
	public JButton JBArriba, JBAbajo, JBIzquierda, JBDerecha;
	public boolean tengoTesoro = false;

/*	public static void main(String[] args){
		Inicio i = new Inicio(10, 10, 0, 0, 3, 2);
		i.setWumpus(5, 5);
		i.tiraFlecha(Tecla.DERECHA);
	}*/

/**
 * Constructor
 * @param sizeX Tamaño X del tablero
 * @param sizeY Tamaño Y del tablero
 * @param playerX Coordenada x inicial
 * @param playerY Coordenada y inicial
 * @param lives Numero de vidas inicial
 * @param arrows Numero de flechas inicial
 */
	public Inicio(int sizeX, int sizeY, int playerX, int playerY, int lives, int arrows){
		int i, j;
		this.rejillaX = sizeX;
		this.rejillaY = sizeY;

		jJugador = new Jugador(playerX, playerY, lives, arrows);
		matrizIP = new ImagePanel[sizeX][sizeY];

		//inicializacion del tablero
		for(i=0; i<sizeX; i++)
			for(j=0; j<sizeY; j++)
				matrizIP[i][j] = new ImagePanel("Zelda");
		
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
		jpEstado.setLayout(null);
		JLabel lblEstado = new JLabel("Estado");
		lblEstado.setBounds(0,0,50,50);
		jpEstado.add(lblEstado);

		ImageIcon imgIcon = new ImageIcon("img/vida.png");
	    Image img = imgIcon.getImage();
	    img = img.getScaledInstance(20, 20,  java.awt.Image.SCALE_SMOOTH);  
	    imgIcon = new ImageIcon(img);  

		JLabel lblmVidas = new JLabel(imgIcon);
		lblmVidas.setBounds(20,20,50,50);
		jpEstado.add(lblmVidas);
		
		lblVidas = new JLabel(""+jJugador.getVidas());
	    lblVidas.setBounds(0, 20,50,50);
		jpEstado.add(lblVidas);

		imgIcon = new ImageIcon("img/flecha.png");
	    img = imgIcon.getImage();
	    img = img.getScaledInstance(20, 20,  java.awt.Image.SCALE_SMOOTH);  
	    imgIcon = new ImageIcon(img);

		JLabel lblmFlechas = new JLabel(imgIcon);
		lblmFlechas.setBounds(20,40,50,50);
		jpEstado.add(lblmFlechas);
		
		lblFlechas = new JLabel(""+jJugador.getFlechas());
		lblFlechas.setBounds(0,40,50,50);
		jpEstado.add(lblFlechas);

		imgIcon = new ImageIcon("img/tesoro.png");
	    img = imgIcon.getImage();
	    img = img.getScaledInstance(20, 20,  java.awt.Image.SCALE_SMOOTH);  
	    imgIcon = new ImageIcon(img);
		lblTesoro = new JLabel(imgIcon);
		lblTesoro.setBounds(0,60,50,50);
		lblTesoro.setVisible(false);
		jpEstado.add(lblTesoro);
	    
		jpEstado.setBounds(50*sizeX+100, getAlturaMenos(95), 100, 150);
		ventana.add(jpEstado);
		
		/**
		 * Panel de controles
		 */
		JPanel jpBotones = new JPanel();

		JLabel lblControles=new JLabel("Controles");
		jpBotones.add(lblControles);
		JBArriba = new JButton("Arriba");
		jpBotones.add(JBArriba);
		JBArriba.setFocusable(false);
		
		JBIzquierda = new JButton("<");
		jpBotones.add(JBIzquierda);
		JBIzquierda.setFocusable(false);
		
		JBDerecha = new JButton(">");
		jpBotones.add(JBDerecha);
		JBDerecha.setFocusable(false);

		JBAbajo = new JButton("Abajo");
		jpBotones.add(JBAbajo);
		JBAbajo.setFocusable(false);

		

		jpBotones.setBounds(50*sizeX+100, getAlturaMenos(70), 100, 120);
		ventana.add(jpBotones);
		
		/**
		 * Consola
		 */
		JLabel lblConsola=new JLabel("Consola");
		lblConsola.setBounds(50*sizeX+50, getAlturaMenos(45), 100, 20);
		ventana.add(lblConsola);

		jtConsola=new JTextArea();
		jtConsola.setLineWrap(true);
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
		//muestro al jugador
		matrizIP[playerX][playerY].initializeParameter(desconocido, false);
		matrizIP[playerX][playerY].initializeParameter(jugador, true);
	}
	public int getAlturaMenos(int porcentaje)
	{
		return(ventana.getHeight()-porcentaje*ventana.getHeight()/100);
	}
	
	/**
	 * Mueve el jugador
	 * @param iMovX Cantidad de casillas que se movera en horizontal
	 * @param iMovY Cantidad de casillas que se movera en vertical
	 * @return true en caso de exito y false en caso de error
	 */
	public boolean mover(int iMovX, int iMovY){

		resultado = setPlayer(iMovX + jJugador.getX(), iMovY + jJugador.getY());
		return resultado;
		
	}

	/**
	 * Coloca un pozo en el tablero
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void setHole(int x, int y){
		resultado = false;
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY)
		{
			boolean colision = false;
			for(int i=0; i<11; i++)
			{ 
				if(colisiones[i]&&matrizIP[x][y].bVector[i])
					colision=true;
			}
			if(!colision)
			{
				resultado = true;
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
	}

	/**
	 * Cambia la localización del wumpus
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void setWumpus(int x, int y){
		resultado = false;
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY && !matrizIP[x][y].bVector[pozo] 
					&& !matrizIP[x][y].bVector[puerta]
					&& !matrizIP[x][y].bVector[jugador])
		{
			matrizIP[x][y].changeParameter(flecha, false);
			if(matrizIP[x][y].bVector[ambrosia])
			{
				matrizIP[x][y].changeParameter(flecha, false);	
				jWumpus.setVidas(jWumpus.getVidas()+1);
			}

			if(jWumpus==null)
				jWumpus= new Wumpus(x,y);
			else
			{
				eraseWumpus(jWumpus.getX(),jWumpus.getY());
				jWumpus.setX(x);
				jWumpus.setY(y);
			}
			
			if(x<rejillaX-1)
				matrizIP[x+1][y].changeParameter(olor, true);
			if(x>0)
				matrizIP[x-1][y].changeParameter(olor, true);
			if(y<rejillaY-1)
				matrizIP[x][y+1].changeParameter(olor, true);
			if(y>0)
				matrizIP[x][y-1].changeParameter(olor, true);
	
			matrizIP[x][y].changeParameter(wumpus, true);
			resultado = true;

		}
	}

	/**
	 * Borra el wumpus y su olor del tablero
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void eraseWumpus(int x, int y){
		
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY)
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

	/**
	 * Tira una flecha
	 */
	public void tiraFlecha(int direccion){
		int iAuxX = 0, iAuxY = 0;
		this.resultado = false;

		iAuxX = jJugador.x;
		iAuxY = jJugador.y;

		if(jJugador.getFlechas() > 0){
			jJugador.setFlechas(jJugador.getFlechas() - 1);

			while(iAuxX < this.rejillaX && iAuxX >= 0 && iAuxY < this.rejillaY && iAuxY >= 0){
				matrizIP[iAuxX][iAuxY].changeParameter(flecha, true);
	
				try {Thread.sleep(150);} catch (InterruptedException e){e.printStackTrace();}
	
				matrizIP[iAuxX][iAuxY].changeParameter(flecha, false);
	
				if(iAuxX == jWumpus.getX() && iAuxY == jWumpus.getY()){
					this.resultado = true;
					
					if(jWumpus.getVidas() > 0)
						jWumpus.setVidas(jWumpus.getVidas() - 1);
	
					if(jWumpus.getVidas() == 0)
						matrizIP[iAuxX][iAuxY].changeParameter(wumpus, false);
					break;
				}
	
				if(direccion == Tecla.DERECHA)
					iAuxX++;
	
				if(direccion == Tecla.IZQUIERDA)
					iAuxX--;
	
				if(direccion == Tecla.ABAJO)
					iAuxY++;
	
				if(direccion == Tecla.ARRIBA)
					iAuxY--;
			}
		}
	}

	/**
	 * Coloca una flecha en el tablero
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void setArrow(int x, int y){
		resultado = false;
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY)
		{
			boolean colision = false;
			for(int i=0; i<11; i++)
			{
				if(colisiones[i]&&matrizIP[x][y].bVector[i])
					colision=true;
			}
			if(!colision)
			{
				matrizIP[x][y].changeParameter(flecha, true);
				resultado = true;
			}
		}
	}

	/**
	 * Coloca un tesoro en el tablero
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void setTreasure(int x, int y){
		resultado = false;
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY)
		{
			boolean colision = false;
			for(int i=0; i<11; i++)
			{
				if(colisiones[i]&&matrizIP[x][y].bVector[i])
					colision=true;
			}
			if(!colision)
			{
				matrizIP[x][y].changeParameter(tesoro, true);
				resultado = true;
			}
		}
	}

	/**
	 * Coloca una ambrosía en el tablero
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void setAmbrosia(int x, int y){
		resultado = false;
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY)
		{
			boolean colision = false;
			for(int i=0; i<11; i++)
			{
				if(colisiones[i]&&matrizIP[x][y].bVector[i])
					colision=true;
			}
			if(!colision)
			{
				matrizIP[x][y].changeParameter(ambrosia, true);
				resultado = true;
			}
		}		
	}

	/**
	 * Coloca la salida en el tablero
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void setPuerta(int x, int y){
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY)
		{
			matrizIP[x][y].changeParameter(puerta, true);
			resultado = true;
		}else
			resultado = false;
	}

	/**
	 * Coloca una mina en el tablero
	 * @param x Coordenada x
	 * @param y Coordenada y
	 */
	public void setMina(int x, int y){
		resultado = false;
		if(x>=0 && x<rejillaX && y>=0 && y<rejillaY)
		{
			boolean colision = false;
			for(int i=0; i<11; i++)
			{
				if(colisiones[i]&&matrizIP[x][y].bVector[i])
					colision=true;
			}
			if(!colision)
			{
				matrizIP[x][y].changeParameter(mina, true);
				resultado = true;
			}
		}
	}
	
	/**
	 * Colocar el jugador en un lugar determinado
	 * @param x Coordenada x
	 * @param y Coordenada y
	 * @return true en caso de exito y false en caso de error
	 */
	public boolean setPlayer(int x, int y){
		
		ImagePanel ipAux = matrizIP[jJugador.getX()][jJugador.getY()];

		if(x >= 0 && x < rejillaX && y >= 0 && y < rejillaY){
			//Quita al jugador de la casilla donde estaba
			ipAux.cambiarImagen(false);

			//Mover
			jJugador.setX(x);
			jJugador.setY(y);
			
			ipAux = matrizIP[jJugador.getX()][jJugador.getY()];
			if(ipAux.bVector[mina])
			{
				jJugador.setVidas(jJugador.getVidas() - 1);
				this.lblVidas.setText(jJugador.getVidas()+"");
			}
			if(ipAux.bVector[flecha])
			{
				jJugador.setFlechas(jJugador.getFlechas() + 1);
				this.lblFlechas.setText(jJugador.getFlechas()+"");
			}
			if(ipAux.bVector[ambrosia])
			{
				jJugador.setVidas(jJugador.getVidas() + 1);
				this.lblVidas.setText("" + jJugador.getVidas());
			}
			if(ipAux.bVector[tesoro])
			{
				this.tengoTesoro = true;
				this.lblTesoro.setVisible(true);
			}
			if(ipAux.bVector[wumpus])
			{
				jJugador.setVidas(jJugador.getVidas() - 1);
				this.lblVidas.setText("" + jJugador.getVidas());
			}
			if(ipAux.bVector[pozo])
			{
				jJugador.setVidas(jJugador.getVidas() - 1);
					this.lblVidas.setText(""+ jJugador.getVidas());
			}
			
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
	/**
	 * Mueve el wumpus
	 * @param iMovX Cantidad de casillas que se movera en horizontal
	 * @param iMovY Cantidad de casillas que se movera en vertical
	 */
	public void moverWumpus(int iMovX, int iMovY){
		setWumpus(iMovX + jWumpus.getX(), iMovY + jWumpus.getY());
		
	}
	/**
	 * Muestra un mensaje en una ventana de diálogo
	 * @param mensaje Mensaje a mostrar
	 */
	public void mostrarMensaje(String mensaje){
		JOptionPane.showMessageDialog(ventana,mensaje);
	}
	
	/**
	 * Muestra una pregunta al usuario con opciones si y no	
	 * @param mensaje Mensaje que se mostrara
	 * @return Opcion elegida
	 */
	public int mostrarPregunta(String mensaje){
		return JOptionPane.showConfirmDialog(ventana,mensaje);
	}
	/**
	 * Cierra la ventana actual
	 */
	public void salir()
	{
		ventana.setVisible(false);
	}
}
