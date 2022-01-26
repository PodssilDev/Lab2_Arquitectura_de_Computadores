# Laboratorio de Arquirectura de Computadores 2021-2
# Laboratorio 2: Acercandose al Hardware: Programacion en Lenguaje Ensamblador
# Nombre: John Serrano Carrasco
# Seccion: 13309-0-A-1
# Fecha: 07 de diciembre de 2021

# El programa recibe NUMEROS ENTEROS y calcula la serie de Taylor de la funcion sin(x) desde orden 1 hasta orden 11.
# Si se desea, se puede cambiar el orden para que el programa calcule menos ordenes (util para probar con numeros grandes)
# Debido a que se deben utilizar las multiplicaciones y divisiones de los programas 3a y 3b respectivamente, estos debieron
# ser adaptados para poder trabajar con flotantes. Por lo tanto, los registro $f24 $f25, $f19 y $f22 actuan como registros 
# $a para las subrutinas y los registros $f4, $f5 y $f7 actuan como $v0 y $v1 respectivamente, para los resultados de l
# as subrutinas. Se recomienda ingresar valores enteros cercanos a 0, ya sea positivos o negativos.
# Recordar que para comparar con los valores reales, la serie de Taylor funciona con RADIANES.
# Para mas detalles, ver explicacion de la solucion en el informe.

.data
     mensaje1: .asciiz "Porfavor ingrese un numero cercano a cero (Por ejemplo, 1, 2 o 3): " # Se carga un mensaje que se mostrara al pedir entrada
     inicialFactorial: .float 3.0 # Se carga un flotante, el cual sera el primer factorial en calcularse
     numeroUno: .float 1.0 # Se carga un flotante que sera de ayuda para realizar los calculos
     numeroDos: .float 2.0 # Se carga un flotante que sera de ayuda para realizar los calculos
     numeroAyuda: .float 0.01 # Se carga un flotante que sera de ayuda mas adelante.
     numeroCien: .float 100  # Se carga un flotante que sera de ayuda para realizar los calculos
     mensaje2P1: .asciiz "El seno de " # Se carga la primera parte de un mensaje que sera mostrado junto con el resultado
     mensaje2P2: .asciiz " con orden " # Se carga la segunda parte de un mensaje que sera mostrado junto con el resultado
     mensaje2P3: .asciiz " es: " # Se carga la tercera parte de un mensaje que sera mostrado junto con el resultado
     saltodeLinea: .asciiz "\n" # Se carga un salto de linea
     orden: .word 11 # Se carga un numero entero, el cual corresponde al orden maximo de la serie.
                     # CUIDADO: El programa funciona con ordenes sobre 11, pero podria demorarse excesivamente dependiendo
                     # de el numero ingresado
                     
.text
main:
     lwc1 $f22, numeroCien # Se carga el numero 100 al registro $f22
     lw $t0, orden # Se carga el orden al registro $t0
     
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, mensaje1 # Se carga el mensaje1 al registro $a0
     syscall # Se imprime el mensaje por consola
          
     li $v0, 5 # Se prepara para recibir un numero entero
     syscall # Se solicita un entero por consola
    
     move $s1, $v0 # Se mueve el entero recibido al registro $s1
     
     mtc1 $v0, $f0 # Se mueve el entero recibido al registro $f0 del coprocesador 1
     mtc1 $v0, $f1 # Se mueve el entero recibido al registro $f1 del coprocesador 1
     cvt.s.w $f0, $f0 # Se transforma el entero guardado en $f0 a un flotante
     cvt.s.w $f1, $f1 # Se transforma el entero guardado en $f1 a un flotante
     
     lwc1 $f2, inicialFactorial # Se carga el numero 3 al registro $f2 del coprocesador 1
     lwc1 $f28, numeroUno # Se carga el numero 1 en el registro $f28 del coprocesador 1
     lwc1 $f27, numeroDos # Se carga el numero 2 en el registro $f27 del coprocesador 1
     lwc1 $f13, numeroAyuda # Se carga el numero 0,01 en el registro $f13 del coprocesador 1
     
     bgez $s1, cicloPrincipal # Si el numero es positivo o mayor que 0, se salta a la etiqueta "cicloPrincipal"
     add.s $f3, $f0, $f0 # Se realiza la suma de $f0 consigo mismo y se guarda en el registro $f3
     sub.s $f0, $f0, $f3 # Se realiza la resta entre $f0 y la suma realiza anteriormente, cambiando el signo a $f0
     add.s $f3, $f26, $f26 # Se limpia el registro %f3
     add.s $f1, $f0, $f26 # Se agrega el signo nuevo de $f0 al registro $f1
     
