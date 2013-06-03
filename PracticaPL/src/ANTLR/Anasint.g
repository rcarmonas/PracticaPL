/*
	Trabajo de Prácticas: Procesadores de Lenguaje
		Rafael Carmona Sánchez
		Antonio Cubero Fernández
		José Manuel Herruzo Ruiz
	Analizador sintáctico.
*/


// Analizador sintáctico
header{
	package ANTLR;
	import java.util.Scanner;
	import Interfaz.*;
	import Excepciones.*;
	import java.lang.*;
	import java.util.Random;
	import javax.swing.text.BadLocationException;

	}
class Anasint extends Parser;

options 
{
	// Se exporta el vocabulario de componentes lexicos 
	// utilizado en el analisis sintactico
	exportVocab = Anasint;

}

// Nuevos atributos de la clase Anasin
{		
	//Variable que activa o desactiva la muestra de información de debug
	boolean debug = false;
	boolean semilla=false;
	Random rand;
	public Inicio interfaz;
	Tecla tecla;
	
	//Función para activar o desactivar la información adicional
	public void setDebug(boolean debug)
	{
		this.debug = debug;
	}
	
	//Clase para representar una expresión tanto numérica como alfanumérica
	private class Expresion
	{
		public String tipo;
		public String _valor;
		public Expresion()
		{
			this.tipo = "numero";
			this._valor = "0";
		}
	}
	//Tabla de símbolos usada
	private TablaSimbolos tablaSimbolos;
	
	//Método para establecer la tabla de símbolos usada por esta clase
	public void setTablaSimbolos(TablaSimbolos t)
	{
		tablaSimbolos = t;	
	}
	
	//Función que devuelve la tabla de símbolos de la clase
	public TablaSimbolos getTablaSimbolos()
	{
		return tablaSimbolos;
	}
	
	//Inserta o sobreescribe un identificador en la tabla de símbolos
	private void insertarIdentificador(String nombre, String tipo, String valorCadena)
		{
			
			// Busca el identificador en la tabla de símbolos
			int indice = tablaSimbolos.existeSimbolo(nombre);

			// Si encuentra el identificador, le modifica su valor
			if (indice >= 0)
			{
				tablaSimbolos.getSimbolo(indice).setValor(valorCadena);
				tablaSimbolos.getSimbolo(indice).setTipo(tipo);
			}
			// Si no lo encuentra, lo inserta en la tabla de símbolos
			else
			{
				// Se crea la variable
				Variable v = new Variable (nombre,tipo,valorCadena);

				// Se inserta la variable en la tabla de símbolos
				tablaSimbolos.insertarSimbolo(v);
			}
		}
		
	//Elimina los elementos de una línea para favorecer la recuperación de un error
	private void recuperacionError(int fin)
	{
		try {
				consume(); 
    			consumeUntil(fin);
			} 
		catch (Exception e) 
			{
			}
	}
	//Muestra una excepción por consola
	private	void mostrarExcepcion(RecognitionException re, int fin)
	{
		System.err.println("Error en la línea " + re.getLine() + " : " + re.getMessage());
		if(debug)
			this.tablaSimbolos.escribirSimbolos();
		try {
				consume(); 
    			consumeUntil(fin);
    			consume();
			} 
		catch (Exception e) 
			{
			}
	}
	
	public void inicializar()
	{
		interfaz = new Inicio(10, 10, 0, 0, 1, 1, 9, 9, 1, "Mario");
		interfaz.ventana.setVisible(true);
	}
}

//Reglas:


//Asignación tanto numérica como alfanumérica
asignacion
	[boolean ejecutar]
	//Variable local
	{Expresion e;}
	:
	id:IDENT 
	(
	(OP_ASIG e=expresion[ejecutar]
		{	
			String nombre = id.getText();
			if(ejecutar)
				insertarIdentificador(nombre, e.tipo, e._valor);
			if(debug)
	 			System.out.println("Asignación =>" + nombre + "=" + e._valor);
		}	
	)
	|
	(
		OP_INCREMENTO
			{
			    // Busca el identificador en la tabla de símbolos
				int indice = tablaSimbolos.existeSimbolo(id.getText());
				String tipo;
				double valor;
				// Si encuentra el identificador, devuelve su valor
				if (indice >= 0)
					tipo = tablaSimbolos.getSimbolo(indice).getTipo();
				else
					throw new UndefinedIdentException(id.getLine(), id.getText());
					
				if (!tipo.equals("numero"))
					throw new RecognitionException();
				else
					valor = Double.parseDouble(tablaSimbolos.getSimbolo(indice).getValor());
					
				valor = valor+1;
				
				insertarIdentificador(id.getText(), tipo, String.valueOf(valor));
				
			}
		)
		|
		(
		OP_DECREMENTO
			{
			    // Busca el identificador en la tabla de símbolos
				int indice = tablaSimbolos.existeSimbolo(id.getText());
				String tipo;
				double valor;
				// Si encuentra el identificador, devuelve su valor
				if (indice >= 0)
					tipo = tablaSimbolos.getSimbolo(indice).getTipo();
				else
					throw new RecognitionException();
					
				if (!tipo.equals("numero"))
					throw new RecognitionException();
				else
					valor = Double.parseDouble(tablaSimbolos.getSimbolo(indice).getValor());
					
				valor = valor-1;
				
				insertarIdentificador(id.getText(), tipo, String.valueOf(valor));
			}
		)
	)
	PUNTO_COMA
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en asignacion");
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [UndefinedIdentException ex]
		{
			if(ejecutar)
			{
				ex.printError();
				recuperacionError(PUNTO_COMA);
			}
		}

