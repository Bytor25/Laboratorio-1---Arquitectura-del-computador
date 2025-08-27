	.data
# Textos de menú y mensajes
text_F00: .asciiz "\n\tCoseno hiperbólico\n"
text_F01: .asciiz "\n\tNOTA: Si desea ingresar fracciones, conviertalo a valores con decimales. ej: (1/2) = 0.5"
          .asciiz "\nIngrese un número real: "
text_F02: .asciiz "\n\tNOTA: La cantidad de iteraciones debe ser un número entero entre 0 y 100.\n Ingrese la cantidad de iteraciones: "
text_F03: .asciiz "\nEl resultado de cos("
text_F04: .asciiz ")es: "

# Mensajes de error
Etext_F00: .asciiz "\n\t ERROR: El límite de iteraciones no puede ser negativo, intentelo de nuevo."
Etext_F01: .asciiz "\n\t ERROR: El límite de iteraciones no puede ser mayor de 100, intentelo de nuevo."

# Valores constantes
dos_F: .double 2.0		
	.text
	j funciones_main
	

#---------- Coseno hiperbólico ---------- 
funciones_main:
	li $v0, 4
	la $a0, text_F00 # Mensaje "Coseno hiperbólico"
	syscall
	
	la $a0, text_F01
	syscall
	
	li $v0, 7 # Recibe el valor de X como double
	syscall
	
	mov.d $f2, $f0 # Mueve el valor de X a $f2
	
	li $t1, 0 # Se inicializa la variable de iteración
	
	j calcular_coseno_hiperbolico # Vuelve a calcular el coseno
	
iteracion_negativa_funciones: # Funcion para indicar cuando se ingresa un límite de iteración negativa
	li $v0,4
	la $a0, Etext_F00 # Mensaje de error
	syscall
	
	j calcular_coseno_hiperbolico # Vuelve a calcular el coseno
	
iteracion_mayor_funciones: # Funcion para indicar cuando se ingresa un límite de iteración mayor a 100
	li $v0, 4
	la $a0, Etext_F01 # Mensaje de error
	syscall
	
	j calcular_coseno_hiperbolico # Vuelve a calcular el coseno
	
calcular_coseno_hiperbolico: # Función de implementación de la formula para calculo de cosh(x)

	li $v0, 4
	la $a0, text_F02 # Límite de iteraciones para las series de taylor
	syscall
	
	li $v0, 5 # Recibe el valor del límite de iteraciones
	syscall 
	
	bltz $v0, iteracion_negativa_funciones # Validar que el límite de iteración no sea negativo
	bgt $v0, 100, iteracion_mayor_funciones # Validar que el límite de iteración no sea mayor a 100
	
	move $t2, $v0 # Mueve el valor de las iteraciones a t2
	
	li $t3, 1 # Variable para validación en el uso de euler en 1
	
	addi $sp, $sp, -4   # Reserva 4 bytes en la pila (mueve el puntero $sp hacia abajo)
	sw   $ra, 0($sp)    # Guarda el contenido del registro $ra (dirección de retorno) en la pila
	
	jal loop_euler # Salto para obtener e^x
	
	mov.d $f16, $f10 # Mueve el valor del resultado a $f16
	
	mov.d $f14, $f2 # Copia el valor de X como seguridad para imprimir despues
	
	neg.d $f2, $f2 # Niega a X para calcular e^-x
	
	li $t1, 0 # Reinicia la variable de iteración
	
	jal loop_euler # Salto para obtener e^-x
	
	li $t3, 0 # Variable para validación en el uso de euler en 0
	
	mov.d $f18, $f10 # Mueve el valor del resultado a $f18
	
	add.d $f20, $f18, $f16 # e^x + e^-x, almacena el resultado en $f20
	
	l.d $f24, dos_F # Carga la constante 2.0 (double) en el registro $f24
	
	div.d $f26, $f20, $f24 # [(e^x + e^-x)/2], almacena el resultado en $f26
	
	li $v0, 4
	la $a0, text_F03
	syscall
	
	mov.d $f12, $f14 # Mueve el valor de X para imprimirlo
	
	li $v0, 3 # Imprime el valor de X
	syscall
	
	li $v0, 4
	la $a0, text_F04
	syscall
	
	mov.d $f12, $f26 # Mueve el resultado para imprimirlo
	
	li $v0, 3 # Muestra el resultado
	syscall
	
    	lw   $ra, 0($sp) # Recupera el valor original de $ra desde la pila
    	addi $sp, $sp, 4 # Libera el espacio en la pila (restaura el puntero $sp)
    	jr   $ra # Regresa a la dirección guardada en $ra (continúa el programa)

	.include "expresiones.asm"
	
	
	


	
	
