	.data
	
	.text

menos_uno_elevado_n:
	andi $t0, $t1, 1 
    	beq  $t0, $zero, es_par
    
es_impar:
    	li   $v0, -1
    	jr   $ra

es_par:
    	li   $v0, 1
    	jr   $ra