//-------------------------------------------------------------------------------------------
//Expresión, y elementos de los que se compone
expresion
	[boolean ejecutar]
	returns [Expresion resultado = new Expresion();]
	{Expresion e1, e2;}
	:e1=sumando[ejecutar]{resultado = e1;}
	(
		//Suma
		(
			m:OP_MAS e2 = sumando[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(val1+val2);
				else if(ejecutar)
					throw new WrongTypeException(m.getLine(), "Se esperaba dato numérico");
			}
		)
		|
		(//Resta
			me:OP_MENOS e2 = sumando[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(val1-val2);
				else if(ejecutar)
					throw new WrongTypeException(me.getLine(), "Se esperaba dato numérico");
			}
		)
	)*
		
	 	{if(debug)System.out.println("Expresion=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en expresion");
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			if(ejecutar)
			{
				ex.printError();
				recuperacionError(PUNTO_COMA);	
			}
		}


sumando
	[boolean ejecutar]
    //Valor que devuelve
	returns [Expresion resultado = new Expresion();]
	//Variables locales
	{Expresion e1, e2;}
	: (e1=factor[ejecutar]{resultado = e1;})
	(
		//Producto
		(
			p:OP_PRODUCTO e2 = factor[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo)&& resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(val1*val2);
				else if(ejecutar)
					throw new WrongTypeException(p.getLine(), "Se esperaba dato numérico");
			}
		)
		|
		(//División
			d:OP_DIVISION e2 = factor[ejecutar]
				{
					double val1 = Double.parseDouble(resultado._valor);
					double val2 = Double.parseDouble(e2._valor);
					if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero")) 
						resultado._valor = String.valueOf(val1/val2);
					else if(ejecutar)
						throw new WrongTypeException(d.getLine(), "Se esperaba dato numérico");
				}
		)
		|
		(//Módulo
			m:MOD e2 = factor[ejecutar]
				{
					double val1 = Double.parseDouble(resultado._valor);
					double val2 = Double.parseDouble(e2._valor);
					if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
						resultado._valor = String.valueOf((int)val1%(int)val2);
					else if(ejecutar)
						throw new WrongTypeException(m.getLine(), "Se esperaba dato numérico");
				}
		)
	)*
	{if(debug)System.out.println("Sumando=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en sumando");
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			if(ejecutar)
			{
				ex.printError();
				recuperacionError(PUNTO_COMA);	
			}
		}
		
factor
	[boolean ejecutar]
	returns [Expresion resultado = new Expresion();]
		{Expresion e1, e2;}
	:(e1=termino[ejecutar]{resultado = e1;})
	(
		(
			p:OP_POTENCIA e2 = termino[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(Math.pow(val1, val2));
				else if(ejecutar)
					throw new WrongTypeException(p.getLine(), "Se esperaba dato numérico");
			}
		)
		|
		(
			c:OP_CONCATENACION e2 = termino[ejecutar]
				{
					if(ejecutar && resultado.tipo.equals(e2.tipo)&& resultado.tipo.equals("cadena"))
						resultado._valor = resultado._valor + e2._valor;
					else if(ejecutar)
						throw new WrongTypeException(c.getLine(), "Se esperaba dato alfanumérico");
				}
		)
	)*
	{if(debug)System.out.println("Factor=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en factor");
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			if(ejecutar)
			{
				ex.printError();
				recuperacionError(PUNTO_COMA);	
			}
		}
	
