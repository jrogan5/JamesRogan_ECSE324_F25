// ECSE 324 Lab 3 Part 1: Interactive Display Using Polling
// ARM A9 Assembly - Polling-based I/O

// Register aliases
A1 .req r0
A2 .req r1
LR .req r14

// ==================== Constants ====================
.equ SW_ADDR,       0xFF200040
.equ LED_ADDR,      0xFF200000
.equ KEY_BASE,      0xFF200050
.equ HEX_BASE0,     0xFF200020
.equ HEX_BASE1,     0xFF200030

// ==================== Data Section ====================
.data
.align 4

// HEX segment codes
HEX_CODES:
    .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111  // 0, 1, 2, 3
    .byte 0b01100110, 0b01101101, 0b01111101, 0b00000111  // 4, 5, 6, 7
    .byte 0b01111111, 0b01101111, 0b01110111, 0b01111100  // 8, 9, A, b
    .byte 0b00111001, 0b01011110, 0b01111001, 0b01110001  // C, d, E, F

// Messages (padded to 6 characters with blanks)
MSG_C0FFEE:    .byte 0x39, 0x3F, 0x71, 0x71, 0x79, 0x79  // C0FFEE (6 chars)
MSG_CAFE5:     .byte 0x39, 0x77, 0x71, 0x79, 0x6D, 0x00  // CAFE5  (5 chars + 1 blank)
MSG_CAB5:      .byte 0x39, 0x77, 0x7C, 0x6D, 0x00, 0x00  // CAb5   (4 chars + 2 blanks)
MSG_ACE:       .byte 0x77, 0x39, 0x79, 0x00, 0x00, 0x00  // ACE    (3 chars + 3 blanks)

// Application state
// Offsets: dir_left=0, msg_ptr=4, head_pos=8, window=12, prev_sw=18, rotation_count=22
.align 4
app_state:
    .word 1                 // dir_left: offset 0 (1=left, 0=right)
    .word MSG_C0FFEE        // msg_ptr: offset 4
    .word 0                 // head_pos: offset 8
    .space 6                // window: offset 12 (6 bytes for HEX displays)
    .hword 0xFFFF           // prev_sw: offset 18 (half-word)
    .word 0                 // rotation_count: offset 20

// ==================== Text Section ====================
.text
.global _start

_start:
    // Initialize the display with default message
    BL init_display

