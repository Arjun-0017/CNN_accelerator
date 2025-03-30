# CNN_accelerator
CNN_accelerator for detection of side channel attack.
Baes on preleminary sutdy, verilog code is written for the CNN based AI accelerator, which will detect Side Channel Attack.
This "CNN_accelerator.v" has multiple modules. Working of each of this modules explained here.

# Matrix Multiplication Module (matrix_mult)
This module performs matrix multiplication between a given input matrix and a kernel. It is parameterized for flexibility.
Parameters:
**SIZE:** Defines the dimension of the square matrix (default is 3×3).
DATA_WIDTH: Defines the bit-width of each matrix element (default is 8 bits).
Inputs:
clk: Clock signal.
rst: Reset signal.
matrix: A flattened 1D array containing SIZE × SIZE elements.
kernel: A flattened 1D array of the same size as matrix.
Outputs:
result: The output value representing the sum of element-wise multiplications.
