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
	
	Inicio interfaz;
	
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
		
	//Muestra una excepción por consola
	private	void mostrarExcepcion(RecognitionException re)
	{
		System.out.println("Error en la línea " + re.getLine() + " --> " + re.getMessage());
		if(debug)
			this.tablaSimbolos.escribirSimbolos();
		try {
				consume(); 
    			consumeUntil(PUNTO_COMA);
    			consume();
			} 
		catch (Exception e) 
			{
			}
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
					throw new RecognitionException();
					
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
			mostrarExcepcion(re);
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
			OP_MAS e2 = sumando[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(val1+val2);
				else if(ejecutar)
					throw new RecognitionException();
			}
		)
		|
		(//Resta
			OP_MENOS e2 = sumando[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(val1-val2);
				else if(ejecutar)
					throw new RecognitionException();
			}
		)
	)*
		
	 	{if(debug)System.out.println("Expresion=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en expresion");
 			if(ejecutar)
			mostrarExcepcion(re);
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
			OP_PRODUCTO e2 = factor[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo)&& resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(val1*val2);
				else if(ejecutar)
					throw new RecognitionException();			
			}
		)
		|
		(//División
			OP_DIVISION e2 = factor[ejecutar]
				{
					double val1 = Double.parseDouble(resultado._valor);
					double val2 = Double.parseDouble(e2._valor);
					if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero")) 
						resultado._valor = String.valueOf(val1/val2);
					else if(ejecutar)
						throw new RecognitionException();	
				}
		)
		|
		(//Módulo
			MOD e2 = factor[ejecutar]
				{
					double val1 = Double.parseDouble(resultado._valor);
					double val2 = Double.parseDouble(e2._valor);
					if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
						resultado._valor = String.valueOf((int)val1%(int)val2);
					else if(ejecutar)
						throw new RecognitionException();	
				}
		)
	)*
	{if(debug)System.out.println("Sumando=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en sumando");
 			if(ejecutar)
			mostrarExcepcion(re);
		 }
		
factor
	[boolean ejecutar]
	returns [Expresion resultado = new Expresion();]
		{Expresion e1, e2;}
	:(e1=termino[ejecutar]{resultado = e1;})
	(
		(
			OP_POTENCIA e2 = termino[ejecutar]
			{
				double val1 = Double.parseDouble(resultado._valor);
				double val2 = Double.parseDouble(e2._valor);
				if(ejecutar && resultado.tipo.equals(e2.tipo) && resultado.tipo.equals("numero"))
					resultado._valor = String.valueOf(Math.pow(val1, val2));
				else if(ejecutar)
					throw new RecognitionException();			
			}
		)
		|
		(
			OP_CONCATENACION e2 = termino[ejecutar]
				{
					if(ejecutar && resultado.tipo.equals(e2.tipo)&& resultado.tipo.equals("cadena"))
						resultado._valor = resultado._valor + e2._valor;
					else if(ejecutar)
						throw new RecognitionException();	
				}
		)
	)*
	{if(debug)System.out.println("Factor=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en factor");
 			if(ejecutar)
			mostrarExcepcion(re);
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
				System.err.println("Error: el identificador " + i.getText() + " está indefinido");
				throw new RecognitionException();
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
	   )|( OP_MENOS e=termino[ejecutar]
	   	{
	   		if(e.tipo.equals("numero"))
	   		{
	   			resultado._valor = String.valueOf(-Double.parseDouble(e._valor));
	   			resultado.tipo = "numero";
	   		}
	   		else if(ejecutar)
	   			throw new RecognitionException();
	   		else
	   		{
	   			resultado._valor = "0";
	   			resultado.tipo = "numero";
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
				mostrarExcepcion(re);
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
			Scanner entrada = new Scanner(System.in);
			int valor = entrada.nextInt();
			//TODO Controlar fallo
			insertarIdentificador(id.getText(), "numero", String.valueOf(valor));
		}
	}
		;
	exception
 		catch [RecognitionException re] {
 			if(debug&&ejecutar)System.out.println("Error en leer");
 			if(ejecutar)
			mostrarExcepcion(re);
		 }


leerCadena 
	[boolean ejecutar]
	//Variables locales
	: LEER_CADENA PARENT_IZ id:IDENT PARENT_DE PUNTO_COMA
	{
		if(ejecutar)
		{
			Scanner entrada = new Scanner(System.in);
			String valorCadena = entrada.next();
			insertarIdentificador(id.getText(), "cadena", valorCadena);
		}
	}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re);
		 }
		
lectura
	[boolean ejecutar]
	: leer[ejecutar] | leerCadena[ejecutar]
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re);
		 }
		
escribir 
		[boolean ejecutar]
		//Variables locales
		{Expresion e;}
		: ESCRIBIR PARENT_IZ e=expresion[ejecutar] PARENT_DE PUNTO_COMA
		{
			if(ejecutar)
				System.out.println(e._valor);
		}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re);
		 }

escribirCadena 
		[boolean ejecutar]
		//Variables locales
		{Expresion s;}
		: ESCRIBIR_CADENA PARENT_IZ s=expresion[ejecutar] PARENT_DE PUNTO_COMA
		{
			if(ejecutar)
				System.out.println(s._valor);
		}
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
				mostrarExcepcion(re);
		 }
			
