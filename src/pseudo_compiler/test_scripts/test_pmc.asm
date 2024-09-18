        start $zero
        addi $t1, $zero, 4
        addi $t2, $zero, 2
        vset_fp $v3, 7
        vset_fp $v4, 9
        vsw_fp $v3, $t1, 0
        vadd_fp $v5, $v3, $v4
        add $zero, $zero, $zero
        add $zero, $zero, $zero
        end $zero
        addi $t1, $zero, 32
        vsw_fp $stall, $t1, 0
        addi $t1, $zero, 64
        vsw_fp $cpi, $t1, 0
        addi $t1, $zero, 96
        vsw_fp $ac, $t1, 0
        addi $t1, $zero, 128
        vsw_fp $mem, $t1, 0
