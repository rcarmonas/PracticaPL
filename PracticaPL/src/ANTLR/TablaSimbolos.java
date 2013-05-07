package ANTLR;
//Imports necesarios de Java.
import java.util.*;


/** 
Clase TablaSimbolos
<HR>
<HR width="80%">
@author Luis Del Moral, Juan María Palomo y Profesor
@version 1
@see Variable
*/
public class TablaSimbolos 
{
	/**  La tabla de símbolos es un ArrayList */
	private ArrayList <Variable> _simbolos;
	
	// Constructores

	/**
	<li> Constructor sin argumentos
	*/
	public TablaSimbolos()
	{
		// Se inicializa la tabla de símbolos.
		_simbolos = new ArrayList <Variable>();
	}
	
	// Métodos de modificacion 

	/**
	<li> Insertar una variable en la tabla de símbolos
	@param nuevoSimbolo  Variable que se va a insertar en la tabla de símbolos
	*/
	public void insertarSimbolo(Variable nuevoSimbolo)
	{
		_simbolos.add(nuevoSimbolo);
	}
	
	// Metodos de consulta

	/**
	<li> Devuelve 
	@param indice    Indica el lugar en el que está almacenada la variable en la tabla de símbolos.
	@return Variable que ocupa la posición señalada por indice 
	*/
	public Variable getSimbolo(int indice)
	{
		Variable auxiliar = _simbolos.get(indice);				
		return auxiliar;
	}
	
	/**
	Comprueba si existe el <b>símbolo</b> en la <b>tabla de símbolos</b>. 
	<ul>
		<li> Si existe, devuelve el índice que indica la posición del símbolo
		<li> En caso contrario, devuelve -1
	</ul>
	@param nombreSimbolo Nombre del símbolo buscado.
	@return Índice del símbolo o -1 si no ha sido encontrado.
	@see Variable
	*/
	public int existeSimbolo(String nombreSimbolo)
	{
		boolean encontrado = false;
		Variable auxiliar = null;

		int indice = -1;
		int numeroSimbolos = _simbolos.size();
		int i = 0;

		// Se busca en toda la tabla de símbolos.
		while ( (i < numeroSimbolos) && (encontrado == false))
		{
			auxiliar = _simbolos.get(i);

			if (auxiliar.getNombre().equals(nombreSimbolo))
			{
				encontrado = true;
				indice = i;
			}
			else
				i++;
		}	
		
		/*
		   Se devuelve el índice del símbolo
		   o -1 si no ha sido encontrado.
		*/
		return indice;
	}
	
	// Métodos de modificación

	/**
	<li> Elimina el identificador de la tabla de símbolos
	@param nombreSimbolo Nombre del símbolo que se desea borrar.
	@return true, si el símbolo ha sido borrado; false, en caso contrario
	@see #insertarSimbolo
	@see #existeSimbolo
	*/
	public boolean eliminarSimbolo(String nombreSimbolo)
	{
		int indice;
		
		// Busca la posición del Símbolo en la Tabla de Símbolos
		indice = existeSimbolo(nombreSimbolo);

		// Si existe, lo borra
		if (indice >= 0)
		{
				_simbolos.remove(indice);
				return true;
		}

		// Si no, emite un mensaje de aviso
		else
				return false;
			
	}

	/**
	<li> Escribe por pantalla los identificadores de la tabla de símbolos
	@see Variable
	*/
	public void escribirSimbolos()
	{

		Variable auxiliar;
		int numeroSimbolos = _simbolos.size();

		for (int i = 0; i < numeroSimbolos; i++)
		{
			auxiliar = _simbolos.get(i);
			auxiliar.escribirVariable();

			
		}

	}
}
