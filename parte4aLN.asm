# Laboratorio de Arquirectura de Computadores 2021-2
# Laboratorio 2: Acercandose al Hardware: Programacion en Lenguaje Ensamblador
# Nombre: John Serrano Carrasco
# Seccion: 13309-0-A-1
# Fecha: 07 de diciembre de 2021

# El programa calcula la serie de Taylor de la funcion ln(x). Debido a que la serie como tal esta definida para valores
# entre (0,2], se recomienda probar con esos valores. Principalmente se recomienda valores cercanos a 1.0,
# como por ejemplo, 0,8 , 0,7 , 1,2 , 1,3 etc,  ya que en  ordenes mas grandes el programa empieza a demorarse 
# bastante si son numeros alejados de 1.0. SOLO FUNCIONA HASTA ORDEN 11!. Si se ingresa un 0 o algun valor negativo
# el programa terminara con un mensaje indicando que el logaritmo natural no esta definido para esos numeros. 
# Debido a que se deben utilizar las multiplicaciones y divisiones de los programas 3a y 3b respectivamente, estos debieron
# ser adaptados para poder trabajar con flotantes. Por lo tanto, los registro $f24 $f25, $f19 y $f22 actuan como registros 
# $a para las subrutinas y los registros $f4, $f5 y $f7 actuan como $v0 y $v1 respectivamente, para los resultados de las
# as subrutinas. Debido a la division de dos decimales, se pierden varios decimales en el proceso. 
# Para mas detalles, ver explicacion de la solucion en el informe.

.data
     mensaje1: .asciiz "Porfavor ingrese un numero entre 0.1 y 2: " # Se carga un mensaje que se mostrara al pedir entrada
     numeroUno: .float 1.0 # Se carga un flotante que sera de ayuda para realizar los calculos
     numeroDos: .float 2.0 # Se carga un flotante que sera de ayuda para realizar los calculos
     numeroDiez: .float 10.0 # Se carga un flotante que sera de ayuda para realizar los calculos
     numeroCien: .float 100.0 # Se carga un flotante que sera de ayuda para realizar los calculos
     numeroAyuda1: .float 0.01 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda2: .float 0.001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda3: .float 0.0001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda4: .float 0.00001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda5: .float 0.000001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda6: .float 0.0000001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda7: .float 0.00000001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda8: .float 0.000000001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda9: .float 0.0000000001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda10: .float 0.00000000001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroAyuda11: .float 0.000000000001 # Se carga un flotante que sera de ayuda mas adelante.
     numeroInvalido: .asciiz "No esta definido el logaritmo natural para este numero" # Se carga un mensaje que se mostrara si el usuario ingresa un numero negativo o 0
     mensaje2P1: .asciiz "El logaritmo natural de " # Se carga la primera parte de un mensaje que sera mostrado junto con el resultado
     mensaje2P2: .asciiz " con orden " # Se carga la segunda parte de un mensaje que sera mostrado junto con el resultado
     mensaje2P3: .asciiz " es: " # Se carga la tercera parte de un mensaje que sera mostrado junto con el resultado
     saltodeLinea: .asciiz "\n" # Se carga un salto de linea
     orden: .word 11 # Se carga un numero entero, el cual corresponde al orden maximo de la serie.
                     # CUIDADO: El programa funciona con orden 11 como maximo, por lo que cambiar a un orden mayor podria
                     # provocar fallos no previstos. Si se quiere dejar con orden 11, se recomienda probar con numeros 
                     # cercanos a 1.0 (ej: 0,8 - 0,9 - 1,1 - 1,25 etc). Orden 11 podria tomar varios minutos con algunos 
                     # numeros.

