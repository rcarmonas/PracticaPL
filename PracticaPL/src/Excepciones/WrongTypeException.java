package Excepciones;

@SuppressWarnings("serial")
public class WrongTypeException extends Exception {

	int line;
	String cadena;
	/**
	 * Constructor
	 * @param nLine Número de línea donde el error ha ocurrido
	 * @param ident Identificador que ha producido el error
	 */
	public WrongTypeException(int nLine, String message)
	{
		super(message);
		this.line = nLine;
		this.cadena = message;
	}
	/**
	 * Imprime información sobre el error
	 */
	public void printError()
	{
		System.err.println("Tipo erróneo: " + this.cadena + " Línea: " + line);
	}
}
