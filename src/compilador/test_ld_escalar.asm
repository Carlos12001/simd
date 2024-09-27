        addi $t1, $zero, 0xF
        sw $t1, $zero, 0
        
        addi $t3, $zero, 16
        addi $t4, $zero, 0xCECA
        sw $t4, $t3, 0

        addi $t1, $zero, 768
        addi $t5, $zero, 0x0ABA
        sw $t5, $t1, 25
        
        addi $t2, $zero, 0
        addi $t3, $zero, 0
        addi $t4, $zero, 0


        vset $v5, 2
        vset $v2, 3
        vadd $v1, $v5, $v2
        vst $v5, $zero, 0


        addi $t2, $zero, 0
        addi $t3, $zero, 0
        addi $t4, $zero, 0
        

