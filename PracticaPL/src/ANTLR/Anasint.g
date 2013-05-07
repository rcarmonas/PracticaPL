/*
 Ejemplo 5

	Incluye 
	Se ha incluido un contador de instrucciones reconocidas

	Gramatica de las expresiones aritmeticas.

	El analizador lexico y el analizador sintactico 
	estan definidos en ficheros diferentes

	Este fichero contiene la definicion del analizador sintactico
*/


// Analizador sintáctico

class Anasint extends Parser;

options 
{
	// Se exporta el vocabulario de componentes lexicos 
	// utilizado en el analisis sintactico
	exportVocab = Anasint;

}

// Nuevos atributos de la clase Anasint
{
  // Atributo de Anasint para contar las instrucciones reconocidas
  int contador = 0;
}

// Zona de reglas gramaticales
tipo : TIPO_REAL
		| TIPO_VOID
		| TIPO_ENTERO
		| TIPO_BOOLEANO
		{
			System.out.println("Reconocido tipo");
		}
		;
		
operador_logico : OP_Y
					| OP_O
					| OP_IGUAL
					| OP_DISTINTO
					| OP_MENOR
					| OP_MAYOR
					| OP_MENOR_IGUAL
					| OP_MAYOR_IGUAL
	;

funcion : tipo IDENT PARENT_IZ  (parametros)? PARENT_DE LLAVE_IZ instrucciones LLAVE_DE
	;
	
parametro: tipo (OP_PRODUCTO)* IDENT
	 ;
parametros: parametro (COMA parametro)* 
          ;

declaracion: tipo lista_identificadores PUNTO_COMA
			{
				System.out.println("Reconocida sentencia de declaración");
			}
            ;

lista_identificadores: (OP_PRODUCTO)* IDENT (COMA (OP_PRODUCTO)* IDENT)*
	;

asignacion : IDENT (componentes)? OP_ASIG expresion PUNTO_COMA
	;

do_while : RES_HACER LLAVE_IZ instrucciones LLAVE_DE RES_MIENTRAS condicion PUNTO_COMA
	;

condicion : PARENT_IZ expresion operador_logico expresion PARENT_DE
	;

si_entonces : RES_SI condicion LLAVE_IZ instrucciones LLAVE_DE (RES_SI_NO LLAVE_IZ instrucciones LLAVE_DE)?
	;

instrucciones :
	      (
		      ( 
			// Se usa un predicado sintactico para resolver el conflicto
			(IDENT OP_ASIG) => asignacion
		      | declaracion
		      | do_while
		      | si_entonces
		      )
			// Acción semántica
			{
				contador++;
				System.out.println("Reconocida la instrucción nº "+ contador);
			}
              )*
	      ;







expresion : sumando ( (OP_MAS | OP_MENOS) sumando)* 
          ;

sumando : factor ( ( OP_PRODUCTO| OP_DIVISION) factor)* 
         ;

componentes: (componente)+
	   ;

componente: CORCHETE_IZ expresion CORCHETE_DE
           ;

factor: NUMERO
      | IDENT (componentes)?
      | PARENT_IZ expresion PARENT_DE
      ;

