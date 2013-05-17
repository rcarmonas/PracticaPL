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

	public static int ARRIBA = 38;
	public static int ABAJO = 40;
	public static int DERECHA = 39;
	public static int IZQUIERDA = 37;

	int teclaPulsada;
	Inicio interfaz;
	KeyListener listener;
	
	public Tecla(Inicio j){
		interfaz=j;
	}
	/**
	 * Se bloquea a la espera de una pulsación
	 * @return Devuelve la primera tecla pulsada
	 */
	synchronized public int get()
	{
		listener = new MiKeyListener(this);
		interfaz.jtEntrada.addKeyListener(listener);
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
	synchronized public void pulsacion(int tecla)
	{
		this.teclaPulsada = tecla;
		interfaz.jtEntrada.removeKeyListener(listener);
		this.notify();
	}

}
