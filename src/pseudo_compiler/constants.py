CLI_ERROR_CODE = 2

# types
R = 'R'
I = 'I'
J = 'J'

IMM_SIZE = 16
ADDR_SIZE = 26

#mnemonics
ADDI = 'addi'
ADD = 'add'
SUB = 'sub'
BEQ = 'beq'
BLT = 'blt'
J = 'jump'
SW = 'sw'
LW = 'lw'
ADDFP = 'add_fp'
MULFP = 'mul_fp'
SWFP = 'sw_fp'
LWFP = 'ld_fp'
VADDFP = 'vadd_fp'
VMULFP = 'vmul_fp'
VSUMFP = 'vsum_fp'
VSETFP = 'vset_fp'
VST = 'vsw_fp'
VLD = 'vld_fp'
END = 'end'
START = 'start'

isa = {
    ADD : {'type': R, 'opcode': '000000', 'funct': '000000'},
    SUB : {'type': R, 'opcode': '000000', 'funct': '000001'},
    ADDFP : {'type': R, 'opcode': '000100', 'funct': '000100'},
    MULFP : {'type': R, 'opcode': '000100', 'funct': '000110'},
    VADDFP : {'type': R, 'opcode': '001100', 'funct': '100100'},
    VMULFP : {'type': R, 'opcode': '001100', 'funct': '100110'},
    VSUMFP : {'type': R, 'opcode': '001100', 'funct': '110000'},
    ADDI : {'type': I, 'opcode': '010000'},
    BEQ : {'type': I, 'opcode': '100000'},
    BLT : {'type': I, 'opcode': '100001'},
    SW : {'type': I, 'opcode': '010001'},
    LW : {'type': I, 'opcode': '010010'},
    SWFP : {'type': I, 'opcode': '010101'},
    LWFP : {'type': I, 'opcode': '010110'},
    VSETFP : {'type': I, 'opcode': '111111'},
    VST : {'type': I, 'opcode': '011101'},
    VLD : {'type': I, 'opcode': '011110'},
    J : {'type': J, 'opcode': '100010'},
    END: {'type': None, 'opcode': '110001'},
    START: {'type': None, 'opcode': '110010'},
}

#Registers names
registers = {
    '$zero': '00000',
    '$t0': '00001', 
    '$t1': '00010', 
    '$t2': '00011', 
    '$t3': '00100', 
    '$t4': '00101', 
    '$t5': '00110', 
    '$t6': '00111', 
    '$t7': '01000', 
    '$t8': '01001', 
    '$t9': '01010', 
    '$t10': '01011', 
    '$t11': '01100', 
    '$t12': '01101', 
    '$t13': '01110', 
    '$t14': '01111',
    '$v0': '10000', 
    '$v1': '10001', 
    '$v2': '10010', 
    '$v3': '10011', 
    '$v4': '10100', 
    '$v5': '10101', 
    '$v6': '10110', 
    '$v7': '10111', 
    '$stall': '11000', 
    '$cpi': '11001', 
    '$ac': '11010', 
    '$mem': '11011', 
    '$': '01100', 
    '$': '01101', 
    '$': '01110', 
    '$': '01111',


}