termino
	[boolean ejecutar]
	//Valor que devuelve:
	returns [Expresion resultado = new Expresion();]
		{Expresion e;}
	: 
	(
		(n:LIT_NUMERO
		{
			{
				resultado._valor = n.getText();
				resultado.tipo = "numero";	
			}
		
		}
      )|(
		l:LIT_CADENA
		{
			resultado._valor = l.getText();
			resultado.tipo = "cadena";
		}
      )|(
      	i:IDENT
      	{
      		// Busca el identificador en la tabla de símbolos
			int indice = tablaSimbolos.existeSimbolo(i.getText());

			// Si encuentra el identificador, devuelve su valor
			if (indice >= 0)
			{
				// Se recupera el valor almacenado como cadena
				resultado._valor = tablaSimbolos.getSimbolo(indice).getValor();
				resultado.tipo = tablaSimbolos.getSimbolo(indice).getTipo();
			}
			else if(ejecutar)
			{
				throw new UndefinedIdentException(i.getLine(), i.getText());
			}
			else
			{
				resultado.tipo = "numero";
				resultado._valor = "0";
			}
      	}
      )|( PARENT_IZ e=expresion[ejecutar] PARENT_DE
      	  {
	      		resultado = e;	      	
	      } 
	   )|( m:OP_MENOS e=termino[ejecutar]
	   	{
	   		if(e.tipo.equals("numero"))
	   		{
	   			resultado._valor = String.valueOf(-Double.parseDouble(e._valor));
	   			resultado.tipo = "numero";
	   		}
	   		else if(ejecutar)
				throw new WrongTypeException(m.getLine(), "Se esperaba dato numérico");
	   		else
	   		{
	   			resultado._valor = "0";
	   			resultado.tipo = "numero";
	   		}
	   	}	
	   )|( e=terminoWumpus[ejecutar]
	   {
	   		if(e.tipo.equals("numero"))
	   		 	resultado = e;
	   		else if(!ejecutar)
	   		{
				throw new WrongTypeException(-1, "Se esperaba dato numérico");
	   		}
	   }
	   )
	   )
	   	{if(debug)System.out.println("termino=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en termino");
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			if(ejecutar)
			{
				ex.printError();
				recuperacionError(PUNTO_COMA);	
			}
		}
		catch [UndefinedIdentException exId]
		{
			if(ejecutar)
			{
				exId.printError();
				recuperacionError(PUNTO_COMA);	
			}
		}

//-------------------------------------------------------------------------------------------
//Funciones de lectura/escritura
leer 
	[boolean ejecutar]
	//Variables locales
	: LEER PARENT_IZ id:IDENT PARENT_DE PUNTO_COMA
	{
		if(ejecutar)
		{
			tecla=new Tecla(interfaz);
			int valor = Integer.parseInt(tecla.getTexto());
			//TODO Controlar fallo
			insertarIdentificador(id.getText(), "numero", String.valueOf(valor));
			//borro la entrada
			interfaz.jtEntrada.setText("");
			//pongo la entrada en la consola
			interfaz.jtConsola.insert(valor+"\n",interfaz.jtConsola.getCaretPosition());
			interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getCaretPosition()+2);
		}
	}
		;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en leer");
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }


leerCadena 
	[boolean ejecutar]
	//Variables locales
	: LEER_CADENA PARENT_IZ id:IDENT PARENT_DE PUNTO_COMA
	{
		if(ejecutar)
		{
			tecla=new Tecla(interfaz);
			String valorCadena = tecla.getTexto();
			insertarIdentificador(id.getText(), "cadena", valorCadena);
			//borro la entrada
			interfaz.jtEntrada.setText("");
			//pongo la entrada en la consola
			interfaz.jtConsola.insert(valorCadena+"\n",interfaz.jtConsola.getCaretPosition());
			interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getCaretPosition()+valorCadena.length()+1);
		}
	}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		
lectura
	[boolean ejecutar]
	: leer[ejecutar] | leerCadena[ejecutar]
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		
escribir 
		[boolean ejecutar]
		//Variables locales
		{Expresion e;}
		: ESCRIBIR PARENT_IZ e=expresion[ejecutar] PARENT_DE PUNTO_COMA
		{
			if(ejecutar)
			{
				interfaz.jtConsola.insert(e._valor+"\n",interfaz.jtConsola.getCaretPosition());
				interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getCaretPosition()+e._valor.length()+1);
			}
		}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }

escribirCadena 
		[boolean ejecutar]
		//Variables locales
		{Expresion s;}
		: ESCRIBIR_CADENA PARENT_IZ s=expresion[ejecutar] PARENT_DE PUNTO_COMA
		{
			if(ejecutar){
				interfaz.jtConsola.insert(s._valor,interfaz.jtConsola.getCaretPosition());
				interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getCaretPosition()+s._valor.length());
			}
		}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
			
escritura 
	[boolean ejecutar]
	: escribir[ejecutar] | escribirCadena[ejecutar] | mensaje[ejecutar]
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }

