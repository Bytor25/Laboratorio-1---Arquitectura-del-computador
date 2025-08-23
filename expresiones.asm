 	.data

text_E00: .asciiz "\n\t Menú expresiones:\n 1. Cálculo de pi con el método de Libniz\n 2.Cálculo de Euler 'e' elevado a la potencia 'x'\n 3. Integral definida\n 0. Salir\n"
text_E01: .asciiz "Seleccione una opción: "	
	
	.text
	
	j expresiones_main
	
validar_opciones_expresiones:
	beqz $v0, end_expresiones
	beq $v0, 1, salto_pi_libniz
	
salto_pi_libniz:
	
	
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
	j main
	

	
	
