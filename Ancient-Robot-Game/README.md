# Ancient Robot Game

## Project Goal
This program implements a turn-based grid survival game where a human player attempts to evade four autonomous robots. The game serves as a practical demonstration of fundamental MIPS32 Assembly programming, focusing on data structure management, conditional logic, and system I/O.

## Gameplay
The game takes place on an x,y grid. For every step, the human player inputs a move (North, South, East, West, or Stay). The four robots then move autonomously, always attempting to close the distance to the human. The game ends when any robot occupies the same (x,y) coordinate as the human player.

## How it works
 - The coordiantes of the four robots are managed efficiently using two arrays in the static data segment:
    x: Stores the x-coordinates for the four robots
    y: Stores the y-coordinates for the four robots
 - Control Flow and Logic
    The main game logic is implemented as a long running while loop, managed entirely through MIPS conditional branch instructions (beq, blez, etc.) to process moves until the human is caught.
    The autonomous robots moves are processed by a complex series of nested conditional checks to determine the optimal move to reach the human the fastest. Demonstrating proficiency in translating high-level if/else if/else structures into efficient MIPS branching operations.
 - Stack Usage, MIPS Conventions
    When calling functions, the program explicitly saves the return address of the caller ($ra) and the caller-saved registers ($s0-$s7) which must be preserved onto the stack before beginning function operations, and restored in proper order before returning to the caller.

## Flowchart
![Game loop flowchart](flowchart.svg)

### How to run
 1. Download MARS (MIPS Assembly and Runtime Simulator) IDE from the official source
    - More here dpetersanderson dot github dot io
 2. Open the .asm file in MARS
 3. Assemble and Run using F3 then F11
 4. Enter moves in the terminal
 5. Enjoy!
