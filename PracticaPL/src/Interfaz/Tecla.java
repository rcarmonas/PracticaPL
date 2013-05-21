package Interfaz;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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
	public static int ESPACIO = 32;
	public static int ESCAPE = 27;


	int teclaPulsada;
	String texto;
	Inicio interfaz;
	KeyListener listener;
	ActionListener abajo, arriba, derecha, izquierda;

	
	public Tecla(Inicio j){
		interfaz=j;
	}
	/**
	 * Se bloquea a la espera de una pulsación
	 * @return Devuelve la primera tecla pulsada
	 */
	synchronized public int getTecla()
	{
		listener = new MiKeyListener(this,true);
		interfaz.ventana.addKeyListener(listener);
		prepararBotones();
		interfaz.ventana.requestFocusInWindow();
		try {
			wait();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return this.teclaPulsada;
	}
	
	synchronized public String getTexto()
	{
		listener = new MiKeyListener(this,false);
		interfaz.jtEntrada.addKeyListener(listener);
		interfaz.jtEntrada.setEditable(true);
		interfaz.jtEntrada.setFocusable(true);
		interfaz.jtEntrada.requestFocusInWindow();
		try {
			wait();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return texto;
	}
	
	/**
	 * Establece una pulsación
	 * @param tecla Tecla pulsada
	 */
	synchronized public void pulsacion(int tecla)
	{
		this.teclaPulsada = tecla;
		interfaz.ventana.removeKeyListener(listener);
		this.notify();
	}
	/**
	 * Notificación de pulsación de tecla intro para la consola
	 * @param tecla Texto que contiene el campo de la consola
	 */
	synchronized public void pulsacion(String tecla)
	{
		this.texto = tecla;
		interfaz.jtEntrada.removeKeyListener(listener);
		interfaz.jtEntrada.setEditable(false);
		interfaz.jtEntrada.setFocusable(false);
		eliminarListeners();
		this.notify();
	}
	/**
	 * Elimina los listeners de los botones
	 */
	public void eliminarListeners()
	{
		interfaz.JBArriba.removeActionListener(arriba);
		interfaz.JBAbajo.removeActionListener(abajo);
		interfaz.JBDerecha.removeActionListener(derecha);
		interfaz.JBIzquierda.removeActionListener(izquierda);

	}
	/**
	 * Prepara los listeners de los botones de la interfaz
	 */
	public void prepararBotones()
	{
		interfaz.JBAbajo.addActionListener(abajo = new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pulsacion(Tecla.ABAJO);
			}
		});
		interfaz.JBArriba.addActionListener(arriba = new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pulsacion(Tecla.ARRIBA);

			}
		});

		interfaz.JBDerecha.addActionListener(derecha = new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pulsacion(Tecla.DERECHA);

			}
		});

		interfaz.JBIzquierda.addActionListener(izquierda = new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pulsacion(Tecla.IZQUIERDA);

			}
		});
	}
}
