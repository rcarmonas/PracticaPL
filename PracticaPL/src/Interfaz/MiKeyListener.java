package Interfaz;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class MiKeyListener implements KeyListener {

	Inicio interfaz;
	MiKeyListener(Inicio i){
		interfaz=i;
	}
		@Override
		public void keyTyped(KeyEvent e) {
		}

		@Override
		public void keyPressed(KeyEvent e) {
			switch(e.getKeyCode())
			{
				case 38://arriba
					interfaz.mover(0, -1);
				break;
				case 40://abajo
					interfaz.mover(0, 1);
				break;
				case 37://izquierda
					interfaz.mover(-1, 0);
				break;
				case 39://derecha
					interfaz.mover(1, 0);
				break;
			}
		}

		@Override
		public void keyReleased(KeyEvent e) {
		}
	}
