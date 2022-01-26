# Laboratorio de Arquirectura de Computadores 2021-2
# Laboratorio 2: Acercandose al Hardware: Programacion en Lenguaje Ensamblador
# Nombre: John Serrano Carrasco
# Seccion: 13309-0-A-1
# Fecha: 07 de diciembre de 2021

# El programa realiza una division de dos numeros enteros, es decir, numeros enteros positivos y/o numeros enteros
# negativos. Dependiendo de los numeros a dividir, el resultado puede ser unentero o un decimal.  
# Para probar el programa con otros numeros se debe cambiar los numeros de "primerNumero" y "segundoNumero".
# Si se quiere dividir por 0, el programa finalizara mostrando un mensaje, el cual indica que no es posible dividir
# por 0. El resultado de la division tiene como maximo (a excepcion de algunos casos) dos decimales.

.data
     primerNumero: .word 1000 # Se carga el primer numero de entrada en duro
     segundoNumero: .word 5 # Se carga el segundo numero de entrada en duro
     numeroAyuda: .float 0.01 # Se carga un flotante que sera de ayuda mas adelante.
     espacio: .asciiz "\n" # Se carga un espacio que sera de ayuda para imprimir los mensajes a continuacion
     mensaje1: .asciiz "El primer numero es: " # Se carga un mensaje que se mostrara para indicar cual es el primer numero
     mensaje2: .asciiz "El segundo numero es: " # Se carga un mensaje que se mostrara para indicar cual es el segundo numero
     output: .asciiz "El resultado de la division entre ambos es: " # Se carga un mensaje que se mostrara junto al resultado
     divisionZero: .asciiz  "No se puede dividir por 0." # Se carga un mensaje que se mostrara en caso de que se divida por 0

.text
main:

     lwc1 $f12, numeroAyuda # Se carga el flotante al registro $f12 del coprocesador 1
     lw $t1, primerNumero # Se carga el primer numero al registro $t1
     
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, mensaje1 # Se carga el mensaje1 al registro $a0
     syscall # Se imprime el mensaje por consola
     
     li $v0, 1 # Se prepara para imprimir un entero por consola
     move $a0, $t1 # Se copia y guarda el primer numero al registro $a0
     syscall # Se imprime el numero por consola
     
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, espacio # Se carga un "\n"  al registro $a0
     syscall # Se imprime el salto de linea por consola
     
     lw $t2, segundoNumero # Se carga el segundo numero al registro #t2
     
     li $v0, 4  # Se prepara para imprimir un string por consola
     la $a0, mensaje2 # Se carga el mensaje2 al registro $a0
     syscall # Se imprime el mensaje por consola
     
     li $v0, 1 # Se prepara para imprimir un entero por consola
     move $a0, $t2 # Se copia y guarda el segundo numero al registro $a0
     syscall # Se imprime el numero por consola
     
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, espacio # Se carga un "\n"  al registro $a0
     syscall # Se imprime el salto de linea por consola
     
     lwc1 $f12, numeroAyuda # Se carga el flotante al registro $f12 del coprocesador 1
     
     beqz $t2, error # Si se intenta dividir por 0, se salta a la etiqueta error
     
     slt $t3, $t1, $zero # Se comprueba si el primer numero, guardado en el registro $t1 es negativo
     slt $t4, $t2, $zero # Se comprueba si el segundo numero, guardado en el registro $t2 es negativo
     
     addi $t9, $zero, 1 # Se agrega un 1 al registro $t9
     
     beq $t9, $t3, numeroUnoNegativo # Si el primer numero es negativo, se salta a la etiqueta "numeroUnoNegativo"
     beq $t9, $t4, numeroDosNegativo # Si el segundo numero es negativo, se salta a la etiqueta "numeroDosNegativo"
     
