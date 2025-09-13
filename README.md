# 16-bit Ripple Carry Adder VLSI Design

A complete VLSI implementation of a 16-bit Ripple Carry Adder using Propagate-Generate (PG) logic, developed as part of EEE 468 VLSI Laboratory coursework at Bangladesh University of Engineering and Technology (BUET).

## Project Overview

This project implements a 16-bit ripple carry adder circuit that performs binary addition of two 16-bit inputs with carry propagation. The design follows a comprehensive VLSI design flow from RTL coding to physical layout implementation.

## Key Features

- **16-bit Binary Addition**: Supports addition of two 16-bit numbers with carry input/output
- **Propagate-Generate Logic**: Implements efficient PG logic for carry propagation
- **Advanced Verification**: Layered testbench with intelligent coverage-driven testing featuring:
  - Dynamic weight adjustment for uniform coverage distribution
  - Pre-randomization functions for optimized test generation
  - Penalty-based bin selection for faster coverage closure
- **Multi-Parameter Optimization:** Comprehensive design optimization including:
  - Automated parameter sweeping across frequency, input/output delays
  - Weighted cost function balancing power, area, and timing
  - MATLAB-based visualization of optimization landscapes

- **Optimized Layout**: Area-optimized physical design with 93.71% density utilization
- **Power Analysis**: Comprehensive power consumption analysis and optimization

## Tools Used

### Cadence CAD Tools Suite
- **NCSim**: RTL simulation and verification
- **Simvision**: Waveform visualization and debugging  
- **Genus**: RTL synthesis and optimization
- **Innovus**: Place & Route (PnR) and physical design

### Additional Tools
- **SystemVerilog**: HDL for design and verification
- **MATLAB**: Data analysis and visualization of optimization results
- **TCL Scripting**: Automation of synthesis parameter sweeps

## Design Methodology

### 1. RTL Design
- Verilog implementation using full adder modules
- Propagate-Generate logic for efficient carry handling
- Both combinational and clocked variants

### 2. Verification Strategy
- **Flat Testbench**: Basic functional verification
- **Layered Testbench**: Advanced verification with:
  - Coverage-driven testing with 1024 bins
  - Intelligent weight distribution for faster coverage
  - Cross-coverage analysis for comprehensive testing
  - Pre-randomization functions for optimized test generation

### 3. Synthesis & Optimization
- Multi-parameter optimization targeting:
  - **Power**: Minimized to 2712.78 nW
  - **Area**: Optimized layout utilization
  - **Delay**: Critical path analysis and timing optimization
- Parameter sweeping across 2100+ design points
- Weighted cost function optimization

### 4. Physical Design (PnR)
- **Initial Design**: 20μm × 20μm die size
- **Optimized Design**: 12μm × 15μm with 93.71% density
- DRC-clean layout with proper metal fill
- Pin distribution optimization

## Performance Metrics
- **Power Consumption**: 2712.78 nW (total leakage + dynamic)
- **Die Area**: 180 μm² (12μm × 15μm optimized layout)
- **Density Utilization**: 93.71% (maximum achievable without errors)
- **Coverage Achievement**: 100% functional coverage with optimized testbench

## Future Enhancements

- Implementation of Carry Lookahead Adder for improved performance
- Carry Skip Adder architecture for better delay characteristics

## References

1. *CMOS VLSI Design: A Circuits and Systems Perspective* - Neil H. E. Weste, David Money Harris
2. *A Practical Look at SystemVerilog* - Doug Smith
3. *SystemVerilog for Verification, 3rd Edition* - Chris Spear, Greg Tumbush

## License

This project is part of academic coursework at BUET. Please respect academic integrity guidelines if referencing this work.
