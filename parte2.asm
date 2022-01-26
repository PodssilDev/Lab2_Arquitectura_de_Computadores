# Laboratorio de Arquirectura de Computadores 2021-2
# Laboratorio 2: Acercandose al Hardware: Programacion en Lenguaje Ensamblador
# Nombre: John Serrano Carrasco
# Seccion: 13309-0-A-1
# Fecha: 06 de diciembre de 2021

# El programa recibe dos numeros enteros (positivos o negativos) y calcula el MCD entre ambos. Si se introducen
# numeros negativos, de igual forma se retorna el MCD pero positivo, ya que el cambio de signos de los numeros no
# influye en el signo final del MCD, el cual es siempre positivo. Se utiliza recursion y se trabaja con Stack.

.data
    primerNumero: .word 12  # Aqui se puede cambiar el numero para obtener otros resultados
    segundoNumero: .word -84 # Aqui se puede cambiar el numero para obtener otros resultados
    mensaje1: .asciiz "El primer numero es: " # Se carga un mensaje que se mostrara para indicar cual es el primer numero
    mensaje2: .asciiz "El segundo numero es: " # Se carga un mensaje que se mostrara para indicar cual es el segundo numero
    mensajeResultado: .asciiz "El Maximo Comun Divisor entre ambos numeros es: "  # Mensaje que aparecera junto al resultado
    saltodeLinea: .asciiz "\n" # Se carga un salto de linea para separar lineas de strings

.text
main:
    li $v0 4 # Se prepara para imprimir un string por consola
    la $a0 mensaje1 # Se carga el mensaje1 en el registro $a0
    syscall # Se imprime el mensaje por consola
    
    lw $a0 primerNumero # Se carga el primer numero al registro $a0
    li $v0 1 # Se prepara para imprimir un entero por consola
    syscall # Se imrpime el entero por consola
    
    li $v0 4  # Se prepara para imprimir un string por consola
    la $a0 saltodeLinea # Se carga el salto de Linea en el registro $a0
    syscall # Se imprime el salto de linea
    
    li $v0 4 # Se prepara para imprimir un string por consola
    la $a0 mensaje2 # Se carga el mensajew en el registro $a0
    syscall # Se imprime el mensaje por consola
    
    lw $a0 segundoNumero  # Se carga el segundo numero al registro $a0
    li $v0 1 # Se prepara para imprimir un entero por consola
    syscall # Se imprime el entero por consola

    li $v0 4  # Se prepara para imprimir un string por consola
    la $a0 saltodeLinea # Se carga el salto de Linea en el registro $a0
    syscall # Se imprime el salto de linea
    
    # Se preparan las entradas para la subrutina MCD
    lw $a1, primerNumero  # Se carga el primer numero a $a1
    lw $a2, segundoNumero # Se carga el segundo numero a $a2
    
    jal MCD # Se llama a la funcion recursiva MCD
    
    move $t1, $v0 # Se copia el resultado de la funcion MCD, guardado en $v0, a $t1
    
    bltz $t1 cambiarSigno # Si el resultado es negativo, se pasa a positivo, pues MCD es siempre positivo.

continuarMain:
    
    # Se muestra el mensaje en pantalla
    li $v0, 4 # Se prepara para imprimir un string por consola
    la $a0, mensajeResultado # Se carga el "mensajeResultado" en el registro $a0
    syscall  # Se imprime el mensaje por consola
    
    li $v0,1 # Se prepara para imprimir por consola
    move $a0, $t1  # Se mueve el resultado de la recursion guardado temporalmente en $t1 al registro $a0
    syscall # Se imprime el numero por consola
    
    j END # Se realiza un salto a la etiqueta "END" donde se finalizara el programa

MCD:
    # Como se va a utilizar recursion, es necesario hacer espacio en el stack
    subu $sp, $sp, 12  # Se hace espacio en el stack para 3 numeros
    sw $ra, 0($sp) # Se guarda el return adress de la funcion al stack
    sw $s0, 4($sp) # Se guarda el valor de $s0 en el stack
    sw $s1, 8($sp) # Se guarda el valor de $s1 en el stack 

    move $s0, $a1 # Se pasa el valor de $a1 (primerNumero) a $s0 
    move $s1, $a2 # Se pasa el valor de $a2 (segundoNumero) a $s1 

    beq $s1, $zero, escaparMCD # Si el valor de $s1 es igual a 0, se salta a la etiqueta "escaparMCD"

    move $a1, $s1 # Si no se cumple lo anterior, se mueve el valor de $s1 a $a0. (Asi siempre el mayor sera primero)
    
    div $s0, $s1 # Se dividen los valores de $s0 y $s1. El valor del resto se guarda en el registro hi
    mfhi $a2 # Se mueve el resto de la division anterior, guardado en el registro hi, al registro $a1

    jal MCD # Se vuelve a llamar a la funcion, repitiendo el proceso.
    
limpiezaYTerminoMCD:
    lw $ra, 0 ($sp)  # Se recupera un return adress del stack
    sw $zero, 0($sp) # Se limpia el stack
    
    lw $s0, 4 ($sp) # Se recupera un valor de $s0 guardado en el stack
    sw $zero, 4($sp) # Se limpia el stack
    
    lw $s1, 8 ($sp) # Se recupera un valor de $s1 guardado en el stack
    sw $zero, 8($sp) # Se limpia el stack
    
    addi $sp,$sp , 12 # Se recupera el stack pointer original, añadiendo 12 a $sp.
    jr $ra # Se utiliza jump register para volver a main.

escaparMCD:
    move $v0, $s0 # Se coloca el valor de $s0 como retorno de la funcion en el registro $v0
    j limpiezaYTerminoMCD # Se salta a la etiqueta limpiezaYTerminoMCD, donde se finaliza la funcion
    
cambiarSigno:
    li $t2, -1 # Se carga un -2 al registro $t2
    mul $t1, $t1, $t2 # Se multiplica $t1 con $t2, guardando el resultado en $t1
    move $t2, $zero # Se limpia el registro $t2
    j continuarMain # Se vuelve a la continuacion de main.
    
END: 
    move $t1, $zero # Se limpia el unico registro temporal utilizado
    
    li $v0, 10  # Se prepara para finalizar el programa
    syscall # Se finaliza el programa
