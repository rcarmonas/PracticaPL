package ANTLR;
// Test.java (clase principal)


import java.io.*;
import java.util.Scanner;

import Interfaz.Inicio;
import antlr.*;

public class Test
{
	public static void main(String args[]) 
	{
		boolean debug = false;
		try 
		{			
			Anasint anasint=null;
			Analex analex = null;
			TablaSimbolos ts = null;
			Inicio interfaz = null;
			// Se abre el fichero pasado como argumento de entrada
			if(args.length>0)
			{
				FileInputStream fichero =new FileInputStream(args[0]);
				// Analizador léxico
				analex = new Analex(fichero);
				// Analizador sintáctico
				anasint = new Anasint(analex);
				anasint.setTablaSimbolos(new TablaSimbolos());
				// Se invoca a la función asociada al símbolo inicial
				anasint.setDebug(debug);
				anasint.prog();
			}else
			{
		    	Scanner in = new Scanner(System.in);
		    	boolean aux = true;
				while(aux)
		    	{
					System.out.println("Introduzca una instrucción:");
		    		String cadena= in.nextLine();
		    		
		    		if( (analex==null) && (anasint==null) )
		    		{
		    			analex= new Analex(new StringReader(cadena));
		    			anasint= new Anasint(analex);
						anasint.setTablaSimbolos(new TablaSimbolos());
						anasint.inicializar();
		    		}
		    		else
		    		{
		    			ts = anasint.getTablaSimbolos();
		    			interfaz = anasint.interfaz;
		    			
		    			analex= new Analex(new StringReader(cadena));
		    			anasint= new Anasint(analex);
					
		    			anasint.interfaz = interfaz;
		    			anasint.setTablaSimbolos(ts);
		    		}
		    		anasint.instruccion(true);
		    	}
				in.close();
			}
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

