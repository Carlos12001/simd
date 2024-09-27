# tests/test_ALU_vec_aux.py

import cocotb
from cocotb.triggers import Timer
from cocotb.result import TestFailure

@cocotb.test()
async def test_ALU_operations(dut):
    """Test para el módulo ALU_vec_aux utilizando cocotb."""
    

    # Función auxiliar para establecer los valores de entrada
    async def set_inputs(data_a, data_b, data_c, opcode, instance_num=0):
        dut.data_a.value = data_a
        dut.data_b.value = data_b
        dut.data_c.value = data_c
        dut.opcode.value = opcode
        dut.instance_num.value = instance_num
        await Timer(1, units='ns')  # Espera 1ns para que el diseño procese las entradas

    # Función auxiliar para verificar los resultados
    def check_results(expected_result, expected_flags):
        # Obtener el resultado como entero con signo
        actual_result = dut.result.value.signed_integer
        if actual_result != expected_result:
            raise TestFailure(f"Resultado incorrecto: Esperado {expected_result}, Obtenido {actual_result}")
        
        # Obtener las flags como entero
        actual_flags = dut.flags.value.integer
        if actual_flags != expected_flags:
            raise TestFailure(f"Flags incorrectas: Esperado {bin(expected_flags)}, Obtenido {bin(actual_flags)}")

    # Lista de casos de prueba
    test_cases = [
        # Caso 1: Multiplicación Positiva
        {
            'data_a': 5,
            'data_b': 3,
            'data_c': 0,
            'opcode': 0b000,  # Multiplicación
            'expected_result': 15,
            'expected_flags': 0b0000  # Carry=0, Zero=0, Negative=0, Overflow=0
        },
        # Caso 2: Multiplicación con Overflow
        {
            'data_a': 128,  # Valor que causa overflow en 8 bits
            'data_b': 2,
            'data_c': 0,
            'opcode': 0b000,  # Multiplicación
            'expected_result': 0,  # Lower 8 bits de 256 (0x100)
            'expected_flags': 0b1010  # Carry=0, Zero=1, Negative=0, Overflow=1
        },
        # Caso 3: Resta sin Overflow
        {
            'data_a': 10,
            'data_b': 5,
            'data_c': 0,
            'opcode': 0b001,  # Resta
            'expected_result': 5,
            'expected_flags': 0b0000  # Carry=0, Zero=0, Negative=0, Overflow=0
        },
        # Caso 4: Resta con Overflow
        {
            'data_a': -128,  # Valor mínimo en 8 bits
            'data_b': 1,
            'data_c': 0,
            'opcode': 0b001,  # Resta
            'expected_result': 127,  # (-128) - 1 = -129 → 127 en 8 bits
            'expected_flags': 0b1000  # Carry=0, Zero=0, Negative=0, Overflow=1
        },
        # Caso 5: Suma sin Overflow
        {
            'data_a': 50,
            'data_b': 20,
            'data_c': 0,
            'opcode': 0b010,  # Suma
            'expected_result': 70,
            'expected_flags': 0b0000  # Carry=0, Zero=0, Negative=0, Overflow=0
        },
        # Caso 6: Suma con Overflow
        {
            'data_a': 100,
            'data_b': 100,
            'data_c': 0,
            'opcode': 0b010,  # Suma
            'expected_result': -56,  # 200 en 8 bits es -56
            'expected_flags': 0b1100  # Carry=1, Zero=1, Negative=0, Overflow=0
        },
        # Caso 7: Operación 'Set'
        {
            'data_a': 0,
            'data_b': 0,
            'data_c': -50,
            'opcode': 0b111,  # 'Set'
            'expected_result': -50,  # -50 en 8 bits es -50
            'expected_flags': 0b0100  # Carry=0, Zero=0, Negative=1, Overflow=0
        },
        # Caso 8: Operación Inválida
        {
            'data_a': 0,
            'data_b': 0,
            'data_c': 0,
            'opcode': 0b011,  # Operación no definida
            'expected_result': 0,
            'expected_flags': 0b0000  # Carry=0, Zero=0, Negative=0, Overflow=0
        },
        # Caso 9: Suma que resulta en Cero
        {
            'data_a': 50,
            'data_b': -50,
            'data_c': 0,
            'opcode': 0b010,  # Suma
            'expected_result': 0,
            'expected_flags': 0b0010  # Carry=0, Zero=1, Negative=0, Overflow=0
        },
        # Caso 10: Suma que resulta en un Número Negativo
        {
            'data_a': -100,
            'data_b': -30,
            'data_c': 0,
            'opcode': 0b010,  # Suma
            'expected_result': (-130) & 0xFF,  # -130 en 8 bits es 126
            'expected_flags': 0b1001  # Carry=1, Zero=0, Negative=0, Overflow=1
        },
    ]

    for idx, case in enumerate(test_cases, start=1):
        await set_inputs(
            data_a=case['data_a'],
            data_b=case['data_b'],
            data_c=case['data_c'],
            opcode=case['opcode']
        )
        try:
            check_results(case['expected_result'], case['expected_flags'])
            cocotb.log.info(f"Caso {idx}: PASADO")
        except TestFailure as e:
            cocotb.log.error(f"Caso {idx}: FALLADO - {e}")
            raise
    
    cocotb.log.info("Todos los casos de prueba pasaron exitosamente.")
