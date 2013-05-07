package ANTLR;
/** 
Clase Variable
<HR>
<HR width="80%">
@author Luis Del Moral, Juan María Palomo y Profesor
@version 1
@see TablaSimbolos
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
	<li> Constructor <b>sin</b> argumentos
	@see #Variable(String nombre,String tipo, String valor)
	*/
	public Variable()
	{
	
	}
	
	/**
	<li> Constructor <b>parametrizado</b>
	  @param nombre  Identificador de la variable
	  @param tipo    Tipo de la variable
	  @param valor   Valor de la variable
	  @see #Variable()
	*/
	public Variable(String nombre,String tipo, String valor)
	{
		_nombre = nombre;
		_tipo = tipo;
		_valor = valor;
	}
	
	// Métodos de modificación

	/**
	 <li> Método que permite modificar el <b>nombre</b> de la variable
	  @param nombre    Nuevo nombre que se va a asignar a la variable
	  @see #setTipo
	  @see #setValor
	*/
	public void setNombre(String nombre)
	{
		_nombre = nombre;
	}


	/**
	 <li> Método que permite modificar el <b>tipo</b> de la variable
	  @param tipo    Nuevo tipo que se va a asignar a la variable
	  @see #setNombre
	  @see #setValor
	*/
	public void setTipo(String tipo)
	{
		_tipo = tipo;
	}

	/**
	 <li> Método que permite modificar el <b>valor</b> de la variable
	  @param valor Nuevo Valor de la variable (de tipo String)
	  @see #setNombre
	  @see #setTipo
	*/
	public void setValor(String valor)
	{
		// Se asigna el valor de la variable.
		_valor = valor;
	}
	
	// Métodos de consulta

	/**
	 <li> Método que permite consultar el <b>nombre</b> de la variable
	  @return   Nombre de la variable
	  @see #getTipo
	*/

	public String getNombre()
	{
		return _nombre;
	}


	/**
	 <li> Método que permite consultar el <b>tipo</b> de la variable
	  @return Tipo de la variable
	  @see #getNombre
	  @see #getValor
	*/
	public String getTipo()
	{
		return _tipo;
	}

	/**
	 <li> Método que permite consultar el  <b>valor</b> de la variable
	  @return Valor de la variable
	  @see #getNombre
	  @see #getTipo
	*/
	public String getValor()
	{
		// Se devuelve el valor de la variable.
		return _valor;
	}


	// Métodos de escritura

	/**
	 <li> Método que permite escribir por pantalla el nombre y el tipo de la variable
	  @see #getNombre
	  @see #getTipo
	  @see #getValor
	*/
	public void escribirVariable ()
	{
		System.out.println("Identificador: "+ getNombre()+ "\t Tipo: " + getTipo()+"\t Valor: "+ getValor());
	}




}