mensaje 
		[boolean ejecutar]
		//Variables locales
		{Expresion s;}
		: MOSTRAR_MENSAJE PARENT_IZ s=expresion[ejecutar] PARENT_DE PUNTO_COMA
		{
			if(ejecutar)
				{
				interfaz.mostrarMensaje(s._valor);
				}
		}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		
pregunta
		[boolean ejecutar]
		returns [Expresion e = new Expresion()]
		//Variables locales
		{Expresion s;}
		: MOSTRAR_PREGUNTA PARENT_IZ s=expresion[ejecutar] PARENT_DE
		{
			if(ejecutar)
				{
					e._valor = String.valueOf(interfaz.mostrarPregunta(s._valor));
					e.tipo = "numero";
				}
		}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }

//-------------------------------------------------------------------------------------------
//Condición y los elementos de los que se compone
termino_cond
	[boolean ejecutar]
	//Valor devuelto
	returns [boolean resultado = false;]
	//Variables locales
	{Expresion e1, e2;
	boolean b;}
	:
	(
	e1=expresion[ejecutar]
		((
			OP_IGUAL e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						resultado = e2._valor.equals(e1._valor);
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1==val2);
					}
			}
		)|(
			OP_DISTINTO e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						resultado = !e2._valor.equals(e1._valor);
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1!=val2);
					}
			}
		)|(
			m:OP_MAYOR e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new WrongTypeException(m.getLine(), "Se esperadaba dato numérico");
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1>val2);
					}
			}
		)|(
			me:OP_MENOR e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new WrongTypeException(me.getLine(), "Se esperadaba dato numérico");
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1<val2);
					}
			}
		)|(
			mi:OP_MAYOR_IGUAL e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new WrongTypeException(mi.getLine(), "Se esperadaba dato numérico");
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1>=val2);
					}
			}
		)|(
			mei:OP_MENOR_IGUAL e2=expresion[ejecutar]
			{
						if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new WrongTypeException(mei.getLine(), "Se esperadaba dato numérico");
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1<=val2);
					}
			}	
		)
		)
	)|(
			CORCH_IZ b=condicion[ejecutar] CORCH_DE
			{
				resultado = b;
			}
	)|(
			b=condicionWumpus[ejecutar]
			{
				resultado = b;
			}
	
	)|(LIT_CIERTO{resultado=true;})|(LIT_FALSO{resultado=false;})
	{if(debug)System.out.println("Termino_cond=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {

 			if(debug&&ejecutar)System.out.println("Error en termino_cond");
 			if(ejecutar)
				mostrarExcepcion(re, PARENT_DE);
			resultado = false;
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PARENT_DE);
		}
		

