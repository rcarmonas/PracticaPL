package Interfaz;

public class Jugador {
	int vidas;
	int flechas;
	int x, y;
	public int xIni, yIni;
	public int lastX, lastY;

	Jugador(int i, int j, int vidas, int flechas){
		this.xIni = i;
		this.yIni = j;
		this.x = i;
		this.y = j;
		this.vidas = vidas;
		this.flechas = flechas;
	}

	public int getFlechas() {
		return flechas;
	}

	public void setFlechas(int flechas) {
		this.flechas = flechas;
	}

	public int getVidas() {
		return vidas;
	}

	public void setVidas(int vidas) {
		this.vidas = vidas;
	}

	public int getX() {
		return x;
	}

	public void setX(int x) {
		this.x = x;
	}

	public int getY() {
		return y;
	}

	public void setY(int y) {
		this.y = y;
	}
	
	public void restart()
	{
		this.x = this.xIni;
		this.y = this.yIni;
	}


}
