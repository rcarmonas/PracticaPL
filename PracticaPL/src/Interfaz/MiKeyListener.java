package Interfaz;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class MiKeyListener implements KeyListener {

	Tecla tecla;
	boolean direccion;
	
	MiKeyListener(Tecla t,boolean d){
		tecla=t;
		direccion=d;
	}
		@Override
		public void keyTyped(KeyEvent e) {
		}

		@Override
		public void keyPressed(KeyEvent e) {
			if(direccion){//si es el keylistener de leer teclas de dirección
				tecla.pulsacion(e.getKeyCode());
			}
			else//si es el keylistener de la entrada de texto
			{
				if(e.getKeyCode()==10)//si es el intro
				{
					tecla.pulsacion(tecla.interfaz.jtEntrada.getText());
				}
			}
		}

		@Override
		public void keyReleased(KeyEvent e) {
		}
		
	}
