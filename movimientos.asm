	.data
# Textos de menú y mensajes	
text_M00: .asciiz "\n\tMenú de movimientos\n 1. Movimiento rectilíneo uniformemente acelerado\n 2. Movimiento circular uniforme\n 0. Salir\n\t NOTA: Para seleccionar una opcion, ingrese el numero indicado antes de la opcion\n"
text_M01: .asciiz "\nSeleccione una opción: "
text_M02: .asciiz "\n\t¿Qué variable desea calcular?\n 1. Velocidad en función del tiempo\n 2. Distancia en función del tiempo\n 0. Salir"
text_M03: .asciiz "\n\tIngrese el valor de las siguientes variables:\n\tNOTA: Los valores deben ser decimales o enteros reales, no imaginarios.\n\n"
text_M04: .asciiz "\n\tNOTA: Ingrese la velocidad inicial en metros por segundo (m/s). Si no está en esta unidad, realice la conversión manual."
          .asciiz "\n\tNOTA: Si desea ingresar fracciones, conviertalo a valores con decimales. ej: (1/2) = 0.5"
          .asciiz "\n Velocidad inicial (v0) = "
text_M05: .asciiz "\n\tNOTA: Ingrese la aceleración en metros por segundo al cuadrado (m/s^2). Si no está en esta unidad, realice la conversión manual."
          .asciiz "\n\tNOTA: Si desea ingresar fracciones, conviertalo a valores con decimales. ej: (1/2) = 0.5"
          .asciiz "\n Aceleración (a) = "
text_M06: .asciiz "\n\tNOTA: Ingrese el tiempo en segundos (s). Si no está en esta unidad, realice la conversión manual. El valor solo puede ser positivo."
          .asciiz "\n\tNOTA: Si desea ingresar fracciones, conviertalo a valores con decimales. ej: (1/2) = 0.5"
          .asciiz "\n Tiempo (t) = "
text_M07: .asciiz "\n La velocidad calculada en metros por segundo fue: "
text_M09: .asciiz "\n\tNOTA: Ingrese la distancia inicial en metros. Si no está en esta unidad, realice la conversión manual."
          .asciiz "\n\tNOTA: Si desea ingresar fracciones, conviertalo a valores con decimales. ej: (1/2) = 0.5"
          .asciiz "\n Distancia inicial (x0) = "
text_M10: .asciiz "\n La distancia calculada en metros fue: "
text_M11: .asciiz "\n\t¿Qué variable desea calcular?\n 1. Velocidad angular\n 2. Velocidad lineal\n 0. Salir\n"
text_M12: .asciiz "\n\tNOTA: Ingrese el periodo en segundos (s). Si no está en esta unidad, realice la conversión manual. El valor solo puede ser positivo."
          .asciiz "\n\tNOTA: Si desea ingresar fracciones, conviertalo a valores con decimales. ej: (1/2) = 0.5"
          .asciiz "\n Periodo (T) = "
text_M13: .asciiz "\n La velocidad angular en rad/s es: "
text_M14: .asciiz "\n\tNOTA: Ingrese el radio en metros (m). Si no está en esta unidad, realice la conversión manual. El valor solo puede ser positivo."
          .asciiz "\n\tNOTA: Si desea ingresar fracciones, conviertalo a valores con decimales. ej: (1/2) = 0.5"
          .asciiz "\n Radio (r) = "
text_M15: .asciiz "\n La velocidad lineal en m/s es: "

# Mensajes de error
Etext_M00: .asciiz "\n\t ERROR: Opcion invalida, intentelo de nuevo."
Etext_M01: .asciiz "\n\t ERROR: ¡El tiempo no puede ser negativo,! Ingrese un nuevo valor.\n"
Etext_M02: .asciiz "\n\t ERROR: ¡El radio no puede ser negativo!, Ingrese un nuevo valor.\n"

# Valores constantes
cero_M: .double 0.0
un_medio_M: .double 0.5
pi_M: .double 3.141592653589793
dos_M: .double 2.0

	.text
	
	j movimientos_main

#---------- Menú movimientos ----------	
movimientos_main: # Función para mostrar las opciones en movimientos
	li $v0, 4
	la $a0, text_M00 # Opciones del menú
	syscall
	
	la $a0, text_M01 
	syscall
	
	li $v0, 5 # Lee el valor de la opción como entero
	syscall
	
	move $t1, $v0 # Mueve el valor de la opcion ingresada a $t1

