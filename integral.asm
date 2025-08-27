	.data
	
text_I00: .asciiz "\n\tIntegral de x^2 en el intervalo [a, b]"
text_I01: .asciiz "\n\tNOTA: Los valores de a y b deben ser reales. Además, b no puede ser menor que a. "
           .asciiz "Si desea ingresar fracciones, conviértalas previamente a valores decimales."
text_I02: .asciiz "\n Ingrese el valor de 'a': "
text_I03: .asciiz "\n Ingrese el valor de 'b': "
text_I04: .asciiz "\n El resultado de la integral de x^2 en el intervalo "
text_I05: .asciiz " a "
text_I06: .asciiz " es: "
text_I07: .asciiz "\n\tNOTA: La cantidad de iteraciones debe ser un número entero en el rango [1, 100].\n Ingrese la cantidad de iteraciones: "

Etext_I00: .asciiz "\n ERROR: El valor de b no puede ser menor que a. Inténtelo de nuevo."

dos_I:   .double 2.0
cero_I:  .double 0.0
	
	.text
	
	j integral_main

#---------- Integral definida usando la regla del trapecio ----------	
integral_main: # Función principal: solicita las variables necesarias para el cálculo de la integral definida
	li $v0, 4
	la $a0, text_I00
	syscall
	
	la $a0, text_I01
	syscall
	
	la $a0, text_I02
	syscall
	
	li $v0, 7              # Lee el valor de 'a'
	syscall 
	
	mov.d $f2, $f0         # Guarda el valor de 'a' en $f2
	
	li $v0, 4
	la $a0, text_I03
	syscall
	
	li $v0, 7              # Lee el valor de 'b'
	syscall
	
	mov.d $f4, $f0         # Guarda el valor de 'b' en $f4
	
    	c.lt.d $f4, $f2         # Compara: si b < a se activa el flag de condición
    	bc1t b_menor_a          # Si la condición es verdadera, salta a la etiqueta b_menor_a

	li $v0, 4
	la $a0, text_I07
	syscall
	
	li $v0, 5              # Lee la cantidad de iteraciones 
	syscall
	
	move $t2, $v0          # Guarda el número de iteraciones en $t2
	
	li $t1, 1              # Inicializa la variable de iteración en 1
	
	l.d $f22, cero_I       # Inicializa el acumulador de la sumatoria en 0 
	
	j calcular_integral    # Salta a la función de cálculo de la integral
	
	
b_menor_a: # Caso de error: se ingresó un valor de b menor que a
	li $v0, 4
	la $a0, Etext_I00      # Muestra mensaje de error
	syscall
	
	j integral_main        # Vuelve a solicitar los datos
	
resultado_integral: # Función que muestra el resultado de la integral
	li $v0, 4
	la $a0, text_I04
	syscall
	
	mov.d $f12, $f2        # Carga el valor de 'a' para imprimirlo
	li $v0, 3              # Imprime 'a'
	syscall
	
	li $v0, 4
	la $a0, text_I05
	syscall
	
	mov.d $f12, $f4        # Carga el valor de 'b' para imprimirlo
	li $v0, 3              # Imprime 'b'
	syscall
	
	li $v0, 4
	la $a0, text_I06
	syscall
	
	mov.d $f12, $f14       # Carga el resultado final de la integral
	li $v0, 3              # Imprime el resultado de la integral
	syscall
	
	j end_integral         # Termina y libera la pila
	
calcular_integral: # Implementa la ecuación de la regla del trapecio

	# Cálculo de h = (b-a)/n
	
	sub.d $f6, $f4, $f2    # Calcula (b-a), guarda en $f6
	
	mtc1 $t2, $f8          # Convierte el número de iteraciones a double
	cvt.d.w $f8, $f8 
	
	div.d $f10, $f6, $f8   # h = (b-a)/n 
	
	l.d $f6, dos_I         # Carga constante 2.0 en $f6
	div.d $f26, $f10, $f6  # Calcula h/2
	
	mov.d $f28, $f4        # Guarda 'b' en $f28 para calcular b^2
	
	addi $sp, $sp, -4      # Reserva espacio en la pila
	sw   $ra, 0($sp)       # Guarda la dirección de retorno
	
	jal elevar_cuadrado    # Eleva 'b' al cuadrado
	
	mov.d $f16, $f30       # Guarda b^2 en $f16
	
	j loop_integral_sumatoria # Salta al cálculo de la sumatoria
	
elevar_cuadrado: # Eleva al cuadrado el número en $f28

	mul.d $f30, $f28, $f28 # Calcula (número * número), guarda en $f30
	 
	jr $ra                 # Retorna al punto de llamada
	
loop_integral_sumatoria: # Implementa la sumatoria de la ecuación

	mtc1 $t1, $f6          # Convierte la iteración actual a double
	cvt.d.w $f6, $f6 
	
	mul.d $f8, $f6, $f10   # Calcula i*h
	add.d $f14, $f2, $f8   # Calcula (a + i*h)
	
	mov.d $f28, $f14       # Prepara (a + i*h) para elevarlo al cuadrado
	
	jal elevar_cuadrado    # Eleva al cuadrado (a + i*h)
	
	mov.d $f18, $f30       # Guarda el resultado en $f18
	
	add.d $f22, $f22, $f18 # Acumula en la sumatoria
	
	add $t1, $t1, 1        # Incrementa la iteración
	
	blt $t1, $t2, loop_integral_sumatoria # Repite mientras i < n
	
operacion_final: # Realiza los últimos cálculos de la fórmula
	l.d $f6, dos_I         
	
	mul.d $f22, $f22, $f6  # Multiplica la sumatoria por 2
	
	add.d $f20, $f22, $f16 # Suma el resultado con b^2
	
	mov.d $f28, $f2        # Prepara 'a' para elevarlo al cuadrado
	
	jal elevar_cuadrado    # Eleva a^2
	
	mov.d $f8, $f30        # Guarda a^2 en $f8
	
	add.d $f24, $f8, $f20  # Suma a^2 con el acumulado
	
	mul.d $f14, $f26, $f24 # Multiplica (h/2) por el resultado final
	
	j resultado_integral   # Muestra el resultado
	
	
end_integral: # Libera la pila y retorna
    	lw   $ra, 0($sp)     # Restaura $ra
    	addi $sp, $sp, 4     # Libera espacio en la pila
    	jr   $ra             # Retorna
