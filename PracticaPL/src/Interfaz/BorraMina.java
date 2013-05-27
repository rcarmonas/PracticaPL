package Interfaz;

public class BorraMina implements Runnable {
	ImagePanel ip;

	public BorraMina(ImagePanel ipaux) {
		// TODO Auto-generated constructor stub
		ip = ipaux;
	}

	@Override
	public void run() {
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {e.printStackTrace();}
		this.ip.changeParameter(Inicio.mina, false);
	}

}
