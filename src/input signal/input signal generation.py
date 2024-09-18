import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import firwin
import os

"""""""""""""""""""""""""""""""""""
        INPUT SIGNAL GENERATION
"""""""""""""""""""""""""""""""""""

# Function to convert float to hex
#   f = float value to convert to hex
def float_to_q78_hex(f):
    q78_value = int(np.round(f * 2**8)) & 0xFFFF  
    return format(q78_value, '04X')  

# Function to create a sine_wave
#   time = signal in time (seconds)
#   frequency = sine wave frequency
def create_sine_wave(time, frequency):
    return np.sin(2 * np.pi * frequency * time)

# Funtion to convert signal data to Q7.8
def convert_toQ78(signal):
    return np.round(signal * (2**8)).astype(np.int8) / (2**8)

# Funtion to convert signal data in Q7.8 to Hex
def convert_Q78_toHex(signal):
    return np.round(signal * (2**8)).astype(np.int16) / (2**8)

# Function to write the signal values tabulated to a file
def write_signal_data_to_file(time, signal, signal_q78, signal_Hex, file_name):
    current_directory = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(current_directory, exist_ok=True)

    with open(os.path.join(current_directory, file_name), 'w') as file:
        file.write("*** INPUT SIGNAL ***\n\n")
        file.write("Time (s) \t Signal Data \t\t Q7.8 Data \t\t Hex Data\n")
        for t, value, value_Q78, value_Q78_toHex in zip(time, signal, signal_q78, signal_Hex):
            hex_value = float_to_q78_hex(value_Q78_toHex)
            file.write(f"{t:.2f} \t\t {value:.8f} \t\t {value_Q78:.8f} \t\t {hex_value}\n")
    
    print("\nThe input signal file was created successfully.\n")

# Funtion to plot signal
def plot_signal(x_signal, y_signal):
    plt.stem(x_signal, y_signal)
    plt.title('Wave')
    plt.xlabel('Time (s)')
    plt.show()

# Generate sine wave
period = 5
samples = 39200 * 5
time = np.linspace(0, period, samples, endpoint=False)
frequency = 1000
sine_wave = create_sine_wave(time, frequency)

# Convert to Q7.8 and Hex
sine_q78 = convert_toQ78(sine_wave)
sine_q78_Hex = convert_Q78_toHex(sine_wave)

# Print data
write_signal_data_to_file(time, sine_wave, sine_q78, sine_q78_Hex, "input_signal_data.txt")

# Plot
plot_signal(time, sine_wave)



"""""""""""""""""""""""""""""""""""
        COEFFICIENT GENERATION
"""""""""""""""""""""""""""""""""""

# Function to adjust the filter coefficients
def adjust_coefficients(coefficients):
    epsilon = 1e-6  # Valor pequeño para evitar división por cero
    adjusted_coefficients = np.where(np.logical_or(coefficients <= -0.99 + epsilon, coefficients >= 0.99 - epsilon),
                                      np.sign(coefficients) * 0.99,
                                      coefficients)
    return adjusted_coefficients

# Function to generate the filter coefficients
def create_coefficients(frequency, filter_order):
    filter_coefficients = firwin(filter_order + 1, frequency)
    max_abs_coefficient = max(abs(filter_coefficients))
    normalized_coefficients = filter_coefficients / max_abs_coefficient

    if max(abs(normalized_coefficients)) > 1:
        normalized_coefficients /= max(abs(normalized_coefficients))
    
    normalized_coefficients = adjust_coefficients(normalized_coefficients)
    normalized_coefficients = np.round(normalized_coefficients, 8)

    return normalized_coefficients

# Function to write the coefficients values tabulated to a file
def write_coefficients_data_to_file(signal, signal_q78, signal_Hex, file_name):
    current_directory = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(current_directory, exist_ok=True)

    with open(os.path.join(current_directory, file_name), 'w') as file:
        file.write("*** COEFFICIENTS ***\n\n")
        file.write("Coefficients Data \t\t Q7.8 Data \t\t Hex Data\n")
        for value, value_Q78, value_Q78_toHex in zip(signal, signal_q78, signal_Hex):
            hex_value = float_to_q78_hex(value_Q78_toHex)
            file.write(f"{value:.8f} \t\t\t {value_Q78:.8f} \t\t {hex_value}\n")
    
    print("The coefficients file was created successfully.\n")

# Generate coefficients
frequency = 0.1
filter_order = 31

coefficients = create_coefficients(frequency, filter_order)
coefficients_q78 = convert_toQ78(coefficients)
coefficients_q78_Hex = convert_Q78_toHex(coefficients_q78)

write_coefficients_data_to_file(coefficients, coefficients_q78, coefficients_q78_Hex, "coefficients_data.txt")



