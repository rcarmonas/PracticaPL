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
	charVocabulary = '\3'..'\377';
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
	

	//Wumpus:
	SET_POZO = "colocar_pozo";
	SET_WUMPUS = "colocar_wumpus";
	SET_AMBROSIA ="colocar_ambrosia";
	SET_FLECHA = "colocar_flecha";
	SET_TESORO = "colocar_tesoro";
	SET_JUGADOR = "colocar_jugador";
	SET_MINA = "colocar_mina";
	SET_SALIDA = "colocar_salida";
	PAUSA = "pausa";
	MOVER_JUGADOR = "mover_jugador";
	MOVER_WUMPUS = "mover_wumpus";
	ALEATORIO = "aleatorio";
	DIR_ALEATORIO = "direccion_aleatoria";
	LEER_TECLA="leer_tecla";
	INFO_CASILLA="info_casilla";
	
	//Comprobación de casillas:
	HAY_WUMPUS = "hay_wumpus";
	HAY_TESORO = "hay_tesoro";
	HAY_JUGADOR = "hay_jugador";
	HAY_FLECHA = "hay_flecha";
	HAY_AMBROSIA = "hay_ambrosia";
	HAY_POZO = "hay pozo";
	HAY_VIENTO = "hay_viento";
	HAY_OLOR = "hay_olor";
	HAY_MINA = "hay_mina";
	HAY_SALIDA = "hay_salida";
	OCULTO = "oculto";
	
	// Literales lógicos
	LIT_CIERTO = "verdadero" ;
	LIT_FALSO = "falso" ;

	// Literales numericos
	LIT_REAL ; 
	LIT_ENTERO;
	
}
// FIN DE LA DECLARACION DE TOKENS PREDEFINIDOS


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

OP_CONCATENACION : "||"
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

CONFIGURACION : "<config>"
	;

EJECUCION : "<ejecutar>"
	;

FIN: "<fin>"
	;

CONF_X : "@xtamano"
	;

CONF_Y : "@ytamano"
	;

CONF_XPlayer: "@xjugador"
	;

CONF_YPlayer: "@yjugador"
	;

CONF_flechas: "@flechas"
	;

CONF_vidas: "@vidas"
	;
	
DERECHA: ":derecha"
	;
IZQUIERDA: ":izquierda"
	;
ARRIBA: ":arriba"
	;
ABAJO: ":abajo"
	;
ESPACIO: ":espacio" //32
	;
ESCAPE: ":scape" //27
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
