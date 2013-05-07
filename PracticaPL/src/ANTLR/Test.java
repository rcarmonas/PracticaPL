package ANTLR;
// Test.java (clase principal)

import java.io.*;
import antlr.*;

public class Test 
{
	public static void main(String args[]) 
	{
		try 
		{
			// Se abre el fichero pasado como argumento de entrada
			FileInputStream fichero =new FileInputStream(args[0]);

			// Analizador léxico
			Analex analex = new Analex(fichero);
		
			// Analizador sintáctico
			Anasint anasint = new Anasint(analex);

			// Se invoca a la función asociada al símbolo inicial
			anasint.prog();	

			// Se muestran los identificadores reconocidos
			System.out.println("\n\nContenido de la Tabla de Símbolos");
			anasint.getTablaSimbolos().escribirSimbolos();
		}


		// Control de excepciones de ANTLR
		catch(ANTLRException ae) 
		{
			System.err.println(ae.getMessage());
		}

		// Control de excepciones de fichero inexistente
		catch(FileNotFoundException fnfe) 
		{
			System.err.println("No se ha encontrado el fichero " + args[0]);
		}
	}
}

