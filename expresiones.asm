 	.data
# Textos de men� y mensajes
text_E00: .asciiz "\n\tMen� de expresiones:\n 1. C�lculo de pi con el m�todo de Leibniz\n 2. C�lculo de Euler e^x con series de Taylor\n 3. Integral definida\n 0. Salir\n\t NOTA: Para seleccionar una opcion, ingrese el numero indicado antes de la opcion\n"
text_E01: .asciiz "Seleccione una opci�n: "
text_E02: .asciiz "\n C�lculo de e^x con series de Taylor\n"
text_E03: .asciiz "\n Ingrese el valor de x: "
text_E04: .asciiz "\n\tNOTA: La cantidad de iteraciones debe ser un n�mero entero entre 0 y 100.\n Ingrese la cantidad de iteraciones: "
text_E05: .asciiz "\n El resultado de pi es: "
text_E06: .asciiz "\n El resultado de e^"
text_E07: .asciiz " es: "

# Mensaje de error

Etext_E00: .asciiz "\n\t ERROR: Opci�n invalida, intentelo de nuevo."
Etext_E01: .asciiz "\n\t ERROR: El l�mite de iteraciones no puede ser negativo, intentelo de nuevo."
Etext_E02: .asciiz "\n\t ERROR: El l�mite de iteraciones no puede ser mayor de 100, intentelo de nuevo."


# Valores constantes
cero_E: .double 0.0	
uno_E: .double 1.0
cuatro_E: .double 4.0
	.text
	
	j expresiones_main

#---------- Men� expresiones ----------	
expresiones_main: # Men� principal para el �rea de expresiones
	li $v0, 4
	la $a0, text_E00 # Opciones del men�
	syscall
	
	la $a0, text_E01
	syscall
	
	li $v0, 5 # Recibe la opci�n seleccionada
	syscall
	
	j validar_opciones_expresiones
	
validar_opciones_expresiones: # Funci�n para validar la opcion ingresada por el usuario
	beqz $v0, end_expresiones_2 # Si opci�n = 0, lleva al main 
	beq $v0, 1, salto_pi_libniz # Si opci�n = 1, lleva a calcular pi con el m�todo de libniz
	beq $v0, 2, salto_euler_taylor # Si opci�n = 2, lleva a calcular el euler con series de taylor
	beq $v0, 3, salto_integral # Si opci�n = 3, lleva a calcular la integral definida 
	bltz $v0, opcion_invalida_expresiones # Valida que la opci�n no sea un n�mero negativo
	bge $v0, 4, opcion_invalida_expresiones # Valida que la opci�n no sea mayor o igual a 4
	
	
opcion_invalida_expresiones: # Funci�n para indicar cuando se ingresa una opci�n incorrecta
	li $v0, 4
	la $a0, Etext_E00 # Mensaje de error
	syscall
	
	j expresiones_main # Vuelve a iniciar el proceso en expresiones
	
iteracion_negativa_expresiones_pi: # Funcion para indicar cuando se ingresa un l�mite de iteraci�n negativo
	li $v0, 4
	la $a0, Etext_E01 # Mensaje de error
	syscall
	
	j salto_pi_libniz # Reinicia el proceso de calculo de pi
	
iteracion_mayor_expresiones_pi: # Funcion para indicar cuando se ingresa un l�mite de iteraci�n mayor a 100
	li $v0, 4
	la $a0, Etext_E02 # Mensaje de error
	syscall
	
	j salto_pi_libniz # Reinicia el proceso de calculo de pi
	
iteracion_negativa_expresiones_euler: # Funcion para indicar cuando se ingresa un l�mite de iteraci�n negativo
	li $v0, 4
	la $a0, Etext_E01 # Mensaje de error
	syscall
	
	j salto_euler_taylor # Reinicia el proceso de calculo de euler
	
iteracion_mayor_expresiones_euler: # Funcion para indicar cuando se ingresa un l�mite de iteraci�n mayor a 100
	li $v0, 4
	la $a0, Etext_E02 # Mensaje de error
	syscall
	
	j salto_euler_taylor # Reinicia el proceso de calculo de euler

	
#---------- Pi con el m�todo de Libniz ----------			
salto_pi_libniz: # Salto intermedio y punto de solicitud de datos para calculo de pi
	li $v0, 4
	la $a0, text_E04 # Solicita la cantidad de iteraciones a realizar
	syscall
	

	li $v0, 5 # Lee el valor como un n�mero entero
	syscall
	
	bltz $v0, iteracion_negativa_expresiones_pi # Validar que el l�mite de iteraci�n no sea negativo
	bgt $v0, 100 , iteracion_mayor_expresiones_pi # Validar que el l�mite de iteraci�n no sea mayor a 100
	
	move $t2, $v0  # Se mueve el valor ingresado de limite de iteracion a t2     
	
	li $t1, 0	# Variable de iteraci�n se inicia en 0    
	l.d $f10, cero_E   	# Variable para almacenar el resultado final	

	addi $sp, $sp, -4   # Reserva 4 bytes en la pila (mueve el puntero $sp hacia abajo)
	sw   $ra, 0($sp)    # Guarda el contenido del registro $ra (direcci�n de retorno) en la pila

	j loop_pi

