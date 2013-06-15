
FUENTES_AUXILIARES_LEXICOS = src/ANTLR/Analex.java src/ANTLR/AnalexTokenTypes.java
FUENTES_AUXILIARES_SINTACTICOS = src/ANTLR/Anasint.java  src/ANTLR/AnasintTokenTypes.java src/ANTLR/Variable.java src/ANTLR/TablaSimbolos.java
FUENTES_INTERFAZ= src/Interfaz/Inicio.java src/Interfaz/BorrarMina.java src/Interfaz/ImagePanel.java src/Interfaz/Jugador.java src/Interfaz/MiKeyListener.java src/Interfaz/Tecla.java src/Interfaz/Wumpus.java
CLASS = Analex.class Anasint.class  AnalexTokenTypes.class AnasintTokenTypes.class Test.class BorrarMina.class ImagePanel.class Inicio.class Jugador.class MiKeyListener.class Tecla.class Wumpus.class
SMAP = src/ANTLR/Analex.smap  src/ANTLR/Anasint.smap
TXT = src/ANTLR/AnalexTokenTypes.txt src/ANTLR/AnasintTokenTypes.txt

Test.class: src/ANTLR/Test.java $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(FUENTES_INTERFAZ)
	javac src/ANTLR/Test.java $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(FUENTES_INTERFAZ)

$(FUENTES_AUXILIARES_SINTACTICOS) AnasintTokenTypes.txt: Anasint.g
	java antlr.Tool src/ANTLR/Anasint.g


$(FUENTES_AUXILIARES_LEXICOS): Analex.g AnasintTokenTypes.txt
	java antlr.Tool src/ANTLR/Analex.g

clean:
	rm -f $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(CLASS) $(SMAP) $(TXT)

