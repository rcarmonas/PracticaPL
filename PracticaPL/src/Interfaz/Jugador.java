package Interfaz;

public class Jugador {
	int vidas;
	int flechas;
	public int getFlechas() {
		return flechas;
	}

	public void setFlechas(int flechas) {
		this.flechas = flechas;
	}

	int x, y;

	Jugador(int i,int j){
		this.x = i;
		this.y = j;
		vidas = 3;
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


}
