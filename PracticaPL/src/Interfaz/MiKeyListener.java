package Interfaz;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class MiKeyListener implements KeyListener {

	Inicio interfaz;
	Tecla tecla;
	MiKeyListener(Tecla t){
		tecla=t;
	}
		@Override
		public void keyTyped(KeyEvent e) {
		}

		@Override
		public void keyPressed(KeyEvent e) {
			tecla.pulsacion(e.getKeyCode());

		}

		@Override
		public void keyReleased(KeyEvent e) {
		}
		
	}
