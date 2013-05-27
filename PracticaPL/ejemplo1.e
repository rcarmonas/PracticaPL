{
  Asignatura:    Procesadores de Lenguajes

  Titulación:    Ingeniería Informática
  Curso:         Tercero
  Cuatrimestre:  Segundo

  Departamento:  Informática y Análisis Numérico
  Centro:        Escuela Politécnica Superior de Córdoba
  Universidad de Córdoba
 
  Curso académico: 2012 - 2013

  Fichero de ejemplo para el interprete de pseudocódigo en español: ipe.exe
}

# Bienvenida

borrar;
lugar(10,10);
escribir_cadena('Introduce tu nombre --> ');
leer_cadena(nombre);

borrar;
lugar(10,10);
escribir_cadena(' Bienvenido/a << ');
escribir_cadena(nombre);
escribir_cadena(' >> al intérprete de pseudocódigo en español:\'ipe.exe\'.');

lugar(40,10);
escribir_cadena('Pulsa una tecla para continuar');
leer_cadena(pausa1);


repetir 

 # Opciones disponibles
 borrar;
 lugar(10,10);
 escribir_cadena(' Factorial de un número --> 1 ');
 lugar(11,10);
 escribir_cadena(' Máximo común divisor ----> 2 ');
 lugar(12,10);
 escribir_cadena(' Finalizar ---------------> 0 ');

 lugar(15,10);
 escribir_cadena(' Elige una opcion ');
 leer(opcion);

 borrar;

 si (opcion == 0)       # Fin del programa
   entonces 
        lugar(10,10);
        escribir_cadena(nombre);
        escribir_cadena(': gracias por usar el intérprete ipe.exe ');
   si_no
   
    # Factorial de un número
	si (opcion == 1)
   	    entonces
                lugar(10,10);
		escribir_cadena(' Factorial de un numero  ');
                lugar(11,10);
		escribir_cadena(' Introduce un numero entero ');
		leer(N);
		factorial = 1;
		para i desde 2 hasta N paso 1 hacer
			factorial = factorial * i;
		fin_para;

        # Resultado
        lugar(15,10);
		escribir_cadena(' El factorial de ');
		escribir(N);
		escribir_cadena(' es ');
		escribir(factorial);
    
    # Máximo común divisor
    si_no 
    	escribir_cadena('prueba1');
        si (opcion == 2)
	       entonces
	       			escribir_cadena('prueba2');
                   	lugar(10,10);
					escribir_cadena(' Máximo común divisor de dos números ');
                   	lugar(11,10);
		   			escribir_cadena(' Algoritmo de Euclides ');
                   	lugar(12,10);
		   			escribir_cadena(' Escribe el primer número ');
					leer(a);
                   	lugar(13,10);
					escribir_cadena(' Escribe el segundo número ');
					leer(b);
					
					
					# Se ordenan los números
					si (a < b)
						entonces 
							escribir_cadena('prueba3');
							auxiliar = a;
							a = b;
							b = auxiliar;
					fin_si;
					escribir_cadena('prueba4');
				# Se guardan los valores originales
				A1 = a;
				B1 = b;
					escribir_cadena('prueba5');
				# Se aplica el método de Euclides	
				resto = a  __mod  b;

				mientras (resto <> 0) hacer
					a = b;
					b = resto;
					resto = a  __mod  b;
				fin_mientras;
         
         							escribir_cadena('prueba6');
         		
 				# Se muestra el resultado
				lugar(15,10);
				escribir_cadena(' Máximo común divisor de ');
				escribir(A1);
				escribir_cadena(' y ');
				escribir(B1);
				escribir_cadena(' es ---> ');
				escribir(b);

	# Resto de opciones
 	 si_no  
		lugar(15,10);
    	escribir_cadena(' Opcion incorrecta ');
     fin_si;
 fin_si;
fin_si;

 lugar(40,10); 
 escribir_cadena(' Pulse una tecla para continuar --> ');
 leer_cadena(pausa1);
 
escribir_cadena('La opcion es:');
escribir(opcion);
 
hasta (opcion == 0);

# Despedida final

borrar;
lugar(10,10);
escribir_cadena('El programa ha concluido');