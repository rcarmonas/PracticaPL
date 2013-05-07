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
	//importVocab = Anasint;

	// Se indica que los literales se comprueben localmente
	testLiterals=false;

	// lookahead: número de símbolos de anticipación
	k=2;

	// No se tiene en cuenta la diferencia entre mayúsculas y minúsculas en los identificadores
	caseSensitive=false;

	// No se tiene en cuenta la diferencia entre mayúsculas y minúsculas en los literales (palabras reservadas)
	caseSensitiveLiterals = false;
}
// FIN DE LA ZONA DE OPCIONES DEL ANALIZADOR LÉXICO

// DECLARACIÓN DE TOKENS PREDEFINIDOS

tokens
{
	//Palabras reservadas
	MOD = "__mod";
	O = "__o";
	Y = "__y";
	NO = "__no";
	LEER = "leer";
	LEER_CADENA = "leer_cadena";
	ESCRIBIR = "escribir";
	ESCRIBIR_CADENA = "escribir_cadena";
	SI = "si";
	ENTONCES = "entonces";
	SINO = "si_no";
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
	LIT_CADENA;
}
// FIN DE LA DECLARACIÓN DE TOKENS PREDEFINIDOS

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
	;

//Número:
LIT_NUMERO :
		((DIGITO)+'.') => (DIGITO)+'.'(DIGITO)* ('e'( '+' | '-' )? (DIGITO)+ )?	{$setType(LIT_REAL);}
		| (DIGITO)+	{$setType(LIT_ENTERO);}
       ;
      
// Cadena que permite incluir saltos de línea
LIT_CADENA: '\''! 
                ( options {greedy=false;}: ~('\\')
                 | "\\\'")* 
            '\''!
          ;

//Operadores aritméticos

OP_SUMA : '+'
	;

OP_RESTA : '-'
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


// FIN DE LA ZONA DE REGLAS LÉXICAS
