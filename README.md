# CNN_accelerator
CNN_accelerator for detection of side channel attack.\
Baes on preleminary sutdy, verilog code is written for the CNN based AI accelerator, which will detect Side Channel Attack.\
This "CNN_accelerator.v" has multiple modules. Working of each of this modules explained here.\

# Hardware Modules for FPGA-based AI and Cryptography

This Verilog code consists of multiple hardware modules designed for different purposes, including matrix multiplication, activation functions (ReLU), pooling (MaxPool), AES S-box substitution, and AXI4 master-slave communication.

---

## **1. Matrix Multiplication Module (`matrix_mult`)**
This module performs matrix multiplication between a given input `matrix` and a `kernel`. It is parameterized for flexibility.

### **Parameters:**
- `SIZE`: Defines the dimension of the square matrix (default is 3×3).
- `DATA_WIDTH`: Defines the bit-width of each matrix element (default is 8 bits).

### **Inputs:**
- `clk`: Clock signal.
- `rst`: Reset signal.
- `matrix`: A flattened 1D array containing `SIZE × SIZE` elements.
- `kernel`: A flattened 1D array of the same size as `matrix`.

### **Outputs:**
- `result`: The output value representing the sum of element-wise multiplications.

### **Example Calculation:**
For a 3×3 matrix and kernel:

$$
A =
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\
a_{21} & a_{22} & a_{23} \\
a_{31} & a_{32} & a_{33}
\end{bmatrix}
$$


---

## **2. ReLU Activation Function (`relu`)**
The Rectified Linear Unit (ReLU) function is used in deep learning. It ensures non-linearity by outputting zero for negative inputs.

### **Behavior:**
- If the most significant bit (MSB) of `in_data` is `1` (indicating a negative number in 2’s complement representation), `out_data` is set to `0`.
- Otherwise, `out_data` remains unchanged.

### **Example:**
- `in_data = 8'b00001111` (15) → `out_data = 15`
- `in_data = 8'b11110000` (-16) → `out_data = 0`

---

## **3. Max Pooling Module (`maxpool`)**
This module performs **max pooling**, a technique used in convolutional neural networks (CNNs) to reduce dimensions while retaining important features.

### **Example Calculation:**
For a 2×2 pooling window:

\[
\begin{bmatrix} 3 & 7 \\ 5 & 2 \end{bmatrix}
\]

Output: `max_value = 7`

---

## **4. AES S-Box Module (`aes_sbox`)**
This module implements the AES S-box, a crucial part of AES encryption, which performs a nonlinear substitution.

### **Behavior:**
- Reads `sbox.hex` into an internal lookup table at startup.
- Outputs the S-box transformation of `in_data`.

### **Example:**
If `in_data = 8'h63`, `out_data` might be `8'h7c` (assuming standard AES S-box mapping).

---

## **5. AXI4 Master Module (`axi4_master`)**
This module implements a simplified **AXI4 Master** interface for reading and writing data to an AXI4 bus.

### **AXI4 Bus Signals:**
- `awaddr`: Write address.
- `wdata`: Write data.
- `araddr`: Read address.
- `rdata`: Read data.

---

## **6. AXI4 Slave Module (`axi4_slave`)**
This module implements a simplified **AXI4 Slave** interface, which responds to read/write requests from the master.

### **Behavior:**
- If `rst` is active, it resets control signals.
- Otherwise, it would handle read/write transactions.

---

## **Summary**
| Module        | Function |
|--------------|----------|
| `matrix_mult` | Computes dot product of a matrix and kernel. |
| `relu`        | Implements the ReLU activation function. |
| `maxpool`     | Performs max pooling over a matrix. |
| `aes_sbox`    | Implements AES S-box transformation. |
| `axi4_master` | Handles AXI4 master read/write operations. |
| `axi4_slave`  | Implements an AXI4 slave for memory-mapped communication. |

This design contains fundamental building blocks for a hardware-accelerated CNN, a cryptographic function, and AXI4 communication, useful for integration into FPGA or ASIC-based AI accelerators.

