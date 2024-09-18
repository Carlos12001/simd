def hex_a_decimal_q7_8(hex_str):
    # Paso 1: Convertir de Hexa a Binario
    bin_str = format(int(hex_str, 16), '016b')  # Asegura 16 bits
    
    # Paso 2: Determinar si es negativo y preparar la conversión
    es_negativo = bin_str[0] == '1'
    if es_negativo:
        # Convertir a positivo usando complemento a dos para la conversión correcta
        bin_str = format((int(bin_str, 2) - 1 ^ 0xFFFF) + 1, '016b')
    
    # Separar en parte entera y fraccionaria
    parte_entera_bin = bin_str[:8]
    parte_fraccional_bin = bin_str[8:]
    
    # Paso 3: Calcular el valor decimal
    parte_entera_dec = int(parte_entera_bin, 2)
    parte_fraccional_dec = sum(int(bit) * 2**-(i+1) for i, bit in enumerate(parte_fraccional_bin))
    
    resultado_decimal = parte_entera_dec + parte_fraccional_dec
    
    return -resultado_decimal if es_negativo else resultado_decimal


def leer_y_procesar_mif(ruta_archivo, N):
    # Abrir el archivo .mif para lectura
    with open(ruta_archivo, 'r') as archivo:
        lineas = archivo.readlines()
    
    # Encontrar el inicio de los datos
    inicio_datos = lineas.index("CONTENT BEGIN\n") + 1  # Asumiendo que siempre hay una línea "CONTENT BEGIN"
    final_datos = lineas.index("END;\n")  # Asumiendo que siempre hay una línea "CONTENT BEGIN"
    datos = lineas[inicio_datos:final_datos]
    
    # Preparar el archivo de salida
    with open('salida_8coef.txt', 'w') as salida:
        for linea in datos:
            
            partes = linea.split(':')
            datos_binarios = partes[1].split(';')[0].strip()
            # Dividir los datos en segmentos de N bits y convertir a hexadecimal
            for i in range(0, len(datos_binarios), N):
                segmento = datos_binarios[i:i+N]

                numero_hex = hex(int(segmento, 2))[2:]  # Convertir a hexadecimal y quitar el prefijo '0x'
                numero_Q78 = hex_a_decimal_q7_8(numero_hex)
                salida.write(str(numero_Q78) + '\n')


# Llamar a la función con la ruta del archivo .mif y el valor de N
leer_y_procesar_mif('./8_coef.mif', 16)
