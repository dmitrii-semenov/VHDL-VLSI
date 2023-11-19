# Project in VLSI curcuit design

This is a project in the course "VLSI Digital Integrated Circuits Design and VHDL".

Topic: Auxiliary Arithmetic Unit (AAU)

In [Requirement Specification](https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/Req_v2.1.pdf), there are general, architecture and interface definitions 

## Project definition
* Auxiliary Arithmetic Unit (AAU) performs elementary arithmetic operations (addition and multiplication) with numbers that are sent through the communication interface
* Data is transmitted over the SPI (AAU's slave) line, communication protocol - frames, packets, line error check 

## Project flow
* Specification analysis (step 1)
* System design (step 2)
* Design of sub-blocks, creation of RTL description and simulation on the block level (step 3)
* Verification by simulation (step 4)
* Implementation (step 5)

## Outputs
* RTL description
* Verification environment
* Results of implementation
* Documentation

## Hardware description

Block diagram for `dig_top`:

![https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/top.jpg](https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/top.jpg)

This block consists of 3 sub-blocks, which are `spi_if` (SPI Interface), `pkt_ctrl` (Packet Control) and `arithm_unit` (Arithmetic Unit). Each separate block is described below.

Block diagram for `spi_if`:

![https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/spi.jpg](https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/spi.jpg)

This block processes input data and sends data to the next block. On the input pins, there is a `DFF` (Double D Flip-Flop) to ensure glitchless input signals. Error of input data performed by the "Frame detection & check" block. MOSI (Master Output Slave Input) and MISO (Master Input Slave Output) are connected to the shift registers to keep the input data vectors in the appropriate format for further processing.

Block diagram for `pkt_ctrl`:

![https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/pkt.jpg](https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/pkt.jpg)

This block is made by a Finite State Machine (FSM) to process the input data and send them to the Arithmetic Unit (AU). Also, this unit sends the results the result of addition and multiplication from the AU to the SPI Interface. The sequence is defined by the requirement REQ_AAU_I_024. In addition, `pkt_ctrl` counts the time interval between sending two frames, so if it is longer than 1 ms, the packet is considered invalid (REQ_AAU_I_023).

Block diagram for `arithm_unit`:

![https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/arit.jpg](https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/arit.jpg)

This block performs addition and multiplication operations. The result is rounded (REQ_AAU_F_012) and overflow detection is included (REQ_AAU_F_013). These two arithmetic operations are performed at the same time and results are sent to the output pins back to the `pkt_ctrl` module.  To make sure that all operations are synchronous, a D-type FF is connected to the inputs and outputs.  

## Source files

All source files (VHDL architecture) are located in [this](https://github.com/dmitrii-semenov/VHDL-VLSI/tree/main/src) folder

All simulation files (in VHDL) are located in [this](https://github.com/dmitrii-semenov/VHDL-VLSI/tree/main/tb) folder