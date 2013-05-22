package Interfaz;

public class Wumpus {
	int x;
	int y;
	int vidas;
	public Wumpus(int xx,int yy)
	{
		x=xx;
		y=yy;
		vidas = 1;
	}
	public Wumpus(int xx,int yy, int iVidas)
	{
		x=xx;
		y=yy;
		vidas = iVidas;
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
	public int getVidas() {
		return vidas;
	}
	public void setVidas(int vidas) {
		this.vidas = vidas;
	}
	

}
