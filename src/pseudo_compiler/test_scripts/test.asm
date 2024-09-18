        addi $t1, $zero, 2
        addi $t2, $zero, 3
        add $t3, $t1, $t2
        blt $t1, $t2, salto
salto2: 
        addi $t6, $zero, 4
        addi $t6, $t6, 6
        sub $t6, $t6, $t3
        jump salto3
salto:  
        addi $t5, $zero, 2
        beq $t1, $t5, salto2
        addi $t6, $zero, 9
        addi $t6, $zero, 8
salto3: 
        addi $t2, $zero, 0