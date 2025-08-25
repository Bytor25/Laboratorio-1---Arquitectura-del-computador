	.data
text_F00: .asciiz "\n\t Coseno Hiperbólico\n"
text_F01: .asciiz "\nIngrese un número real: "
text_F02: .asciiz "\n\t NOTA: Para el valor de la cantidad de iteraciones a realizar, debe estar en un rango de los números enteros 0 a 100 iteraciones. \n Ingrese la cantidad de iteraciones que desea realizar: "
text_F03: .asciiz "\nEl resultado del coseno hiperbolico es: "

dos_F: .double 2.0		
	.text
	j funciones_main
	

funciones_main:
	li $v0, 4
	la $a0, text_F00
	syscall
	
	la $a0, text_F01
	syscall
	
	li $v0, 7
	syscall
	
	mov.d $f2, $f0 # Valor de X
	
	li $v0, 4
	la $a0, text_F02
	syscall
	
	li $v0, 5
	syscall 
	move $t2, $v0
	
	li $t1, 0 # Variable de iteración
	

calcular_coseno_hiperbolico:
	li $t3, 1
	sw $ra, 0($sp)
	jal loop_euler
	
	mov.d $f16, $f10
	
	mov.d $f14, $f2
	
	neg.d $f2, $f2
	li $t1, 0
	jal loop_euler
	
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
	
	
	


	
	
