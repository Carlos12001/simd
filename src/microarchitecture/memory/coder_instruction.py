import csv

with open("meminstr.dat", "r") as f, open("code.csv", "w", newline='') as f2:
    headers = ["line", "operation", "data type", "memdir", "funct", "instr"]
    writer = csv.DictWriter(f2, fieldnames=headers)
    writer.writeheader()

    for i, line in enumerate(f):
        # Imprimir la línea completa para ver su contenido
        print(f"Line {i}: {line.strip()}") 
        
        operation = line[0:2]   
        data_type = line[2:4]  
        memdir = line[4:6]     

        dic = {
            "line": i,
            "operation": operation,
            "data type": data_type,
            "memdir": memdir,
            "funct": reversed(line[-7:-1]) if memdir == "00" and operation != "10" and line[0:6]!="010000" else None
        }
        
        print(dic)
        writer.writerow(dic)

  