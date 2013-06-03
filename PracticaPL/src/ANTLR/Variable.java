package ANTLR;


/**
 * Clase Variable para su uso en la tabla de símbolos
 * @author Rafael Carmona Sánchez
 * @author Antonio Cubero Fernández
 * @author José Manuel Herruzo Ruiz
 *
 */
public class Variable 
{
	// Atributos privados

	/**  Nombre del identificador */
	private String _nombre;
 
	 /** Tipo del identificador */
	private String _tipo;  
	
	 /** Valor identificador */
	private String _valor;  

	// Constructores


	/**
	 * Constructor vacío
	 */
	public Variable()
	{
	
	}
	


	/**
	 * Constructor parametrizado
	 * @param nombre Nombre del símbolo
	 * @param tipo Tipo del símbolo
	 * @param valor Valor del símbolo
	 */
	public Variable(String nombre,String tipo, String valor)
	{
		_nombre = nombre;
		_tipo = tipo;
		_valor = valor;
	}
	
	// Métodos de modificación




	public void setNombre(String nombre)
	{
		_nombre = nombre;
	}




	public void setTipo(String tipo)
	{
		_tipo = tipo;
	}



	public void setValor(String valor)
	{
		// Se asigna el valor de la variable.
		_valor = valor;
	}
	
	// Métodos de consulta




	public String getNombre()
	{
		return _nombre;
	}




	public String getTipo()
	{
		return _tipo;
	}



	public String getValor()
	{
		// Se devuelve el valor de la variable.
		return _valor;
	}


	// Métodos de escritura


	/**
	 * Imprime la información de un símbolo por la consola estándar
	 */
	public void escribirVariable ()
	{
		System.out.println("Identificador: "+ getNombre()+ "\t Tipo: " + getTipo()+"\t Valor: "+ getValor());
	}




}