cicloPrincipal:
     addi $t5, $t5, 1 # Se agrega un 1 a $t5, que corresponde a orden actual
     jal factorial # Se llama a la subrutina factorial
     
     add.s $f25, $f26, $f4 # Se copia el resultado de la subrutina anterior al registro $f25
     
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
     add.s $f3, $f26, $f26 # Se limpia el registro $f3
     add.s $f5, $f26, $f26 # Se limpia el registro $f5
     add.s $f8, $f26, $f26 # Se limpia el registro $f8
     
     jal potencia # Se llama a la subrutina potencia, donde se calculara la misma potencia del numero al que se le calculo el factorial
     add.s $f24, $f26, $f4 # Se copia el resultado de la subrutina al registro $f24
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
     add.s $f5, $f26, $f26 # Se limpia el registro $f5
     add.s $f8, $f26, $f26 # Se limpia el registro $f8
     
    j algoritmoDivision # Se salta a la etiqueta "algoritmoDivision". Se calculara potencia / factorial

potencia:
     sub.s $f3, $f2, $f28 # Se realiza el calculo de cuantas veces se debe repetir el proceso de potencia. Se guarda en $f3
     add.s $f4, $f4, $f0 # Se agrega a $f4 el numero de entrada
     add.s $f5, $f5, $f0 # Se agrega a $f5 el numero de entrada
     
cicloPotencia: 
multPotencia:
     c.eq.s $f6, $f5 # Se compara si los flotantes guardados en $f6 y $f5 son iguales
     bc1t salirDeMultiPotencia # Si son iguales, se sale de la multiplicacion
     add.s $f7, $f7, $f4 # Se realiza la suma de $f7 con $f4. En $f7 se guarda el resultado de la multiplicacion
     add.s $f6, $f6, $f28 # Se aumenta el contador  de multiplicacion en 1
     j multPotencia # Se vuelve a saltar a la etiqueta "multPotencia"

salirDeMultiPotencia:
     add.s $f4, $f7, $f26 # Se copia el resultado de la multiplicacion al registro $f4
     add.s $f8, $f8, $f28 # Se suma un 1 al contador de potencia
     add.s $f6, $f26, $f26 # Se limpia el registro $f6
     add.s $f7, $f26, $f26 # Se limpia el registro $f7
     c.eq.s $f8, $f3 # Se compara si los flotantes guardados en $f6 y $f5 son iguales
     bc1f cicloPotencia # Si no son iguales, se salta a la etiqueta "cicloPotencia"
     jr $ra # Si son iguales, se termina el proceso y se recupera el return adress para volver a donde fue llamada la subrutina
     
factorial:
     sub.s $f3, $f2, $f27 # Se obtiene el total de multiplicacion que se deben hacer (el numero - 2)
     add.s $f4, $f4, $f2 # Se guarda el primer numero el cual corresponde al factorial a calcular
     add.s $f5, $f5, $f27 # Se guarda un 2 en el registro $f5
     
cicloFactorial:
multFactorial:
     c.eq.s $f6, $f5  # Se compara si los flotantes guardados en $f6 y $f5 son iguales
     bc1t salirDeMultiFactorial # Si son iguales, se salta a la etiqueta "salirDeMultiFactorial"
     add.s $f7, $f7, $f4  # Se realiza la suma de $f7 con $f4. En $f7 se guarda el resultado de la multiplicacion
     add.s $f6, $f6, $f28 # Se aumenta el contador de multiplicacion en 1
     j multFactorial # Se salta a la etiqueta "multFactorial"
     
salirDeMultiFactorial:
     add.s $f6, $f26, $f26 # Se reinicia el contador anterior 0.0 REINICIO MI CONTADOR
     add.s $f4, $f7, $f26 # Se suma el resultado de la multiplicacion anterior al registro $f4
     add.s $f5, $f5, $f28 # Se aumenta $f5 para continuar multiplicandoo
     add.s $f8, $f8, $f28 # Se aumenta el contador de factorial en 1
     add.s $f7, $f26 $f26 # Se limpia el registro $f7
     c.eq.s $f3, $f8 # Se compara si los flotantes guardados en $f3 y $f8 son iguales
     bc1f cicloFactorial # Si no son iguales, se salta a la etiqueta "cicloFactorial"
     jr $ra # Si son iguales, se recupera el return adress para volver a donde fue llamada la funcion
     
