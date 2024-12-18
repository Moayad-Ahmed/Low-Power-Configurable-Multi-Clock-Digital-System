# RTL to GDS Implementation of Low Power Configurable Multi Clock Digital System
A System that is responsible of receiving commands through the UART receiver to perform different system functions as register file reading/writing or processing the data using the ALU block and then sends the result to the UART transmitter through an Asynchronous FIFO to handle different clock rates and avoid data loss.

## Overview
### The Universal Asynchronous Receiver Transmitter (UART) RX block is designed to receive multiple UART frames in each operation. The first frame determines the specific operation to be executed, with the system supporting four distinct commands:
1. Register File Write Command.
2. Register File Read Command.
3. ALU Operation with Operands Command.
4. ALU Operation without Operands Command.
   
**The UART RX block operates on a 3.6864 MHz UART clock, while the System Controller functions on a 50 MHz reference clock. To bridge these two clock domains, the UART RX data undergoes synchronization through a Double Flip-Flop Synchronizer before being processed by the System Controller.**

## System Controller Operation

After synchronization, the data enters the System Controller, which determines the required operation and configures the necessary control signals. Here's how the System Controller manages different tasks:

1. **Register File Write Operation (0xAA):**

<p align="center">
  <img src="https://github.com/user-attachments/assets/9744c005-e3d4-4cba-b194-d8ed7d39a431"/>
</p>

   - It enables the `WrEn` signal of the Register File, indicating a Write operation.
   
   - The desired `Address` for writing is specified.
  
2. **Register File Read Operation (0xBB):**

<p align="center">
  <img src="https://github.com/user-attachments/assets/298b7294-8046-493b-b5ce-9335899073bf"/>
</p>

   - It enables the `RdEn` signal of the Register File, indicating a Read operation.

   - The desired `Address` for reading is specified.

   - The data is retrieved from the Register File and sent to the UART TX.

> **Note: The UART TX operates on a different clock frequency, specifically 115.2 KHz. To prevent data loss due to clock domain crossing (CDC), a `FIFO` (First-In-First-Out) is placed just before the UART TX, ensuring proper transmission of data without any loss or corruption.**

3. **ALU Operation With Operands (0xCC):**

<p align="center">
  <img src="https://github.com/user-attachments/assets/d24d1f9b-03d1-4299-962e-fbc7ee970cad"/>
</p>

   - It enables the `WrEn` signal of the Register File, indicating a Write operation of the two operands.
   
   - It activates the `ALU_EN` signal of the ALU, signaling the start of an ALU operation.

   - The `CLK_GATE` is enabled to activate the `ALU_CLK`.

   - The operands required for the operation are obtained from the Register File at the predefined addresses.

   - The desired function for the ALU operation is taken from the `ALU_FUN` signal.

   - The result of the ALU operation `ALU_OUT` is passed to the System Controller.

   - From there, the result is sent to the Asynchronous FIFO, and after that to the UART TX.

4. **ALU Operation Without Operands (0xDD):** 

<p align="center">
  <img src="https://github.com/user-attachments/assets/a1512f12-fbdb-428f-a6a7-f5f8ab778506"/>
</p>

   - This configuration allows the ALU to operate on the Operands that were Pre-Stored in the Register File without changing those Operands.

## System Architecture

The system contains 10 interconnected blocks across two clock domains. Below is an architectural breakdown of these blocks:

<p align="center">
  <img src="https://github.com/user-attachments/assets/5f2946d0-c2d1-4113-923c-d86d35131ea7"/>
</p>

## Clock Domain 1 (50 MHz REF CLK)

1. **RegFile (Register File)**

The RegFile block is a data storage unit, used for data storage and retrieval operations.

2. **ALU (Arithmetic Logic Unit)**

The ALU is the computational block of the system, capable of executing multiple operations:
- Arithmetic: Addition, Subtraction, Multiplication, Division.
- Logical: AND, OR, NAND, NOR, XOR, XNOR.
- Comparison: Equality (A = B), Greater than (A > B), Less than (A < B).
- Shift: Left & Right by 1 bit.

3. **Clock Gating**

The Clock Gating block optimizes power consumption by controlling clock signals during idle periods, reducing overall power consumption.

4. **SYS CTRL (System Controller)**

The System Controller functions as the core decision-making unit of the system. It interprets incoming UART frames and executes commands by controlling signals across various blocks.

## Clock Domain 2 (3.6864 MHz UART CLK)

5. **UART TX (UART Transmitter)**

The UART RX is responsible for transmitting data to external devices or master via UART communication.

6. **UART RX (UART Receiver)**

The UART RX receives incoming data and commands from external sources and sends them to the system controller after validating that there are no errors in the frames.

7. **PULSE GEN (Pulse Generator)**

PULSE GEN generates a pulse signal, converting the High time of the `Tx_Busy` signal (i.e. 11 UART TX clock cycles) into a single pulse to the `Rd_INC` signal.

8. **Clock Dividers**

Clock Dividers are essential for generating clocks with different frequencies and ratios required by different blocks.

## Data Synchronizers

9. **RST Synchronizer**

The RST Synchronizer ensures synchronous de-assertion of asynchronous active-low reset signals, to avoid violating recovery times, and to make sure flip flops don't enter a metastability state.

10. **Data Synchronizer**

The Data Synchronizer employs a robust synchronization scheme to manage Clock Domain Crossing (CDC) effectively, ensuring reliable data transfer between different clock domains.

## Reserved Registers

The system includes reserved registers, with each register serving a specific functionality:

1. **REG0 (Address: 0x0) - ALU Operand A**
2. **REG1 (Address: 0x1) - ALU Operand B**
3. **REG2 (Address: 0x2) - UART Configuration**
   - Bit 0: Parity Enable (Default: 1)
   - Bit 1: Parity Type (Default: 0 &rarr; Even Parity)
   - Bits 7-2: Prescale (Default: 32)
4. **REG3 (Address: 0x3) - Division Ratio**
   - Bits 7-0: Division ratio (Default: 32)
