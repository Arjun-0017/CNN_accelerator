# CNN_accelerator
CNN_accelerator for detection of side channel attack.\
Based on preliminary sutdy, verilog code is written for the CNN based AI accelerator, which will detect Side Channel Attack.

**Note**: This design is under development.

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
a_{1} & a_{2} & a_{3} \\
a_{4} & a_{5} & a_{6} \\
a_{7} & a_{8} & a_{9}
\end{bmatrix}
$$
$$
B =
\begin{bmatrix}
b_{1} & b_{2} & b_{3} \\
b_{4} & b_{5} & b_{6} \\
b_{7} & b_{8} & b_{9}
\end{bmatrix}
$$

### The output is:

$$
(a_1 \times b_1) + (a_2 \times b_2) + \dots + (a_9 \times b_9)
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

$$
\begin{bmatrix}
3 & 7 \\
5 & 2
\end{bmatrix}
$$

Output: `max_value = 7`

---

## **4. AXI4 Master Module (`axi4_master`)**
This module implements a simplified **AXI4 Master** interface for reading and writing data to an AXI4 bus.

### **AXI4 Bus Signals:**
- `awaddr`: Write address.
- `wdata`: Write data.
- `araddr`: Read address.
- `rdata`: Read data.

---

## **5. AXI4 Slave Module (`axi4_slave`)**
This module implements a simplified **AXI4 Slave** interface, which responds to read/write requests from the master.

### **Behavior:**
- If `rst` is active, it resets control signals.
- Otherwise, it would handle read/write transactions.

---

## **Summary of modules**
| Module        | Function |
|--------------|----------|
| `matrix_mult` | Computes dot product of a matrix and kernel. |
| `relu`        | Implements the ReLU activation function. |
| `maxpool`     | Performs max pooling over a matrix. |
| `aes_sbox`    | Implements AES S-box transformation. |
| `axi4_master` | Handles AXI4 master read/write operations. |
| `axi4_slave`  | Implements an AXI4 slave for memory-mapped communication. |



# AXI4 Master Interface (CNN Accelerator → VEGA)

This section provides details about the AXI4 Master interface signals used for communication between CNN accelerator and VEGA. The table below maps Verilog signals to their corresponding VEGA AT1051 signals and describes their functionality.

## Signal Mapping Table

| **Verilog Signal** | **VEGA AT1051 Signal**     | **Description**                                      |
|---------------------|----------------------------|------------------------------------------------------|
| `awaddr`           | `AXI_SIDE_M0_AWADDR`      | Write address                                        |
| `awvalid`          | `AXI_SIDE_M0_AWVALID`     | Write address valid                                 |
| `awready`          | `AXI_SIDE_M0_AWREADY`     | Write address ready (input from VEGA)              |
| `wdata`            | `AXI_SIDE_M0_WDATA`       | Write data                                          |
| `wvalid`           | `AXI_SIDE_M0_WVALID`      | Write data valid                                   |
| `wready`           | `AXI_SIDE_M0_WREADY`      | Write data ready (input from VEGA)                |
| `bvalid`           | `AXI_SIDE_M0_BVALID`      | Write response valid (input from VEGA)            |
| `bready`           | `AXI_SIDE_M0_BREADY`      | Write response ready                               |
| `araddr`           | `AXI_SIDE_M0_ARADDR`      | Read address                                       |
| `arvalid`          | `AXI_SIDE_M0_ARVALID`     | Read address valid                                 |
| `arready`          | `AXI_SIDE_M0_ARREADY`     | Read address ready (input from VEGA)              |
| `rdata`            | `AXI_SIDE_M0_RDATA`       | Read data (input from VEGA)                       |
| `rvalid`           | `AXI_SIDE_M0_RVALID`      | Read data valid (input from VEGA)              |
| `rready`           | `AXI_SIDE_M0_RREADY`      | Read ready                       |


## Signal Descriptions

- **Write Address (`awaddr`)**: Specifies the target memory address for write operations.
- **Write Address Valid (`awvalid`)**: Indicates that the write address is valid and ready to be sent.
- **Write Address Ready (`awready`)**: A signal from VEGA indicating readiness to receive the write address.
- **Write Data (`wdata`)**: Contains the actual data to be written to the target memory address.
- **Write Data Valid (`wvalid`)**: Signals that the write data is valid and ready for transfer.
- **Write Data Ready (`wready`)**: A signal from VEGA indicating readiness to receive write data.
- **Write Response Valid (`bvalid`)**: Indicates that VEGA has processed the write operation and is sending a response.
- **Write Response Ready (`bready`)**: Signals readiness to receive a response for a completed write operation.
- **Read Address (`araddr`)**: Specifies the target memory address for read operations.
- **Read Address Valid (`arvalid`)**: Indicates that the read address is valid and ready to be sent.
- **Read Address Ready (`arready`)**: A signal from VEGA indicating readiness to receive the read address.
- **Read Data (`rdata`)**: Contains the actual data read from the target memory address.


