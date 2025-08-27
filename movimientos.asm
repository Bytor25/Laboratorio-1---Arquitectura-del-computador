	.data
	
text_M00: .asciiz "\n\tMenú de movimientos\n 1. Movimiento rectilíneo uniformemente acelerado\n 2. Movimiento circular uniforme\n 0. Salir\n"
text_M01: .asciiz "\nSeleccione una opción: "
text_M02: .asciiz "\n\t¿Qué variable desea calcular?\n 1. Velocidad en función del tiempo\n 2. Distancia en función del tiempo\n 0. Salir"
text_M03: .asciiz "\n\tIngrese el valor de las siguientes variables:\n\tNOTA: Los valores deben ser decimales o enteros reales, no imaginarios.\n\n"
text_M04: .asciiz "\n\tNOTA: Ingrese la velocidad inicial en metros por segundo (m/s). Si no está en esta unidad, realice la conversión manual.\n Velocidad inicial (v0) = "
text_M05: .asciiz "\n\tNOTA: Ingrese la aceleración en metros por segundo al cuadrado (m/s^2). Si no está en esta unidad, realice la conversión manual.\n Aceleración (a) = "
text_M06: .asciiz "\n\tNOTA: Ingrese el tiempo en segundos (s). Si no está en esta unidad, realice la conversión manual. El valor solo puede ser positivo.\n Tiempo (t) = "
text_M07: .asciiz "\n La velocidad calculada en metros por segundo fue: "
text_M08: .asciiz "\n ¡El tiempo no puede ser negativo! Ingrese un nuevo valor.\n"
text_M09: .asciiz "\n\tNOTA: Ingrese la distancia inicial en metros. Si no está en esta unidad, realice la conversión manual.\n Distancia inicial (x0) = "
text_M10: .asciiz "\n La distancia calculada en metros fue: "
text_M11: .asciiz "\n\t¿Qué variable desea calcular?\n 1. Velocidad angular\n 2. Velocidad lineal\n 0. Salir\n"
text_M12: .asciiz "\n\tNOTA: Ingrese el periodo en segundos (s). Si no está en esta unidad, realice la conversión manual. El valor solo puede ser positivo.\n Periodo (T) = "
text_M13: .asciiz "\n La velocidad angular en rad/s es: "
text_M14: .asciiz "\n\tNOTA: Ingrese el radio en metros (m). Si no está en esta unidad, realice la conversión manual. El valor solo puede ser positivo.\n Radio (r) = "
text_M15: .asciiz "\n La velocidad lineal en m/s es: "
text_M16: .asciiz "\n ¡El radio no puede ser negativo! Ingrese un nuevo valor.\n"


cero_M: .double 0.0
un_medio_M: .double 0.5
pi_M: .double 3.141592653589793
dos_M: .double 2.0

	.text
	
	j movimientos_main
	
movimientos_main:
	li $v0, 4
	la $a0, text_M00
	syscall
	
	la $a0, text_M01
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0

validar_opciones_movimientos:
	beqz $t1, end_movimientos_2 # Validar si la opcion del menú secundario de movimientos es 0, en caso de ser cierto, vuelve al menú principal en el main.
	beq $t1, 1, variables_mrua # Validar si la opcion del menú secundario de movimientos es 1, en caso de ser cierto, se dirige a la función variables_mrua.
	beq $t1, 2, variables_mcu # Validar si la opcion del menú secundario de movimientos es 2, en caso de ser cierto, se dirige a la función variables_mcu.

variables_mrua:
	li $v0, 4
	la $a0, text_M02
	syscall
	
	la $a0, text_M01
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0
	

validar_variables_mrua:
	beqz $t2, end_movimientos_2 # Valida si la opcion en los tipos de variables de MRUA es 0, de caso de que se cumpla, vuelve al menú principal en el main.
	beq $t2, 1, calcular_velocidad # Valida si la opción en los tipos de variables de MRUA es 1, en caso de ser cierto, se dirige a la función calcular velocidad.
	beq $t2, 2, calcular_distancia # Valida si la opción en los tipos de variables de MRUA es 2, en caso de ser cierto, se dirige a la función calcular distancia.

calcular_distancia:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	jal solicitar_variables_distancia 
	
	mul.d $f10, $f6, $f6 # Eleva el tiempo al cuadrado y guarda el resultado en el registro $f10
	
	l.d $f14, un_medio_M # Carga el valor 0.5 en el registro $f14
	mul.d $f16, $f14, $f4 # Multiplica a un medio por la aceleración y almacena el resultado en el registro $f16
	
	mul.d $f18, $f16, $f10 # Multiplica el tiempo al cuadrado por el resultado de 1/2 por la aceleración y el resultado lo almacena en el registro $f18
	
	mul.d $f20, $f2, $f6 # Multiplica la velocidad inicial por el tiempo
	
	add.d $f22, $f20, $f18 # Suma el resultado de la velocidad inicial por el tiempo mas el resultado de el tiempo al cuadrado por el resultado de 1/2 por la aceleración
	
	add.d $f12, $f22, $f8 # Suma el resultado anterior con la distancia incial
	
	li $v0, 4
	la $a0, text_M10
	syscall
	
	li $v0, 3 # Muestra el resultado de la operación
	syscall
	
	j end_movimientos
	
