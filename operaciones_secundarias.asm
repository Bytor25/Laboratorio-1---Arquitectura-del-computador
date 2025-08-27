	.data
	
	.text

menos_uno_elevado_n:
    	andi $t0, $t1, 1        # Saca el último bit del número en $t1
                            	    # ($t0=0 si es par, $t0=1 si es impar)

    	beq  $t0, $zero, es_par # Si $t0 es 0, salta a "es_par"
                            	    # (eso significa que el número es par)


    
es_impar:
    	li   $v0, -1 # Carga el valor -1 en el registro $v0
    	jr   $ra # Salto a la posición almacenada en memoria

es_par:
    	li   $v0, 1 # Carga el valor 1 en el registro $v0
    	jr   $ra # Salto a la posición almacenada en memoria
