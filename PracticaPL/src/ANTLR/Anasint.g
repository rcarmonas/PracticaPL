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
			} 
		catch (Exception e) 
			{
			}
	}
}

//Reglas:


//Asignación tanto numérica como alfanumérica
asignacion
	//Variable local
	{Expresion e;
	String id;}
	:id=identificador OP_ASIG
	(
		e=expresion
		{	
			String nombre = id;
			insertarIdentificador(nombre, e.tipo, e._valor);
			if(debug)
	 			System.out.println("Asignación =>" + nombre + "=" + e._valor);
		}	
	)
	PUNTO_COMA
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en asignacion");
			mostrarExcepcion(re);
		 }


//Un identificador, tanto sin tipo, como númerico o alfanumérico
identificador
	returns [String resultado ="";]
	:
	(
	i:IDENT{resultado = i.getText();}
	|
	ic:IDEN_CADENA{resultado = ic.getText();}
	|
	in:IDEN_NUMERO{resultado = in.getText();}
	)
	{if(debug)System.out.println("Identificador=>" + resultado);}
	
	;
	exception
 		catch [RecognitionException re] {
 			 if(debug)System.out.println("Error en identificador");
			mostrarExcepcion(re);
		 }

//Expresión, tanto numérica como alfanumérica	
expresion
	returns [Expresion resultado = new Expresion();]
	{double n; String c;}
	:	
	(
	c=expresionAlfaNum
	{
		resultado.tipo = "cadena";
		resultado._valor = c;
	}
	 |
	 n=expresionNum
	 {
	 	resultado.tipo = "numero";
		resultado._valor = String.valueOf(n);
	 }
	 )
	 	{if(debug)System.out.println("Expresion=>" + resultado._valor);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en expresion");
			mostrarExcepcion(re);
		 }		
		
//Expresión numérica
expresionNum 
	//Valor que devuelve
	returns [double resultado = (double)0.0;]
	//Variables locales
	{double e1, e2;}
	: e1=sumando{resultado = e1;}
	(
		//Suma
		(
			OP_MAS e2 = sumando
			{
				resultado = resultado + e2;	
			}
		)
		|
		(//Resta
			OP_MENOS e2 = sumando
				{
					resultado = resultado - e2;
				}
		)
	)*
	{if(debug)System.out.println("ExpresionNum=>" + resultado);}
	
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en expresionNum");
			mostrarExcepcion(re);
		 }


sumando
    //Valor que devuelve
	returns [double resultado = (double)0.0;]
	//Variables locales
	{double e1=-1, e2=-1;}
	: (e1=factor{resultado = e1;})
	(
		//Producto
		(
			OP_PRODUCTO e2 = factor
			{
				resultado = resultado * e2;	
			}
		)
		|
		(//División
			OP_DIVISION e2 = factor
				{
					resultado = resultado / e2;
				}
		)
		|
		(//Módulo
			MOD e2 = factor
				{
					resultado = (int)resultado % (int)e2;
				}
		)
	)*
	{if(debug)System.out.println("Sumando=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en sumando");
			mostrarExcepcion(re);
		 }
		
//Expresión alfanumérica
expresionAlfaNum
	//Valor que devuelve
	returns [String resultado = "";]
	//Variables locales
	{String e1, e2;}
	: e1=factorAlfaNum{resultado = e1;}
		//Suma
		(
			OP_MAS e2 = factorAlfaNum
			{
				resultado = resultado + e2;	
			}
		)*
	{if(debug)System.out.println("ExpresionAlfa=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en expresion Alfa_num");
			mostrarExcepcion(re);
		 }
				
factorAlfaNum
	//Valor que devuelve
	returns [String resultado = "";]
	//Variables locales
	{String e;}
	:
	((
		l:LIT_CADENA
		{
			resultado = l.getText();	
		}
	)|(
		i:IDEN_CADENA
		{
			// Busca el identificador en la tabla de símbolos
			int indice = tablaSimbolos.existeSimbolo(i.getText());
			// Si encuentra el identificador, devuelve su valor
			if (indice >= 0)
			{
				// Se recupera el valor almacenado como cadena
				String valorCadena = tablaSimbolos.getSimbolo(indice).getValor();

				// La cadena se convierte a número real
				resultado = valorCadena;
			}
			else
				System.err.println("Error: el identificador " + i.getText() + " está indefinido");
		})
	)
		{if(debug)System.out.println("FactorAlfa=>" + resultado);}
	
		;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en factorAlfaNum");
			mostrarExcepcion(re);
		 }
				
