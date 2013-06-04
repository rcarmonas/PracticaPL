#Calculadora en pseudocódigo
mientras (verdadero) hacer
	borrar;
	escribir_cadena('Elige operacion: ');
	lugar(2, 5);
	escribir_cadena('1.-Suma');
	lugar(3,5);
	escribir_cadena('2.-Resta');
	lugar(4, 5);
	escribir_cadena('3.-Producto');
	lugar(5,5);
	escribir_cadena('4.-Division');
	lugar(6, 5);
	escribir_cadena('5.-Potencia');
	lugar(7,5);
	escribir_cadena('6.-Raiz Cuadrada');
	lugar(8,0);
	leer(eleccion);
	
	si(eleccion==1) entonces #Suma
		borrar;
		lugar(1, 30);
		escribir_cadena('Suma');
		lugar(2, 0);
		escribir_cadena('Introduzca primer sumando: ');
		leer(n1);
		lugar(3, 0);
		escribir_cadena('Introduzca segundo sumando: ');
		leer(n2);
		lugar(4,0);
		escribir_cadena('El resultado es: ');
		escribir(n1 + n2);
	fin_si;
	si(eleccion==2) entonces #Resta
		borrar;
		lugar(1, 30);
		escribir_cadena('Resta');
		lugar(2, 0);
		escribir_cadena('Introduzca primer operando: ');
		leer(n1);
		lugar(3, 0);
		escribir_cadena('Introduzca segundo operando: ');
		leer(n2);
		lugar(4,0);
		escribir_cadena('El resultado es: ');
		escribir(n1 - n2);
	fin_si;
	si(eleccion==3) entonces #Producto
		borrar;
		lugar(1, 30);
		escribir_cadena('Producto');
		lugar(2, 0);
		escribir_cadena('Introduzca primer operando: ');
		leer(n1);
		lugar(3, 0);
		escribir_cadena('Introduzca segundo operando: ');
		leer(n2);
		lugar(4,0);
		escribir_cadena('El resultado es: ');
		escribir(n1 * n2);
	fin_si;
	si(eleccion==4) entonces #Division
		borrar;
		lugar(1, 30);
		escribir_cadena('Division');
		lugar(2, 0);
		escribir_cadena('Introduzca primer operando: ');
		leer(n1);
		lugar(3, 0);
		escribir_cadena('Introduzca segundo operando: ');
		leer(n2);
		lugar(4,0);
		escribir_cadena('El resultado es: ');
		escribir(n1 / n2);
	fin_si;
	si(eleccion==5) entonces #Potencia
		borrar;
		lugar(1, 30);
		escribir_cadena('Potencia');
		lugar(2, 0);
		escribir_cadena('Introduzca primer operando: ');
		leer(n1);
		lugar(3, 0);
		escribir_cadena('Introduzca segundo operando: ');
		leer(n2);
		lugar(4,0);
		escribir_cadena('El resultado es: ');
		escribir(n1 ** n2);
	fin_si;
	si(eleccion==6) entonces #Raiz cuadrada
				borrar;
		lugar(1, 30);
		escribir_cadena('Resta');
		lugar(2, 0);
		escribir_cadena('Introduzca operando: ');
		leer(n1);
		lugar(3,0);
		escribir_cadena('El resultado es: ');
		escribir(n1 ** 0.5);
	fin_si;
	
	escribir_cadena('Pulse una tecla para continuar o escape para salir ');
	tecla = leer_tecla;
	si (tecla == :scape) entonces
		sal = pregunta('Desea salir?');
		si(sal == 0) entonces
			salir;
		fin_si;
	fin_si;
fin_mientras;