
FUENTES_AUXILIARES_LEXICOS = Analex.java AnalexTokenTypes.java
FUENTES_AUXILIARES_SINTACTICOS = Anasint.java  AnasintTokenTypes.java
TABLA_SIMBOLOS = src/ANTLR/Variable.java src/ANTLR/TablaSimbolos.java
FUENTES_INTERFAZ= src/Interfaz/Inicio.java src/Interfaz/BorraMina.java src/Interfaz/ImagePanel.java src/Interfaz/Jugador.java src/Interfaz/MiKeyListener.java src/Interfaz/Tecla.java src/Interfaz/Wumpus.java
CLASS = Analex.class Anasint.class  AnalexTokenTypes.class AnasintTokenTypes.class Test.class BorraMina.class ImagePanel.class Inicio.class Jugador.class MiKeyListener.class Tecla.class Wumpus.class UndefinedIdentException.class WrongTypeException.class
SMAP = Analex.smap  Anasint.smap
TXT = AnalexTokenTypes.txt AnasintTokenTypes.txt
FUENTES_EXCEPCIONES= UndefinedIdentException.java WrongTypeException.java

Test.class: src/ANTLR/Test.java $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(TABLA_SIMBOLOS) $(FUENTES_INTERFAZ) $(FUENTES_EXCEPCIONES)
	javac src/ANTLR/Test.java $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(FUENTES_INTERFAZ)

$(FUENTES_AUXILIARES_SINTACTICOS) AnasintTokenTypes.txt: src/ANTLR/Anasint.g
	java antlr.Tool src/ANTLR/Anasint.g


$(FUENTES_AUXILIARES_LEXICOS): src/ANTLR/Analex.g AnasintTokenTypes.txt
	java antlr.Tool src/ANTLR/Analex.g

clean:
	rm -f $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(CLASS) $(SMAP) $(TXT)


