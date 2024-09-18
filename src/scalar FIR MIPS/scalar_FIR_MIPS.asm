# Programa en ensamblador MIPS que calcula un filtro fir con la ecuacion
# y(n) = sum from k=0 to N of bk * x(n-k) for n = 0,...,Nx
# usando operaciones escalares y registros de punto flotante

.data
    # Coeficientes del filtro (bk)
	bk: .float 0.1, 0.2, 0.3, 0.4, 0.5, 0.1, 0.2, 0.3, 0.4, 0.5, 0.1, 0.2, 0.3, 0.4, 0.5, 0.1      
	
    # Muestras de entrada (x(n))
    x: .float   1.0, 2.0, 3.0, 4.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0

    # Arreglo para guardar las muestras de salida (y(n)) en bytes  
	y: .space 60                            

	Nbk: .word 16    # Numero de coeficientes del filtro
	Nx: .word 16     # Numero de muestras de entrada
	offset: .word 4  # Offset para el arreglo de entrada

.text
.global _start

# Inicializar los registros
_start:
    la $t0, y           # Referencia del arreglo y
    la $t2, x           # Referencia del arreglo x

    la $t3, y           # Copia de la referencia del arreglo y

    lw $t4, Nbk         # Numero de coeficientes del filtro
    lw $t5, Nx          # Numero de muestras de entrada
    addi $t5, $t5, -1

    lw $t6, offset      # Offset del arreglo x
    mul $t7, $t6, $t5   # Posicion final del arreglo de entrada   
    
    li $s0, 1           # Contador de terminos de y(n)

# Restablecer los registros 
reset:
    la $t1, bk          # Referencia del arreglo bk
    
	li $t8, 0           # Indice k de la sumatoria

    la $t2, x           # Referencia del arreglo x
    add $t2, $t2, $t7

    li.s $f1, 0.0       # Acumulador para la suma parcial


# Se calcula cada muestra de salida
loop:
    lwc1 $f2, 0($t1)        # Cargar bk en $f1
    lwc1 $f3, 0($t2)        # Cargar x(n-k) en $f2

    mul.s $f4, $f2, $f3     # Multiplicar bk por x(n-k) y guardar en $f3
    add.s $f1, $f1, $f4     # Sumar el resultado al acumulador
    
    addi $t8, $t8, 1
    beq $t8, $s0, store_yn  # No se necesitan mas terminos de la sumatoria

    addi $t1, $t1, 4        # Incrementar el indice del arreglo bk
    sub $t2, $t2, $t6       # Disminuir el indice de la posicion final del arreglo x

    j loop

# Guardar y(n)
store_yn:
    swc1 $f1, 0($t3)        # Guardar y(n) en el arreglo y
    
    addi $s0, $s0, 1   
    blt $s0, $t4, next_yn   # Calcular el siguiente y(n)
    
    j exit                  # Terminar el calculo del y(n)

# Calcular el siguiente y(n)
next_yn:
    add $t3, $t3, $t6       # Sumar offset
    j reset
    
# Terminar el programa
exit:
    li $v0, 10  # Codigo para terminar el programa
    syscall     # Llamar al sistema