.text
main:
     li $t3 1 # Se carga el numero 1 en el registro $t3
     lwc1 $f22, numeroCien # Se agrega el numero 100 al registro $t2
     lw $t1, orden # Se carga el orden maximo en el registro $t1
     
     li $v0, 4 # Se prepara para imprimir un string por consola
     la $a0, mensaje1 # Se carga el mensaje1 al registro $a0
     syscall # Se imprime el mensaje por consola
          
     li $v0, 6 # Se prepara para pedir un flotante por consola
     syscall # Se pide un flotante por consola
     
     c.le.s $f0 $f26 # Se comprueba si el numero ingresado es negativo o 0
     bc1t invalido # Si se cumple lo anterior, se salta a la etiqueta "invalido"
     
     add.s  $f1, $f1 $f0 # Se copia el numero guardado en  el registro $f0 al registro $f1
     add.s $f12 $f0 $f26 # Se copia el numero guardado en  el registro $f0 al registro f12
     add.s $f14 $f12 $f26 # Se copia el numero guardado en el registro $f12 al registro $f14
     
     lwc1 $f28, numeroUno # Se carga al registro $f28 el numero 1.0
     lwc1 $f27, numeroDos # Se carga al registro $f27 el numero 2.0
     sub.s $f0 $f0 $f28 # Se resta $f0 en una unidad (Para asi calcular ln(x) y no ln(x+1) )
     sub.s $f1 $f1 $f28 # Se resta $f1 en una unidad
     
     addi $t5 $t5 1 # Se aumenta el contador de orden en una unidad
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 mensaje2P1 # Se carga al registro $a0 el "mensaje2P1"
     syscall # Se imprime el mensaje en la consola
     
     li $v0 2 # Se prepara para imprimir un flotante
     syscall # Se imprime el flotante guardado en $f12 (numero solicitado por entrada)
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 mensaje2P2 # Se carga al registro $a0 el "mensaje2P2"
     syscall # Se imprime el mensaje en la consola
     
     li $v0 1 # Se prepara para imprimir un entero
     move $a0, $t5 # Se copia el contenido de $t5 al registro $a0
     syscall # Se imprime el numero entero anterior
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 mensaje2P3 # Se carga al registro $a0 el "mensaje2P3"
     syscall # Se imprime el mensaje en la consola
     
     add.s $f12 $f1 $f26 # Se copia al registro $f12 el contenido del reistro $f1
     li $v0 2 # Se prepara para imprimir un flotante
     syscall # Se imprime el flotante guardado en $f12
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 saltodeLinea # Se carga al registro $a0 el salto de linea
     syscall # Se imprime el salto de linea
     
     add.s $f12 $f14 $f26 # Se copia a $f12 el contenido de $f14 (vuelve el numero de entrada)
     add.s $f14 $f26 $f26 # Se limpia el registro %f14
     
     c.lt.s  $f0 $f26 # Se compara si el flotante guardado en $f0 es negativo -0.6 < 0.0
     bc1f cicloPrincipal1 # Si no es negativo, se salta a la etiqueta "cicloPrncipal1"
     add.s $f14 $f26 $f28 # De lo contrario, se agrega a $f14 un 1.0
     add.s $f4 $f0 $f0 # Se realiza la suma de dos veces $f0 y se guarda en $f4
     sub.s $f0 $f0 $f4 # Se realiza la suma de $f0 con $f4, cambiando el signo del numero guardado en $f0
     add.s $f4 $f26 $f26 # Se limpia el registro $f4
     addi $t8 $t8 1 # Se agrega un 1 al registro $t8
     
cicloPrincipal1:
     mtc1 $t5 $f2 # Se mueve el contenido de $t5 al registro $f12 del coprocesador
     cvt.s.w $f2 $f2 # Se convierte el contenido de $f2 en entero a flotante
     add.s $f13 $f0 $f26 # Se copia el contenido de $f0 al registro $f13
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 en el registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante" 
     
     add.s $f0 $f7 $f26 # Se copia a $f0 el resultado de la subrutina anterior (Se multiplica por 10 la entrada)
     add.s $f7 $f26 $f26 # Se limpia el registro $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f28
     cvt.w.s $f0 $f0 # Se convierte el contenido de $f0 a un entero
     mfc1 $t0 $f0 # Se mueve el numero del registro $f0 al registro $t0
     mtc1 $t0 $f0 # Se mueve de vuelta al registro $f0. Esto es para eliminar la parte necesaria que haya quedado del numero
     cvt.s.w $f0 $f0 # Se convierte de entero a flotante y ahora el numero ya no tiene parte decimal (esencial)
     
