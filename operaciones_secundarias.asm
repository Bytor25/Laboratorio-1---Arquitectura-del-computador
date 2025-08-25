	.data
	
cero: .double 0.0
uno: .double 1.0

	.text

menos_uno_elevado_n: 
	li $t3, 0
	li $t4, 1
	neg $t4, $t4
	move $t5, $t4

loop_exponente:
	mul $t5, $t5, $t4
	
	add $t3, $t3, 1
	
	blt $t3, $t1, loop_exponente
	
	move $v0, $t5
	
	jr $ra
