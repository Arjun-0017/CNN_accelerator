# CNN_accelerator
CNN_accelerator for detection of side channel attack.\
Baes on preleminary sutdy, verilog code is written for the CNN based AI accelerator, which will detect Side Channel Attack.\
This "CNN_accelerator.v" has multiple modules. Working of each of this modules explained here.\

## Matrix Multiplication Module (matrix_mult)
This module performs matrix multiplication between a given input matrix and a kernel. It is parameterized for flexibility.\n
### Parameters:
**SIZE**: Defines the dimension of the square matrix (default is 3×3).\
**DATA_WIDTH**: Defines the bit-width of each matrix element (default is 8 bits).
### Inputs:
**clk**: Clock signal.\
**rst**: Reset signal.\
**matrix**: A flattened 1D array containing SIZE × SIZE elements.\
**kernel**: A flattened 1D array of the same size as matrix.\
### Outputs:
**result**: The output value representing the sum of element-wise multiplications.\
### Internal Registers and Variables:
**mult:** A register array that stores the element-wise multiplication results.\
**sum:** Accumulates the sum of these multiplications.\

### Behavior:
When rst is high, sum is reset to 0.\
On every positive clock edge:
  * sum is reset to 0.
  * A loop iterates through all elements of matrix and kernel, performing element-wise multiplication and accumulation.
  * The final sum is assigned to result.

### Example Calculation:
**For a 3×3 matrix and kernel**:
\[
\begin{bmatrix} 
a_1 & a_2 & a_3 \\ 
a_4 & a_5 & a_6 \\ 
a_7 & a_8 & a_9 
\end{bmatrix}
\]

\[
\begin{bmatrix} 
b_1 & b_2 & b_3 \\ 
b_4 & b_5 & b_6 \\ 
b_7 & b_8 & b_9 
\end{bmatrix}
\]