cicloPrincipal2:
     addi $t5 $t5 1 # Se aumenta el orden actual en 1 ( Se parte en orden 2)
     mtc1 $t5 $f2 # Se mueve el orden actual al registro $f2
     cvt.s.w $f2 $f2 # El numero anterior se transforma de entero a flotante
 
     jal potencia # Se llama a la subrutina "potencia"
     
     add.s $f24, $f26 $f4 # Se agrega al registro $f24 el resultado de la subrutina anterior
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
     add.s $f5, $f26, $f26 # Se limpia el registro $f5
     add.s $f8, $f26, $f26 # Se limpia el registro $f8
     
     mtc1 $t5 $f25 # Se mueve el contenido de $t5 al registro $f25
     cvt.s.w $f25 $f25 # Se transforma el contenido de $f25 de entero a flotante
     lwc1 $f13 numeroAyuda1 # Se carga en el registro $f13 el numero 0,01
     
     j algoritmoDivision # Se salta a la etiqueta "algoritmoDivision"
    
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
    
algoritmoDivision:   
     add.s $f23, $f26, $f24 # Se copia el numero guardado en $f24 al registro $f23
     
     jal division # Se llama a la subrutina "division". Se divide $f24 con $f25
     
     add.s $f20, $f26, $f4 # Se copia el resultado al registro $f20
     add.s $f4, $f26, $f26 # Se limpia el registro $f4
   
     c.eq.s $f24, $f26  # Se compara si los flotantes guardados en $f4 y $f26 son iguales
     bc1t recuperarCifrasOriginales # Si son iguales, se salta a la etiqueta "recuperarCifrasOriginales"
     
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
     
     j recuperarCifrasOriginales # Se salta a la etiqueta "recuperarCifrasOriginales"
     
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

recuperarCifrasOriginales:
     add.s $f23 $f26 $f26 # Se limpia el registro f23
     add.s $f24 $f26 $f26 # Se limpia el registro $f24
     add.s $f25 $f26 $f26 # Se limpia el registro $f25
     add.s $f3 $f26 $f26 # Se limpia el registro $f3
     add.s $f6 $f26 $f26 # Se limpia el registro $f6
     add.s $f7 $f26 $f26 # Se limpia el registro $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f16 $f26 $f26 # Se limpia el registro $f16
     add.s $f19 $f26 $f20 # Se limpia el registro $f19
     
     beq $t5 2 orden2 # Si el orden actual es 2, se salta a la etiqueta "orden2"
     beq $t5 3 orden3 # Si el orden actual es 3, se salta a la etiqueta "orden3"
     beq $t5 4 orden4 # Si el orden actual es 4, se salta a la etiqueta "orden4"
     beq $t5 5 orden5 # Si el orden actual es 5, se salta a la etiqueta "orden5"
     beq $t5 6 orden6 # Si el orden actual es 6, se salta a la etiqueta "orden6"
     beq $t5 7 orden7 # Si el orden actual es 7, se salta a la etiqueta "orden7"
     beq $t5 8 orden8 # Si el orden actual es 8, se salta a la etiqueta "orden8"
     beq $t5 9 orden9 # Si el orden actual es 9, se salta a la etiqueta "orden9"
     beq $t5 10 orden10 # Si el orden actual es 10, se salta a la etiqueta "orden10"
     beq $t5 11 orden11 # Si el orden actual es 11, se salta a la etiqueta "orden11"
     
orden2:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda2 # Se carga en el registro $f13 el numero 0,001
     
     jal multiplicacionFlotante  # Se llama a la subrutina "multiplicacionFlotante"
     
     j verificarSignoP2 # Se salta a la etiqueta "verificarSignoP2"
     
