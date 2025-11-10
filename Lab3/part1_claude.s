// ECSE 324 Lab 3 Part 1
// ARM A9 Assembly - DE1-SoC Polling-based I/O
// Author: Claude (restarted from scratch)

// Register aliases (ARM Procedure Call Standard)
A1 .req r0
A2 .req r1
LR .req r14

// Memory-mapped I/O addresses
.equ SW_ADDR, 0xFF200040        // Slider switches base address
.equ LED_ADDR, 0xFF200000       // LEDs base address

.global _start
.text

_start:
    // Main loop - poll switches and mirror to LEDs
LOOP:
    BL read_slider_switches_ASM  // Read switches, result in A1
    BL write_LEDs_ASM            // Write A1 value to LEDs
    B LOOP                       // Repeat forever

//==============================================================================
// Slider Switches Driver
// Returns the state of slider switches in A1
// post- A1: slider switch state (10 bits)
//==============================================================================
read_slider_switches_ASM:
    LDR A2, =SW_ADDR            // Load address of slider switch register
    LDR A1, [A2]                // Read slider switch state
    BX LR                       // Return

//==============================================================================
// LEDs Driver
// Writes the state of LEDs (On/Off) from A1 to the LEDs' control register
// pre-- A1: data to write to LED state (10 bits)
//==============================================================================
write_LEDs_ASM:
    LDR A2, =LED_ADDR           // Load address of LED register
    STR A1, [A2]                // Write A1 to LED register
    BX LR                       // Return

.end
