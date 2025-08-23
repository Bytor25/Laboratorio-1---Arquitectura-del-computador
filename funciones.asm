	.data
text_F00: .asciiz "Funciones\n"
		
	.text
	
funciones_main:
	li $v0, 4
	la $a0, text_F00
	syscall
	
	j main