algoritmoDivision:   
     add.s $f23, $f26, $f24 # Se copia el numero guardado en $f24 al registro $f23
     
     jal division # Se llama a la subrutina "division". Se divide $f24 con $f25
     
     add.s $f20, $f26, $f4 # Se copia el resultado al registro $f20
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
   
     c.eq.s $f24, $f26  # Se compara si los flotantes guardados en $f4 y $f26 son iguales
     bc1t verificarSignoFinal # Si son iguales, se salta a la etiqueta "verificarSignoFinal"
     
     add.s $f24, $f26, $f23 # Se vuelve a agregar el primer numero al registro $f24
     
     jal multiplicacionEntera # Se llama a la subrutina "multiplicacionEntera"
     
     add.s $f24, $f5, $f26 # Se agrega a $f24 el resultado de la multiplicacion anterior
     
     jal division # Se llama a la subrutina "division"
     
     add.s $f19, $f19, $f4 # Se agrega al registro $f19 el resultado de la division anterior
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
     add.s $f5, $f26, $f26 # Se limpia el registro $f4
     add.s $f8, $f26, $f26 # Se limpia el registro $f8
     add.s $f24, $f26, $f19  # Se copia el contenido de $f19 a $f24
     add.s $f16, $f26, $f25 # Se limpia el registro $f16
     add.s $f25, $f26, $f22 # Se copia en $f25 el contenido de $f22
     
     jal division # Se llama a la subrutina "division"
     
     add.s $f24, $f26, $f4 # Se agrega a $f24 el resultado de la division anterior
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
    
     jal multiplicacionEntera # Se llama a la subrutina "multiplicacionEntera"
     
     sub.s $f19, $f19, $f5 # Se resta el contenido de $f19 con el contenido del registro $f5   
     add.s $f5, $f26, $f26 # Se limpia el registro $f5
     add.s $f8, $f26, $f26 # Se limpia el registro $f8
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
     
     add.s $f20, $f20, $f7 # Se suman los flotantes guardados en $f8 y $f20, y el resultado se guarda en el registro $f20
     
     j verificarSignoFinal # Se salta a la etiqueta "verificarSignoFinal"
 
division:
     c.eq.s $f24, $f26 # Se compara si los flotantes guardados en $f24 y $f26 son iguales
     bc1t salirDeDivision # Si son iguales entonces se salta a la etiqueta "salirDeDivision"
     c.le.s $f24, $f26 # Se compara si $f24 es menor que $f26 ($f24 < 0)
     bc1t prepararParaParteDecimal # Si lo anterior se cumple, se salta a la etiqueta "prepararParaParteDecimal"
     sub.s $f24, $f24, $f25 # Se realiza la resta de $f24 menos $f25 y se guarda el resultado en $f24
     add.s $f4, $f4, $f28  # Se suma 1 al contenido de $f4, donde se guardara el resultado
     j division # Se salta nuevamente al inicio de la subrutina

salirDeDivision:
     jr $ra # Se recupera el return adress para volver a donde fue llamada la subrutina.

prepararParaParteDecimal:
    sub.s $f4, $f4, $f28 # Se resta 1 al contenido de $f4, para quitar la unidad extra que sobraba de la parte entera
    jr $ra # Se recupera el return adress para volver a donde fue llamada la subrutina
    
multiplicacionEntera:
     c.eq.s $f8, $f22  # Se compara si los flotantes guardados en $f8 y $f22 son iguales
     bc1t salirDeMultiplicacion # Si son iguales,  se salta a la etiqueta "salirDeMultiplicacion"
     add.s $f5, $f5, $f24 # Se suma reliaza la suma de $f24 con $f5, y el resultado se guarda en $f5
     add.s $f8, $f8, $f28 # Se aumenta el contador en una unidad
     j multiplicacionEntera # Se salta al inicio de la subrutina

salirDeMultiplicacion:
     jr $ra  # Se recupera el return adress para volver a donde fue llamada la subrutina
     
multiplicacionFlotante:
     c.eq.s $f8, $f19,  # Se compara si los flotantes guardados en $f8 y $f19 son iguales
     bc1t salirDeMultiplicacion # Si son iguales se salta a la etiqueta "salirDeMultiplicacion"
     add.s $f7, $f7, $f13 # Se realiza la suma de los flotantes de $f7 y $f13 y se guarda en $f7
     add.s $f8, $f8, $f28 # Se aumenta el contador
     j multiplicacionFlotante # Se salta al inicio de a subrutina
     