"""""""""""""""""""""""""""""""""""
            FIR FILTER 
"""""""""""""""""""""""""""""""""""

# Function to calculate the scalar FIR filter
# diferrence equation
def fir_filter(x, coefficients):
    coefficients_len = len(coefficients)
    x_len = len(x)
    y = []

    for i in range(x_len):
        y.append(0)
        for j in range(coefficients_len):
            if i - j >= 0:
                y[i] += coefficients[j] * x[i - j]

    return y

# Function to calculate the scalar FIR filter
# sum equation
def fir_filter_sum_eq(x, coefficients):
    y = []
    size = len(x)
    x = np.append(x, [0] * 16)
    for i in range(size):
        y.append(0)
        for j in range(len(coefficients)):
            if i + j < len(x):
                y[i] += x[i + j] * coefficients[j]

    return y

# Function to write the filter results to a file
def write_filter_results_to_file(signal_q78, file_name):
    current_directory = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(current_directory, exist_ok=True)

    with open(os.path.join(current_directory, file_name), 'w') as file:
        file.write("*** FIR FILTER RESULTS ***\n\n")
        file.write("Q7.8 Data\n")
        for value_Q78 in signal_q78:
            file.write(f"{value_Q78:.8f}\n")
    
    print("The fir_filter_results file was created successfully.\n")

x = sine_wave
bk = coefficients_q78

y = fir_filter(x, bk)
y2 = fir_filter_sum_eq(x, bk[0:16])

# Write the results to the file
write_filter_results_to_file(y, "fir_filter_data.txt")
write_filter_results_to_file(y2, "fir_filter_sum_eq_data.txt")



"""""""""""""""""""""""""""""""""""
        .MIF FILE GENERATION
"""""""""""""""""""""""""""""""""""

# Function to create .mif file
def create_mif_file(depth, width, sine_q78_Hex, coefficients_q78_Hex):
    # Directory path
    current_directory = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(current_directory, exist_ok=True)

    # Create and open the .mif file for writing
    with open(os.path.join(current_directory, 'sine_wave.mif'), 'w') as mif_file:
        mif_file.write(f"DEPTH = {depth};\n")
        mif_file.write(f"WIDTH = {width};\n\n")
        mif_file.write("ADDRESS_RADIX = DEC;\n")
        mif_file.write("DATA_RADIX = HEX;\n\n")
        mif_file.write("CONTENT BEGIN\n")
        
        pos = 0
        hex_values_concatenated = "" 

        mif_file.write(f"\t{pos} : {'0'*48 + '0005FB600005FB80'};\n")  
        pos += 1

        # Write the signal data in hexadecimal format
        for address, value_Q78_toHex in enumerate(sine_q78_Hex):
            hex_value = float_to_q78_hex(value_Q78_toHex)
            hex_values_concatenated += hex_value  
            
            if len(hex_values_concatenated) == 64:
                #mif_file.write(f"\t{pos} : {hex_values_concatenated};\n")
                hex_chunks = [hex_values_concatenated[i:i+4] for i in range(0, len(hex_values_concatenated), 4)]
                reversed_hex_values = ''.join(hex_chunks[::-1])
                mif_file.write(f"\t{pos} : {reversed_hex_values};\n")
                hex_values_concatenated = "" 
                pos += 1
        
        hex_values_concatenated = "" 
        
        mif_file.write(f"\t{pos} : {'0'*64};\n")
        pos += 1

        # Write the coefficients data
        for value_Q78_Hex in coefficients_q78_Hex:
            hex_value = float_to_q78_hex(value_Q78_Hex)
            hex_values_concatenated += hex_value  

            if len(hex_values_concatenated) == 64:
                #mif_file.write(f"\t{pos} : {hex_values_concatenated};\n")
                hex_chunks = [hex_values_concatenated[i:i+4] for i in range(0, len(hex_values_concatenated), 4)]
                reversed_hex_values = ''.join(hex_chunks[::-1])
                mif_file.write(f"\t{pos} : {reversed_hex_values};\n")
                hex_values_concatenated = "" 
                pos += 1

        # Initialize remaining memory locations with zeros
        for address in range(pos, depth):
            mif_file.write(f"\t{address} : {'0'*64};\n")        

        # End the content of the .mif file
        mif_file.write("END;")

    print("The .mif file was created successfully.\n")

# Create .mif file
depth = 12288  
width = 256

create_mif_file(depth, width, sine_q78_Hex, coefficients_q78_Hex)

# LINE 0                : RESERVED
# LINE 1 - 12250        : AUDIO FILE
# LINE 12251            : RESERVED
# LINE 12252 - 12253    : COEFFICIENTS
# LINE 12254 - 12287    : EMPY SPACE