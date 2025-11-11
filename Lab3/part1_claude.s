// ECSE 324 Lab 3 Part 1: Interactive Display with Interrupts
// ARM A9 Assembly Implementation

// ==================== Vector Table ====================
.section .vectors, "ax"
    B _start                    // reset vector
    B SERVICE_UND              // undefined instruction vector
    B SERVICE_SVC              // software interrupt vector
    B SERVICE_ABT_INST         // aborted prefetch vector
    B SERVICE_ABT_DATA         // aborted data vector
    .word 0                    // unused vector
    B SERVICE_IRQ              // IRQ interrupt vector
    B SERVICE_FIQ              // FIQ interrupt vector

// ==================== Constants ====================
.equ SW_ADDR,       0xFF200040
.equ LED_ADDR,      0xFF200000
.equ KEY_BASE,      0xFF200050
.equ HEX_BASE0,     0xFF200020
.equ HEX_BASE1,     0xFF200030

// ARM A9 Private Timer
.equ PRIVTMR_BASE,  0xFFFEC600
.equ TMR_LOAD,      0x00
.equ TMR_COUNT,     0x04
.equ TMR_CONTROL,   0x08
.equ TMR_INTSTAT,   0x0C

// GIC
.equ GIC_CPU_BASE,  0xFFFEC100
.equ GIC_DIST_BASE, 0xFFFED000
.equ ICCIAR_OFFSET, 0x0C
.equ ICCEOIR_OFFSET, 0x10

.equ IRQ_ID_KEY,    73
.equ IRQ_ID_TIMER,  29

// ==================== Data Section ====================
.data
.align 4

// HEX segment codes
HEX_CODES:
    .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111  // 0, 1, 2, 3
    .byte 0b01100110, 0b01101101, 0b01111101, 0b00000111  // 4, 5, 6, 7
    .byte 0b01111111, 0b01101111, 0b01110111, 0b01111100  // 8, 9, A, b
    .byte 0b00111001, 0b01011110, 0b01111001, 0b01110001  // C, d, E, F

// Timer load values for different speeds
// 200 MHz clock: speed 0=slowest (1s), speed 4=fastest (1/16s)
TIMER_LOADS:
    .word 200000000     // 1 second (speed 0 - slowest)
    .word 100000000     // 1/2 second (speed 1)
    .word 50000000      // 1/4 second (speed 2) - default
    .word 25000000      // 1/8 second (speed 3)
    .word 12500000      // 1/16 second (speed 4 - fastest)

// Messages (padded to minimum 6 characters with blanks for rotation)
MSG_C0FFEE:    .byte 0x39, 0x3F, 0x71, 0x71, 0x79, 0x79  // C0FFEE (6 chars)
MSG_CAFE5:     .byte 0x39, 0x77, 0x71, 0x79, 0x6D, 0x00  // CAFE5  (5 chars + 1 blank)
MSG_CAB5:      .byte 0x39, 0x77, 0x7C, 0x6D, 0x00, 0x00  // CAb5   (4 chars + 2 blanks)
MSG_ACE:       .byte 0x77, 0x39, 0x79, 0x00, 0x00, 0x00  // ACE    (3 chars + 3 blanks)
MSG_70AD570015: .byte 0x07, 0x3F, 0x77, 0x5E, 0x6D, 0x07, 0x3F, 0x3F, 0x06, 0x6D  // 70Ad570015 (10 chars)
MSG_LONG:      .byte 0x39, 0x77, 0x71, 0x79, 0x00, 0x7C, 0x79, 0x79, 0x71, 0x00, 0x39, 0x3F, 0x71, 0x71, 0x79, 0x79  // CAFE bEEF C0FFEE (16 chars)

// Message lengths (short messages padded to 6 for rotation)
MSG_LEN_C0FFEE:     .word 6
MSG_LEN_CAFE5:      .word 6
MSG_LEN_CAB5:       .word 6
MSG_LEN_ACE:        .word 6
MSG_LEN_70AD570015: .word 10
MSG_LEN_LONG:       .word 16

// Interrupt flags
.align 4
PB_int_flag:
    .word 0x0