verificarSignoFinal:
     add.s $f6, $f20, $f20 # Se suma dos veces $f20 y se guarda en #f6
     sub.s $f20, $f20, $f6 # Se realiza la resta entre $f20 y la suma anterior, cambiando el signo de $f20
     addi $t1, $t1, 1 # Se aumenta en una unidad el registro $t1
     bne $t1, $t5, verificarSignoFinal # Si $t1 y $t5 tienen valores distintos, se salta al inicio de la etiqueta
     
     move $t1, $zero # Se limpia el registro $t1
     add.s $f1, $f1, $f20 # Se agrega al resultado total el resultado del orden actual
     addi $t2, $t2, 1 # Se aumenta en una unidad el registro $t2
     add.s $f2, $f2, $f27 # Se aumenta en dos unidades el registro $f2
     
     add.s $f3, $f26, $f26 # Se limpia el registro $f3
     add.s $f6, $f26, $f26  # Se limpia el registro $f6
     add.s $f7, $f26, $f26  # Se limpia el registro $f7
     add.s $f8, $f26, $f26  # Se limpia el registro $f8
     add.s $f16, $f26, $f26  # Se limpia el registro $f16
     add.s $f19, $f26, $f26  # Se limpia el registro $f19
     add.s $f20, $f26, $f26  # Se limpia el registro $f20
     add.s $f23, $f26, $f26  # Se limpia el registro $f23
     add.s $f24, $f26, $f26  # Se limpia el registro $f24
     add.s $f25, $f26, $f26  # Se limpia el registro $f25
     
     li $v0, 4 # Se prepara para imprimir un mensaje
     la $a0, mensaje2P1 # Se carga el "mensaje2P1" en el registro $a0
     syscall # Se imprime el mensaje anterior
     
     li $v0, 1 # Se prepara para imprimir un entero
     move $a0, $s1 # Se mueve el numero guardado en $s1 al registro $a0
     syscall # Se imprime el entero anterior
     
     li $v0, 4 # Se prepara para imprimir un mensaje
     la $a0, mensaje2P2 # Se carga el "mensaje2P2" en el registro $a0
     syscall # Se imprime el mensaje anterior
     
     li $v0, 1 # Se prepara para imprimir un entero
     move $a0, $t5 # Se mueve el entero guardado en $t5 al registro $a0
     syscall # Se imprime el entero anterior
     
     li $v0, 4 # Se prepara para imprimir un mensaje
     la $a0, mensaje2P3 # Se carga el "mensaje2P3" en el registro $a0
     syscall # Se imprime el mensaje anterior
     
     add.s $f12, $f26, $f1 # Se copia el contenido de $f1 al registro $f12
     blez $s1, cambiarSignoResultado # Si $s1 es menor que 0, se salta a la etiqueta "cambiarSignoResultado"
     
     li $v0, 2 # Se prepara para imprimir un flotante
     syscall # Se imprime el flotante (resultado actual)
     
     li $v0, 4 # Se prepara para imprimir un mensaje
     la $a0, saltodeLinea # Se carga el salto de linea en el registro $a0
     syscall # Se imprime el salto de linea
     
     bne $t0, $t5 cicloPrincipal # Si $t1 y $t2 tienen valores distintos (no se ha llegado al ultimo orden) se salta a la etiqueta "cilcoPrincipal"
     
     j END # Si son iguales, se salta a la etiqueta "END" para finalizar el programa
     
cambiarSignoResultado:
     add.s $f4, $f12, $f12 # Se realiza la suma de dos veces $f12 y se guarda en el registro $f4
     sub.s $f12, $f12, $f4 # Se realiza la resta de $f12 con $f4, cambiando el signo de $f12
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
     
     li $v0, 2 # Se prepara para imprimir un flotante
     syscall # Se imprime un flotante (resultado actual)
     
     li $v0, 4 # Se prepara para imprimir un string
     la $a0, saltodeLinea # Se carga el salto de linea en el registro $a0
     syscall # Se imprime el salto de linea
     
     bne $t0, $t5 cicloPrincipal # Si aun no se ha llegado al orden final, se salta a la etiqueta "cicloPrincipal"
     
     j END # Se salta a la etiqueta "END" para finalizar el programa 
     
END: 
     move $t0, $zero # Se limpia el registro $t0
     move $t1, $zero # Se limpia el registro $t1
     move $t2, $zero # Se limpia el registro $t2
     move $t5, $zero # Se limpia el registro $t5
     
     li $v0, 10 # Se prepara para finalizar el programa
     syscall # Se finaliza el programa
    