validar_opciones_movimientos: # Función para validar la opcion ingresada por el usuario
	beqz $t1, end_movimientos_2 # Si opción = 0, lleva al main 
	beq $t1, 1, variables_mrua # Si opción = 1, lleva al menú de variables MRUA
	beq $t1, 2, variables_mcu # Si opción = 2, lleva al menú de variables MCU
	bltz $t1, opcion_invalida_movimientos # Valida que la opción no sea un numero negativo
	bge $t1, 3, opcion_invalida_movimientos # Valida que la opción no sea mayor o igual a 3
	
opcion_invalida_movimientos: # Función para indicar cuando se ingresa una opción incorrecta
	li $v0, 4
	la $a0, Etext_M00 # Mensaje de error
	syscall
	j movimientos_main # Vuelve a iniciar el proceso en movimientos

	
#---------- Movimiento rectilíneo uniformemente acelerado ----------	
variables_mrua: # Muestra un menú para mostrar las dos posible ecuaciones a utilizar
	li $v0, 4
	la $a0, text_M02 # Menú de MRUA
	syscall
	
	la $a0, text_M01
	syscall
	
	li $v0, 5 # Lee el valor de la opción como entero
	syscall
	
	move $t2, $v0 # Mueve el valor de la opcion al registro t2
	

validar_variables_mrua: # Función para validar la opción ingresada en el menú de MRUA
	beqz $t2, end_movimientos_2 # Si opción = 0, lleva al main
	beq $t2, 1, calcular_velocidad # Si opción = 1, lleva a la ecuación de velocidad
	beq $t2, 2, calcular_distancia # Si opción = 2, lleva a la ecuación de distancia
	bltz $t2, opcion_MRUA_invalida # Valida que la opción ingresada no sea negativa
	bge $t2, 3, opcion_MRUA_invalida # Valida que la opción ingresada no sea mayor o igual que 3
	
opcion_MRUA_invalida: # Función para indicar cuando se ingresa una opción incorrecta
	li $v0, 4
	la $a0, Etext_M00 # Mensaje de error
	syscall
	
	j variables_mrua # Vuelve al menu de MRUA
	
#---------- MRUA. Distancia ----------
calcular_distancia: # Función de implementacion de la formula de distancia
	addi $sp, $sp, -4   # Reserva 4 bytes en la pila (mueve el puntero $sp hacia abajo)
	sw   $ra, 0($sp)    # Guarda el contenido del registro $ra (dirección de retorno) en la pila
	
	jal solicitar_variables_distancia # Salto para solicitar las variables de distancia
	
	mul.d $f10, $f6, $f6 # Eleva el tiempo al cuadrado y guarda el resultado en el registro $f10
	
	l.d $f14, un_medio_M # Carga el valor 0.5 (1/2) en el registro $f14
	
	mul.d $f16, $f14, $f4 # (1/2)*a y se almacena en $f16
	
	mul.d $f18, $f16, $f10 # t^2*(1/2)*a y se almacena en $f18
	
	mul.d $f20, $f2, $f6 # V0 * t y se almacena en $f20
	
	add.d $f22, $f20, $f18 # V0*t + t^2*(1/2)*a y se almacena en $f22
	
	add.d $f12, $f22, $f8 # X0 + V0*t + t^2*(1/2)*a  y el resultado se almacena en $f12
	
	li $v0, 4
	la $a0, text_M10
	syscall
	
	li $v0, 3 # Muestra el resultado de la operación
	syscall
	
	j end_movimientos # Salto para volver al main
	 
solicitar_variables_distancia: # Función para solicitar las variable spara calcular la distancia

	li $v0, 4
	la $a0, text_M03
	syscall
	
	la $a0, text_M06 
	syscall
	
	li $v0, 7 # Recibe el valor del tiempo
	syscall
	
	l.d $f2, cero_M        # Carga el valor constante 0.0 (double) en el registro $f2
	c.lt.d $f0, $f2        # Compara en hardware: establece el flag si $f0 < $f2 (es decir, si $f0 < 0.0)
	bc1t tiempo_negativo_distancia   # Si el flag quedó en verdadero (T = true), salta a la etiqueta tiempo_negativo

	mov.d $f6, $f0 # Mueve el valor del tiempo al registro $f6
	
	li $v0,4
	la $a0, text_M04 
	syscall
	
	li $v0, 7 # Recibe el valor de la velocidad inicial
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
	
	jr $ra # Regresa a calcular distancia
	
