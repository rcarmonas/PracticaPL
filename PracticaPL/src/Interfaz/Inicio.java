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
	public Wumpus jWumpus = null;
	ImagePanel matrizIP[][];
	public int rejillaX, rejillaY, tesoroX, tesoroY;
	JLabel lblVidas;
	JLabel lblFlechas;
	JLabel lblTesoro;
	JLabel lblWumpus;
	public JTextField jtEntrada;
	public JTextArea jtConsola;
	public boolean resultado = false;
	public JButton JBArriba, JBAbajo, JBIzquierda, JBDerecha,jBDisparar;
	public boolean tengoTesoro = false;
	public int lastX, lastY;
	

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
 * @param xWumpus Coordenada X wumpus
 * @param yWumpus Coordenada Y Wumpus
 * @param vidasWumpus Número de vidas del Wumpus
 * @param mod Mod del juego
 */
	public Inicio(int sizeX, int sizeY, int playerX, int playerY, int lives, int arrows, int xWumpus, int yWumpus, int vidasWumpus, String mod){
		int i, j;
		this.rejillaX = sizeX;
		this.rejillaY = sizeY;

		jJugador = new Jugador(playerX, playerY, lives, arrows);
		matrizIP = new ImagePanel[sizeX][sizeY];
		jWumpus = new Wumpus(xWumpus, yWumpus, vidasWumpus);

		//inicializacion del tablero
		for(i=0; i<sizeX; i++)
			for(j=0; j<sizeY; j++)
				matrizIP[i][j] = new ImagePanel(mod);
		matrizIP[jJugador.getX()][jJugador.getY()].initializeParameter(desconocido, false);
		matrizIP[jJugador.getX()][jJugador.getY()].initializeParameter(jugador, true);
		//creacion de la ventana
		ventana = new JFrame();
		ventana.setTitle("Mundo Wumpus");
		if(sizeY*50+80<500)
			ventana.setSize(sizeX*50+400, 500);
		else
			ventana.setSize(sizeX*50+400, sizeY*50+80);

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

		ImageIcon imgIcon = new ImageIcon("img/Iconos/vida.png");
	    Image img = imgIcon.getImage();
	    img = img.getScaledInstance(20, 20,  java.awt.Image.SCALE_SMOOTH);  
	    imgIcon = new ImageIcon(img);  

		JLabel lblmVidas = new JLabel(imgIcon);
		lblmVidas.setBounds(20,20,50,50);
		jpEstado.add(lblmVidas);
		
		lblVidas = new JLabel(""+jJugador.getVidas());
	    lblVidas.setBounds(0, 20,50,50);
		jpEstado.add(lblVidas);

		imgIcon = new ImageIcon("img/Iconos/flecha.png");
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
	    img = img.getScaledInstance(30, 30,  java.awt.Image.SCALE_SMOOTH);  
	    imgIcon = new ImageIcon(img);
		lblTesoro = new JLabel(imgIcon);
		lblTesoro.setBounds(0,80,30,30);
		lblTesoro.setVisible(false);
		jpEstado.add(lblTesoro);
		
		imgIcon = new ImageIcon("img/Iconos/Wumpus_muerto.png");
	    img = imgIcon.getImage();
	    img = img.getScaledInstance(30, 30,  java.awt.Image.SCALE_SMOOTH);  
	    imgIcon = new ImageIcon(img);
		lblWumpus = new JLabel(imgIcon);
		lblWumpus.setBounds(40,80,30,30);
		lblWumpus.setVisible(false);
		jpEstado.add(lblWumpus);
	    
		jpEstado.setBounds(50*sizeX+180, getAlturaMenos(99), 100, 120);
		ventana.add(jpEstado);
		
		/**
		 * Panel de controles
		 */
		JPanel jpBotones = new JPanel();
		jpBotones.setLayout(null);
		JLabel lblControles=new JLabel("Controles");
		jpBotones.add(lblControles);
		lblControles.setBounds(20, 0, 100, 20);

		JBArriba=crearBoton("img/Iconos/Arriba.png","img/Iconos/Arribas.png",30,40);
		jpBotones.add(JBArriba);
		JBArriba.setBounds(40, 20, 30, 40);
		
		JBIzquierda = crearBoton("img/Iconos/Izquierda.png","img/Iconos/Izquierdas.png",40,30);
		jpBotones.add(JBIzquierda);
		JBIzquierda.setBounds(0,60,40,30);
		
		JBDerecha = crearBoton("img/Iconos/Derecha.png","img/Iconos/Derechas.png",40,30);
		jpBotones.add(JBDerecha);
		JBDerecha.setBounds(70,60,40, 30);
		
		JBAbajo = crearBoton("img/Iconos/Abajo.png","img/Iconos/Abajos.png",30,40);
		jpBotones.add(JBAbajo);
		JBAbajo.setBounds(40,90,30,40);
		
		jBDisparar = crearBoton("img/Iconos/Disparar.png","img/Iconos/Disparars.png",30,30);
		jpBotones.add(jBDisparar);
		jBDisparar.setBounds(41,59,30,30);
		
		jpBotones.setBounds(50*sizeX+150, getAlturaMenos(73), 150, 150);
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
		jtConsola.getCaret().setVisible(true);
		
		jtConsola.getDocument().addDocumentListener(new DocumentListener() {
				@Override
				public void changedUpdate(DocumentEvent arg0) {
				}
				@Override
				public void insertUpdate(DocumentEvent arg0) {
					try{
						//jtConsola.setCaretPosition(jtConsola.getLineStartOffset(jtConsola.getLineCount()-1));
					}catch(Exception ex){}
					
				}
				@Override
				public void removeUpdate(DocumentEvent arg0) {					
				}
		});
		JScrollPane jsScroll= new JScrollPane(jtConsola);
		jsScroll.setBounds(50*sizeX+50, getAlturaMenos(45)+25, 330, getAlturaMenos(75));
		ventana.add(jsScroll);
		
		jtEntrada=new JTextField();
		jtEntrada.setEditable(false);
		jtEntrada.setFocusable(false);
		jtEntrada.setBounds(50*sizeX+50, getAlturaMenos(45)+30+getAlturaMenos(75), 330, 20);
		ventana.add(jtEntrada);
	}
	public JButton crearBoton(String icono1,String icono2,int x,int y)
	{
		ImageIcon imgIcon = new ImageIcon(icono1);
	    Image img = imgIcon.getImage();
	    img = img.getScaledInstance(x, y,  java.awt.Image.SCALE_SMOOTH);  
	    imgIcon = new ImageIcon(img);
	    
		JButton JB = new JButton(imgIcon);
		JB.setOpaque(false);
		JB.setContentAreaFilled(false);
		JB.setBorderPainted(false);
		
		JB.setFocusable(false);
		imgIcon = new ImageIcon(icono2);
	    img = imgIcon.getImage();
	    img = img.getScaledInstance(x, y,  java.awt.Image.SCALE_SMOOTH);
	    imgIcon = new ImageIcon(img);
		JB.setRolloverIcon(imgIcon);
		return JB;
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

		resultado = setPlayer(iMovX + jJugador.getX(), iMovY + jJugador.getY(), false);
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
					&& !matrizIP[x][y].bVector[jugador]
					&& jWumpus.getVidas() > 0)
		{
			matrizIP[x][y].changeParameter(flecha, false);
			if(matrizIP[x][y].bVector[ambrosia])
			{
				matrizIP[x][y].changeParameter(ambrosia, false);	
				jWumpus.setVidas(jWumpus.getVidas()+1);
			}


			eraseWumpus(jWumpus.getX(),jWumpus.getY());
			jWumpus.setX(x);
			jWumpus.setY(y);
			
			
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
			lblFlechas.setText(String.valueOf(jJugador.getFlechas()));

			while(iAuxX < this.rejillaX && iAuxX >= 0 && iAuxY < this.rejillaY && iAuxY >= 0){
				matrizIP[iAuxX][iAuxY].changeParameter(flecha, true);
	
				try {Thread.sleep(150);} catch (InterruptedException e){e.printStackTrace();}
	
				matrizIP[iAuxX][iAuxY].changeParameter(flecha, false);
	
				if(iAuxX == jWumpus.getX() && iAuxY == jWumpus.getY()){
					this.resultado = true;
					
					if(jWumpus.getVidas() > 0)
						jWumpus.setVidas(jWumpus.getVidas() - 1);

					if(jWumpus.getVidas() == 0)
					{
						matrizIP[iAuxX][iAuxY].changeParameter(wumpus, false);
						jWumpus.setX(-1);
						lblWumpus.setVisible(true);
					}
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
		if(x == -1 && y == -1){
			x = tesoroX;
			y = tesoroY;
		}
		else{
			tesoroX = x;
			tesoroY = y;
		}
		
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
	public boolean setPlayer(int x, int y, boolean reinicio){
		
		ImagePanel ipAux = matrizIP[jJugador.getX()][jJugador.getY()];
		
		if(x >= 0 && x < rejillaX && y >= 0 && y < rejillaY){
			//Quita al jugador de la casilla donde estaba
			ipAux.cambiarImagen(false);

			//Mover
			jJugador.setX(x);
			jJugador.setY(y);
			
			if(!reinicio)
			{
				lastX = x;
				lastY = y;
			}

			ipAux = matrizIP[jJugador.getX()][jJugador.getY()];
			ipAux.cambiarImagen(true);
			
			if(ipAux.bVector[mina])
				muerto();

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
			if(jJugador.getX()==jWumpus.getX()&&jJugador.getY()==jWumpus.getY())
				muerto();

			if(ipAux.bVector[pozo])
				muerto();
			
		}
		else
			return false;

		return true;
	}
	
	/**
	 * Función llamada cuando el jugador pierde una vida
	 */
	void muerto(){
		//Quitar vida
		jJugador.setVidas(jJugador.getVidas() - 1);
		this.lblVidas.setText("" + jJugador.getVidas());

		//Mover a la casilla de salida
		setPlayer(jJugador.xIni, jJugador.yIni, true);

		//Quitar tesoro
		this.tengoTesoro = false;
		this.lblTesoro.setVisible(false);
		setTreasure(-1, -1);
		
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
	/**
	 * Cambia el cursor de la consola
	 * @param x posicion donde se pondra el cursor
	 */
	public void setCursor(int x)
	{
		jtConsola.setCaretPosition(x);
	}
}
