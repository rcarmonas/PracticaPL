header{
	package ANTLR;
}

class MicroCalcLexer extends Lexer;

BLANCO : (' ' | '\t')
		{ $setType(Token.SKIP); };

OP_MAS : '+';

OP_MENOS: '-';

OP_PRODUCTO: '*';

OP_COCIENTE: '/';

PARENT_AB: '(';

PARENT_CE: ')';

NUMERO: ('0'..'9')+('.'('0'..'9')+)?;

class MicroCalcParser extends Parser;
options{
	buildAST = true;
}

expresion: expSuma;

expSuma: expResta (OP_MAS^ expResta)*;

expResta: expProducto (OP_MENOS^ expProducto)*;

expProducto: expCociente (OP_PRODUCTO^ expCociente)*;

expCociente: expBase (OP_COCIENTE^ expBase)*;

expBase: NUMERO
	| PARENT_AB! expresion PARENT_CE!
	;

class MicroCalcTreeParser extends TreeParser;

expresion returns [float result=0]
{ float izq=0,der=0; }
	: n:NUMERO
		{ result = new Float(n.getText()).floatValue(); }
	| #(OP_MAS izq=expresion der=expresion)
		{ result = izq+der; }
	| #(OP_MENOS izq=expresion der=expresion)
		{ result = izq-der; }
	| #(OP_PRODUCTO izq=expresion der=expresion)
		{ result =izq*der; }
	| #(OP_COCIENTE izq=expresion der=expresion)
		{
		if(der==0.0)
			throw new ArithmeticException("Division por cero");
		result=izq/der;
		}
	;