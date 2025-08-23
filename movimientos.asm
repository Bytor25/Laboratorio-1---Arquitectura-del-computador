	.data
	
text_M00: .asciiz "\n\tMenú movimientos\n 1. Movimiento rectilíneo uniformemente acelerado\n 2. Movimiento circular uniforme\n 0. Salir\n "
text_M01: .asciiz "Seleccione una opción: "	
text_M02: .asciiz "\n\t¿Qué variable desea calcular:\n 1. Velocidad en función del tiempo \n 2. Distancia o posición en función del tiempo\n 0. salir"
text_M03: .asciiz "\n\tIngrese el valor de las siguientes variables:\n\t ¡¡¡NOTA!!! El valor de las variables no pueden ser valores imaginarios, solo valores decimales o enteros.\n\n"
text_M04: .asciiz "\n\t¡¡NOTA!! Para el valor de la velocidad inicial, ingrese el dato en metros sobre segundo (m/s), en caso de no tenerla en este tipo de unidad internacional, haga la conversion manualmente.\n Velocidad inicial(v0) = "
text_M05: .asciiz "\n\t¡¡NOTA!! Para el valor de la aceleración, ingrese el dato en metros sobre segundo al cuadrado (m/s^2), en caso de no tenerla en este tipo de unidad internacional, haga la conversion manualmente.\n Aceleración(a) = "
text_M06: .asciiz "\n\t¡¡NOTA!! Para el valor del tiempo, ingrese el dato en segundos (s), en caso de no tenerla en este tipo de unidad internacional, haga la conversion manualmente y el valor en solo puede ser positivo.\n Tiempo(t) = "
text_M07: .asciiz "\n La velocidad calculada en metros sobre segundo, fue de: " 
text_M08: .asciiz "\n ¡¡¡El tiempo no puede ser negativo!!!. Ingrese un número nuevo.\n"
text_M09: .asciiz "\n\t ¡¡NOTA!! Para el valor de la distancia inicial, ingrese el dato en metros, en caso de no tener el dato en este tipo de unidad internacional, haga la conversion manualmente.\n Distancia inicial(x0) = "
text_M10: .asciiz "\n La distancia calculada en metros, fue de: "

cero: .double 0.0
un_medio: .double 0.5

	.text
	
	j movimientos_main

validar_opciones_movimientos:
	beqz $t1, end_movimientos # Validar si la opcion del menú secundario de movimientos es 0, en caso de ser cierto, vuelve al menú principal en el main.
	beq $t1, 1, variables_mrua # Validar si la opcion del menú secundario de movimientos es 1, en caso de ser cierto, se dirige a la función variables_mrua.

validar_variables_mrua:
	beqz $t2, end_movimientos # Valida si la opcion en los tipos de variables de MRUA es o, de caso de que se cumpla, vuelve al menú principal en el main.
	beq $t2, 1, calcular_velocidad # Valida si la opción en los tipos de variables de MRUA es 1, en caso de ser cierto, se dirige a la función calcular velocidad.
	beq $t2, 2, calcular_distancia # Valida si la opción en los tipos de variables de MRUA es 2, en caso de ser cierto, se dirige a la función calcular distancia.
calcular_distancia:
	jal solicitar_variables_distancia 
	
	mul.d $f10, $f6, $f6 # Eleva el tiempo al cuadrado y guarda el resultado en el registro $f10
	
	l.d $f14, un_medio # Carga el valor 0.5 en el registro $f14
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
	la $a0, text_M06 
	syscall
	
	li $v0, 7 # Recibe el valor del tiempo
	syscall
	
	l.d $f2, cero # Carga el valor de 0.0 en el registro $f2.
	c.lt.d $f0, $f2 # Compara si el valor de $f0 es menor que el de $f2 para validar que el tiempo no sea negativo
    	bc1t tiempo_negativo # Si la anterior condicion se cumple, se envia a la funcion de tiempo_negatico
	
	mov.d $f6, $f0 # Mueve el valor del tiempo al registro $f6
	
	li $v0,4
	la $a0, text_M03
	syscall
	
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
	la $a0, text_M06
	syscall
	
	li $v0, 7
	syscall
	
	l.d $f2, cero # Carga el valor de 0.0 en el registro $f2.
	c.lt.d $f0, $f2 # Compara si el valor de $f0 es menor que el de $f2 para validar que el tiempo no sea negativo
    	bc1t tiempo_negativo # Si la anterior condicion se cumple, se envia a la funcion de tiempo_negatico
	
	mov.d $f6, $f0 # Mueve el valor del tiempo al registro $f6
	
	li $v0,4
	la $a0, text_M03
	syscall
	
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
	
variables_mrua:
	li $v0, 4
	la $a0, text_M02
	syscall
	
	la $a0, text_M01
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0
	
	j validar_variables_mrua
	
movimientos_main:
	li $v0, 4
	la $a0, text_M00
	syscall
	
	la $a0, text_M01
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0
	j validar_opciones_movimientos
	
	
	
end_movimientos:
	j main
	
	
