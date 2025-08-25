 	.data

text_E00: .asciiz "\n\t Menú expresiones:\n 1. Cálculo de pi con el método de Libniz\n 2.Cálculo de Euler 'e^x' con series de taylor\n 3. Integral definida\n 0. Salir\n"
text_E01: .asciiz "Seleccione una opción: "
text_E02: .asciiz "\n e^x con series de taylor\n"
text_E03: .asciiz "\n Ingrese el valor para x: "
text_E04: .asciiz "\n\t NOTA: Para el valor de la cantidad de iteraciones a realizar, debe estar en un rango de los números enteros 0 a 100 iteraciones. \n Ingrese la cantidad de iteraciones que desea realizar: "
text_E05: .asciiz "\n El resultado es: "

cero_E: .double 0.0	
uno_E: .double 1.0
	.text
	
	j expresiones_main
	
validar_opciones_expresiones:
	beqz $v0, end_expresiones_2
	beq $v0, 1, salto_pi_libniz
	beq $v0, 2, salto_euler_taylor
	
salto_pi_libniz:
	li $v0, 4
	la $a0, text_E04
	syscall

	li $v0, 5
	syscall
	move $t2, $v0       
	
	li $t1, 0           
	li $t9, 0
	mtc1  $t9, $f10
	cvt.d.w $f10, $f10

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	j loop_pi

loop_pi:
	jal menos_uno_elevado_n  

	mtc1 $v0, $f2
	cvt.d.w $f2, $f2

	mul $t6, $t1, 2
	add $t7, $t6, 1
	mtc1 $t7, $f4
	cvt.d.w $f4, $f4

	# division double: f6 = f2 / f4
	div.d $f6, $f2, $f4

	# acumular: f10 += f6
	add.d $f10, $f10, $f6

	# incrementar contador n
	addi $t1, $t1, 1
	ble $t1, $t2, loop_pi

	# multiplicar por 4.0
	li $t9, 4
	mtc1 $t9, $f8
	cvt.d.w $f8, $f8
	mul.d $f12, $f10, $f8   # f12 = resultado

	j resultado_pi

resultado_pi:
	li $v0, 4
	la $a0, text_E05
	syscall
	
	# imprimir double f12
	li $v0, 3
	mov.d $f12, $f12
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
	la $a0, text_E05
	syscall
	
	mov.d $f12, $f10
	
	li $v0, 3
	syscall

coseno_hiperbolico:
	jr $ra
	
expresiones_main:
	li $v0, 4
	la $a0, text_E00
	syscall
	
	la $a0, text_E01
	syscall
	
	li $v0, 5
	syscall
	
	j validar_opciones_expresiones
	
end_expresiones: 	
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4 
	jr $ra
	
end_expresiones_2: 	
	jr $ra
	.include "operaciones_secundarias.asm"

	

	
	
