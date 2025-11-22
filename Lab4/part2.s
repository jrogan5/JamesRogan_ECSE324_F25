/*
 * ECSE 324 Lab 4 - Part 2: PS/2 Keyboard Driver
 *
 * IMPLEMENTED FUNCTIONALITY:
 * - VGA driver functions: COPIED FROM PART 1 (complete)
 * - read_PS2_data_ASM: YOU IMPLEMENT
 * - Test code: PROVIDED
 */

.global _start

/* ========================= CONSTANTS ========================= */
.equ PS2_DATA_REG, 0xff200100
.equ PIXEL_BUFFER_BASE, 0xc8000000
.equ CHAR_BUFFER_BASE, 0xc9000000
.equ PIXEL_WIDTH, 320
.equ PIXEL_HEIGHT, 240
.equ CHAR_WIDTH, 80
.equ CHAR_HEIGHT, 60

/* ========================= MAIN ========================= */
_start:
    bl input_loop
end:
    b end

/* ========================= VGA DRIVER (COPIED FROM PART 1) ========================= */

VGA_draw_point_ASM:
    push {r4, r5, lr}
    cmp r0, #0
    blt draw_point_exit
    ldr r4, =PIXEL_WIDTH
    cmp r0, r4
    bge draw_point_exit
    cmp r1, #0
    blt draw_point_exit
    ldr r4, =PIXEL_HEIGHT
    cmp r1, r4
    bge draw_point_exit
    ldr r4, =PIXEL_BUFFER_BASE
    lsl r5, r1, #10
    orr r4, r4, r5
    lsl r5, r0, #1
    orr r4, r4, r5
    strh r2, [r4]
draw_point_exit:
    pop {r4, r5, pc}

VGA_clear_pixelbuff_ASM:
    push {r4, r5, r6, lr}
    mov r4, #0
clear_pixel_y_loop:
    ldr r6, =PIXEL_HEIGHT
    cmp r4, r6
    bge clear_pixel_exit
    mov r5, #0
clear_pixel_x_loop:
    ldr r6, =PIXEL_WIDTH
    cmp r5, r6
    bge clear_pixel_next_y
    mov r0, r5
    mov r1, r4
    mov r2, #0
    bl VGA_draw_point_ASM
    add r5, r5, #1
    b clear_pixel_x_loop
clear_pixel_next_y:
    add r4, r4, #1
    b clear_pixel_y_loop
clear_pixel_exit:
    pop {r4, r5, r6, pc}

VGA_write_char_ASM:
    push {r4, r5, lr}
    cmp r0, #0
    blt write_char_exit
    ldr r4, =CHAR_WIDTH
    cmp r0, r4
    bge write_char_exit
    cmp r1, #0
    blt write_char_exit
    ldr r4, =CHAR_HEIGHT
    cmp r1, r4
    bge write_char_exit
    ldr r4, =CHAR_BUFFER_BASE
    lsl r5, r1, #7
    orr r4, r4, r5
    orr r4, r4, r0
    strb r2, [r4]
write_char_exit:
    pop {r4, r5, pc}

VGA_clear_charbuff_ASM:
    push {r4, r5, r6, lr}
    mov r4, #0
clear_char_y_loop:
    ldr r6, =CHAR_HEIGHT
    cmp r4, r6
    bge clear_char_exit
    mov r5, #0
clear_char_x_loop:
    ldr r6, =CHAR_WIDTH
    cmp r5, r6
    bge clear_char_next_y
    mov r0, r5
    mov r1, r4
    mov r2, #0
    bl VGA_write_char_ASM
    add r5, r5, #1
    b clear_char_x_loop
clear_char_next_y:
    add r4, r4, #1
    b clear_char_y_loop
clear_char_exit:
    pop {r4, r5, r6, pc}

/* ========================= PS/2 DRIVER ========================= */

