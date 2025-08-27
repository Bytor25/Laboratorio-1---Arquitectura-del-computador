	.data
text_F00: .asciiz "\n\tCoseno hiperbólico\n"
text_F01: .asciiz "\nIngrese un número real: "
text_F02: .asciiz "\n\tNOTA: La cantidad de iteraciones debe ser un número entero entre 0 y 100.\n Ingrese la cantidad de iteraciones: "
text_F03: .asciiz "\nEl resultado del coseno hiperbólico es: "


dos_F: .double 2.0		
	.text
	j funciones_main
	

funciones_main:
	li $v0, 4
	la $a0, text_F00 # Imprime el texto "Coseno Hiperbólico cosh(x)
	syscall
	
	la $a0, text_F01 # Solicita el valor para 'x'
	syscall
	
	li $v0, 7 # Lee el valor para 'x' como tipo de dato double
	syscall
	
	mov.d $f2, $f0 # Mueve el valor de 'x' de f0 a f2
	
	li $v0, 4
	la $a0, text_F02 # Solicita la cantidad de iteraciónes que se desean realizar para el calculo del coseno hiperbólico
	syscall
	
	li $v0, 5 # Lee el valor para las iteraciones como tipo de dato entero
	syscall 
	
	move $t2, $v0 # Mueve el valor de las iteraciones de v0 a t2
	
	li $t1, 0 # Se inicializa la variable de iteración
	

calcular_coseno_hiperbolico: 
	li $t3, 1 # Variable para validación en el uso de euler
	
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	jal loop_euler # Salto para obtener e^x
	
	mov.d $f16, $f10 # Mueve el valor del resultado 
	
	mov.d $f14, $f2
	
	neg.d $f2, $f2
	li $t1, 0
	
	jal loop_euler # Salto para obtener e^-x
	
	li $t3, 0
	
	mov.d $f18, $f10
	
	add.d $f20, $f18, $f16
	
	l.d $f24, dos_F
	div.d $f12, $f20, $f24
	
	li $v0, 4
	la $a0, text_F03
	syscall
	
	li $v0, 3
	syscall
	
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4 
	jr $ra

	.include "expresiones.asm"
	
	
	


	
	
