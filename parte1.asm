# Laboratorio de Arquirectura de Computadores 2021-2
# Laboratorio 2: Acercandose al Hardware: Programacion en Lenguaje Ensamblador
# Nombre: John Serrano Carrasco
# Seccion: 13309-0-A-1
# Fecha: 07 de diciembre de 2021

# El programa recibe dos numeros enteros por entrada y calcula cual es el mayor de estos dos. Retorna el mayor numero.

.data
     input1: .asciiz "Por favor ingrese el primer entero: " # Se carga el primer mensaje a mostrar por consola
     input2: .asciiz "Por favor ingrese el segundo entero: " # Se carga el segundo mensaje a mostrar por consola
     output: .asciiz "El maximo es: " # Se carga el tercer mensaje a mostrar por consola
     
.text
main:
     li $v0, 4 # Se prepara para imprimir un string
     la $a0, input1 # Se carga "input1" al registro $a0
     syscall # Se imprime el mensaje en la consola
     
     li $v0, 5 # Se prepara para pedir un numero entero por consola
     syscall # Se pide un numero entero por consola
     
     move $t1, $v0  # Se mueve el numero del registro $v0 al registro $t1
     
     li $v0, 4  # Se prepara para imprimir un string
     la $a0, input2 # Se carga "input2" al registro $a0
     syscall # Se imprime el mensaje en la consola
     
     li $v0, 5 # Se prepara para pedir un segundo numero entero por consola
     syscall # Se pide un numero entero por consola
     
     move $t2, $v0 # Se mueve el numero del registro $v0 al reistro $t2
     
     # Se preparan los parametros para la subrutina de la línea 42
     add $a1, $zero, $t1 # Se agrega el numero guardado en el registro $t1 al registro $a1
     add $a2, $zero, $t2 # Se agrega el numero guardado en el registro $t2 al registro $a2
     
     li $v0, 4 # Se prepara para mostrar un string por consola
     la $a0, output # Se carga "output" al registro $a0
     syscall # Se imprime el mensaje en la consola
     
     jal comparacion # Se llama a la subrutina "comparacion"
     
     li $v0, 1 # Se prepara para imprimir un entero por consola
     move $a0, $v1 # Se mueve el contenido de $v1 (resultado subrutina) al registro $a0
     syscall # Se imprime el numero en la consola
     
     j END   # Se salta a la etiqueta "END"

comparacion:
     slt $t0, $a1, $a2 # Se comparan los numeros, verificando si $a1 < $a2
     
     beqz $t0, primeroEsMayor # Si primerNumero es mayor, se salta a la etiqueta "primeroEsMayor"
     
     move $v1, $a2 # Si no sucede lo anterior, se mueve el numero guardado en $a2 al registro $v1
     
     jr $ra # Se recupera el return adress para volver a main
    
primeroEsMayor:
     move $v1, $a1 # Se mueve el numero guardado0 en #a1 al registro $v1
     jr $ra # Se recupera el return adress para volver a main
     
      	
END:
     move $t0, $zero # Se limpia el registro $t1
     move $t1, $zero # Se limpia el registro $t2
     move $t2, $zero # Se limpia el registro #t3
     
     li $v0, 10 # Se prepara para finalizar el programa
     syscall # Se finaliza el programa.
