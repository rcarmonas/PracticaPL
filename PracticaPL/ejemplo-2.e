
escribir_cadena('Ejemplo de intercambio de valores \n');

escribir_cadena('Introduce un número --> ');

leer(numero);

si (numero > 0)
  entonces
           escribir_cadena('Introduce una cadena --> ');
           leer_cadena(dato);
   si_no
           escribir_cadena('Introduce una número --> ');
           leer(dato);
fin_si;

# Asignación
nueva = dato;


escribir_cadena('Valor leído --> ');

si (numero > 0)
 entonces
	escribir_cadena(nueva);
 si_no
	escribir(nueva);
fin_si;