factor_cond
	[boolean ejecutar]
	//Valor devuelto
	returns [boolean resultado = false;]
	//Variables locales
	{boolean a, b;}
	:
	(
		OP_NO b=termino_cond[ejecutar]
		{
			resultado = !b;
		}
	)
	|
	(
		b = termino_cond[ejecutar]
		{
			resultado = b;
		}
	)
	{if(debug)System.out.println("FactorCondicion=>" +  resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			 if(debug&&ejecutar)System.out.println("Error en factor_cond");
 			 if(ejecutar)
			mostrarExcepcion(re, PARENT_DE);
		 }

		
		
sumando_cond
	[boolean ejecutar]
	returns [boolean resultado = false;]
	{boolean a, b;}
	:(a=factor_cond[ejecutar]{resultado = a;})
	(
		OP_Y b = factor_cond[ejecutar]
		{
			resultado = resultado && b;	
		}
	)*
	{if(debug)System.out.println("Sumando_cond=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en sumando_cond");
 			if(ejecutar)
			mostrarExcepcion(re, PARENT_DE);
		 }
	
	
condicion
	[boolean ejecutar]
	returns [boolean resultado = false;]
	{boolean a,b;}
	:(
		(a=sumando_cond[ejecutar]{resultado = a;})
		(
			OP_O b=sumando_cond[ejecutar]
			{
				resultado = resultado || b;
			}	
		)*
	)
	{if(debug)System.out.println("Condición=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
			if(debug&&ejecutar)System.out.println("Error en condicion");
			if(ejecutar)
			mostrarExcepcion(re, PARENT_DE);
		 }


//-------------------------------------------------------------------------------------------
//Sentencia condicional
sentencia_si
	[boolean ejecutar]
	// Variable local
	 {boolean valor;}
	 : 	SI PARENT_IZ valor=condicion[ejecutar] PARENT_DE
	   	ENTONCES 
		(instruccion[ejecutar&&valor])+
		(
			SI_NO
			(instruccion[ejecutar&&(!valor)])+
		)?
		FIN_SI PUNTO_COMA
			{if(debug)System.out.println("Sentencia if=>" + valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
 			{
				mostrarExcepcion(re, FIN_SI);
				consume();
 			}
		 }
		
//-------------------------------------------------------------------------------------------
//Bucle mientras
bucle_mientras
		[boolean ejecutar]
		// Variables locales
		{boolean valor; int marca=-1;}
		:
		 // Se establece una marca para indicar el punto de inicio del bucle
		{marca = mark();}
		 MIENTRAS PARENT_IZ valor=condicion[ejecutar] PARENT_DE 
		 HACER 
		 (instruccion[valor&&ejecutar])+
		 FIN_MIENTRAS PUNTO_COMA
		 {
		 	if(ejecutar&&valor)
		 	{
				rewind(marca); 
				this.bucle_mientras(true);
		 	}
		}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
 			{
				mostrarExcepcion(re, FIN_MIENTRAS);
 			}
				consume();
		 }
		catch [StackOverflowError re]
		{
			if(ejecutar)
			{
				System.err.println("ERROR: Bucle mientras infinito.");
				System.exit(0);
			}
		}
		
//-------------------------------------------------------------------------------------------
// Bucle repetir
bucle_repetir
		[boolean ejecutar]
		// Variables locales
		{boolean valor=true; int marca=-1;}
		:
		 // Se establece una marca para indicar el punto de inicio del bucle
		{marca = mark();}
		 REPETIR
		 (instruccion[valor&&ejecutar])+ 
		HASTA PARENT_IZ valor=condicion[ejecutar] PARENT_DE PUNTO_COMA
			{
				if((!valor)&&ejecutar)
				{
					rewind(marca); 
					this.bucle_repetir(true);
				}
			}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
 			{
				mostrarExcepcion(re, PUNTO_COMA);
				consume();
 			}
		 }
		catch [StackOverflowError re]
		{
			if(ejecutar)
			{
				System.err.println("ERROR: Bucle repetir infinito");
				System.exit(0);
			}
		}
//-------------------------------------------------------------------------------------------
// Bucle para y partes de las que se compone
cuerpo_bucle_para
	[String id, boolean ejecutar]
	{Expresion h, p;
	double n=0;
	boolean valor;
	int marca=-1;}
	:
	{
		marca = mark();
		if(ejecutar)
		{
			int indice = tablaSimbolos.existeSimbolo(id);
			String valorCadena = tablaSimbolos.getSimbolo(indice).getValor();
			n = Double.parseDouble(valorCadena);
		}
	}
	HASTA h = expresion[ejecutar]
	PASO p = expresion[ejecutar]
	{
		double valh = Double.parseDouble(h._valor);
		double valp = Double.parseDouble(p._valor);
		if((valp<0 && n>=valh)|(valp>0 && n<=valh))
			valor = true;
		else
			valor = false;
	}
	HACER
	(instruccion[valor&&ejecutar])+
	FIN_PARA PUNTO_COMA
	{
		if(valor&&ejecutar)
		{
			insertarIdentificador(id, "numero", String.valueOf(n+valp));
			rewind(marca); 
			this.cuerpo_bucle_para(id, true);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
 			{
				mostrarExcepcion(re, FIN_PARA);
				consume();
 			}
		 }
		catch [StackOverflowError re]
		{
			if(ejecutar)
			{
				System.err.println("ERROR: Bucle para infinito.");
				System.exit(0);
			}
		}
		
		
bucle_para
		[boolean ejecutar]
		// Variables locales
		{boolean valor;
		Expresion d;
		double h;
		double p;}
		:
		PARA id:IDENT
		DESDE d=expresion[ejecutar]
		{
			if(ejecutar)
				insertarIdentificador(id.getText(), "numero", d._valor);
		}
		cuerpo_bucle_para[id.getText(), ejecutar]
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
 			{
				mostrarExcepcion(re, FIN_PARA );
				consume();
 			}
		 }
		
//-------------------------------------------------------------------------------------------
//Control de la consola
borrar
	[boolean ejecutar]
	: BORRAR PUNTO_COMA
	{
		if(ejecutar)
			interfaz.jtConsola.setText("");
	}
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		
		
lugar
	[boolean ejecutar]
	{Expresion x, y;}
	: LUGAR PARENT_IZ x=expresion[ejecutar] COMA y=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		double valx = Double.parseDouble(y._valor);
		double valy = Double.parseDouble(x._valor);
		if(ejecutar)
		{
			if(interfaz.jtConsola.getLineCount()<valy)
			{
				int diferencia=(int)valy-interfaz.jtConsola.getLineCount();
				for(int i=0;i<diferencia;i++)
				{
					interfaz.jtConsola.append("\n");
					interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getCaretPosition()+1);
				}
			}
			int diferencia=interfaz.jtConsola.getLineEndOffset((int)valy-1)-interfaz.jtConsola.getLineStartOffset((int)valy-1);
			if(diferencia<valx)
			{
				interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getLineStartOffset((int)valy-1));
				for(int i=0;i<valx-diferencia;i++)
				{
					interfaz.jtConsola.insert(" ",interfaz.jtConsola.getCaretPosition());
					interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getCaretPosition()+1);
				}
			}
			interfaz.jtConsola.setCaretPosition(interfaz.jtConsola.getLineStartOffset((int)valy-1)+(int)valx);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [BadLocationException be] {
			System.err.println("Error en el cursor de la consola");
		 }
		catch [IllegalArgumentException ie] {
			System.err.println("Error en el cursor de la consola");
		 }



