# Makefile para cocotb y Icarus Verilog

TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/ALU_vec_aux.sv
TOPLEVEL = ALU_vec_aux
MODULE = tests.test_ALU_vec_aux

# Directorio de pruebas
TEST_DIR = tests

# Importa reglas de cocotb
include $(shell cocotb-config --makefiles)/Makefile.sim