---
# AXI4 Slave Interface (VEGA → CNN Accelerator)

This section provides details about the AXI4 Slave interface signals used for communication between VEGA and CNN accelerator. The table below maps Verilog signals to their corresponding VEGA AT1051 signals and describes their functionality.

## Signal Mapping Table

| **Verilog Signal** | **VEGA AT1051 Signal**     | **Description**                                      |
|---------------------|----------------------------|------------------------------------------------------|
| `awaddr`           | `AXI_SIDE_M1_AWADDR`      | Write address from VEGA                             |
| `awvalid`          | `AXI_SIDE_M1_AWVALID`     | Write address valid from VEGA                      |
| `awready`          | `AXI_SIDE_M1_AWREADY`     | Write address ready (output to VEGA)               |
| `wdata`            | `AXI_SIDE_M1_WDATA`       | Write data from VEGA                                |
| `wvalid`           | `AXI_SIDE_M1_WVALID`      | Write data valid from VEGA                         |
| `wready`           | `AXI_SIDE_M1_WREADY`      | Write data ready (output to VEGA)                  |
| `bvalid`           | `AXI_SIDE_M1_BVALID`      | Write response valid (output to VEGA)              |
| `bready`           | `AXI_SIDE_M1_BREADY`      | Write response ready from VEGA                     |
| `araddr`           | `AXI_SIDE_M1_ARADDR`      | Read address from VEGA                             |
| `arvalid`          | `AXI_SIDE_M1_ARVALID`     | Read address valid from VEGA                       |
| `arready`          | `AXI_SIDE_M1_ARREADY`     | Read address ready (output to VEGA)                |
| `rdata`            | `AXI_SIDE_M1_RDATA`       | Read data (output to VEGA)                         |
| `rvalid`           | `AXI_SIDE_M1_RVALID`      | Read data valid (output to VEGA)                   |
| `rready`           | `AXI_SIDE_M1_RREADY`      | Read ready from VEGA                               |

## Signal Descriptions

- **Write Address (`awaddr`)**: Specifies the target memory address for write operations, sent by VEGA.
- **Write Address Valid (`awvalid`)**: Indicates that the write address is valid and ready to be processed, sent by VEGA.
- **Write Address Ready (`awready`)**: A signal indicating readiness of CNN accelerator to receive the write address.
- **Write Data (`wdata`)**: Contains the actual data to be written, sent by VEGA.
- **Write Data Valid (`wvalid`)**: Signals that the write data is valid and ready for transfer, sent by VEGA.
- **Write Data Ready (`wready`)**: A signal indicating readiness of CNN accelerator to receive write data.
- **Write Response Valid (`bvalid`)**: Indicates that CNN accelerator has processed the write operation and is sending a response.
- **Write Response Ready (`bready`)**: Signals readiness of VEGA to receive a response for a completed write operation.
- **Read Address (`araddr`)**: Specifies the target memory address for read operations, sent by VEGA.
- **Read Address Valid (`arvalid`)**: Indicates that the read address is valid and ready to be processed, sent by VEGA.
- **Read Address Ready (`arready`)**: A signal indicating readiness of CNN accelerator to receive the read address.
- **Read Data (`rdata`)**: Contains the actual data read from the target memory address, sent by CNN accelerator.
- **Read Data Valid (`rvalid`)**: Indicates that the read data is valid and ready for transfer, sent by CNN accelerator.
- **Read Ready (`rready`)**: Signals readiness of VEGA to receive read data.

---
# Clock and Reset

This section describes the clock and reset signals used in the AXI4 interface.

## Signal Mapping Table

| **Verilog Signal** | **VEGA AT1051 Signal** | **Description**     |
|---------------------|------------------------|---------------------|
| `clk`              | `AXI_SIDE_CLK`        | AXI4 clock          |
| `rst`              | `AXI_SIDE_RST_N`      | Active-low reset    |

## Signal Descriptions

- **Clock (`clk`)**: The main clock signal for the AXI4 interface, provided by VEGA (`AXI_SIDE_CLK`).
- **Reset (`rst`)**: An active-low reset signal used to initialize or reset the AXI4 interface (`AXI_SIDE_RST_N`).

---