tim_int_flag:
    .word 0x0

// Application state
// Offsets: speed_idx=0, paused=4, dir_left=8, msg_ptr=12, msg_len=16, head_pos=20, window=24, prev_sw=32
.align 4
app_state:
    .word 2                 // speed_idx: offset 0
    .word 0                 // paused: offset 4
    .word 1                 // dir_left: offset 8
    .word MSG_C0FFEE        // msg_ptr: offset 12
    .word 6                 // msg_len: offset 16
    .word 0                 // head_pos: offset 20
    .space 6                // window: offset 24
    .align 2                // Align to word boundary
    .word 0xFFFFFFFF        // prev_sw: offset 32

// ==================== Text Section ====================
.text
.global _start

_start:
    // Set up stack pointers for IRQ and SVC processor modes
    MOV R1, #0b11010010         // interrupts masked, MODE = IRQ
    MSR CPSR_c, R1              // change to IRQ mode
    LDR SP, =0xFFFFFFFF - 3     // set IRQ stack to A9 on-chip memory

    // Change to SVC (supervisor) mode with interrupts disabled
    MOV R1, #0b11010011         // interrupts masked, MODE = SVC
    MSR CPSR, R1                // change to supervisor mode
    LDR SP, =0x3FFFFFFF - 3     // set SVC stack to top of DDR3 memory

    // Initialize the display with default message
    BL init_display

    // Configure the GIC
    BL CONFIG_GIC

    // Enable pushbutton interrupts
    MOV A1, #0xF                // Enable all 4 pushbuttons
    BL enable_PB_INT_ASM

    // Configure and start the timer with default speed (index 2 = 0.25s)
    LDR A1, =TIMER_LOADS
    LDR A1, [A1, #8]            // Load value for speed index 2
    MOV A2, #0b111              // Enable=1, Auto-reload=1, IRQ-enable=1
    BL ARM_TIM_config_ASM

    // Set LEDs to show default speed (index 2 = 6 LEDs)
    MOV A1, #0b111111           // 6 LEDs on for speed 2
    BL write_LEDs_ASM

    // Enable IRQ interrupts in the processor
    MOV R0, #0b01010011         // IRQ unmasked, MODE = SVC
    MSR CPSR_c, R0

// ==================== Main Loop ====================
IDLE:
    // Poll slider switches for message changes
    BL read_slider_switches_ASM
    MOV R4, A1                  // R4 = current switch value
    LDR R5, =app_state
    LDR R6, [R5, #32]           // R6 = prev_sw (offset 32)

    // Check if lower 5 bits changed
    AND R7, R4, #0x1F
    AND R8, R6, #0x1F
    CMP R7, R8
    BNE switch_changed

check_pb_flag:
    // Check pushbutton interrupt flag
    LDR R0, =PB_int_flag
    LDR R1, [R0]
    CMP R1, #0
    BEQ check_timer_flag

    // Clear the flag
    MOV R2, #0
    STR R2, [R0]

    // Handle pushbutton press
    MOV A1, R1
    BL handle_pushbutton

check_timer_flag:
    // Check timer interrupt flag
    LDR R0, =tim_int_flag
    LDR R1, [R0]
    CMP R1, #0
    BEQ IDLE

    // Clear the flag
    MOV R2, #0
    STR R2, [R0]

    // Check if paused
    LDR R3, =app_state
    LDR R4, [R3, #4]            // Load paused flag
    CMP R4, #0
    BNE IDLE                     // If paused, don't rotate

    // Rotate the display
    BL rotate_display
    B IDLE

switch_changed:
    // Update prev_sw
    STR R4, [R5, #32]           // prev_sw (offset 32)

    // Apply new message
    MOV A1, R4
    BL apply_message
    B check_pb_flag

// ==================== Initialization ====================
init_display:
    PUSH {R4-R7, LR}

    // Clear all HEX displays
    MOV A1, #0x3F
    BL HEX_clear_ASM

    // Load default message (C0FFEE) into window
    LDR R4, =MSG_C0FFEE
    LDR R5, =app_state
    ADD R5, R5, #24             // Point to window (offset 24)
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
    ADD A1, A1, #24             // Point to window (offset 24)
    BL display_window

    POP {R4-R7, PC}

// ==================== Message Handling ====================
apply_message:
    PUSH {R4-R10, LR}
    MOV R9, A1                  // Save switch value
    AND R9, R9, #0x1F           // Mask to lower 5 bits

    // Determine which message to load
    LDR R4, =MSG_C0FFEE
    LDR R5, =6

    CMP R9, #0x01
    BEQ msg_cafe5
    CMP R9, #0x02
    BEQ msg_cab5
    CMP R9, #0x04
    BEQ msg_ace
    CMP R9, #0x08
    BEQ msg_70ad
    CMP R9, #0x10
    BEQ msg_long
    CMP R9, #0x00
    BEQ msg_c0ffee

    // Unknown message - clear display
    MOV R5, #0
    B apply_msg_update

msg_cafe5:
    LDR R4, =MSG_CAFE5
    LDR R5, =6
    B apply_msg_update

msg_cab5:
    LDR R4, =MSG_CAB5
    LDR R5, =6
    B apply_msg_update

msg_ace:
    LDR R4, =MSG_ACE
    LDR R5, =6
    B apply_msg_update

msg_70ad:
    LDR R4, =MSG_70AD570015
    LDR R5, =10
    B apply_msg_update

msg_long:
    LDR R4, =MSG_LONG
    LDR R5, =16
    B apply_msg_update

msg_c0ffee:
    LDR R4, =MSG_C0FFEE
    LDR R5, =6

apply_msg_update:
    // Update app_state
    LDR R6, =app_state
    STR R4, [R6, #12]           // msg_ptr (offset 12)
    STR R5, [R6, #16]           // msg_len (offset 16)
    MOV R7, #0
    STR R7, [R6, #20]           // head_pos = 0 (offset 20)

    // Clear window
    ADD R6, R6, #24             // Point to window (offset 24)
    MOV R7, #0
clear_window_loop:
    CMP R7, #6
    BEQ fill_window
    MOV R8, #0
    STRB R8, [R6, R7]
    ADD R7, R7, #1
    B clear_window_loop

fill_window:
    // Fill window with message (left-justified)
    CMP R5, #0                  // If no message, show blank
    BEQ apply_display

    MOV R7, #0                  // window index
    MOV R8, #0                  // message index
fill_loop:
    CMP R7, #6
    BEQ apply_display
    CMP R8, R5                  // Check if we've used all message chars
    BEQ apply_display

    LDRB R9, [R4, R8]
    STRB R9, [R6, R7]
    ADD R7, R7, #1
    ADD R8, R8, #1
    B fill_loop

apply_display:
    // Display the window
    LDR A1, =app_state
    ADD A1, A1, #24             // Point to window (offset 24)
    BL display_window

    POP {R4-R10, PC}

// ==================== Display Rotation ====================
rotate_display:
    PUSH {R4-R11, LR}

    LDR R4, =app_state
    LDR R5, [R4, #12]           // msg_ptr (offset 12)
    LDR R6, [R4, #16]           // msg_len (offset 16)

    // Check if there's a message
    CMP R6, #0
    BEQ rotate_done

    LDR R7, [R4, #20]           // head_pos (offset 20)
    LDR R8, [R4, #8]            // dir_left (offset 8)

    // Update head position based on direction
    CMP R8, #1
    BEQ rotate_left

rotate_right:
    // Move right (decrement head)
    SUB R7, R7, #1
    CMP R7, #0
    BGE rotate_update_head
    ADD R7, R7, R6              // Wrap around
    B rotate_update_head

rotate_left:
    // Move left (increment head)
    ADD R7, R7, #1
    CMP R7, R6
    BLT rotate_update_head
    SUB R7, R7, R6              // Wrap around

rotate_update_head:
    STR R7, [R4, #20]           // Update head_pos (offset 20)

    // Build new window
    ADD R9, R4, #24             // R9 = window pointer (offset 24)
    MOV R10, #0                 // window index

rotate_build_loop:
    CMP R10, #6
    BEQ rotate_show

    // Calculate message index: (head_pos + window_index) % msg_len
    ADD R11, R7, R10
    CMP R11, R6
    BLT rotate_no_wrap
    SUB R11, R11, R6

rotate_no_wrap:
    // Get character from message
    LDRB R0, [R5, R11]
    STRB R0, [R9, R10]

    ADD R10, R10, #1
    B rotate_build_loop

rotate_show:
    // Display the window
    MOV A1, R9
    BL display_window

rotate_done:
    POP {R4-R11, PC}

// ==================== Pushbutton Handler ====================
handle_pushbutton:
    PUSH {R4-R8, LR}
    MOV R4, A1                  // R4 = edge flags

    LDR R5, =app_state
    LDR R6, [R5, #4]            // paused flag
    LDR R7, [R5, #0]            // speed_idx

    // Check PB3 (pause toggle) - always works
    TST R4, #0x8
    BEQ check_pb2

    // Toggle pause
    EOR R6, R6, #1
    STR R6, [R5, #4]

    // Update LEDs
    CMP R6, #0
    BNE pause_leds_off

    // Unpaused - restore speed LEDs
    MOV A1, R7
    BL set_speed_leds
    B check_pb2

pause_leds_off:
    MOV A1, #0
    BL write_LEDs_ASM

check_pb2:
    // PB2 (reverse direction) - only if not paused
    CMP R6, #1
    BEQ check_pb1

    TST R4, #0x4
    BEQ check_pb1

    // Toggle direction
    LDR R8, [R5, #8]
    EOR R8, R8, #1
    STR R8, [R5, #8]

check_pb1:
    // PB1 (faster) - only if not paused and not at max
    CMP R6, #1
    BEQ check_pb0

    TST R4, #0x2
    BEQ check_pb0

    // Increase speed if not at max
    CMP R7, #4
    BGE check_pb0

    ADD R7, R7, #1
    STR R7, [R5, #0]

    // Update timer and LEDs
    MOV A1, R7
    BL set_speed
    B handle_pb_done

check_pb0:
    // PB0 (slower) - only if not paused and not at min
    CMP R6, #1
    BEQ handle_pb_done

    TST R4, #0x1
    BEQ handle_pb_done

    // Decrease speed if not at min
    CMP R7, #0
    BLE handle_pb_done

    SUB R7, R7, #1
    STR R7, [R5, #0]

    // Update timer and LEDs
    MOV A1, R7
    BL set_speed

handle_pb_done:
    POP {R4-R8, PC}

// ==================== Speed Control ====================
set_speed:
    PUSH {R4-R6, LR}
    MOV R4, A1                  // R4 = speed index

    // Clamp to 0-4
    CMP R4, #0
    MOVLT R4, #0
    CMP R4, #4
    MOVGT R4, #4

    // Get timer load value
    LDR R5, =TIMER_LOADS
    LDR A1, [R5, R4, LSL #2]

    // Configure timer
    MOV A2, #0b111              // Enable=1, Auto-reload=1, IRQ-enable=1
    BL ARM_TIM_config_ASM

    // Update LEDs
    MOV A1, R4
    BL set_speed_leds

    POP {R4-R6, PC}

set_speed_leds:
    PUSH {R4, LR}
    MOV R4, A1                  // R4 = speed index

    // Calculate LED pattern: (speed_idx + 1) * 2 LEDs
    ADD R4, R4, #1              // speed_idx + 1 (1-5)
    LSL R4, R4, #1              // * 2 (2, 4, 6, 8, 10)

    // Build LED mask
    CMP R4, #10
    LDRGE A1, =0x3FF            // All 10 LEDs
    BGE set_leds_write

    MOV A1, #1
    LSL A1, A1, R4
    SUB A1, A1, #1              // (1 << count) - 1

set_leds_write:
    BL write_LEDs_ASM

    POP {R4, PC}

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
    STR R5, [R6, R4, LSL #4]    // LSL #4 = multiply by 16 for 0x10 spacing

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

// ARM Timer Drivers
ARM_TIM_config_ASM:
    LDR A3, =PRIVTMR_BASE
    STR A1, [A3, #TMR_LOAD]
    STR A2, [A3, #TMR_CONTROL]
    BX LR

ARM_TIM_read_INT_ASM:
    LDR A2, =PRIVTMR_BASE
    LDR A1, [A2, #TMR_INTSTAT]
    AND A1, A1, #1
    BX LR

ARM_TIM_clear_INT_ASM:
    LDR A2, =PRIVTMR_BASE
    MOV A1, #1
    STR A1, [A2, #TMR_INTSTAT]
    BX LR

// ==================== GIC Configuration ====================
CONFIG_GIC:
    PUSH {LR}

    // Configure KEY interrupt (ID 73)
    MOV R0, #IRQ_ID_KEY
    MOV R1, #1
    BL CONFIG_INTERRUPT

    // Configure Timer interrupt (ID 29)
    MOV R0, #IRQ_ID_TIMER
    MOV R1, #1
    BL CONFIG_INTERRUPT

    // Configure the GIC CPU Interface
    LDR R0, =GIC_CPU_BASE

    // Set Interrupt Priority Mask Register (ICCPMR)
    LDR R1, =0xFFFF
    STR R1, [R0, #0x04]

    // Set enable bit in CPU Interface Control Register (ICCICR)
    MOV R1, #1
    STR R1, [R0]

    // Set enable bit in Distributor Control Register (ICDDCR)
    LDR R0, =GIC_DIST_BASE
    STR R1, [R0]

    POP {PC}

CONFIG_INTERRUPT:
    PUSH {R4-R5, LR}

    // Configure Interrupt Set-Enable Registers (ICDISERn)
    LSR R4, R0, #3
    BIC R4, R4, #3
    LDR R2, =0xFFFED100
    ADD R4, R2, R4
    AND R2, R0, #0x1F
    MOV R5, #1
    LSL R2, R5, R2

    LDR R3, [R4]
    ORR R3, R3, R2
    STR R3, [R4]

    // Configure Interrupt Processor Targets Register (ICDIPTRn)
    BIC R4, R0, #3
    LDR R2, =0xFFFED800
    ADD R4, R2, R4
    AND R2, R0, #0x3
    ADD R4, R2, R4

    STRB R1, [R4]

    POP {R4-R5, PC}

// ==================== Exception Handlers ====================
SERVICE_UND:
    B SERVICE_UND

SERVICE_SVC:
    B SERVICE_SVC

SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA

SERVICE_ABT_INST:
    B SERVICE_ABT_INST

SERVICE_IRQ:
    PUSH {R0-R7, LR}

    // Read the ICCIAR from the CPU Interface
    LDR R4, =GIC_CPU_BASE
    LDR R5, [R4, #ICCIAR_OFFSET]

    // Check which interrupt occurred
    CMP R5, #IRQ_ID_TIMER
    BEQ call_timer_isr

    CMP R5, #IRQ_ID_KEY
    BEQ call_key_isr

    B UNEXPECTED

call_timer_isr:
    BL ARM_TIM_ISR
    B EXIT_IRQ

call_key_isr:
    BL KEY_ISR
    B EXIT_IRQ

UNEXPECTED:
    B UNEXPECTED

EXIT_IRQ:
    // Write to the End of Interrupt Register (ICCEOIR)
    STR R5, [R4, #ICCEOIR_OFFSET]

    POP {R0-R7, LR}
    SUBS PC, LR, #4

SERVICE_FIQ:
    B SERVICE_FIQ

// ==================== Interrupt Service Routines ====================
KEY_ISR:
    PUSH {R0-R2, LR}

    // Read edge capture register
    LDR R0, =KEY_BASE
    LDR R1, [R0, #0xC]

    // Store to flag
    LDR R2, =PB_int_flag
    STR R1, [R2]

    // Clear edge capture
    MOV R1, #0xF
    STR R1, [R0, #0xC]

    POP {R0-R2, PC}

ARM_TIM_ISR:
    PUSH {R0-R2, LR}

    // Set flag
    LDR R0, =tim_int_flag
    MOV R1, #1
    STR R1, [R0]

    // Clear timer interrupt
    BL ARM_TIM_clear_INT_ASM

    POP {R0-R2, PC}

.end
