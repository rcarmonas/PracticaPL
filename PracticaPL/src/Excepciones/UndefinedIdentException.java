package Excepciones;
/**
 * Clase para controlar las excepciones por identificadores no definidos
 * @author Rafael Carmona Sánchez
 * @author Antonio Cubero Fernández
 * @author José Manuel Herruzo Ruiz
 *
 */
@SuppressWarnings("serial")
public class UndefinedIdentException extends Exception{

	int line;
	String ident;
	/**
	 * Constructor
	 * @param nLine Número de línea donde el error ha ocurrido
	 * @param ident Identificador que ha producido el error
	 */
	public UndefinedIdentException(int nLine, String ident)
	{
		this.line = nLine;
		this.ident = ident;
	}
	/**
	 * Imprime información sobre el error
	 */
	public void printError()
	{
		System.err.println("Identificador indefinido: " + this.ident + " Línea: " + line);
	}

}