tiempo_negativo_distancia: # Funcion para indicar cuando se ingresa un tiempo negativo
    	li $v0, 4
    	la $a0, Etext_M01 # Mensaje de error
    	syscall
    	
    	j solicitar_variables_distancia # Vuelve a solicitar las variables de distancia	

#---------- MRUA. Velocidad ----------
calcular_velocidad: # Función de implementación de la formula de velocidad
	addi $sp, $sp, -4   # Reserva 4 bytes en la pila (mueve el puntero $sp hacia abajo)
	sw   $ra, 0($sp)    # Guarda el contenido del registro $ra (dirección de retorno) en la pila
	
	jal solicitar_variables_velocidad # Salto para solicitar las variables de velocidad
	
	mul.d $f8, $f4, $f6 # Multiplica la aceleracion($f2) con el tiempo($f3) y lo almacena en el registro $f4.
	
	add.d $f12, $f2, $f8 # Sumar la velocidad inicial($f11) con el resultado de multiplicar aceleracion con tiempo ($f4).
	
	li $v0, 4
	la $a0, text_M07
	syscall
	
	li $v0, 3 # Muestra el resultado de la operación
	syscall
	
	j end_movimientos # Salto para volver al main

solicitar_variables_velocidad: # Menú que muestra las opciones de variables a encontrar en el MRUA
	li $v0, 4
	la $a0, text_M03
	syscall
	
	la $a0, text_M06
	syscall
	
	li $v0, 7 # Recibe el valor del tiempo
	syscall
	
	l.d $f2, cero_M        # Carga el valor constante 0.0 (double) en el registro $f2
	c.lt.d $f0, $f2        # Compara en hardware: establece el flag si $f0 < $f2 (es decir, si $f0 < 0.0)
	bc1t tiempo_negativo_velocidad   # Si el flag quedó en verdadero (T = true), salta a la etiqueta tiempo_negativo
	
	mov.d $f6, $f0 # Mueve el valor del tiempo al registro $f6
	
	li $v0,4
	la $a0, text_M04
	syscall
	
	li $v0, 7 # Recibe el valor de la velocidad inicial
	syscall
	
	mov.d $f2, $f0 # Mueve el valor de la velocidad inicial al registro $f2
	
	li $v0, 4
	la $a0, text_M05
	syscall
	
	li $v0,7 # Recibe el valor de la aceleración
	syscall
	
	mov.d $f4, $f0 # Mueve el valor de la aceleración al registro $f4
	
	jr $ra # Regresa a calcular velocidad
	
tiempo_negativo_velocidad: # Funcion para indicar cuando se ingresa un tiempo negativo
    	li $v0, 4
    	la $a0, Etext_M01 # Mensaje de error
    	syscall
    	
    	j solicitar_variables_velocidad # Vuelve a solicitar las variables de velocidad	

#---------- Movimiento circular uniforme ----------		
variables_mcu: # Muestra un menú para mostrar las dos posible ecuaciones a utilizar
	li $v0, 4
	la $a0, text_M11 # Menú MCU
	syscall
	
	la $a0, text_M01
	syscall
	
	li $v0, 5 # Recibe el valor de la opción como entero
	syscall
	
	move $t3, $v0 # Mueve el valor de la opción al registro $t3

validar_variables_mcu: # Función para validar la opcion ingresada por el usuario
	beqz $t3, end_movimientos_2 # Si opción = 0, lleva al main 
	beq $t3, 1, calcular_velocidad_angular # Si opción = 1, lleva a la ecuación de velocidad angular
	beq $t3, 2, obtener_velocidad_angular # Si opción = 2, lleva a la ecuación de velocidad lineal, primero obteniendo la velocidad angular
	bltz $t3, opcion_MCU_invalida # Valida que la opción ingresada no sea negativa
	bge $t3, 3, opcion_MCU_invalida # Valida que la opción ingresada no sea mayor o igual que 3
		
	
opcion_MCU_invalida: # Función para indicar cuando se ingresa una opción incorrecta
	li $v0, 4
	la $a0, Etext_M00 # Mensaje de error
	syscall
	
	j variables_mcu # Vuelve al menu de MRUA