factor 
	//Valor que devuelve:
	returns [double resultado = (double)0.0;]
		{double e;}
	: 
	(
		(n:LIT_NUMERO
		{
			{resultado = new Double(n.getText()).doubleValue();}
		}
      )| (
      	i:IDEN_NUMERO
      	{
      					// Busca el identificador en la tabla de símbolos
			int indice = tablaSimbolos.existeSimbolo(i.getText());

			// Si encuentra el identificador, devuelve su valor
			if (indice >= 0)
			{
				// Se recupera el valor almacenado como cadena
				String valorCadena = tablaSimbolos.getSimbolo(indice).getValor();

				// La cadena se convierte a número real
				resultado = Double.parseDouble(valorCadena);
			}
			else
				System.err.println("Error: el identificador " + i.getText() + " está indefinido");
      	}
      )|( PARENT_IZ e=expresionNum PARENT_DE
      	  {
	      	resultado = e;	      	
	      } 
	   )|( OP_MENOS e=factor
	   	{
	   		resultado = -e;
	   	}
	   ) 
	   )
	   	{if(debug)System.out.println("factor=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en factor");
			mostrarExcepcion(re);
		 }

		
leer 
	//Variables locales
	{String id;}
	: LEER PARENT_IZ id=identificador PARENT_DE PUNTO_COMA
	{
		Scanner entrada = new Scanner(System.in);
		int valor = entrada.nextInt();
		//TODO Controlar fallo
		insertarIdentificador(id, "numero", String.valueOf(valor));
	}
		;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en leer");
			mostrarExcepcion(re);
		 }


leerCadena 
	//Variables locales
	{String id;}
	: LEER_CADENA PARENT_IZ id=identificador PARENT_DE PUNTO_COMA
	{
		Scanner entrada = new Scanner(System.in);
		String valorCadena = entrada.next();
		insertarIdentificador(id, "cadena", valorCadena);
	}
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
lectura : leer | leerCadena
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
escribir 
		//Variables locales
		{double e;}
		: ESCRIBIR PARENT_IZ e=expresionNum PARENT_DE PUNTO_COMA
		{
			System.out.println(String.valueOf(e));
		}
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
escribirCadena 
		//Variables locales
		{String s;}
		: ESCRIBIR_CADENA PARENT_IZ s=expresionAlfaNum PARENT_DE PUNTO_COMA
		{
			System.out.println(s);
		}
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
			
escritura : escribir | escribirCadena
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }

instruccion : 
	escritura 
	| lectura 
	| asignacion 
	| sentencia_si
	| bucle_mientras 
	| bucle_repetir 
	| bucle_para
	| borrar
	| lugar
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		