orden3:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     
     lwc1 $f13 numeroAyuda3  # Se carga en el registro $f13 el numero 0,0001
     
     jal multiplicacionFlotante # Se llama a la subrutina "mutliplicacionFlotante"
     
     beq $t8 1 verificarSigno # Si el contenido de $t8 es un numero 1, entonces se salta a la etiqueta "verificarSigno"
     j prepararRepetirCiclo # Se salta a la etiqueta "prepararRepetirCiclo"
     
orden4:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda4  # Se carga en el registro $f13 el numero 0,00001
     
     jal multiplicacionFlotante  # Se llama a la subrutina "multiplicacionFlotante"
     
     j verificarSignoP2 # Se salta a la etiqueta "verificarSignoP2"
     
orden5:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda5 # Se carga en el registro $f13 el numero 0,000001
     
     jal multiplicacionFlotante # Se llama a la subrutina "mutliplicacionFlotante"
     
     beq $t8 1 verificarSigno # Si el contenido de $t8 es un numero 1, entonces se salta a la etiqueta "verificarSigno"
     j prepararRepetirCiclo # Se salta a la etiqueta "prepararRepetirCiclo"
     
orden6:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda6 # Se carga en el registro $f13 el numero 0,0000001
     
     jal multiplicacionFlotante  # Se llama a la subrutina "multiplicacionFlotante"
     
     j verificarSignoP2 # Se salta a la etiqueta "verificarSignoP2"
     
orden7:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda7 # Se carga en el registro $f13 el numero 0,00000001
     
     jal multiplicacionFlotante # Se llama a la subrutina "mutliplicacionFlotante"
     
     beq $t8 1 verificarSigno # Si el contenido de $t8 es un numero 1, entonces se salta a la etiqueta "verificarSigno"
     j prepararRepetirCiclo # Se salta a la etiqueta "prepararRepetirCiclo"
      
orden8:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda8  # Se carga en el registro $f13 el numero 0,000000001
     
     jal multiplicacionFlotante  # Se llama a la subrutina "multiplicacionFlotante"
     
     j verificarSignoP2 # Se salta a la etiqueta "verificarSignoP2"
     
orden9:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda9  # Se carga en el registro $f13 el numero 0,0000000001
     
     jal multiplicacionFlotante # Se llama a la subrutina "mutliplicacionFlotante"
     
     beq $t8 1 verificarSigno # Si el contenido de $t8 es un numero 1, entonces se salta a la etiqueta "verificarSigno"
     j prepararRepetirCiclo # Se salta a la etiqueta "prepararRepetirCiclo"
      
orden10:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda10  # Se carga en el registro $f13 el numero 0,00000000001
     
     jal multiplicacionFlotante  # Se llama a la subrutina "multiplicacionFlotante"
     
     j verificarSignoP2 # Se salta a la etiqueta "verificarSignoP2"
     
orden11:
     add.s $f13 $f20 $f26 # Se guarda en $f13 el contenido de $f20, al cual se le necesita eliminar su parte decimal
     lwc1 $f19 numeroDiez # Se carga el numero 10.0 al registro $f19
     
     jal multiplicacionFlotante # Se llama a la subrutina "multiplicacionFlotante"
  
     cvt.w.s $f7 $f7 # Se convierte el contenido de $f7 de decimal a entero
     mfc1 $t0 $f7 # Se copia el contenido de $f7 al registro $t0
     mtc1 $t0 $f7 # Se copia de vuelta el contenido
     cvt.s.w $f7 $f7 # Se transforma de entero a flotante. Ahora el numero ya no tiene parte decimal
     add.s $f19 $f26 $f7 # Se agrega a $f19 el contenido de $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f7 $f26 $f26 # Se limpia el reistro $f7
     lwc1 $f13 numeroAyuda11 # Se carga en el registro $f13 el numero 0,000000000001
     
     jal multiplicacionFlotante # Se llama a la subrutina "mutliplicacionFlotante"
     
     beq $t8 1 verificarSigno # Si el contenido de $t8 es un numero 1, entonces se salta a la etiqueta "verificarSigno"
     j prepararRepetirCiclo # Se salta a la etiqueta "prepararRepetirCiclo"

