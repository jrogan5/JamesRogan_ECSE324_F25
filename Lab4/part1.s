/*
 * ECSE 324 Lab 4 - Part 1: VGA Driver
 *
 * IMPLEMENTED FUNCTIONALITY:
 * - VGA_draw_point_ASM: COMPLETE
 * - VGA_clear_pixelbuff_ASM: YOU IMPLEMENT
 * - VGA_write_char_ASM: COMPLETE
 * - VGA_clear_charbuff_ASM: YOU IMPLEMENT
 */

.global _start

/* ========================= CONSTANTS ========================= */
.equ PIXEL_BUFFER_BASE, 0xc8000000
.equ CHAR_BUFFER_BASE, 0xc9000000
.equ PIXEL_WIDTH, 320
.equ PIXEL_HEIGHT, 240
.equ CHAR_WIDTH, 80
.equ CHAR_HEIGHT, 60

/* ========================= MAIN ========================= */
_start:
    bl draw_test_screen
end:
    b end

/* ========================= VGA DRIVER FUNCTIONS ========================= */

/*
 * VGA_draw_point_ASM - Draw a pixel at (x, y) with color c
 * C Prototype: void VGA_draw_point_ASM(int x, int y, short c);
 *
 * Arguments: r0 = x, r1 = y, r2 = color (16-bit RGB565)
 * Pixel address formula: 0xc8000000 | (y << 10) | (x << 1)
 */
VGA_draw_point_ASM:
    push {r4, r5, lr}

    // Bounds check x: must be 0 <= x < 320
    cmp r0, #0
    blt draw_point_exit
    ldr r4, =PIXEL_WIDTH
    cmp r0, r4
    bge draw_point_exit

    // Bounds check y: must be 0 <= y < 240
    cmp r1, #0
    blt draw_point_exit
    ldr r4, =PIXEL_HEIGHT
    cmp r1, r4
    bge draw_point_exit

    // Calculate address: base | (y << 10) | (x << 1)
    ldr r4, =PIXEL_BUFFER_BASE
    lsl r5, r1, #10          // y << 10
    orr r4, r4, r5
    lsl r5, r0, #1           // x << 1 (2 bytes per pixel)
    orr r4, r4, r5

    // Store 16-bit color
    strh r2, [r4]            // Use STRH for half-word (16 bits)

draw_point_exit:
    pop {r4, r5, pc}

/*
 * VGA_clear_pixelbuff_ASM - Clear entire pixel buffer to black
 * C Prototype: void VGA_clear_pixelbuff_ASM();
 * Arguments: none
 * Returns: none
 *
 * TODO: YOU IMPLEMENT THIS
 * INSTRUCTIONS:
 * 1. Use nested loops: outer for y (0 to 239), inner for x (0 to 319)
 * 2. Call VGA_draw_point_ASM(x, y, 0) for each pixel
 * 3. Save/restore registers properly
 *
 * HINTS:
 * - Use r4 for y counter, r5 for x counter
 * - Load PIXEL_HEIGHT and PIXEL_WIDTH for comparison
 * - Set r2 = 0 (black color) before calling VGA_draw_point_ASM
 */
VGA_clear_pixelbuff_ASM:
    push {r4, r5, r6, lr}
    mov r4, #0 // y
clear_pixel_y_loop:
    cmp r4, =PIXEL_HEIGHT // 240
    bge clear_pixel_exit
    mov r5 , #0 // x
clear_pixel_x_loop:
    cmp r5, =PIXEL_WIDTH  // 320
    bge clear_pixel_next_y
    ldr r0, r5 // x
    ldr r1, r4 // y
    mov r2, #0 // pixel value: cleared
    bl VGA_draw_point_ASM
    add r5, r5, #1
    b clear_pixel_x_loop

clear_pixel_next_y:
    add r4, r4, #1
clear_pixel_exit:
    pop {r4, r5, r6, pc}

/*
 * VGA_write_char_ASM - Write ASCII character at (x, y)
 * C Prototype: void VGA_write_char_ASM(int x, int y, char c);
 *
 * Arguments: r0 = x, r1 = y, r2 = ASCII character (8-bit)
 * Character address formula: 0xc9000000 | (y << 7) | x
 */
VGA_write_char_ASM:
    push {r4, r5, lr}

    // Bounds check x: must be 0 <= x < 80
    cmp r0, #0
    blt write_char_exit
    ldr r4, =CHAR_WIDTH
    cmp r0, r4
    bge write_char_exit

    // Bounds check y: must be 0 <= y < 60
    cmp r1, #0
    blt write_char_exit
    ldr r4, =CHAR_HEIGHT
    cmp r1, r4
    bge write_char_exit

    // Calculate address: base | (y << 7) | x
    ldr r4, =CHAR_BUFFER_BASE
    lsl r5, r1, #7           // y << 7 (128 chars per row)
    orr r4, r4, r5
    orr r4, r4, r0           // Add x offset

    // Store 8-bit character
    strb r2, [r4]            // Use STRB for byte (8 bits)

