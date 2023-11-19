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
Block diagram for `spi_if`:
Block diagram for `pkt_ctrl`:
Block diagram for `arithm_unit`:

![https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/arithm.png](https://github.com/dmitrii-semenov/VHDL-VLSI/blob/main/Documents/arithm.png)

This block