//-------------------------------------------------------------------------------------------
//Sentencias del mundo de wumpus =D

colocarAmbrosia
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_AMBROSIA PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setAmbrosia(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
		
colocarFlecha
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_FLECHA PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setArrow(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
		
colocarPozo
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_POZO PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");

		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setHole(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
colocarWumpus
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_WUMPUS PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setWumpus(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
		
colocarTesoro
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_TESORO PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setTreasure(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}

colocarJugador
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_JUGADOR PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setPlayer(valX, valY, false);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}

colocarMina
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_MINA PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setMina(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
		
colocarSalida
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	s:SET_SALIDA PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if((e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))&& ejecutar)
		{
			throw new WrongTypeException(s.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setPuerta(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}

moverWumpus
[boolean ejecutar]
	{Expresion e;}
	:
	  m:MOVER_WUMPUS PARENT_IZ e=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e.tipo.equals("cadena") && ejecutar)
		{
			throw new WrongTypeException(m.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valD = (int)(Double.parseDouble(e._valor));
			int auxX=0, auxY=0;
			
			if(valD == Tecla.DERECHA)
				auxX = 1;
			else if(valD == Tecla.IZQUIERDA)
				auxX = -1;
			else if(valD == Tecla.ARRIBA)
				auxY = -1;
			else if(valD == Tecla.ABAJO)
				auxY = 1;
			else
			{
				System.err.println("Se esperaba una dirección");	
				throw new RecognitionException();
			}
			interfaz.moverWumpus(auxX, auxY);
			
		}
	}
	; 
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}

pausa
	[boolean ejecutar]
	{Expresion e;}
	:
	 p:PAUSA PARENT_IZ e=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e.tipo.equals("cadena") && ejecutar)
		{
			throw new WrongTypeException(p.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valT = (int)(Double.parseDouble(e._valor)*1000);
			try{
			  Thread.currentThread().sleep(valT);
			}
			catch(Exception ie){
				System.err.println("Error al intentar pausar");
			}
		}
	}
	;
	exception
 		catch [RecognitionException re] {
  			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}

pulsacion
	[boolean ejecutar]
	returns [int resultado=0;]
	:
	(
		DERECHA
		{resultado = Tecla.DERECHA;}
	)|(
		IZQUIERDA
		{resultado = Tecla.IZQUIERDA;}
	)|(
		ARRIBA
		{resultado = Tecla.ARRIBA;}
	)|(
		ABAJO
		{resultado = Tecla.ABAJO;}
	)|(
		ESPACIO
		{resultado = Tecla.ESPACIO;}
	)|(
		ESCAPE
		{resultado = Tecla.ESCAPE;}
	)
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		
moverJugador
	[boolean ejecutar]
	{Expresion e;}
	:
	  m:MOVER_JUGADOR PARENT_IZ e=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e.tipo.equals("cadena") && ejecutar)
		{
			throw new WrongTypeException(m.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valD = (int)(Double.parseDouble(e._valor));
			int auxX=0, auxY=0;
			
			if(valD == Tecla.DERECHA)
				auxX = 1;
			else if(valD == Tecla.IZQUIERDA)
				auxX = -1;
			else if(valD == Tecla.ARRIBA)
				auxY = -1;
			else if(valD == Tecla.ABAJO)
				auxY = 1;
			else
			{
				System.err.println("Se esperaba una dirección");	
				throw new RecognitionException();
			}
			
			interfaz.mover(auxX, auxY);
			
		}
	}
	; 
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
		
disparar
	[boolean ejecutar]
	{Expresion e;}
	:
	  d:DISPARAR PARENT_IZ e=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e.tipo.equals("cadena") && ejecutar)
		{
			throw new WrongTypeException(d.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int valD = (int)(Double.parseDouble(e._valor));
			interfaz.tiraFlecha(valD);
			
						
		}
	}
	; 
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
		
