# Big-Int

## Project Goal
This program prints a 64-bit integer in a 32-bit register environment (MARS/MIPS32). Since registers are 32-bit, the value lives across HI/LO and is converted to decimal one digit at a time.

## How it works
 - 64-bit long division by 10 across HI/LO to get the next quotient and remainder
 - Each remainder is pushed to the stack so the digits can be printed in the correct order
 - A helper routine cleanly returns the updated HI/LO pair

## Why it matters
 - MARS does not give a native 64-bit print syscall, so the routine builds it from scratch
 - Reinforces multiword arithmetic and bit-level reasoning in MIPS32

### How to run
 1. Download MARS (MIPS Assembly and Runtime Simulator) IDE from the official source
    - More here dpetersanderson dot github dot io
 2. Open Big-Int.asm in MARS
 3. Assemble and Run using F3 then F11
