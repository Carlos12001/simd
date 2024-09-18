    addi $t0, $zero, 4
    
    lw $t2, $t0, 0
    
    addi $t1, $zero, 32

    lw $t3, $zero, 0

    vld_fp $v0, $t3, 0

loop:
    beq $t2, $t1, eof

    vld_fp $v1, $t1, 0

    vmul_fp $v2, $v0, $v1
    vsum_fp $v3, $v2

    sw_fp $v3, $t1, 0

    addi $t1, $t1, 2
    jump loop

eof:
    addi $t3, $zero, 3