escritura 
	[boolean ejecutar]
	: escribir[ejecutar] | escribirCadena[ejecutar]
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re);
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
			OP_MAYOR e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new RecognitionException();
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1>val2);
					}
			}
		)|(
			OP_MENOR e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new RecognitionException();
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1<val2);
					}
			}
		)|(
			OP_MAYOR_IGUAL e2=expresion[ejecutar]
			{
				if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new RecognitionException();
					else
					{
						double val1 = Double.parseDouble(e1._valor);
						double val2 = Double.parseDouble(e2._valor);
						resultado = (val1>=val2);
					}
			}
		)|(
			OP_MENOR_IGUAL e2=expresion[ejecutar]
			{
						if(ejecutar)
					if(e2.tipo.equals("cadena"))
						throw new RecognitionException();
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
	)
	{if(debug)System.out.println("Termino_cond=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {

 			if(debug&&ejecutar)System.out.println("Error en termino_cond");
 			if(ejecutar)
			mostrarExcepcion(re);
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
			mostrarExcepcion(re);
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
			mostrarExcepcion(re);
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
			mostrarExcepcion(re);
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
			mostrarExcepcion(re);
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
			mostrarExcepcion(re);
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
			mostrarExcepcion(re);
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
		if((valp<0 && n>valh)|(valp>0 && n<valh))
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
			mostrarExcepcion(re);
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
			mostrarExcepcion(re);
		 }
		
//-------------------------------------------------------------------------------------------
//Control de la consola
borrar
	[boolean ejecutar]
	: BORRAR PUNTO_COMA
	{
		if(ejecutar)
			System.out.printf("\33[2J");
	}
	;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re);
		 }
		
		
lugar
	[boolean ejecutar]
	{Expresion x, y;}
	: LUGAR PARENT_IZ x=expresion[ejecutar] COMA y=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		double valx = Double.parseDouble(x._valor);
		double valy = Double.parseDouble(y._valor);
		if(ejecutar)
			System.out.printf("\033[%d;%dH",(int)valx,(int)valy);
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }



//-------------------------------------------------------------------------------------------
//Sentencias del mundo de wumpus =D

colocarAmbrosia
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	SET_AMBROSIA PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
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
			mostrarExcepcion(re);
		 }
		
colocarFlecha
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	SET_FLECHA PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
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
			mostrarExcepcion(re);
		 }
		
colocarPozo
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	SET_POZO PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
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
			mostrarExcepcion(re);
		 }

colocarWumpus
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	SET_WUMPUS PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
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
			mostrarExcepcion(re);
		 }
		
colocarTesoro
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	SET_TESORO PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
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
			mostrarExcepcion(re);
		 }

colocarJugador
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	SET_JUGADOR PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.setPlayer(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }

eliminarWumpus
	[boolean ejecutar]
	{Expresion e1, e2;}
	:
	DEL_WUMPUS PARENT_IZ e1=expresion[ejecutar] COMA e2=expresion[ejecutar] PARENT_DE PUNTO_COMA
	{
		if(e1.tipo.equals("cadena") || e2.tipo.equals("cadena"))
		{
			System.err.println("Se esperaba expresion numérica , no alfanumérica");
			throw new RecognitionException();
		}
		else if(ejecutar)
		{
			int valX = (int)Double.parseDouble(e1._valor);
			int valY = (int)Double.parseDouble(e2._valor);
			interfaz.eraseWumpus(valX, valY);
		}
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }

sentenciaWumpus
	[boolean ejecutar]
	:
		colocarPozo[ejecutar]
		|colocarWumpus[ejecutar]
		|colocarAmbrosia[ejecutar]
		|colocarFlecha[ejecutar]
		|colocarTesoro[ejecutar]
		|colocarJugador[ejecutar]
		|eliminarWumpus[ejecutar]
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
//-------------------------------------------------------------------------------------------
//Sentencias de configuración del mundo de wumpus


sentenciasConf
	{
		Expresion x, y, xP, yP, vidas, flechas;
	}
	:
	CONF_X x=expresion[true]
	CONF_Y y=expresion[true]
	CONF_XPlayer xP=expresion[true]
	CONF_YPlayer yP=expresion[true]
	CONF_vidas vidas=expresion[true]
	CONF_flechas flechas=expresion[true]
	{
		if(x.tipo.equals("cadena")
			|| y.tipo.equals("cadena")
			|| xP.tipo.equals("cadena")
			|| yP.tipo.equals("cadena")
			|| vidas.tipo.equals("cadena")
			|| flechas.tipo.equals("cadena"))
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
		interfaz=new Inicio(valy, valx, valxP, valyP, valVidas, valFlechas);
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
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
		;
	exception
 		catch [RecognitionException re] {
 			if(ejecutar)
			mostrarExcepcion(re);
		 }
		

//-------------------------------------------------------------------------------------------
//Programa general
prog: 
	CONFIGURACION
		sentenciasConf
	EJECUCION
		(instruccion[true])+
	FIN
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }




