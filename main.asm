	.globl main

	.data

text00: .asciiz "\n\tMenú\n 1. Movimientos\n 2. Funciones\n 3. Expresiones varias\n 0. Salir\n"
text01: .asciiz "Seleccione una opción: "

Etext00: .asciiz "\n\tNo se pueden ingresar valores negativos, intentelo de nuevo\n"
Etext01: .asciiz "\n\t Opción invalida, intentelo de nuevo\n"

	.text 
	
	j main
	
validar_opcion:
	beqz $v0, end
	beq $v0, 1, salto_movimientos
	beq $v0, 2, salto_funciones
	beq $v0, 3, salto_expresiones
	
	bltz $v0, dato_negativo

main:  
	li $v0, 4
	la $a0, text00
	syscall
	
	la $a0, text01
	syscall
	
	li $v0, 5
	syscall
	j validar_opcion
	
salto_expresiones:
	j expresiones_main

salto_funciones:
	j funciones_main
	
salto_movimientos:
	j movimientos_main
	
dato_negativo:
	li $v0, 4
	la $a0, Etext00
	syscall
	
	j main

end:
	li $v0, 16
	syscall


	.include "funciones.asm"	
	.include "expresiones.asm"
	.include "movimientos.asm"
	

	