continuarMain:      
     add $a1, $zero, $t1 # Se agrega el primer numero al registro $a1
     add $a2, $zero, $t2 # Se agrega el segundo numero al registro $a2
     
     jal division # Se llama a la subrutina "division"
     
     move $s1, $v1 # El resultado de la subrutina anterior se copia y guarda en el registro $s1
    
     beqz $a1, verificarSignoSoloEntera # Si el valor de $a1 es 0, entonces se salta a la etiqueta "verificarSignoSoloEntera"
     
     move $v1, $zero # De lo contrario, se limpia el registro $v1
     
     add $a1, $zero, $t1 # Se vuelve a agregar el primer numero al registro $t1
     addi $a2, $zero, 100 # Se agrega el numero 100 al registro $t2
     
     jal multiplicacionEntera # Se llama a la subrutina "multiplicacionEntera"
     
     move $a1, $v1 # El resultado de la subrutina anterior se copia al registro $a1
     move $v1, $zero # Se limpia el registro $v1
     
     add $a2, $zero, $t2 # Nuevamente se agrega el segundo numero al registro $a2
     move $t7, $zero # Se limpia el registro $t7
     
     jal division # Se llama a la subrutina "division"
     
     move $s2, $v1 # Se copia y guarda el resultado de la subrutina anterior en el registro $s2
     move $a1, $s2 # Se copia y guarda el numero en el registro $s2 al registro $a1
     addi $a2, $zero, 100 # Se guarda el numero 100 en el registro $a2
     move $t7, $zero # Se limpia el registro $t7
     
     jal division # Se llama a la subrutina "division"
     
     move $a1, $v1 # Se copia y guarda el resultado de la subrutina anterior al registro $a1
     move $v1, $zero # Se limpia el registro $v1
     move $t8, $zero # Se limpia el registro $t8
     
     jal multiplicacionEntera # Se llama a la subrutina "multiplicacionEntera"
     
     subu $s2, $s2, $v1 # Se resta el contenido de $s2 con el contenido del registro $v1
     
     mtc1 $s1, $f8 # Se mueve el contenido del registro $s1 al registro $f8 del coprocesador 1
     cvt.s.w $f8, $f8 # Se convierte el contenido de $f8 a single precision
 
     move $a1, $s2 # Se copia y guarda el contenido del registro $s2 en el registro $a2
     move $t8, $zero # Se limpia el registro $t8
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
     
     add.s $f8, $f8, $f7 # Se suman los flotantes guardados en $f8 y $f7, y el resultado se guarda en el registro $f8

     j verificarSignoDecimales # Se salta a la etiqueta "verificarSignoDecimales"
     
numeroUnoNegativo:
     add $t5, $t1, $t1 # Se suma dos veces el primer numero y el resultado se guarda en $t5
     sub $t1, $t1, $t5 # Se resta el primer numero con la suma anterior guardada en $t5, asi $t1 quedando positivo
     beq $t9, $t4, numeroDosNegativo # Si el segundo numero es negativo, se salta a la etiqueta "numeroDosNegativo"
     
     j continuarMain  # Se salta a la etiqueta continuarMain, para continuar con el proceso de division


numeroDosNegativo:
     add $t6, $t2, $t2 # Se suma dos veces el segundo numero y el resultado se guarda en $t6
     sub $t2, $t2, $t6 # Se resta el segundo numero con la suma anteror guardada en $t6, asi $t2 quedando positivo
     
     j continuarMain # Se salta a la etiqueta continuarMain, para continuar con el proceso de division
     
division:
     beqz $a1, salirDeDivision # Si contenido de $a1 es 0, entonces se salta a la etiqueta "salirDeDivision"
     bltz $a1, prepararParaParteDecimal # Si $a1 tiene un numero negativo, entonces se salta a la etiqueta "prepararParaParteDecimal"
     subu $a1, $a1, $a2 # Se realiza la resta de $a1 menos $a2 y se guarda el resultado en $a1
     addi $t7, $t7, 1  # Se suma 1 al contenido de $t7
     j division # Se salta nuevamente al inicio de la subrutina

salirDeDivision:
     move $v1, $t7 # Se copia y guarda el contenido de $t7 al registro $v1
     jr $ra # Se recupera el return adress para volver a donde fue llamada la subrutina.

prepararParaParteDecimal:
    subi $t7, $t7, 1 # Se suma 1 al contenido de $t7
    move $v1, $t7 # Se mueve copia y guarda el contenido de $t7 al registro $v1
    jr $ra # Se recupera el return adress para volver a donde fue llamada la subrutina
    