leerTecla
	[boolean ejecutar]
	returns [Expresion resultado = new Expresion()]
	:
	 LEER_TECLA
	{
		if(ejecutar)
		{
			tecla = new Tecla(interfaz);
			int pulsacion = tecla.getTecla();
			resultado.tipo="numero";
			resultado._valor = String.valueOf(pulsacion);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
	
aleatorio
	[boolean ejecutar]
	returns [int resultado=0;]
	{int i;
	Expresion e;}
	:
	 ALEATORIO PARENT_IZ e=expresion[ejecutar] PARENT_DE
	{
		if(e.tipo.equals("cadena") && ejecutar)
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
		}
		else if(ejecutar)
		{
			if(!semilla)
			{
				rand=new Random();
				rand.setSeed(System.currentTimeMillis());
				semilla = true;
			}
			int valR = (int)(Double.parseDouble(e._valor));
			resultado = rand.nextInt(valR);
		}
	}
	; 
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }

direccionAleatoria
	[boolean ejecutar]
	returns [int resultado=0;]
	{int i;}
	:
	 DIR_ALEATORIO
	{
		if(ejecutar)
		{
			if(!semilla)
			{
				rand=new Random();
				rand.setSeed(System.currentTimeMillis());
				semilla = true;
			}
			int aux = rand.nextInt(4);
			switch(aux)
			{
				case 0:
					resultado = Tecla.DERECHA;
					break;
				case 1:
					resultado = Tecla.IZQUIERDA;
					break;
				case 2:
					resultado = Tecla.ARRIBA;
					break;
				case 3:
					resultado = Tecla.ABAJO;
					break;
			}
		}
	}
	; 
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }


infoCasilla	
	[boolean ejecutar]
	returns [Expresion resultado= new Expresion();]
	{
	boolean aux=false;
	Expresion e1=new Expresion(), e2=new Expresion();
	}
	:
	INFO_CASILLA (PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE{aux = true;})?
	{
		if(ejecutar)
		{
			if(aux)
			{
				if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
				{
					System.err.println("Se esperaba expresion numérica , no alfanumérica");
					throw new RecognitionException();
				}
				else
				{
					int valX = (int)Double.parseDouble(e1._valor);
					int valY = (int)Double.parseDouble(e2._valor);
					resultado.tipo = "numero";
					resultado._valor = String.valueOf(interfaz.getInfoCasilla(valX, valY));
				}
			}
			else
			{	
					int valX = interfaz.jJugador.lastX;
					int valY = interfaz.jJugador.lastY;
					resultado.tipo = "numero";
					resultado._valor = String.valueOf(interfaz.getInfoCasilla(valX, valY));
			}
		}			
	}
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
	
comprobacion
	[boolean ejecutar]
	returns [int resultado=0]
	:
		(HAY_WUMPUS{resultado = Inicio.wumpus;})| 
		(HAY_TESORO{resultado = Inicio.tesoro;})|
		(HAY_JUGADOR{resultado = Inicio.jugador;})|
		(HAY_FLECHA{resultado = Inicio.flecha;})|
		(HAY_AMBROSIA{resultado = Inicio.ambrosia;})|
		(HAY_POZO{resultado = Inicio.pozo;})|
		(HAY_VIENTO{resultado = Inicio.viento;})|
		(HAY_OLOR{resultado = Inicio.olor;})|
		(HAY_MINA{resultado = Inicio.mina;})|
		(HAY_SALIDA{resultado = Inicio.puerta;})|
		(OCULTO{resultado = Inicio.desconocido;})
		
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }

salir
	[boolean ejecutar]
	:
	 SALIR PUNTO_COMA
	{
		if(ejecutar)
		{
			System.exit(0);
		}
	}
	; 
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }

condicionWumpus
	[boolean ejecutar]
	returns [boolean resultado = false]
	{int tipo;
	Expresion e;}
	:
	(tipo=comprobacion[ejecutar] p:PARENT_IZ e=expresion[ejecutar] PARENT_DE
	{
		if(ejecutar && e.tipo.equals("cadena"))
		{
			throw new WrongTypeException(p.getLine(), "Se esperaba dato numérico");
		}
		else if(ejecutar)
		{
			int val = (int)Double.parseDouble(e._valor);
			int aux = (int)(val/Math.pow(2,tipo));
			resultado = ((aux%2)==1);
		}
	}
	)|(RESULTADO
		{
			resultado = interfaz.resultado;
		}			
	)|(TESORO
		{
			resultado = interfaz.tengoTesoro;
		}			
	)
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }
		catch [WrongTypeException ex]
		{
			ex.printError();
			recuperacionError(PUNTO_COMA);
		}
	