condicionNum
	//Valor devuelto
	returns [boolean resultado = false;]
	//Variables locales
	{double e1=1, e2=1;}
	:
	e1=expresionNum
	((
		OP_IGUAL e2=expresionNum
		{
			resultado = e1==e2;
		}
	)|(
		OP_DISTINTO e2=expresionNum
		{
			resultado = e1!=e2;
		}
	)|(
		OP_MAYOR e2=expresionNum
		{
			resultado = e1>e2;
		}
	)|(
		OP_MENOR e2=expresionNum
		{
			resultado = e1<e2;
		}
	)|(
		OP_MAYOR_IGUAL e2=expresionNum
		{
			resultado = e1>=e2;
		}
	)|(
		OP_MENOR_IGUAL e2=expresionNum
		{
			resultado = e1<=e2;
		}	
	)
	)
	{if(debug)System.out.println("CondiciónNum=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {

 			if(debug)System.out.println("Error en condicionNum");
			mostrarExcepcion(re);
		 }

condicionAlfaNum
	//Valor devuelto
	returns [boolean resultado = false;]
	//Variables locales
	{String s1, s2;}
	:
	s1=expresionAlfaNum
	((
		OP_IGUAL s2=expresionAlfaNum
		{
			resultado = s1.equals(s2);
		}
	)|(
		OP_DISTINTO s2=expresionAlfaNum
		{
			resultado = !s1.equals(s2);
		}
	)
	)
	{if(debug)System.out.println("CondiciónAlfa=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en condicionAlfaNum");
			mostrarExcepcion(re);
		 }
		
		
factor_cond
	//Valor devuelto
	returns [boolean resultado = false;]
	//Variables locales
	{boolean a, b;}
	:(
		(
			(
				(b=condicionAlfaNum)
				|(b=condicionNum)
			)
			{
				resultado = b;
			}
		)
		|
		(
			CORCH_IZ b=condicion CORCH_DE
			{
				resultado = b;
			}
		)
	)
	{if(debug)System.out.println("FactorCondicion=>" +  resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			 if(debug)System.out.println("Error en factor_cond");
			mostrarExcepcion(re);
		 }

sumando_cond
	returns [boolean resultado = false;]
	{boolean a, b;}
	:(a=factor_cond{resultado = a;})
	(
		OP_Y b = factor_cond
		{
			resultado = resultado && b;	
		}
	)*
	{if(debug)System.out.println("Sumando_cond=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
 			if(debug)System.out.println("Error en sumando_cond");
			mostrarExcepcion(re);
		 }
	
	
condicion
	returns [boolean resultado = false;]
	{boolean a,b;}
	:(
		(a=sumando_cond{resultado = a;})
		(
			OP_O b=sumando_cond
			{
				resultado = resultado || b;
			}	
		)*
	)
	|
	(
		OP_NO b=condicion
		{
			resultado = !b;
		}
	)
	{if(debug)System.out.println("Condición=>" + resultado);}
	;
	exception
 		catch [RecognitionException re] {
			if(debug)System.out.println("Error en condicion");
			mostrarExcepcion(re);
		 }

sentencia_si
	// Variable local
	 {boolean valor;}
	 : SI PARENT_IZ valor=condicion PARENT_DE
	   ENTONCES 
		(
		 // Si la condición es verdadera, se ejecuta el consecuente
		 {(valor)==true}? (instruccion)+
		 // Si hay parte alternativa, se omite
			(
			  SI_NO
				 (options {greedy=false;}:.)+
			)?
		|
		 // Si la condición es false, se omite el consecuente
  		  {(valor)==false}? (options {greedy=false;}:.)+
		 // Si hay parte alternativa, se ejecuta
			(
			 SI_NO
				(instruccion)+
			)?
		)
		FIN_SI PUNTO_COMA
			{if(debug)System.out.println("Sentencia if=>" + valor);}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
		
bucle_mientras
		// Variables locales
		{boolean valor; int marca=-1;}
		:
		 // Se establece una marca para indicar el punto de inicio del bucle
		{marca = mark();}
		 MIENTRAS PARENT_IZ valor=condicion PARENT_DE 
		      HACER 

			( // Comienzo de las alternativas

			  // Si la condición es falsa, se omite el cuerpo del bucle
			 {valor == false}? (options {greedy=false;}:.)*  FIN_MIENTRAS PUNTO_COMA

			  // Si la condición es verdadera, se ejecutan las instrucciones del bucle
			| {valor == true}? (instruccion)+  FIN_MIENTRAS PUNTO_COMA
				// Se indica que se repita la ejecución del bucle_mientras
				{
				rewind(marca); 
				this.bucle_mientras();
				}
			) // Fin de las alternativas
		
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
		
bucle_repetir
		// Variables locales
		{boolean valor=true; int marca=-1;}
		:
		 // Se establece una marca para indicar el punto de inicio del bucle
		{marca = mark();}
		 REPETIR
			( // Comienzo de las alternativas
				 (instruccion)+  HASTA valor=condicion PUNTO_COMA
				// Se indica que se repita la ejecución del bucle_mientras
				{
					if(valor)
					{
						rewind(marca); 
						this.bucle_repetir();
					}
				}
			) // Fin de las alternativas
		
		;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
		
cuerpo_bucle_para
	[String id]
	{double h, p, n;
	boolean valor;
	int marca=-1;}
	:
	{
		marca = mark();
		int indice = tablaSimbolos.existeSimbolo(id);
		String valorCadena = tablaSimbolos.getSimbolo(indice).getValor();
		n = Double.parseDouble(valorCadena);
	}
	HASTA h = expresionNum
	PASO p = expresionNum
	{
		if((p<0 && n>h)|(p>0 && n<h))
			valor = true;
		else
			valor = false;
		
	}
	HACER
	( // Comienzo de las alternativas
			  // Si la condición es falsa, se omite el cuerpo del bucle
			 {valor == false}? (options {greedy=false;}:.)*  FIN_PARA PUNTO_COMA
			  // Si la condición es verdadera, se ejecutan las instrucciones del bucle
			| {valor == true}? (instruccion)+  FIN_PARA PUNTO_COMA
				{
				insertarIdentificador(id, "numero", String.valueOf(n+p));
				rewind(marca); 
				this.cuerpo_bucle_para(id);
				}
	) 
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
		
bucle_para
		// Variables locales
		{boolean valor;
		String id;
		double d;
		double h;
		double p;}
		:
		PARA id=identificador
		DESDE d=expresionNum
		{
			insertarIdentificador(id, "numero", String.valueOf(d));
		}
		cuerpo_bucle_para[id]
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
		
borrar: BORRAR PUNTO_COMA
	{
		System.out.printf("\33[2J");
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }
		
		
lugar
	{double x, y;}
	: LUGAR PARENT_IZ x=expresionNum COMA y=expresionNum PARENT_DE PUNTO_COMA
	{
		System.out.printf("\033[%d;%dH",(int)x,(int)y);
	}
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }

prog: (instruccion)+
	;
	exception
 		catch [RecognitionException re] {
			mostrarExcepcion(re);
		 }