multiplicacionEntera:
     beq $t8, $a2, salirDeMultiplicacion # Si el contenido de $t8 es igual al contenido de $a2, se salta a la etiqueta "salirDeMultiplicacion"
     add $v1, $v1, $a1 # Se suma reliaza la suma de $a1 con $v1, y el resultado se guarda en $v1
     addi $t8, $t8, 1 # Se suma 1 al contenido de $t8
     j multiplicacionEntera # Se salta al inicio de la subrutina

salirDeMultiplicacion:
     jr $ra  # Se recupera el return adress para volver a donde fue llamada la subrutina
     
multiplicacionFlotante:
     beq $t8, $a1, salirDeMultiplicacion # Si el contenido de $t8 es igual al contenido de $a1, se salta a la etiqueta "salirDeMultiplicacion"
     add.s $f7, $f7, $f12 # Se realiza la suma de los flotantes de $f7 y $f12 y se guarda en $f7
     addi $t8, $t8, 1 # Se suma 1 al contenido de $t8
     j multiplicacionFlotante # Se salta al inicio de a subrutina

imprimirResultadoFlotante:
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, output # Se carga "output" al registro $a0
     syscall # Se imprime el mensaje por consola
     li $v0, 2 # Se prepara para mostrar un flotante por consola
     add.s $f12, $f8, $f0 # Se mueve el contenido de $f8 a $f12
     syscall # Se imprime el numero por consola
     j END # Se salta a la etiqueta "END"

verificarSignoSoloEntera:
     add $t3, $t3, $t4 # Se suma el contenido de $t3 con el contenido de $t4 y se guarda el resultado en $t3
     beq $t3, $t9, cambiarSignoEntera # Si la suma anterior es igual a 1, se salta a la etiqueta "cambiarSignoEntera"
     j soloParteEntera # Si no sucede lo anterior, se salta a la etiqueta "soloParteEntera"

verificarSignoDecimales:
     add $t3, $t3, $t4 # Se suma el contenido de $t3 con el contenido de $t4 y se guarda el resultado en $t3
     beq $t3, $t9, cambiarSignoDecimales # Si la suma anterior es igual a 1, se salta a la etiqueta "cambiarSignoDecimales"
     j imprimirResultadoFlotante # Si no sucede lo anterior,  se salta a la etiqueta "imprimirResultadoFlotante"

cambiarSignoDecimales:
     add.s $f2, $f8, $f8 # Se suma dos veces el contenido de $f8 y se guarda en $f2
     sub.s $f8, $f8, $f2 # Se realiza la resta entre $f8 y $f2, guardando el resultado en $f8
     j imprimirResultadoFlotante # Se salta a la etiqueta "imprimirResultadoFlotante"
     
cambiarSignoEntera:
     add $s4, $s1, $s1 # Se suma dos veces el contenido de $s1 y se guarda en $s4
     sub $s1, $s1, $s4 # Se realiza la resta entre $s1 y $s4 y se guarda el resultado en $s1
     j soloParteEntera # Se salta a la etiqueta "imprimirResultadoFlotante"
     
soloParteEntera:
     li $v0,4 # Se prepara para imprimir un string por consola
     la $a0, output # Se carga "output" al registro $a0
     syscall # Se imprime el mensaje por consola
     li $v0, 1 # Se prepara para imprimir un entero por consola
     move $a0, $s1 # Se mueve el contenido de $s1 a $a0
     syscall # Se imprime el numero guardado en $a0 por consola
     j END # Se salta a la etiqueta "END"

error:
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, divisionZero # Se mueve el mensaje "divisionZero" al registro $a0
     syscall # Se imprime el mensaje por consola
     j END # Se salta a la etiqueta "END"
     
END: 
     move $t1, $zero # Se limpia el registro $t1
     move $t2, $zero # Se limpia el registro $t2
     move $t3, $zero # Se limpia el registro $t3
     move $t4, $zero # Se limpia el registro $t4
     move $t5, $zero # Se limpia el registro $t5
     move $t6, $zero # Se limpia el registro $t6
     move $t7, $zero # Se limpia el registro $t7
     move $t8, $zero # Se limpia el registro $t8
     move $t9, $zero # Se limpia el registro $t9
     
     li $v0, 10 # Se prepara para finalizar el programa
     syscall # Se finaliza el programa
    
