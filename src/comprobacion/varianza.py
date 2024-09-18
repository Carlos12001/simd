def leer_valores_de_archivo(archivo):
    """Función para leer valores desde un archivo .txt y convertirlos a float."""
    with open(archivo, 'r') as f:
        valores = [float(line.strip()) for line in f]
    return valores

def calcular_varianza(valores1, valores2):
    """Función para calcular la varianza entre dos listas de valores."""
    if len(valores1) != len(valores2):
        raise ValueError("Los archivos no tienen el mismo número de líneas.")
    varianzas = [(v1 - v2) ** 2 for v1, v2 in zip(valores1, valores2)]
    return varianzas

def promedio_de_varianza(varianzas):
    """Función para calcular el promedio de la varianza."""
    promedio = sum(varianzas) / len(varianzas)
    return promedio

# Nombres de los archivos
archivo1 = 'fir_filter_31coef.txt'
archivo2 = 'salida_31coef.txt'

# Leer valores
valores1 = leer_valores_de_archivo(archivo1)
valores2 = leer_valores_de_archivo(archivo2)

# Calcular varianza y promedio
varianzas = calcular_varianza(valores1, valores2)
promedio_varianza = promedio_de_varianza(varianzas)

print(f"El promedio de variación entre los dos archivos es: {promedio_varianza}")
