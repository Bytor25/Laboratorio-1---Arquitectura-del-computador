	.globl main

	.data

text00: .asciiz "\n\tMen�\n 1. Movimientos\n 2. Funciones\n 3. Expresiones varias\n 0. Salir\n"
text01: .asciiz "Seleccione una opci�n: "

Etext00: .asciiz "\n\tNo se pueden ingresar valores negativos, intentelo de nuevo\n"
Etext01: .asciiz "\n\t Opci�n invalida, intentelo de nuevo\n"

	.text 
	
	j main
	
validar_opcion: # Funci�n para validar la opci�n seleccionada en el men� principal
	beqz $v0, end
	beq $v0, 1, salto_movimientos
	beq $v0, 2, salto_funciones
	beq $v0, 3, salto_expresiones
	
	bltz $v0, dato_negativo

main:  # Muestra el men� principal y recibe el valor de la opci�n
	li $v0, 4
	la $a0, text00
	syscall
	
	la $a0, text01
	syscall
	
	li $v0, 5
	syscall
	j validar_opcion
	
salto_expresiones: # Salto intermedio para el archivo de expresiones
	jal expresiones_main
	j main

salto_funciones: # Salto intermedio para el archivo de funciones
	jal funciones_main
	
	j main
	
salto_movimientos: # Salto intermedio para el archivo de movimientos
	jal movimientos_main
	
	j main
	
dato_negativo: # Valida que el valor ingresado en la opci�n no sea negativo
	li $v0, 4
	la $a0, Etext00
	syscall
	
	j main

end:
	li $v0, 10
	syscall


	.include "funciones.asm"	
	.include "movimientos.asm"
	

	