verificarSigno:
     add.s $f9 $f7 $f7 # Se realiza la doble suma de $f7 y se guarda en $f9
     sub.s $f7 $f7 $f9 # Se realiza la resta de $f7 con la suma anterior, cambiando el signo a $f7
     j verificarSignoP2 # Se salta a la etiqueta "verificarSignoP2"

verificarSignoP2:
     add.s $f6 $f7 $f7 # Se realiza la doble suma de dos veces $f7 y se guarda en #f6
     sub.s $f7 $f7 $f6 # Se realiza la resta de $f7 con la suma anterior, cambiando el signo a $f7
     addi $t3 $t3 1 # Se aumenta el contador en 1
     bne $t5 $t3 verificarSignoP2 # Si el contador coincide no con el orden actual, se salta al inicio de la etiqueta
     
prepararRepetirCiclo:  
     add.s $f1 $f1 $f7 # Se suma el resultado del orden actual al resultado total
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 mensaje2P1 # Se carga al registro $a0 el "mensaje2P1"
     syscall # Se imprime el mensaje en la consola
     
     li $v0 2 # Se prepara para mostrar un flotante por consola
     syscall # Se imprime el flotante guardado en $f12
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 mensaje2P2 # Se carga al registro $a0 el "mensaje2P2"
     syscall # Se imprime el mensaje en la consola
     
     li $v0 1 # Se prepara para imprimir un entero
     move $a0, $t5 # Se copia el contenido de $t5 al registro $a0
     syscall # Se imprime el numero entero anterior
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 mensaje2P3 # Se carga al registro $a0 el "mensaje2P3"
     syscall # Se imprime el mensaje en la consola
     
     add.s $f24 $f12 $f26 # Se copia a $f24 el contenido de $f12
     add.s $f12 $f1 $f26 # Se copia a $f12 el contenido de $f1
     
     li $v0 2 # Se prepara para imprimir un flotante
     syscall # Se imprime el resultado del orden actual
     
     add.s $f12 $f24 $f26 # Se copia de vuelta el numero guardado en $f24 a $f12
     
     li $v0 4 # Se prepara para imprimir un string por consola
     la $a0 saltodeLinea # Se carga el salto de linea en el registro $a0
     syscall # Se imprime el salto de linea
     
     add.s $f6 $f26 $f26 # Se limpia el registro $f6
     add.s $f7 $f26 $f26 # Se limpia el registro $f7
     add.s $f8 $f26 $f26 # Se limpia el registro $f8
     add.s $f13 $f26 $f26 # Se limpia el registro $f13
     add.s $f19 $f26 $f26 # Se limpia el registro $f19
     add.s $f20 $f26 $f26 # Se limpia el registro $f20
     add.s $f24 $f26 $f26 # Se limpia el registro $f24
     
     beq $t5  $t1 END # Si el orden actual coincide con el orden maximo, se salta a la etiqueta "END"
     j cicloPrincipal2 # De lo contrario, se salta a la etiqueta "cicloPrincipal2" para seguir con el siguiente orden
     
invalido: 
     li $v0 4 # Se prepara para imprimir un mensaje por consola
     la $a0 numeroInvalido # Se carga el mensaje de "nuemeroInvalido"
     syscall # Se imprime el mensaje por consola
     
     j END # Se salta a la etiqueta "END"
      
END:
     move $t0, $zero # Se limpia el registro $t0
     move $t1, $zero # Se limpia el registro $t1
     move $t2, $zero # Se limpia el registro $t2
     move $t3, $zero # Se limpia el registro $t3
     move $t5, $zero # Se limpia el registro $t5
     move $t8, $zero # Se limpia el registro $t8
     
     li $v0, 10 # Se prepara para finalizar el programa
     syscall # Se finaliza el programa
 
