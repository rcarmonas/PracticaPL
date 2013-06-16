FUENTES_AUXILIARES_LEXICOS = Analex.java AnalexTokenTypes.java
FUENTES_AUXILIARES_SINTACTICOS = Anasint.java  AnasintTokenTypes.java
TABLA_SIMBOLOS = ANTLR/Variable.java ANTLR/TablaSimbolos.java
FUENTES_INTERFAZ= Interfaz/Inicio.java Interfaz/BorraMina.java Interfaz/ImagePanel.java Interfaz/Jugador.java Interfaz/MiKeyListener.java Interfaz/Tecla.java Interfaz/Wumpus.java
SMAP = Analex.smap  Anasint.smap
TXT = AnalexTokenTypes.txt AnasintTokenTypes.txt
FUENTES_EXCEPCIONES= Excepciones/UndefinedIdentException.java Excepciones/WrongTypeException.java

Test.class: ANTLR/Test.java $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(TABLA_SIMBOLOS) $(FUENTES_INTERFAZ) $(FUENTES_EXCEPCIONES)
	javac ANTLR/Test.java $(FUENTES_AUXILIARES_LEXICOS) $(FUENTES_AUXILIARES_SINTACTICOS) $(TABLA_SIMBOLOS) $(FUENTES_INTERFAZ) $(FUENTES_EXCEPCIONES)
	mv *.class *.java $(SMAP) $(TXT) ANTLR
$(FUENTES_AUXILIARES_SINTACTICOS) AnasintTokenTypes.txt: ANTLR/Anasint.g
	java antlr.Tool ANTLR/Anasint.g


$(FUENTES_AUXILIARES_LEXICOS): ANTLR/Analex.g AnasintTokenTypes.txt
	java antlr.Tool ANTLR/Analex.g
