package Interfaz;
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
	
	/**
	 * Se bloquea a la espera de una pulsación
	 * @return Devuelve la primera tecla pulsada
	 */
	int get()
	{
		//TODO avisar a MiKeyListener de que escuche
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
		this.notify();
	}

}
