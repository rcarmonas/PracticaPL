package ANTLR;
// Test.java (clase principal)

import java.io.*;
import antlr.*;



public class Test 
{
	public static void main(String args[]) 
	{
		boolean debug = false;
		try 
		{
			/*
			FileInputStream fichero = new FileInputStream(args[0]);
			Analex lexer = new Analex(fichero);

			System.out.println("Fichero: " + args[0]);

			Token tok = lexer.nextToken();

			while(tok.getType() != Token.EOF_TYPE)
			{ 
				System.out.println(
						    "\n Lexema: " + tok.getText()  
						  + "\n Tipo de token:" + tok.getType() 
						  + "\n Línea: " + tok.getLine()   
						  + "   Columna: " + tok.getColumn()  
						  );

				System.out.println(tok);

				tok = lexer.nextToken();
			}
			*/
			
			
			
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