// ==================== Main Loop (Polling) ====================
LOOP:
    // Poll slider switches for message changes
    BL read_slider_switches_ASM
    MOV R4, A1                  // R4 = current switch value
    LDR R5, =app_state
    LDRH R6, [R5, #18]          // R6 = prev_sw (offset 18)

    // Check if switch value changed
    CMP R4, R6
    BNE switch_changed

check_pb3:
    // Poll PB3 for rotation (press and release)
    BL read_PB_edgecp_ASM
    TST A1, #0x8                // Check PB3 bit
    BEQ check_pb2

    // Clear the edge capture
    BL PB_clear_edgecp_ASM

    // Check if we have a message to rotate
    LDR R5, =app_state
    LDR R4, [R5, #4]            // msg_ptr
    CMP R4, #0
    BEQ check_pb2               // No message, skip rotation

    // Rotate the display
    BL rotate_display

    // Increment rotation count
    LDR R5, =app_state
    LDR R6, [R5, #20]           // rotation_count
    ADD R6, R6, #1

    // Check if count exceeds 2047
    CMP R6, #2047
    MOVGT R6, #2048             // Cap at 2048 to keep all LEDs lit

    STR R6, [R5, #20]           // Update rotation_count

    // Update LEDs
    CMP R6, #2047
    LDRGT A1, =0x3FF            // All LEDs on if > 2047
    MOVLE A1, R6                // Otherwise show count
    BL write_LEDs_ASM

check_pb2:
    // Poll PB2 for direction change
    BL read_PB_edgecp_ASM
    TST A1, #0x4                // Check PB2 bit
    BEQ LOOP

    // Clear the edge capture
    BL PB_clear_edgecp_ASM

    // Toggle direction
    LDR R5, =app_state
    LDR R6, [R5, #0]            // dir_left
    EOR R6, R6, #1              // Toggle
    STR R6, [R5, #0]

    B LOOP

switch_changed:
    // Update prev_sw
    STRH R4, [R5, #18]          // prev_sw (offset 18)

    // Determine which message to load based on switch value
    AND R4, R4, #0x1F           // Mask to lower 5 bits

    LDR R6, =MSG_C0FFEE         // Default
    MOV R7, #1                  // Has message flag

    CMP R4, #0x00
    BEQ msg_selected

    CMP R4, #0x01
    LDREQ R6, =MSG_CAFE5
    BEQ msg_selected

    CMP R4, #0x02
    LDREQ R6, =MSG_CAB5
    BEQ msg_selected

    CMP R4, #0x04
    LDREQ R6, =MSG_ACE
    BEQ msg_selected

    // Unknown - no message
    MOV R6, #0
    MOV R7, #0

msg_selected:
    // Update app_state
    LDR R5, =app_state
    STR R6, [R5, #4]            // msg_ptr (offset 4)
    MOV R8, #0
    STR R8, [R5, #8]            // head_pos = 0 (offset 8)
    STR R8, [R5, #20]           // rotation_count = 0 (offset 20)

    // Update LEDs to show count (0)
    MOV A1, #0
    BL write_LEDs_ASM

    // Clear and fill window
    ADD R5, R5, #12             // Point to window (offset 12)
    MOV R8, #0
clear_window:
    CMP R8, #6
    BEQ fill_window_check
    MOV R9, #0
    STRB R9, [R5, R8]
    ADD R8, R8, #1
    B clear_window

fill_window_check:
    CMP R7, #0                  // Check if we have a message
    BEQ display_current         // No message, just clear

    // Copy message to window
    MOV R8, #0
fill_window:
    CMP R8, #6
    BEQ display_current
    LDRB R9, [R6, R8]
    STRB R9, [R5, R8]
    ADD R8, R8, #1
    B fill_window

display_current:
    // Display the window
    LDR A1, =app_state
    ADD A1, A1, #12             // Point to window (offset 12)
    BL display_window

    B check_pb3

// ==================== Initialization ====================
init_display:
    PUSH {R4-R7, LR}

    // Clear all HEX displays
    MOV A1, #0x3F
    BL HEX_clear_ASM

    // Load default message (C0FFEE) into window
    LDR R4, =MSG_C0FFEE
    LDR R5, =app_state
    ADD R5, R5, #12             // Point to window (offset 12)
    MOV R6, #0                  // Counter

init_loop:
    CMP R6, #6
    BEQ init_display_show
    LDRB R7, [R4, R6]
    STRB R7, [R5, R6]
    ADD R6, R6, #1
    B init_loop

init_display_show:
    // Display the window
    LDR A1, =app_state
    ADD A1, A1, #12             // Point to window (offset 12)
    BL display_window

    POP {R4-R7, PC}

// ==================== Display Rotation ====================
rotate_display:
    PUSH {R4-R9, LR}

    LDR R4, =app_state
    LDR R5, [R4, #4]            // msg_ptr (offset 4)

    // Check if there's a message
    CMP R5, #0
    BEQ rotate_done

    LDR R6, [R4, #8]            // head_pos (offset 8)
    LDR R7, [R4, #0]            // dir_left (offset 0)

    // Update head position based on direction
    CMP R7, #1
    BEQ rotate_left

rotate_right:
    // Move right (decrement head)
    SUB R6, R6, #1
    CMP R6, #0
    ADDLT R6, R6, #6            // Wrap around (add 6 if negative)
    B rotate_update_head

rotate_left:
    // Move left (increment head)
    ADD R6, R6, #1
    CMP R6, #6
    SUBGE R6, R6, #6            // Wrap around (sub 6 if >= 6)

rotate_update_head:
    STR R6, [R4, #8]            // Update head_pos (offset 8)

    // Build new window (circular buffer from message)
    ADD R8, R4, #12             // R8 = window pointer (offset 12)
    MOV R9, #0                  // window index

rotate_build_loop:
    CMP R9, #6
    BEQ rotate_show

    // Calculate message index: (head_pos + window_index) % 6
    ADD R0, R6, R9
    CMP R0, #6
    SUBGE R0, R0, #6

    // Get character from message
    LDRB R1, [R5, R0]
    STRB R1, [R8, R9]

    ADD R9, R9, #1
    B rotate_build_loop

rotate_show:
    // Display the window
    MOV A1, R8
    BL display_window

rotate_done:
    POP {R4-R9, PC}

// ==================== Display Window ====================
display_window:
    PUSH {R4-R6, LR}
    MOV R4, A1                  // R4 = window pointer
    MOV R5, #0                  // display index

display_loop:
    CMP R5, #6
    BEQ display_done

    // Get segment code from window
    LDRB R6, [R4, R5]

    // Write to HEX display
    PUSH {A1, A2}
    MOV A1, R5
    MOV A2, R6
    BL HEX_write_digit
    POP {A1, A2}

    ADD R5, R5, #1
    B display_loop

display_done:
    POP {R4-R6, PC}

// ==================== Helper: Write single HEX digit ====================
// Digit index 0 maps to HEX5 (leftmost), digit 5 maps to HEX0 (rightmost)
HEX_write_digit:
    PUSH {R4-R6, LR}
    MOV R4, A1                  // digit index (0-5)
    MOV R5, A2                  // segment code

    // Reverse the mapping: physical_hex = 5 - digit_index
    RSB R4, R4, #5

    // Determine base address and offset
    CMP R4, #4
    BLT hex_base0

hex_base1:
    LDR R6, =HEX_BASE1
    SUB R4, R4, #4
    B hex_write

hex_base0:
    LDR R6, =HEX_BASE0

hex_write:
    STRB R5, [R6, R4, LSL #4]   // LSL #4 = multiply by 16 for 0x10 spacing

    POP {R4-R6, PC}

// ==================== I/O Driver Functions ====================

// Slider Switches Driver
read_slider_switches_ASM:
    LDR A2, =SW_ADDR
    LDR A1, [A2]
    BX LR

// LEDs Driver
write_LEDs_ASM:
    LDR A2, =LED_ADDR
    STR A1, [A2]
    BX LR

// HEX Display Drivers
HEX_clear_ASM:
    PUSH {R4-R6, LR}
    MOV R4, A1                  // mask
    MOV R5, #0                  // display index

hex_clear_loop:
    CMP R5, #6
    BEQ hex_clear_done

    MOV R6, #1
    LSL R6, R6, R5
    TST R4, R6
    BEQ hex_clear_next

    PUSH {A1, A2}
    MOV A1, R5
    MOV A2, #0
    BL HEX_write_digit
    POP {A1, A2}

hex_clear_next:
    ADD R5, R5, #1
    B hex_clear_loop

hex_clear_done:
    POP {R4-R6, PC}

HEX_flood_ASM:
    PUSH {R4-R6, LR}
    MOV R4, A1                  // mask
    MOV R5, #0                  // display index

hex_flood_loop:
    CMP R5, #6
    BEQ hex_flood_done

    MOV R6, #1
    LSL R6, R6, R5
    TST R4, R6
    BEQ hex_flood_next

    PUSH {A1, A2}
    MOV A1, R5
    MOV A2, #0x7F
    BL HEX_write_digit
    POP {A1, A2}

hex_flood_next:
    ADD R5, R5, #1
    B hex_flood_loop

hex_flood_done:
    POP {R4-R6, PC}

HEX_write_ASM:
    PUSH {R4-R7, LR}
    MOV R4, A1                  // mask
    MOV R5, A2                  // value (0-15)

    // Get segment code
    CMP R5, #15
    MOVGT R6, #0
    BGT hex_write_loop

    LDR R7, =HEX_CODES
    LDRB R6, [R7, R5]

hex_write_loop:
    MOV R7, #0                  // display index

hex_write_loop2:
    CMP R7, #6
    BEQ hex_write_done

    MOV R0, #1
    LSL R0, R0, R7
    TST R4, R0
    BEQ hex_write_next

    PUSH {A1, A2}
    MOV A1, R7
    MOV A2, R6
    BL HEX_write_digit
    POP {A1, A2}

hex_write_next:
    ADD R7, R7, #1
    B hex_write_loop2

hex_write_done:
    POP {R4-R7, PC}

// Pushbutton Drivers
read_PB_data_ASM:
    LDR A2, =KEY_BASE
    LDR A1, [A2]
    BX LR

PB_data_is_pressed_ASM:
    PUSH {R4, LR}
    MOV R4, A1
    BL read_PB_data_ASM
    TST A1, R4
    MOVEQ A1, #0
    MOVNE A1, #1
    POP {R4, PC}

read_PB_edgecp_ASM:
    LDR A2, =KEY_BASE
    LDR A1, [A2, #0xC]
    BX LR

PB_edgecp_is_pressed_ASM:
    PUSH {R4, LR}
    MOV R4, A1
    BL read_PB_edgecp_ASM
    TST A1, R4
    MOVEQ A1, #0
    MOVNE A1, #1
    POP {R4, PC}

PB_clear_edgecp_ASM:
    LDR A2, =KEY_BASE
    LDR A1, [A2, #0xC]
    STR A1, [A2, #0xC]
    BX LR

enable_PB_INT_ASM:
    PUSH {R4, LR}
    MOV R4, A1
    LDR A2, =KEY_BASE
    LDR A1, [A2, #0x8]
    ORR A1, A1, R4
    STR A1, [A2, #0x8]
    POP {R4, PC}

disable_PB_INT_ASM:
    PUSH {R4, LR}
    MOV R4, A1
    LDR A2, =KEY_BASE
    LDR A1, [A2, #0x8]
    BIC A1, A1, R4
    STR A1, [A2, #0x8]
    POP {R4, PC}

.end
