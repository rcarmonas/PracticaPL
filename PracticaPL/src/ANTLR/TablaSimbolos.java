package ANTLR;
//Imports necesarios de Java.
import java.util.*;

public class TablaSimbolos 
{
	//La tabla de símbolos es un ArrayList
	private ArrayList <Variable> _simbolos;
	
	// Constructores

	// Constructor sin argumentos
	public TablaSimbolos()
	{
		// Se inicializa la tabla de símbolos.
		_simbolos = new ArrayList <Variable>();
	}
	
	// Métodos de modificacion 

	// Insertar una variable en la tabla de símbolos
	public void insertarSimbolo(Variable nuevoSimbolo)
	{
		_simbolos.add(nuevoSimbolo);
	}
	
	// Metodos de consulta

	public Variable getSimbolo(int indice)
	{
		Variable auxiliar = _simbolos.get(indice);				
		return auxiliar;
	}
	
	// Comprueba si existe el símbolo en la tabla de símbolos
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
		
		// Se devuelve el índice del símbolo o -1 si no ha sido encontrado.
		return indice;
	}
	
	// Métodos de modificación

	// Elimina el identificador de la tabla de símbolos.
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

	// Escribe por pantalla los identificadores de la tabla de símbolos
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
