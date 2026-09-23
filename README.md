# Berkeley CS61C — Computer Architecture & Systems Programming

A collection of programming projects completed in **UC Berkeley CS61C: Great Ideas in Computer Architecture (Fall 2025)**.

These projects are about **computer architecture, low-level programming, and the relationship between software and hardware execution**. The work progresses from C programming and memory management to RISC-V assembly, CPU datapath design, pipelining, and low-level debugging.

> **Disclaimer:** For educational purposes only. Please follow the license and academic integrity requirements of the original course materials.

## Projects

### Project 1 — C Programming & Memory Management

**Systems Programming Fundamentals**

Implemented a Snake game in C while working directly with dynamically allocated memory and structured data.

* C programming and pointer manipulation
* Dynamic memory allocation and deallocation
* Structs and pointer-based data structures
* File I/O and memory-efficient input handling
* Unit testing and integration testing
* Debugging with CGDB and Valgrind
* Detecting memory leaks and invalid memory accesses

The project required reasoning about how data structures are represented in memory, rather than treating them only as high-level abstractions. The assignment also emphasized memory-efficient allocation and debugging of low-level memory errors.

### Project 2 — RISC-V Assembly & Low-Level Computing

**Assembly Programming, Memory Access & Performance-Aware Implementation**

Implemented mathematical and machine-learning-related operations directly in **RISC-V assembly**, including array operations, strided dot products, matrix multiplication, file I/O, and neural-network inference.

* RISC-V instruction set and assembly programming
* Registers, pointers, and memory addressing
* Calling conventions
* Array strides and memory layout
* Matrix multiplication
* Heap allocation and deallocation
* File I/O at the assembly level
* Debugging with Venus / VDB and memcheck
* Reasoning about memory access and out-of-bounds behavior

Working at the assembly level provided practical experience with how seemingly simple high-level operations translate into instructions, register operations, and memory accesses.

### Project 3 — CPU Design & Pipelining

**Computer Architecture & Processor Implementation**

Built and extended a simplified RISC-V processor using **Logisim**, implementing the major components required to execute increasingly complex instructions.

* ALU and register file
* Instruction decoding and immediate generation
* Datapath design
* Control logic
* Load/store instructions
* Branch and jump instructions
* RISC-V instruction formats
* 2-stage instruction pipeline
* Control hazards and pipeline flushing
* Integration testing and hardware-level debugging

The project progressed from implementing a single-cycle datapath to introducing pipelining and handling control hazards, providing hands-on experience with the mechanisms that determine how instructions are actually executed by a processor.

## Technical Scope

| Area                  | Topics                                                     |
| --------------------- | ---------------------------------------------------------- |
| Programming           | C, RISC-V Assembly                                         |
| Computer Architecture | CPU Datapath, ALU, Register File, Control Logic            |
| Memory                | Pointers, Heap Allocation, Memory Layout, Memory Access    |
| Instruction Set       | RISC-V, Instruction Encoding, Calling Convention           |
| Performance           | Array Strides, Memory Access Patterns, Pipelining          |
| Processor Design      | Single-Cycle CPU, 2-Stage Pipeline, Control Hazards        |
| Systems               | File I/O, Dynamic Memory, Low-Level Debugging              |
| Testing               | Unit Testing, Integration Testing, Valgrind, Memcheck, VDB |

## Key Takeaway

Through the experience I mainly understand something about **source code, machine instructions, memory, and processor behavior**.In practical software engineering, I see this as a useful foundation for writing and improving code with an awareness of the environment in which it actually runs and adpating my code to the environment flexibly.