terminoWumpus
	[boolean ejecutar]
	returns [Expresion resultado = new Expresion();]
	{int i;
	Expresion e;}
	:
	(
		i=pulsacion[ejecutar]
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(i);
		}
	)|(
		CONF_vidas
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(interfaz.jJugador.getVidas());
		}
	)|(
		CONF_flechas
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(interfaz.jJugador.getFlechas());
		}
	)|(
		VIDAS_WUMPUS
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(interfaz.jWumpus.getVidas());
		}
	)|(
		CONF_XPlayer
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(interfaz.jJugador.getX());
		}
	)|(
		CONF_YPlayer
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(interfaz.jJugador.getY());
		}
	)|(
		i=aleatorio[ejecutar]
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(i);
		}
	)|(
		i=direccionAleatoria[ejecutar]
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(i);
		}
	)|	(
		e=leerTecla[ejecutar]
		{
			resultado = e;
		}	
	)|(
		e=infoCasilla[ejecutar]
		{
			resultado = e;
		}	
	)|(
		e=pregunta[ejecutar]
		{
			resultado = e;
		}	
	)|(
		CONF_X
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(interfaz.rejillaX);
		}
	)|(
		CONF_Y
		{
			resultado.tipo = "numero";
			resultado._valor = String.valueOf(interfaz.rejillaY);
		}
	)
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re, PUNTO_COMA);
		 }

sentenciaWumpus
	[boolean ejecutar]
	:
		colocarPozo[ejecutar]
		|colocarWumpus[ejecutar]
		|moverWumpus[ejecutar]
		|colocarAmbrosia[ejecutar]
		|colocarFlecha[ejecutar]
		|colocarTesoro[ejecutar]
		|colocarJugador[ejecutar]
		|colocarMina[ejecutar]
		|colocarSalida[ejecutar]
		|pausa[ejecutar]
		|disparar[ejecutar]
		|salir[ejecutar]
		
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }


//-------------------------------------------------------------------------------------------
//Sentencias de configuración del mundo de wumpus


sentenciasConf
	{
		Expresion x, y, xP, yP, vidas, flechas, wvidas, xW, yW;
		Expresion mod = new Expresion();
		mod._valor = "";
		boolean modActivo=false;
	}
	:
	CONF_X x=expresion[true]
	CONF_Y y=expresion[true]
	CONF_XPlayer xP=expresion[true]
	CONF_YPlayer yP=expresion[true]
	CONF_vidas vidas=expresion[true]
	CONF_flechas flechas=expresion[true]
	CONF_XWUMPUS xW = expresion[true]
	CONF_YWUMPUS yW = expresion[true]
	VIDAS_WUMPUS wvidas = expresion[true]
	(CONF_MOD mod= expresion[true]{modActivo=true;})?
	{
		if(x.tipo.equals("cadena")
			|| y.tipo.equals("cadena")
			|| xP.tipo.equals("cadena")
			|| yP.tipo.equals("cadena")
			|| vidas.tipo.equals("cadena")
			|| flechas.tipo.equals("cadena")
			|| wvidas.tipo.equals("cadena")
			|| xW.tipo.equals("cadena")
			|| yW.tipo.equals("cadena")
			|| (modActivo && mod.tipo.equals("numero")))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
		}
		int valy = (int)Double.parseDouble(y._valor);
		int valx = (int)Double.parseDouble(x._valor);
		int valxP = (int)Double.parseDouble(xP._valor);
		int valyP = (int)Double.parseDouble(yP._valor);
		int valVidas = (int)Double.parseDouble(vidas._valor);
		int valFlechas = (int)Double.parseDouble(flechas._valor);
		int valWVidas = (int)Double.parseDouble(wvidas._valor);
		int valxW = (int)Double.parseDouble(xW._valor);
		int valyW = (int)Double.parseDouble(yW._valor);
		interfaz=new Inicio(valy, valx, valxP, valyP, valVidas, valFlechas, valxW, valyW, valWVidas, mod._valor);
		interfaz.ventana.setVisible(true);
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }


//-------------------------------------------------------------------------------------------
//Instruccion
instruccion 
	[boolean ejecutar]
	: 
	escritura[ejecutar] 
	| lectura[ejecutar] 
	| asignacion[ejecutar] 
	| sentencia_si[ejecutar]
	| bucle_mientras[ejecutar] 
	| bucle_repetir[ejecutar] 
	| bucle_para[ejecutar]
	| borrar[ejecutar]
	| lugar[ejecutar]
	| sentenciaWumpus[ejecutar]
	| moverJugador[ejecutar]
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re, PUNTO_COMA);
		 }
		

//-------------------------------------------------------------------------------------------
//Programa general
prog: 
	(
		CONFIGURACION
			sentenciasConf
		EJECUCION
			(instruccion[true])+
		FIN
	)
	|
	(
		{inicializar();}
		(instruccion[true])+
	)
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re, PUNTO_COMA);
		 }




