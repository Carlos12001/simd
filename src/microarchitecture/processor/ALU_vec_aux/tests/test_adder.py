import cocotb
from cocotb.triggers import Timer
from cocotb.regression import TestFactory
from cocotb.result import TestFailure

@cocotb.coroutine
def adder_basic_test(dut):
    """ Test that d = a + b """
    a = 15
    b = 10
    expected_sum = a + b  # Calculate expected sum
    dut.a <= a  # Set input a
    dut.b <= b  # Set input b

    yield Timer(2, units='ns')  # Wait for two simulation time units
    actual_sum = dut.result.value  # Read the output

    if actual_sum != expected_sum:
        raise TestFailure("Adder result is incorrect: {} != {}".format(actual_sum, expected_sum))
    else:
        dut._log.info("Adder result is correct: {} == {}".format(actual_sum, expected_sum))

# Register the test
factory = TestFactory(adder_basic_test)
factory.generate_tests()

