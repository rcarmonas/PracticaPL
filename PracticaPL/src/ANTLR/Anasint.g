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
	private class Expresion
	{
		public String tipo;
		public String _valor;
	}	
	private TablaSimbolos tablaSimbolos;
	
	public void setTablaSimbolos(TablaSimbolos t)
	{
		tablaSimbolos = t;	
	}
	
	public TablaSimbolos getTablaSimbolos()
	{
		return tablaSimbolos;
	}
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
		
	private String tipo(String nombre)
		{
			int indice = tablaSimbolos.existeSimbolo(nombre);
			
			Variable aux = tablaSimbolos.getSimbolo(indice);
		
			return aux.getTipo();
		}
}

//Reglas:

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
	 		System.out.println("Asignación =>" + nombre + "=" + e._valor);
		}	
	)
	PUNTO_COMA
	;
		
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
	{System.out.println("Identificador=>" + resultado);}
	
	;
		
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
	 	{System.out.println("Expresion=>" + resultado._valor);}
	;
		
		
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
	{System.out.println("ExpresionNum=>" + resultado);}
	
	;


sumando
    //Valor que devuelve
	returns [double resultado = (double)0.0;]
	//Variables locales
	{double e1=-1, e2=-1;}
	: (e1=factor{resultado = e1;})
	(
		//Suma
		(
			OP_PRODUCTO e2 = factor
			{
				resultado = resultado * e2;	
			}
		)
		|
		(//Resta
			OP_DIVISION e2 = factor
				{
					resultado = resultado / e2;
				}
		)
	)*
	{System.out.println("Sumando=>" + resultado);}
	;

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
	{System.out.println("ExpresionAlfa=>" + resultado);}
	;
		
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
		{System.out.println("FactorAlfa=>" + resultado);}
	
		;
		
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
	   ))
	   	{System.out.println("factor=>" + resultado);}
		;


		
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

lectura : leer | leerCadena
		;

escribir 
		//Variables locales
		{double e;}
		: ESCRIBIR PARENT_IZ e=expresionNum PARENT_DE PUNTO_COMA
		{
			System.out.println(String.valueOf(e));
		}
		;

escribirCadena 
		//Variables locales
		{String s;}
		: ESCRIBIR_CADENA PARENT_IZ s=expresionAlfaNum PARENT_DE PUNTO_COMA
		{
			System.out.println(s);
		}
		;
		
escritura : escribir | escribirCadena
		;

instruccion : escritura | lectura | asignacion | sentencia_si | bucle_mientras
		;


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
	{System.out.println("CondiciónNum=>" + resultado);}
	;


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
	{System.out.println("CondiciónAlfa=>" + resultado);}
	;

condicion
	//Valor devuelto
	returns [boolean resultado = false;]
	//Variables locales
	{boolean b;}
	: (b=condicionAlfaNum)|(b=condicionNum)
	{
		resultado = b;
		System.out.println("Condicion=>" +  resultado);
	}
	;


sentencia_si
	// Variable local
	 {boolean valor;}
	 : SI valor=condicion
	   ENTONCES 
		(
		 // Si la condición es verdadera, se ejecuta el consecuente
		 {valor==true}? (instruccion)+
		 // Si hay parte alternativa, se omite
			(
			  SI_NO
				 (options {greedy=false;}:.)+
			)?
		|
		 // Si la condición es false, se omite el consecuente
  		  {valor==false}? (options {greedy=false;}:.)+

		 // Si hay parte alternativa, se ejecuta
			(
			 SI_NO
				(instruccion)+
			)?
		)
		FIN_SI
	;

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
			 {valor == false}? (options {greedy=false;}:.)*  FIN_MIENTRAS

			  // Si la condición es verdadera, se ejecutan las instrucciones del bucle
			| {valor == true}? (instruccion)+  FIN_MIENTRAS
				// Se indica que se repita la ejecución del bucle_mientras
				{
				rewind(marca); 
				this.bucle_mientras();
				}
			) // Fin de las alternativas
		
		;

prog: (instruccion)+
	;