/*
 * read_PS2_data_ASM - Read one byte from PS/2 keyboard if available
 * C Prototype: int read_PS2_data_ASM(char *data);
 *
 * Arguments: r0 = pointer to store the byte
 * Returns: r0 = 1 if data was read, 0 if no data available
 *
 * The PS/2 Data Register (0xff200100) format:
 * - Bit 15 (RVALID): 1 if new data is available, 0 otherwise
 * - Bits 7-0: The keyboard scan code byte
 *
 * INSTRUCTIONS FOR YOU TO IMPLEMENT:
 * 1. Load the PS/2 data register value from address 0xff200100
 * 2. Extract the RVALID bit (bit 15): shift right by 15 and mask with 0x1
 * 3. If RVALID is 0, return 0 (no data available)
 * 4. If RVALID is 1:
 *    a. Extract the low 8 bits (the scan code data)
 *    b. Store the byte at the address pointed to by r0 (use STRB)
 *    c. Return 1
 *
 * HINTS:
 * - Use ldr r1, =PS2_DATA_REG to load the register address
 * - Use ldr r2, [r1] to read the register value
 * - Use lsr r3, r2, #15 to shift right by 15 bits
 * - Use and r3, r3, #1 to mask to get RVALID
 * - Use cmp r3, #0 then beq to check if RVALID is 0
 * - Use and r2, r2, #0xFF to extract low 8 bits
 * - Use strb r2, [r0] to store the byte
 */
read_PS2_data_ASM:
    push {r4, lr}

    // TODO: Load PS/2 data register address into r1
    // ldr r1, =PS2_DATA_REG

    // TODO: Read the register value into r2
    // ldr r2, [r1]

    // TODO: Extract RVALID bit (bit 15)
    // lsr r3, r2, #15       // Shift right by 15
    // and r3, r3, #1        // Mask to get just bit 0 (which was bit 15)

    // TODO: Check if RVALID is 0
    // cmp r3, #0
    // beq read_PS2_no_data  // If 0, no data available

    // RVALID is 1, so data is available
    // TODO: Extract the low 8 bits (the scan code)
    // and r2, r2, #0xFF

    // TODO: Store the byte at address pointed to by r0
    // strb r2, [r0]

    // TODO: Set return value to 1 (data was read)
    // mov r0, #1
    // pop {r4, pc}

read_PS2_no_data:
    // TODO: Set return value to 0 (no data available)
    // mov r0, #0
    pop {r4, pc}

/* ========================= TEST CODE (PROVIDED) ========================= */

write_hex_digit:
    push {r4, lr}
    cmp r2, #9
    addhi r2, r2, #55
    addls r2, r2, #48
    and r2, r2, #255
    bl VGA_write_char_ASM
    pop {r4, pc}

write_byte:
    push {r4, r5, r6, lr}
    mov r5, r0
    mov r6, r1
    mov r4, r2
    lsr r2, r2, #4
    bl write_hex_digit
    and r2, r4, #15
    mov r1, r6
    add r0, r5, #1
    bl write_hex_digit
    pop {r4, r5, r6, pc}

input_loop:
    push {r4, r5, lr}
    sub sp, sp, #12
    bl VGA_clear_pixelbuff_ASM
    bl VGA_clear_charbuff_ASM
    mov r4, #0
    mov r5, r4
    b .input_loop_L9
.input_loop_L13:
    ldrb r2, [sp, #7]
    mov r1, r4
    mov r0, r5
    bl write_byte
    add r5, r5, #3
    cmp r5, #79
    addgt r4, r4, #1
    movgt r5, #0
.input_loop_L8:
    cmp r4, #59
    bgt .input_loop_L12
.input_loop_L9:
    add r0, sp, #7
    bl read_PS2_data_ASM
    cmp r0, #0
    beq .input_loop_L8
    b .input_loop_L13
.input_loop_L12:
    add sp, sp, #12
    pop {r4, r5, pc}

.end
