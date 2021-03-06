<config>
 	@xtamano 13
 	@ytamano 13
 	@xjugador 0
 	@yjugador 0
 	@vidas 3
 	@flechas 1
 	@xwumpus aleatorio(10)
 	@ywumpus aleatorio(10)
 	@wvidas 1
 	@mod 'Mario'
<ejecutar>
colocar_salida(0,0);
#Colocamos el wumpus
repetir
	colocar_wumpus(aleatorio(@xtamano), aleatorio(@ytamano));
hasta (@resultado);
#Colocamos una mina
para i desde 0 hasta 2 paso 1 hacer
	repetir
		colocar_mina(aleatorio(@xtamano), aleatorio(@ytamano));
	hasta (@resultado);
fin_para;
#Colocamos la ambrosia
repetir
	colocar_ambrosia(aleatorio(@xtamano), aleatorio(@ytamano));
hasta (@resultado);
#Colocamos una flecha
repetir
	colocar_flecha(aleatorio(@xtamano), aleatorio(@ytamano));
hasta (@resultado);
#Colocamos 8 pozos:
para i desde 0 hasta 8 paso 1 hacer
	repetir
		colocar_pozo(aleatorio(@xtamano), aleatorio(@ytamano));
	hasta (@resultado);
fin_para;
#Colocamos tesoro
repetir
	colocar_tesoro(aleatorio(@xtamano), aleatorio(@ytamano));
hasta (@resultado);
#Colocamos la salida en el lugar inicial
#Bucle principal
escribir('Para jugar, use las teclas de direccion');
vivo = 1;
mientras (vivo==1) hacer
 	tecla = leer_tecla;
 	si(tecla==:derecha __o tecla==:abajo __o tecla==:izquierda __o tecla==:arriba) entonces
 		 mover_jugador(tecla);
 		 si(@resultado) entonces
	 		 casilla = info_casilla;
	 		 si(@vidas <= 0) entonces
	 		 	vivo = 0;
	 		 	mensaje('Has muerto! :(');
	 		 	salir;
	 		 si_no
	 		 	si(hay_salida(casilla) __y @tesoro) entonces
	 		 		mensaje('Has ganado! :D');
	 		 		salir;
	 		 	fin_si;
	 		 fin_si;
	 		 si(hay_tesoro(casilla)) entonces
	 		 	escribir('Enhorabuena! Ha encontrado el tesoro');
	 		 fin_si;
	 		 si(hay_ambrosia(casilla)) entonces
	 		 	escribir('Enhorabuena! Ha encontrado una ambrosia');
	 		 fin_si;
	 		 si(hay_mina(casilla)) entonces
	 		 	escribir('Ha pisado una mina!');
	 		 fin_si;
	 		 si(hay_pozo(casilla)) entonces
	 		 	escribir('Ha caido en un pozo!');
	 		 fin_si;
	 		 si(hay_wumpus(casilla)) entonces
	 		 	escribir('El wumpus te ha comido!!');
	 		 fin_si;
	 	fin_si;
 	si_no
 		si(tecla==:scape) entonces
 			respuesta = pregunta('Desea salir del juego?');
 			si(respuesta==0) entonces
 				salir;
 			fin_si;
 		si_no
	 		si(tecla==:espacio) entonces
	 			escribir('Pulse la direccion para disparar');
	 			tecla2 = leer_tecla;
	 			si(tecla2==:derecha __o tecla2==:abajo __o tecla2==:izquierda __o tecla2==:arriba) entonces
	 				disparar(tecla2);
	 				si(@resultado) entonces
	 					escribir('Se ha oido un chillido de dolor!');
	 				fin_si;
	 			si_no
	 				escribir('Se esperaba una direccion');
	 			fin_si;
	 		fin_si;
	 	fin_si;
 	fin_si;
	 #Movemos el wumpus en una direccion aleatoria:
	 mover_wumpus(direccion_aleatoria);
fin_mientras;
<fin>
