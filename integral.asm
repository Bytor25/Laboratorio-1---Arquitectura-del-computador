	.data
	
text_I00: .asciiz "\n\tIntegral de x^2 en el intervalo [a, b]"
text_I01: .asciiz "\n\tNOTA: Los valores de a y b deben ser reales, y b no puede ser menor que a."
text_I02: .asciiz "\n Ingrese el valor de 'a': "
text_I03: .asciiz "\n Ingrese el valor de 'b': "
text_I04: .asciiz "\n La integral de x^2 entre "
text_I05: .asciiz ", "
text_I06: .asciiz " es: "
text_I07: .asciiz "\n\tNOTA: La cantidad de iteraciones debe ser un número entero entre 0 y 100.\n Ingrese la cantidad de iteraciones: "

Etext_I00: .asciiz "\n ERROR: El valor de b no puede ser menor que a. Intentelo de nuevo."

dos_I: .double 2.0
cero_I: .double 0.0
	
	.text
	
	j integral_main
	
integral_main:
	li $v0, 4
	la $a0, text_I00
	syscall
	
	la $a0, text_I01
	syscall
	
	la $a0, text_I02
	syscall
	
	li $v0, 7
	syscall 
	
	mov.d $f2, $f0
	
	li $v0, 4
	la $a0, text_I03
	syscall
	
	li $v0, 7
	syscall
	
	mov.d $f4, $f0
	
	c.lt.d $f4, $f2
	bc1t b_menor_a
	
	li $v0, 4
	la $a0, text_I07
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0
	
	li $t1, 1
	l.d $f22, cero_I
	
	j calcular_integral
	
	
b_menor_a:
	li $v0, 4
	la $a0, Etext_I00
	syscall
	
	j integral_main
	
resultado_integral:
	li $v0, 4
	la $a0, text_I04
	syscall
	
	mov.d $f12, $f2
	li $v0, 3
	syscall
	
	li $v0, 4
	la $a0, text_I05
	syscall
	
	mov.d $f12, $f4
	li $v0, 3
	syscall
	
	li $v0, 4
	la $a0, text_I06
	syscall
	
	mov.d $f12, $f14
	li $v0, 3
	syscall
	
	j end_integral
	
calcular_integral:

	# Calculo de h (b-a)/n
	
	sub.d $f6, $f4, $f2
	
	mtc1 $t2, $f8
	cvt.d.w $f8, $f8
	
	div.d $f10, $f6, $f8 # Valor para h
	
	l.d $f6,dos_I
	
	div.d $f26, $f10,$f6 # resultado de h/2
	
	mov.d $f28, $f4
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal elevar_cuadrado
	
	mov.d $f16, $f30
	
	j loop_integral_sumatoria
	
elevar_cuadrado:

	mul.d $f30, $f28, $f28
	jr $ra
	
loop_integral_sumatoria:

	mtc1 $t1, $f6
	cvt.d.w $f6, $f6
	
	mul.d $f8, $f6, $f10
	
	add.d $f14, $f2, $f8
	
	mov.d $f28, $f14
	
	jal elevar_cuadrado
	
	mov.d $f18, $f30
	
	add.d $f22, $f22, $f18
	
	add $t1, $t1, 1
	
	blt $t1, $t2, loop_integral_sumatoria
	
operacion_final:
	l.d $f6, dos_I
	
	mul.d $f22, $f22,$f6 
	
	add.d $f20, $f22, $f16
	
	mov.d $f28, $f2 # Se mueve el valor de a para calcular a^2
	
	jal elevar_cuadrado
	
	mov.d $f8, $f30 # Mueve el resultado de a^2 al registro f16
	
	add.d $f24, $f8, $f20
	
	mul.d $f14, $f26, $f24
	
	j resultado_integral
	
	
end_integral:
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4 
	jr $ra	
	
	
	
	
	

	
	

	
	
	
	
	
	
	