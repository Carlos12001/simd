#include <iostream>

#include "FIRFilter.h"
#include "benchmark.h"

using namespace fir;

void benchmark() {
  std::cout << "#------------- FIR filter single --------------------#"
            << std::endl;
  benchmarkFirFilterBigRandomVectors<alignof(float)>(applyFirFilterSingle);

  std::cout
      << "#------------- FIR filter AVX --------------------#" << std::endl
      << "#------------- Inner Loop Vectorization --------------------#"
      << std::endl;
  benchmarkFirFilterBigRandomVectors<alignof(float)>(
      applyFirFilterAVX_innerLoopVectorization);
}

int main() {
  benchmark();
  std::cout << "Success!" << std::endl;
}