loop_pi: # Funci�n de implementaci�n de la sumatoria para el calculo de pi
	jal menos_uno_elevado_n  # Calcula el valor de -1^n

	mul $t3, $t1, 2 # Multiplica a n por 2 (2n)
	addi $t4, $t3, 1 # Suma a 2n un uno (2n+1)
	
	mtc1 $v0, $f2 # Mueve el valor de -1^n al coprocesador
	cvt.d.w $f2, $f2 # Convierte de entero a doble
	
	mtc1 $t4, $f4 # Mueve el valor de (2n+1) al coprocesador
	cvt.d.w $f4, $f4 # Convierte de entero a doble
	
	div.d $f6, $f2, $f4 # Divide -1^n sobre (2n+1)
	
	add.d $f10, $f10, $f6 # Realiza la sumatoria de cada resultado de cada iteraci�n
	
	addi $t1, $t1, 1 # Aumenta la variable de iteraci�n 1 valor
	
	ble $t1,$t2, loop_pi # Validar si la variable de iteraci�n es menor o igual al l�mite de iteraci�n
	
resultado_pi: # Funci�n para mostrar el resultado de pi con el m�todo de Libniz

	l.d $f8, cuatro_E # Carga el valor constante 4.0 (double) en el registro $f8
	
	mul.d $f12, $f10, $f8 # 4 * resultado de la sumatoria, el resultado se almacena en $f12
	
	li $v0, 4
	la $a0, text_E05
	syscall
	
	
	li $v0, 3 # Muestra el resultado de pi
	syscall 
	
	j end_expresiones # Salto para volver al main

#---------- Euler con series de taylor ----------	
salto_euler_taylor: # Salto intermedio y punto de solicitud de datos para calculo de euler
	li $v0, 4
	la $a0, text_E02
	syscall
	
	la $a0, text_E04
	syscall
	
	li $v0, 5 # Recibe el valor del l�mite de iteraci�n
	syscall 
	
	bltz $v0, iteracion_negativa_expresiones_euler # Validar que el l�mite de iteraci�n no sea negativo
	bgt $v0, 100, iteracion_mayor_expresiones_euler # Validar que el l�mite de iteraci�n no sea mayor a 100
	
	move $t2, $v0 # Mueve el valor del l�mite de iteracion a $t2
	
	li $v0,4
	la $a0, text_E03
	syscall
	
	li $v0, 7 # Recibe el valor de X
	syscall
	
	mov.d  $f2, $f0 # Mueve el valor de X a $f2
	
	
	li $t1, 0 # Variable de iteraci�n iniciado en 0
	
loop_euler: # Funci�n de implementaci�n de la sumatoria para el calculo de euler
	beqz $t1, t0_label # Validar si $t1 = 0 para sumar al resultado de la sumatoria 1
	ble $t1, $t2, calcular_euler # Validar si $t1=< l�mite de iteraci�n para seguir con el loop
	bgt $t1, $t2, euler_resultado # Validar si $t1> l�mite de iteraci�n para mostrar el resultado de euler
	
	
calcular_euler: # Implementaci�n de operaci�n dentro de la sumatoria
	mtc1 $t1, $f4 # Carga el valor de la iteraci�n actual al coprocesador 1
	cvt.d.w $f4, $f4 # Convierte el valor de iteraci�n actual de entero a double
	
	div.d $f6, $f2, $f4 # X/n, el resultado se guarda en $f6
	
	mul.d $f6, $f6, $f8 # (X/n)*(tn-1)-> Resultado de la iteraci�n anterior
	
	add.d $f10, $f10, $f6 # Suma el resultado de la iteraci�n actual al resultado de la sumatoria total
	
	mov.d $f8, $f6 # Mueve el resultado de la iteracion actual a $f8 pra convertirse en la iteraci�n anterior
	
	add $t1, $t1, 1 # Aumenta la iteracion 1 valor
	
	j loop_euler # Salto para validar la continuidad del loop
	
	j euler_resultado
	
t0_label: # Funci�n que permite sumar al resultado de la sumatoria el valor 1 cuando la iteraci�n es 0
	l.d $f8, uno_E # Resultado anterior (tn-1)
	l.d $f10, uno_E # Resultado final de la suma
	add $t1, $t1, 1 # Aumenta la iteracion 1 valor
	
	j loop_euler # Salto para validar la continuidad del loop
	
euler_resultado: # Funci�n para mostrar el resultado de euler con series de Taylor

	beq $t3, 1, coseno_hiperbolico # Punto de validaci�n para evitar imprimir el resultado cuando se esta calculando coseno
	 
	li $v0, 4
	la $a0, text_E06
	syscall
	
	mov.d $f12, $f2 # Mueve el valor de X para imprimirlo
	
	li $v0, 3 # Muestra el valor de X
	syscall
	
	li $v0, 4
	la $a0, text_E07
	syscall
	
	mov.d $f12, $f10 # Mueve el resultado
	
	li $v0, 3 # Muestra el resultado
	syscall
	
	j end_expresiones_2 # Salto para volver al main 

coseno_hiperbolico: # Salto de retorno a la operaci�n de coseno hiperbolico
	jr $ra # Regresa a la direcci�n guardada en $ra (contin�a el programa)


salto_integral: # Salto intermedio cuando se desea calcular la integral definida
	j integral_main # Salto para la solicitud de variables para el calculo de la integral
			
end_expresiones:
    	lw   $ra, 0($sp) # Recupera el valor original de $ra desde la pila
    	addi $sp, $sp, 4 # Libera el espacio en la pila (restaura el puntero $sp)
    	jr   $ra # Regresa a la direcci�n guardada en $ra (contin�a el programa)

end_expresiones_2:
    	jr   $ra # Regresa directamente usando $ra (no us� pila para guardar $ra)
    	
	.include "integral.asm"
	.include "operaciones_secundarias.asm"

	

	
	
