package ANTLR;
// Test.java (clase principal)

import java.io.*;

import Interfaz.Inicio;
import antlr.*;



public class Test 
{
	public static void main(String args[]) 
	{
		boolean debug = false;
		try 
		{			
			// Se abre el fichero pasado como argumento de entrada
			FileInputStream fichero =new FileInputStream(args[0]);

			// Analizador léxico
			Analex analex = new Analex(fichero);
		
			// Analizador sintáctico
			Anasint anasint = new Anasint(analex);
			anasint.setTablaSimbolos(new TablaSimbolos());
			// Se invoca a la función asociada al símbolo inicial
			anasint.setDebug(debug);
			anasint.prog();	
			// Se muestran los identificadores reconocidos
			if(debug)
			{
				System.out.println("\n\nContenido de la Tabla de Símbolos");
				anasint.getTablaSimbolos().escribirSimbolos();
			}
			
			//TODO crear la interfaz
			Inicio interfaz=new Inicio(10,10);
			
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