write_char_exit:
    pop {r4, r5, pc}

/*
 * VGA_clear_charbuff_ASM - Clear entire character buffer
 * C Prototype: void VGA_clear_charbuff_ASM();
 *
 * TODO: YOU IMPLEMENT THIS
 * INSTRUCTIONS:
 * 1. Use nested loops: outer for y (0 to 59), inner for x (0 to 79)
 * 2. Call VGA_write_char_ASM(x, y, 0) for each position
 * 3. Very similar structure to VGA_clear_pixelbuff_ASM
 *
 * HINTS:
 * - Use r4 for y counter, r5 for x counter
 * - Load CHAR_HEIGHT (60) and CHAR_WIDTH (80) for comparison
 * - Set r2 = 0 (null character) before calling VGA_write_char_ASM
 */
VGA_clear_charbuff_ASM:
    push {r4, r5, r6, lr}
    mov r4, #0 // y
.clear_char_y_loop:
    cmp r4, =char_HEIGHT // 240
    bge .clear_char_exit
    mov r5 , #0 // x
.clear_char_x_loop:
    cmp r5, =char_WIDTH  // 320
    bge.clear_char_next_y
    ldr r0, r5 // x
    ldr r1, r4 // y
    mov r2, #0 // char value: null
    bl VGA_write_char_ASM
    add r5, r5, #1
    b .clear_char_x_loop

.clear_char_next_y:
    add r4, r4, #1
.clear_char_exit:
    pop {r4, r5, r6, pc}

    pop {r4, r5, r6, pc}

/* ========================= TEST CODE (PROVIDED) ========================= */
draw_test_screen:
    push {r4, r5, r6, r7, r8, r9, r10, lr}
    bl VGA_clear_pixelbuff_ASM
    bl VGA_clear_charbuff_ASM
    mov r6, #0
    ldr r10, .draw_test_screen_L8
    ldr r9, .draw_test_screen_L8+4
    ldr r8, .draw_test_screen_L8+8
    b .draw_test_screen_L2
.draw_test_screen_L7:
    add r6, r6, #1
    cmp r6, #320
    beq .draw_test_screen_L4
.draw_test_screen_L2:
    smull r3, r7, r10, r6
    asr r3, r6, #31
    rsb r7, r3, r7, asr #2
    lsl r7, r7, #5
    lsl r5, r6, #5
    mov r4, #0
.draw_test_screen_L3:
    smull r3, r2, r9, r5
    add r3, r2, r5
    asr r2, r5, #31
    rsb r2, r2, r3, asr #9
    orr r2, r7, r2, lsl #11
    lsl r3, r4, #5
    smull r0, r1, r8, r3
    add r1, r1, r3
    asr r3, r3, #31
    rsb r3, r3, r1, asr #7
    orr r2, r2, r3
    mov r1, r4
    mov r0, r6
    bl VGA_draw_point_ASM
    add r4, r4, #1
    add r5, r5, #32
    cmp r4, #240
    bne .draw_test_screen_L3
    b .draw_test_screen_L7
.draw_test_screen_L4:
    mov r2, #72
    mov r1, #5
    mov r0, #20
    bl VGA_write_char_ASM
    mov r2, #101
    mov r1, #5
    mov r0, #21
    bl VGA_write_char_ASM
    mov r2, #108
    mov r1, #5
    mov r0, #22
    bl VGA_write_char_ASM
    mov r2, #108
    mov r1, #5
    mov r0, #23
    bl VGA_write_char_ASM
    mov r2, #111
    mov r1, #5
    mov r0, #24
    bl VGA_write_char_ASM
    mov r2, #32
    mov r1, #5
    mov r0, #25
    bl VGA_write_char_ASM
    mov r2, #87
    mov r1, #5
    mov r0, #26
    bl VGA_write_char_ASM
    mov r2, #111
    mov r1, #5
    mov r0, #27
    bl VGA_write_char_ASM
    mov r2, #114
    mov r1, #5
    mov r0, #28
    bl VGA_write_char_ASM
    mov r2, #108
    mov r1, #5
    mov r0, #29
    bl VGA_write_char_ASM
    mov r2, #100
    mov r1, #5
    mov r0, #30
    bl VGA_write_char_ASM
    mov r2, #33
    mov r1, #5
    mov r0, #31
    bl VGA_write_char_ASM
    pop {r4, r5, r6, r7, r8, r9, r10, pc}
.draw_test_screen_L8:
    .word 1717986919
    .word -368140053
    .word -2004318071

.end
