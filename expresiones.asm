 	.data

text_E00: .asciiz "\n\tMenú de expresiones:\n 1. Cálculo de pi con el método de Leibniz\n 2. Cálculo de Euler e^x con series de Taylor\n 3. Integral definida\n 0. Salir\n"
text_E01: .asciiz "Seleccione una opción: "
text_E02: .asciiz "\n Cálculo de e^x con series de Taylor\n"
text_E03: .asciiz "\n Ingrese el valor de x: "
text_E04: .asciiz "\n\tNOTA: La cantidad de iteraciones debe ser un número entero entre 0 y 100.\n Ingrese la cantidad de iteraciones: "
text_E05: .asciiz "\n El resultado de pi es: "
text_E06: .asciiz "\n El resultado de elevado a "
text_E07: .asciiz " es: "


cero_E: .double 0.0	
uno_E: .double 1.0
cuatro_E: .double 4.0
	.text
	
	j expresiones_main
	
validar_opciones_expresiones:
	beqz $v0, end_expresiones_2
	beq $v0, 1, salto_pi_libniz
	beq $v0, 2, salto_euler_taylor
	beq $v0, 3, salto_integral

	
# Pi con método de Libniz			
salto_pi_libniz:
	li $v0, 4
	la $a0, text_E04 # Solicita la cantidad de iteraciones a realizar
	syscall

	li $v0, 5 # Lee el valor como un número entero
	syscall
	move $t2, $v0  # Se mueve el valor ingresado de limite de iteracion a t2     
	
	li $t1, 0	# Variable de iteración        
	l.d $f10, cero_E   	# Variable para almacenar el resultado final	

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	j loop_pi

loop_pi:
	jal menos_uno_elevado_n  # Calcula el valor de -1^n

	mul $t3, $t1, 2 # Multiplica a n por 2 (2n)
	addi $t4, $t3, 1 # Suma a 2n un uno (2n+1)
	
	mtc1 $v0, $f2 # Mueve el valor de -1^n al coprocesador
	cvt.d.w $f2, $f2 # Convierte de entero a doble
	
	mtc1 $t4, $f4 # Mueve el valor de (2n+1) al coprocesador
	cvt.d.w $f4, $f4 # Convierte de entero a doble
	
	div.d $f6, $f2, $f4 # Divide -1^n sobre (2n+1)
	
	add.d $f10, $f10, $f6 # Realiza la sumatoria de cada resultado de cada iteración
	
	addi $t1, $t1, 1
	
	ble $t1,$t2, loop_pi
	
resultado_pi:

	l.d $f8, cuatro_E
	
	mul.d $f12, $f10, $f8
	
	li $v0, 4
	la $a0, text_E05
	syscall
	
	
	li $v0, 3
	syscall
	
	j end_expresiones

	

salto_euler_taylor:
	li $v0, 4
	la $a0, text_E02
	syscall
	
	la $a0, text_E03
	syscall
	
	li $v0, 7
	syscall
	
	mov.d  $f2, $f0 # Valor de X
	
	li $v0, 4
	la $a0, text_E04
	syscall
	
	li $v0, 5
	syscall 
	move $t2, $v0
	
	li $t1, 0 # Variable de iteración
	
	j loop_euler
	
loop_euler:
	beqz $t1, t0_label
	ble $t1, $t2, calcular_euler
	bgt $t1, $t2, euler_resultado
	
	
calcular_euler:
	mtc1 $t1, $f4
	cvt.d.w $f4, $f4
	
	div.d $f6, $f2, $f4
	
	mul.d $f6, $f6, $f8
	
	add.d $f10, $f10, $f6
	mov.d $f8, $f6
	
	add $t1, $t1, 1
	
	j loop_euler
	
	
	
t0_label: 
	l.d $f8, uno_E # Resultado anterior (tn-1)
	l.d $f10, uno_E # Resultado final de la suma
	add $t1, $t1, 1
	j loop_euler
	
euler_resultado: 
	beq $t3, 1, coseno_hiperbolico 
	li $v0, 4
	la $a0, text_E06
	syscall
	
	mov.d $f12, $f2 
	li $v0, 3
	syscall
	
	li $v0, 4
	la $a0, text_E07
	syscall
	
	mov.d $f12, $f10
	
	li $v0, 3
	syscall
	
	j end_expresiones

coseno_hiperbolico: # Salto de retorno a la operación de coseno hiperbolico
	jr $ra

	
	
expresiones_main: # Menú principal para el área de expresiones
	li $v0, 4
	la $a0, text_E00
	syscall
	
	la $a0, text_E01
	syscall
	
	li $v0, 5
	syscall
	
	j validar_opciones_expresiones


salto_integral:
	j integral_main		
end_expresiones: 	
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4 
	jr $ra

		
end_expresiones_2: 	
	jr $ra
	.include "integral.asm"
	.include "operaciones_secundarias.asm"

	

	
	