solicitar_variables_distancia:
	li $v0, 4
	la $a0, text_M03
	syscall
	
	la $a0, text_M06 
	syscall
	
	li $v0, 7 # Recibe el valor del tiempo
	syscall
	
	l.d $f2, cero_M # Carga el valor de 0.0 en el registro $f2.
	c.lt.d $f0, $f2 # Compara si el valor de $f0 es menor que el de $f2 para validar que el tiempo no sea negativo
    	bc1t tiempo_negativo # Si la anterior condicion se cumple, se envia a la funcion de tiempo_negatico
	
	mov.d $f6, $f0 # Mueve el valor del tiempo al registro $f6
	
	li $v0,4
	la $a0, text_M04 # Recibe el valor de la velocidad inicial
	syscall
	
	li $v0, 7
	syscall
	
	mov.d $f2, $f0 # Mueve el valor de la velocidad inicial al registro $f2
	
	li $v0, 4
	la $a0, text_M05
	syscall
	
	li $v0,7 # Recibe el valor de la aceleración
	syscall
	
	mov.d $f4, $f0 # Mueve el valor de la aceleración al registro $f4
	
	li $v0, 4
	la $a0, text_M09
	syscall
	
	li $v0,7 # Recibe el valor de la distancia inicial
	syscall
	
	mov.d $f8, $f0 # Mueve el valor de la distancia inicial al registro $f8
	
	jr $ra

calcular_velocidad:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	jal solicitar_variables_velocidad
	
	mul.d $f8, $f4, $f6 # Multiplica la aceleracion($f2) con el tiempo($f3) y lo almacena en el registro $f4.
	add.d $f12, $f2, $f8 # Sumar la velocidad inicial($f11) con el resultado de multiplicar aceleracion con tiempo ($f4).
	
	li $v0, 4
	la $a0, text_M07
	syscall
	
	li $v0, 3 # Muestra el resultado de la operación
	syscall
	
	j end_movimientos

solicitar_variables_velocidad: # Menú que muestra las opciones de variables a encontrar en el MRUA
	li $v0, 4
	la $a0, text_M03
	syscall
	
	la $a0, text_M06
	syscall
	
	li $v0, 7
	syscall
	
	l.d $f2, cero_M # Carga el valor de 0.0 en el registro $f2.
	c.lt.d $f0, $f2 # Compara si el valor de $f0 es menor que el de $f2 para validar que el tiempo no sea negativo
    	bc1t tiempo_negativo # Si la anterior condicion se cumple, se envia a la funcion de tiempo_negatico
	
	mov.d $f6, $f0 # Mueve el valor del tiempo al registro $f6
	
	li $v0,4
	la $a0, text_M04
	syscall
	
	li $v0, 7
	syscall
	
	mov.d $f2, $f0 # Mueve el valor de la velocidad inicial al registro $f2
	
	li $v0, 4
	la $a0, text_M05
	syscall
	
	li $v0,7
	syscall
	
	mov.d $f4, $f0 # Mueve el valor de la aceleración al regiistro $f4
	
	jr $ra
	
tiempo_negativo:
    	li $v0, 4
    	la $a0, text_M08
    	syscall
    	j solicitar_variables_velocidad	
		
variables_mcu:
	li $v0, 4
	la $a0, text_M11
	syscall
	
	la $a0, text_M01
	syscall
	
	li $v0, 5
	syscall
	move $t3, $v0

validar_variables_mcu:
	beqz $t3, end_movimientos_2 
	beq $t3, 1, calcular_velocidad_angular 
	beq $t3, 2, obtener_velocidad_angular
	
calcular_velocidad_angular:
	li $v0, 4
	la $a0, text_M12
	syscall
	
	li $v0, 7
	syscall
	
	l.d $f2, cero_M
    	c.le.d $f0, $f2
    	bc1t periodo_invalido
	
	mov.d $f8, $f0
	
	l.d $f2, pi_M
	l.d $f4, dos_M
	mul.d $f6, $f2, $f4
	
	div.d $f12, $f6, $f8
	
	beq $t7,1, salto_velocidad_lineal
	
	li $v0, 4
	la $a0,text_M13
	syscall
	
	li $v0, 3
	syscall 
salto_velocidad_lineal:
	jr $ra

periodo_invalido:
	li $v0, 4
    	la $a0, text_M08
    	syscall
    	
    	j calcular_velocidad_angular

obtener_velocidad_angular:
	li $t7, 1
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	jal calcular_velocidad_angular
	
	li $t7, 0
	
	j calcular_velocidad_lineal
	
calcular_velocidad_lineal:
	li $v0, 4
	la $a0, text_M14
	syscall
	
	li $v0, 7
	syscall
	
	l.d $f2, cero_M
    	c.le.d $f0, $f2
    	bc1t radio_invalido
	
	mov.d $f10, $f0
	
	mul.d $f12, $f12, $f10
	
	li $v0, 4
	la $a0, text_M15
	syscall
	
	li $v0, 3
	syscall
	
	j end_movimientos
	
radio_invalido:
	li $v0, 4
    	la $a0, text_M16
    	syscall
    	
    	j calcular_velocidad_lineal	
		
end_movimientos:
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4 
	jr $ra
end_movimientos_2:
	jr $ra
	
	
