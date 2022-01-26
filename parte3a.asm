# Laboratorio de Arquirectura de Computadores 2021-2
# Laboratorio 2: Acercandose al Hardware: Programacion en Lenguaje Ensamblador
# Nombre: John Serrano Carrasco
# Seccion: 13309-0-A-1
# Fecha: 06 de diciembre de 2021

# El programa realiza una multiplicacion de dos numeros enteros, es decir, numeros enteros positivos y/o numeros enteros
# negativos. Para probar el programa con otros numeros, se debe cambiar los numeros de "primerNumero" y "segundoNumero".

.data
     primerNumero: .word 278 # Se carga el primer numero de entrada en duro.
     segundoNumero: .word -24 # Se carga el segundo numero de entrada en duro.
     espacio: .asciiz "\n" # Se carga un espacio que sera de ayuda para imprimir los mensajes a continuacion
     mensaje1: .asciiz "El primer numero es: " # Se carga un mensaje que se mostrara para indicar cual es el primer numero
     mensaje2: .asciiz "El segundo numero es: " # Se carga un mensaje que se mostrara para indicar cual es el segundo numero
     output: .asciiz "El resultado de la multiplicacion entre ambos es: " # Se carga un mensaje que se mostrara junto al resultado

.text
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
     
     lw $t2, segundoNumero
     
     li $v0, 4  # Se prepara para imprimir un string por consola
     la $a0, mensaje2 # Se carga el mensaje2 al registro $a0
     syscall # Se imprime el mensaje por consola
     
     li $v0, 1 # Se prepara para imprimir un entero por consola
     move $a0, $t2 # Se copia y guarda el segundo numero al registro $a0
     syscall # Se imprime el numero por consola
     
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, espacio # Se carga un "\n"  al registro $a0
     syscall # Se imprime el salto de linea por consola
     
     slt $t3, $t1, $zero # Se comprueba si el primer numero, guardado en el registro $t1 es negativo
     slt $t4, $t2, $zero # Se comprueba si el segundo numero, guardado en el registro $t2 es negativo
     
     addi $t9, $zero, 1 # Se agrega un 1 al registro $t9
     
     beq $t9, $t3 numeroUnoNegativo # Si el primer numero es negativo, se salta a la etiqueta "numeroUnoNegativo"
     beq $t9, $t4 numeroDosNegativo # Si el segundo numero es negativo, se salta a la etiqueta "numeroDosNegativo"

continuarMain:
     add $a1, $zero, $t1 # Se agrega el primer numero al registro $a1
     add $a2, $zero, $t2 # Se agrega el segundo numero al registro $a2
    
     jal multiplicacion # Se llama a la subrutina "multiplicacion"
     
     j verificarSigno # Se salta a la etiqueta "verificarSigno"
     
numeroUnoNegativo:
     add $t5, $t1, $t1 # Se suma dos veces el primer numero y el resultado se guarda en $t5
     sub $t1, $t1, $t5 # Se resta el primer numero con la suma anterior guardada en $t5, asi $t1 quedando positivo
     beq $t9, $t4, numeroDosNegativo # Si el segundo numero es negativo, se salta a la etiqueta "numeroDosNegativo"
     
     j continuarMain  # Se salta a la etiqueta continuarMain, para continuar con el proceso de multiplicacion
     
numeroDosNegativo:
     add $t6, $t2, $t2 # Se suma dos veces el segundo numero y el resultado se guarda en $t6
     sub $t2, $t2, $t6 # Se resta el segundo numero con la suma anteror guardada en $t6, asi $t2 quedando positivo
     
     j continuarMain # Se salta a la etiqueta continuarMain, para continuar con el proceso de multiplicacion
     
multiplicacion:
     beq $t8, $a2, salirDeMultiplicacion # Si el contenido de $t8 es igual al contenido de $a2, se salta a la etiqueta "salirDeMultiplicacion"
     add $v1, $v1, $a1 # Se suma reliaza la suma de $a1 con $v1, y el resultado se guarda en $v1
     addi $t8, $t8, 1 # Se suma 1 al contenido de $t8
     j multiplicacion # Se salta al inicio de la subrutina

salirDeMultiplicacion:
     jr $ra # Se recupera el return adress para volver a donde fue llamada la subrutina

verificarSigno:
     add $t3, $t3, $t4 # Se realiza la suma de $t3 con $t4 y el resultado se guarda en $t3
     beq $t3, $t9, cambiarSigno # Si $t3 tiene a un 1, entonces se salta a la etiqueta "cambiarSigno"
     move $s0, $v1 # Se copia y guarda el contenido de $v1 al registro $s0
     j END # Se salta a la etiqueta "END"

cambiarSigno:
     add $s1, $v1, $v1 # Se realiza la suma de $v1 con $v1 y el resultado se guarda en $s1
     sub $s0, $v1, $s1 # Se realiza la resta de $v1 con $s1 y el resultado se guarda en $s0
     j END # Se salta a la etiqueta "END"
     
END: 
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, output # Se carga "output" al registro $a0
     syscall  # Se imprime el mensaje por pantalla
    
     li $v0, 1 # Se prepara para imprimir un entero por consola
     move $a0, $s0 # Se mueve el contenido de $s0 al registro $a0
     syscall # Se imprime el entero por pantalla
     
     move $t1, $zero # Se limpia el registro $t1
     move $t2, $zero # Se limpia el registro $t2
     move $t3, $zero # Se limpia el registro $t3
     move $t4, $zero # Se limpia el registro $t4
     move $t5, $zero # Se limpia el registro $t5
     move $t6, $zero # Se limpia el registro $t6
     move $t8, $zero # Se limpia el registro $t8
     move $t9, $zero # Se limpia el registro $t9
    
     li $v0, 10  # Se prepara para finalizar el programa
     syscall # Se finaliza el programa
