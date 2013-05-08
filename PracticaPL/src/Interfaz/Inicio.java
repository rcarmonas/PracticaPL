package Interfaz;

import java.awt.EventQueue;

import javax.swing.JFrame;

public class Inicio {

	
	public JFrame ventana;
	/**
	 * @param args
	 */
	public static void main() {
	EventQueue.invokeLater(new Runnable() {
	public void run() {
			try {
			Inicio window = new Inicio();
			window.ventana.setVisible(true);	
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		});
	}

}
