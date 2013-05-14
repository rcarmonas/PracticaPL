/*
	Trabajo de Prácticas: Procesadores de Lenguaje
		Rafael Carmona Sánchez
		Antonio Cubero Fernández
		José Manuel Herruzo Ruiz
	Analizador léxico.
*/


header{package ANTLR;}
class Analex extends Lexer;


options{
	importVocab = Anasint;

	// Se indica que los literales se comprueben localmente
	testLiterals=false;

	// lookahead: número de símbolos de anticipación
	k=3;

	// No se tiene en cuenta la diferencia entre mayúsculas y minúsculas en los identificadores
	caseSensitive=false;

	// No se tiene en cuenta la diferencia entre mayúsculas y minúsculas en los literales (palabras reservadas)
	caseSensitiveLiterals = false;
}
// FIN DE LA ZONA DE OPCIONES DEL ANALIZADOR LEXICO


// DECLARACION DE TOKENS PREDEFINIDOS

tokens
{
	//Palabras reservadas
	LEER = "leer";
	LEER_CADENA = "leer_cadena";
	ESCRIBIR = "escribir";
	ESCRIBIR_CADENA = "escribir_cadena";
    ENTONCES = "entonces";
    FIN_SI = "fin_si";
	MIENTRAS = "mientras";
	HACER = "hacer";
	FIN_MIENTRAS = "fin_mientras";
	REPETIR = "repetir";
	HASTA = "hasta";
	PARA = "para";
	DESDE = "desde";
	PASO = "paso";
	FIN_PARA = "fin_para";
	BORRAR = "borrar";
	LUGAR = "lugar";

	// Literales lógicos
	LIT_CIERTO = "true" ;
	LIT_FALSO = "false" ;

	// Literales numericos
	LIT_REAL ; 
	LIT_ENTERO;
	
}
// FIN DE LA DECLARACION DE TOKENS PREDEFINIDOS
{		
	private TablaSimbolos tablaSimbolos = new TablaSimbolos();
	
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
			}
			// Si no lo encuentra, lo inserta en la tabla de símbolos
			else
			{
				// Se crea la variable
				Variable v = new Variable (nombre,"float",valorCadena);

				// Se inserta la variable en la tabla de símbolos
				tablaSimbolos.insertarSimbolo(v);
			}
		}
		
	private String getTipo(String nombre)
		{
			
			int indice = tablaSimbolos.existeSimbolo(nombre);
			if(indice<0)
				return null;
			else
			{
				Variable aux = tablaSimbolos.getSimbolo(indice);
			
				return aux.getTipo();
			}
		}
}

// ZONA DE REGLAS

// Tipos de retorno de carro o salto de línea
protected NL :
	(
		// MS-DOS
		// Se usa un predicado sintáctico para resolver el conflicto
		 ("\r\n") => "\r\n" 

		// UNIX
		| '\n'

		// MACINTOSH
		| '\r' 	

	)
		{ newline(); }
	;

// Regla para ignorar los blancos.

BLANCO :
		 ( ' '
		 | '\t'
		 | NL
		 ) 	 { $setType(Token.SKIP); }
		 ;

//  Letras
protected LETRA : 'a'..'z'
		// Se comenta esta línea porque se ha usado la opción caseSensitive=false;
//		| 'A'..'Z'
		;
		


// Dígitos 
protected DIGITO : '0'..'9'
                 ;

// Regla para reconocer los identificadores y palabras reservadas
IDENT
	// Se indica que se compruebe si un identificador es una palabra reservada
	options {testLiterals=true;} 
	: LETRA(LETRA|DIGITO|('_'(LETRA|DIGITO)))*
	{
		String aux = $getText;
		String tipo = getTipo(aux);
		//System.out.println("Identificador: " + tipo + " " + aux);
		if(tipo != null)
		{
			if(tipo.equals("cadena"))
				$setType(IDEN_CADENA);
			else if(tipo.equals("numero"))
				$setType(IDEN_NUMERO);
		}
	}
	;
SI : "si"
	;

SI_NO : "si_no"
	;

//Operadores lógicos y de módulo:
MOD : "__mod"
	;

OP_O : "__o"
	;

OP_Y : "__y"
	;

OP_NO : "__no"
	;

//Número:
LIT_NUMERO :
		((DIGITO)+'.') => (DIGITO)+'.'(DIGITO)* ('e'( '+' | '-' )? (DIGITO)+ )?
		| (DIGITO)+
       ;
      
// Cadena que permite incluir saltos de línea
LIT_CADENA: '\''! 
                ( options {greedy=false;}: ~('\\')
                 | "\\\'")* 
            '\''!
          ;

//Operadores aritméticos

OP_MAS : '+'
	;

OP_MENOS : '-'
	;
	
OP_PRODUCTO : '*'
	;
	
OP_DIVISION : '/'
	;

OP_POTENCIA : "**"
	;

// Separadores 
PUNTO_COMA : ';' 
	;

COMA : ','
	;

//Operadores relacionales
OP_IGUAL : "==" 
	 ;

OP_DISTINTO : "<>" 
	    ;

OP_ASIG : '=' 
	;

OP_MENOR : '<' 
	 ;

OP_MAYOR : '>' 
	 ;

OP_MENOR_IGUAL : "<=" 
	       ;

OP_MAYOR_IGUAL : ">=" 
	       ;

//Operadores adicionales

OP_INCREMENTO : "++" 
	      ;
OP_DECREMENTO : "--" 
	      ;
	      
PARENT_IZ : "("
		;

PARENT_DE : ")"
		;
		
CORCH_IZ : "["
		;

CORCH_DE : "]"
		;

//Comentarios:
protected COMENTARIO1: '#' (~ ('\n'|'\r') )*	
		     ;

protected COMENTARIO2: 
			'{'
			   (options {greedy=false;} : . )* 
		        '}'			 
   		      ; 
// Los comentarios se ignoran
COMENTARIO:
	  (
	    COMENTARIO1 
	  | COMENTARIO2 
          )		{ $setType(Token.SKIP); }
	  ;


// FIN DE LA ZONA DE REGLAS LEXICAS
