package Interfaz;

import java.awt.event.KeyListener;

/**
 * Tecla para manejar las pulsaciones de las flechas de dirección
 * @author Rafael Carmona Sánchez
 * @author Antonio Cubero Fernández
 * @author José Manuel Herruzo Ruiz
 *
 */
public class Tecla {

	static int ARRIBA = 38;
	static int ABAJO = 40;
	static int DERECHA = 39;
	static int IZQUIERDA = 37;

	int teclaPulsada;
	Inicio interfaz;
	KeyListener listener;
	
	Tecla(Inicio j){
		interfaz=j;
	}
	/**
	 * Se bloquea a la espera de una pulsación
	 * @return Devuelve la primera tecla pulsada
	 */
	int get()
	{
		listener = new MiKeyListener(this);
		interfaz.jtConsola.addKeyListener(listener);
		try {
			wait();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return this.teclaPulsada;
	}
	
	/**
	 * Establece una pulsación
	 * @param tecla Tecla pulsada
	 */
	void pulsacion(int tecla)
	{
		this.teclaPulsada = tecla;
		interfaz.jtConsola.removeKeyListener(listener);
		this.notify();
	}

}