#---------- MCU. Velocidad angular ----------	
calcular_velocidad_angular: # Función de implementación de la formula de velocidad angular
	li $v0, 4
	la $a0, text_M12
	syscall
	
	li $v0, 7 # Recibe el valor del periodo (T)
	syscall 
		
	l.d $f2, cero_M        # Carga el valor constante 0.0 (double) en el registro $f2
	c.lt.d $f0, $f2        # Compara en hardware: establece el flag si $f0 < $f2 (es decir, si $f0 < 0.0)
	bc1t periodo_negativo   # Si el flag quedó en verdadero (T = true), salta a la etiqueta periodo_negativo

	mov.d $f8, $f0 # Mueve el valor del periodo a $f8
	
	l.d $f2, pi_M # Carga el valor constante 3.141592653589793 (double) en el registro $f2
	l.d $f4, dos_M # Carga el valor constante 2.0 (double) en el registro $f4
	
	mul.d $f6, $f2, $f4 # 2*? y almacena el resultado en $f6
	
	div.d $f12, $f6, $f8 # 2*?/T y almacena el resultado en $f12
	
	beq $t7,1, salto_velocidad_lineal # Valida si $t7 está en 1 para calcular velocidad lineal en vez de velocidad angular
	
	li $v0, 4
	la $a0,text_M13
	syscall
	
	li $v0, 3 # Muestra el resultado de la velocidad angular
	syscall
	
	j end_movimientos_2 # Salto para volver al main
	 
salto_velocidad_lineal: # Función de salto intermedio para calcular la velocidad lineal despues de obtener la velocidad angular
	li $t7, 0 # Pone el registro $t7 como 0	
	j calcular_velocidad_lineal # Salto para calcular la velocidad lineal

periodo_negativo: # # Funcion para indicar cuando se ingresa un periodo negativo
	li $v0, 4
    	la $a0, Etext_M01 # Mensaje de error
    	syscall
    	
    	j calcular_velocidad_angular # Vuelve a iniciar el proceso de velocidad angular

#---------- MCU. Velocidad lineal ----------
obtener_velocidad_angular: # Salto intermedio para calcular la velocidad angular antes de la velocidad lineal
	li $t7, 1 # Pone el registro $t7 como 1
	
	addi $sp, $sp, -4   # Reserva 4 bytes en la pila (mueve el puntero $sp hacia abajo)
	sw   $ra, 0($sp)    # Guarda el contenido del registro $ra (dirección de retorno) en la pila
	
	jal calcular_velocidad_angular # Salto para calcular la velocidad angular
	

	
calcular_velocidad_lineal: # Función de implementacion dela formula de velocidad lineal

	li $v0, 4
	la $a0, text_M14
	syscall
	
	li $v0, 7 # Recibe el valor del radio(R)
	syscall
	
	l.d $f2, cero_M        # Carga el valor constante 0.0 (double) en el registro $f2
	c.lt.d $f0, $f2        # Compara en hardware: establece el flag si $f0 < $f2 (es decir, si $f0 < 0.0)
	bc1t radio_invalido   # Si el flag quedó en verdadero (T = true), salta a la etiqueta radio_invalido

	
	mov.d $f10, $f0 # Mueve el valor del radio a $f10
	
	mul.d $f12, $f12, $f10 # W * R, siendo 'W' la velocidad angular, el resultado se almacena en $f12
	
	li $v0, 4
	la $a0, text_M15
	syscall
	
	li $v0, 3 # Se muestra el resultado de la velocidad lineal
	syscall
	
	j end_movimientos # Salto para volver al main
	
radio_invalido: # Funcion para indicar cuando se ingresa un radio negativo
	li $v0, 4
    	la $a0, Etext_M02 # Mensaje de error
    	syscall
    	
    	j calcular_velocidad_lineal # Vuelve a solicitar el radio	
		
end_movimientos:
    	lw   $ra, 0($sp) # Recupera el valor original de $ra desde la pila
    	addi $sp, $sp, 4 # Libera el espacio en la pila (restaura el puntero $sp)
    	jr   $ra # Regresa a la dirección guardada en $ra (continúa el programa)

end_movimientos_2:
    	jr   $ra # Regresa directamente usando $ra (no usó pila para guardar $ra)

	
	
