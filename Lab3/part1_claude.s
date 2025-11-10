// ==============================================================================
// ARMv7 Assembly - Embedded Message Display System
// Hardware: DE1-SoC or similar ARM development board
// ==============================================================================

// ------------------------------------------------------------------------------
// Hardware Memory-Mapped I/O Addresses
// ------------------------------------------------------------------------------
.equ MMIO_BASE,         0xFF200000      // Base address for peripherals
.equ LED_OFFSET,        0               // LED register offset
.equ SWITCH_OFFSET,     64              // Slider switch register offset
.equ PB_DATA_OFFSET,    80              // Push button data offset
.equ PB_MASK_OFFSET,    88              // Push button interrupt mask offset
.equ PB_EDGE_OFFSET,    92              // Push button edge capture offset

.equ HEX_LOW_BASE,      0xFF200020      // HEX displays 0-3
.equ HEX_HIGH_BASE,     0xFF200030      // HEX displays 4-5

// ------------------------------------------------------------------------------
// Constants
// ------------------------------------------------------------------------------
.equ MESSAGE_LENGTH,    6               // Maximum message buffer size
.equ LED_COUNTER_MAX,   2048            // Maximum LED counter value
.equ ALL_LEDS,          1023            // All 10 LEDs on (0x3FF)

// Button bit masks
.equ BUTTON_TOGGLE,     0x4             // Button 2 (toggle direction)
.equ BUTTON_ROTATE,     0x8             // Button 3 (rotate message)

// ==============================================================================
// Function: HEX_write_digit
// Description: Writes a 7-segment pattern to a specific HEX display
// Parameters:
//   r0 - Display position (0-5)
//   r1 - 7-segment pattern byte to write
// Returns: None
// ==============================================================================
HEX_write_digit:
        str     fp, [sp, #-4]!          // Save frame pointer
        add     fp, sp, #0              // Set up frame pointer
        
        cmp     r0, #3                  // Check if position 0-3 or 4-5
        ldrle   r3, .LHEX_LOW_ADDR      // Load HEX_LOW_BASE for 0-3
        ldrgt   r3, .LHEX_HIGH_ADDR     // Load HEX_HIGH_BASE for 4-5
        strb    r1, [r0, r3]            // Write pattern to display
        
        add     sp, fp, #0              // Restore stack pointer
        ldr     fp, [sp], #4            // Restore frame pointer
        bx      lr                      // Return
        
.LHEX_LOW_ADDR:
        .word   HEX_LOW_BASE
.LHEX_HIGH_ADDR:
        .word   HEX_HIGH_BASE

// ==============================================================================
// Function: glyph
// Description: Converts a hex digit (0-F) to 7-segment display pattern
// Parameters:
//   r0 - Hex digit value (0-15)
// Returns:
//   r0 - 7-segment pattern byte
// ==============================================================================
glyph:
        str     fp, [sp, #-4]!          // Save frame pointer
        add     fp, sp, #0              // Set up frame pointer
        
        and     r0, r0, #15             // Mask to 4 bits (0-15)
        ldr     r3, .LGLYPH_TABLE_ADDR  // Load address of HEX_CODES table
        ldrb    r0, [r3, r0]            // Get pattern from table
        
        add     sp, fp, #0              // Restore stack pointer
        ldr     fp, [sp], #4            // Restore frame pointer
        bx      lr                      // Return
        
.LGLYPH_TABLE_ADDR:
        .word   HEX_CODES

// ==============================================================================
// Function: HEX_write_six
// Description: Writes a 6-byte message buffer to all 6 HEX displays
// Parameters:
//   r0 - Pointer to 6-byte message buffer
// Returns: None
// ==============================================================================
HEX_write_six:
        push    {r4, r5, r6, r7, fp, lr}
        add     fp, sp, #20
        
        sub     r4, r0, #1              // r4 = buffer pointer - 1
        add     r6, r0, #5              // r6 = buffer end pointer
        rsb     r5, r0, #1              // r5 = offset adjustment
        
.HEX_write_loop:
        add     r0, r5, r4              // Calculate display position
        ldrb    r1, [r4, #1]!           // Load byte and increment pointer
        bl      HEX_write_digit         // Write to display
        cmp     r4, r6                  // Check if done
        bne     .HEX_write_loop         // Continue if not done
        
        sub     sp, fp, #20
        pop     {r4, r5, r6, r7, fp, lr}
        bx      lr

// ==============================================================================
// Function: build_message_from_switches
// Description: Builds a message based on slider switch position (0-4)
//              Switch 0: "COFFEE" (6 chars)
//              Switch 1: "CAFES"  (5 chars)
//              Switch 2: "CABS"   (4 chars)
//              Switch 3: (none)
//              Switch 4: "ACE"    (3 chars)
// Parameters:
//   r0 - Switch value (reads bits 0-4)
//   r1 - Pointer to 6-byte output buffer
// Returns:
//   r0 - Message length (0 if invalid switch)
// ==============================================================================
build_message_from_switches:
        push    {r4, r5, r6, fp, lr}
        add     fp, sp, #16
        sub     sp, sp, #12             // Allocate stack space for temp buffer
        
        mov     r6, r1                  // Save buffer pointer
        sub     r4, r1, #1              // r4 = buffer pointer - 1
        add     r5, r1, #5              // r5 = buffer end pointer
        
        // Clear output buffer
        mov     r3, r4
        mov     r2, #0
.clear_buffer_loop:
        strb    r2, [r3, #1]!           // Clear byte and increment
        cmp     r3, r5
        bne     .clear_buffer_loop
        
        // Decode switch position (bits 0-4)
        and     r0, r0, #31             // Mask to 5 bits
        ldr     r3, .LSWITCH_TABLE_ADDR
        cmp     r0, #4                  // Valid range is 0-4
        bhi     .message_invalid
        
        // Jump table based on switch value
        ldrb    r0, [r3, r0]            // Load jump offset
        add     pc, pc, r0, lsl #2      // Jump to handler
.switch_jump_anchor:
        nop
.switch_jump_table:
        .byte   (.message_coffee - .switch_jump_anchor - 4) / 4
        .byte   (.message_cafes - .switch_jump_anchor - 4) / 4
        .byte   (.message_cabs - .switch_jump_anchor - 4) / 4
        .byte   (.message_invalid - .switch_jump_anchor - 4) / 4
        .byte   (.message_ace - .switch_jump_anchor - 4) / 4

// --- Message: "COFFEE" (6 characters) ---
.message_coffee:
        mov     r0, #12                 // 'C'
        bl      glyph
        strb    r0, [fp, #-28]
        
        mov     r0, #0                  // 'O'
        bl      glyph
        strb    r0, [fp, #-27]
        
        mov     r0, #15                 // 'F'
        bl      glyph
        strb    r0, [fp, #-26]
        strb    r0, [fp, #-25]          // 'F' again
        
        mov     r0, #14                 // 'E'
        bl      glyph
        strb    r0, [fp, #-24]
        strb    r0, [fp, #-23]          // 'E' again
        
        // Copy temp buffer to output
        sub     r3, fp, #29
.copy_coffee:
        ldrb    r2, [r3, #1]!
        strb    r2, [r4, #1]!
        cmp     r4, r5
        bne     .copy_coffee
        
        mov     r0, #6                  // Return length
        b       .message_done

// --- Message: "CAFES" (5 characters) ---
.message_cafes:
        mov     r0, #12                 // 'C'
        bl      glyph
        strb    r0, [fp, #-28]
        
        mov     r0, #10                 // 'A'
        bl      glyph
        strb    r0, [fp, #-27]
        
        mov     r0, #15                 // 'F'
        bl      glyph
        strb    r0, [fp, #-26]
        
        mov     r0, #14                 // 'E'
        bl      glyph
        strb    r0, [fp, #-25]
        
        mov     r0, #5                  // 'S'
        bl      glyph
        strb    r0, [fp, #-24]
        
        // Copy temp buffer to output
        sub     r3, fp, #28
        add     r6, r6, #4              // Adjust end pointer for 5 chars
.copy_cafes:
        ldrb    r2, [r3], #1
        strb    r2, [r4, #1]!
        cmp     r4, r6
        bne     .copy_cafes
        
        mov     r0, #5                  // Return length
        b       .message_done

// --- Message: "CABS" (4 characters) ---
.message_cabs:
        mov     r0, #12                 // 'C'
        bl      glyph
        strb    r0, [fp, #-28]
        
        mov     r0, #10                 // 'A'
        bl      glyph
        strb    r0, [fp, #-27]
        
        mov     r0, #11                 // 'B'
        bl      glyph
        strb    r0, [fp, #-26]
        
        mov     r0, #5                  // 'S'
        bl      glyph
        strb    r0, [fp, #-25]
        
        // Copy temp buffer to output
        sub     r3, fp, #28
        add     r6, r6, #3              // Adjust end pointer for 4 chars
.copy_cabs:
        ldrb    r2, [r3], #1
        strb    r2, [r4, #1]!
        cmp     r4, r6
        bne     .copy_cabs
        
        mov     r0, #4                  // Return length
        b       .message_done

// --- Message: "ACE" (3 characters) ---
.message_ace:
        mov     r0, #10                 // 'A'
        bl      glyph
        mov     r5, r0
        
        mov     r0, #12                 // 'C'
        bl      glyph
        mov     r4, r0
        
        mov     r0, #14                 // 'E'
        bl      glyph
        
        // Write directly to buffer
        strb    r5, [r6]
        strb    r4, [r6, #1]
        strb    r0, [r6, #2]
        
        mov     r0, #3                  // Return length
        b       .message_done

// --- Invalid switch position ---
.message_invalid:
        mov     r0, #0                  // Return 0 length

.message_done:
        sub     sp, fp, #16
        pop     {r4, r5, r6, fp, lr}
        bx      lr

.LSWITCH_TABLE_ADDR:
        .word   .switch_jump_table

// ==============================================================================
// Function: rotate_left
// Description: Rotates a 6-byte message buffer left by 1 position
//              [0,1,2,3,4,5] -> [1,2,3,4,5,0]
// Parameters:
//   r0 - Pointer to 6-byte message buffer
// Returns: None
// ==============================================================================
rotate_left:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldrb    r3, [r0]                // Save first byte
        ldrb    r2, [r0, #1]
        strb    r2, [r0]                // Shift bytes left
        ldrb    r2, [r0, #2]
        strb    r2, [r0, #1]
        ldrb    r2, [r0, #3]
        strb    r2, [r0, #2]
        ldrb    r2, [r0, #4]
        strb    r2, [r0, #3]
        ldrb    r2, [r0, #5]
        strb    r2, [r0, #4]
        strb    r3, [r0, #5]            // Wrap first byte to end
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr

// ==============================================================================
// Function: rotate_right
// Description: Rotates a 6-byte message buffer right by 1 position
//              [0,1,2,3,4,5] -> [5,0,1,2,3,4]
// Parameters:
//   r0 - Pointer to 6-byte message buffer
// Returns: None
// ==============================================================================
rotate_right:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldrb    r3, [r0, #5]            // Save last byte
        ldrb    r2, [r0, #4]
        strb    r2, [r0, #5]            // Shift bytes right
        ldrb    r2, [r0, #3]
        strb    r2, [r0, #4]
        ldrb    r2, [r0, #2]
        strb    r2, [r0, #3]
        ldrb    r2, [r0, #1]
        strb    r2, [r0, #2]
        ldrb    r2, [r0]
        strb    r2, [r0, #1]
        strb    r3, [r0]                // Wrap last byte to beginning
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr

// ==============================================================================
// Hardware I/O Functions
// ==============================================================================

// Function: read_slider_switches_ASM
// Returns: r0 - 10-bit switch value
read_slider_switches_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r3, .LMMIO_BASE_1
        ldr     r0, [r3, #SWITCH_OFFSET]
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_1:
        .word   MMIO_BASE

// Function: write_LEDs_ASM
// Parameters: r0 - LED value to write
write_LEDs_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r3, .LMMIO_BASE_2
        str     r0, [r3, #LED_OFFSET]
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_2:
        .word   MMIO_BASE

// Function: HEX_clear_ASM
// Parameters: r0 - Bit mask for displays to clear (bit 0-5)
HEX_clear_ASM:
        push    {r4, r5, r6, r7, fp, lr}
        add     fp, sp, #20
        
        mov     r5, r0                  // Save display mask
        mov     r4, #0                  // Display counter
        mov     r6, #1                  // Bit mask
        mov     r7, #0                  // Clear pattern
        b       .hex_clear_test
        
.hex_clear_loop:
        add     r4, r4, #1
        cmp     r4, #6
        beq     .hex_clear_done
        
.hex_clear_test:
        ands    r3, r5, r6, lsl r4      // Test if display should be cleared
        beq     .hex_clear_loop
        
        mov     r1, r7                  // Pattern = 0 (clear)
        mov     r0, r4                  // Display position
        bl      HEX_write_digit
        b       .hex_clear_loop
        
.hex_clear_done:
        sub     sp, fp, #20
        pop     {r4, r5, r6, r7, fp, lr}
        bx      lr

// Function: HEX_flood_ASM
// Parameters: r0 - Bit mask for displays to flood (all segments on)
HEX_flood_ASM:
        push    {r4, r5, r6, r7, fp, lr}
        add     fp, sp, #20
        
        mov     r5, r0                  // Save display mask
        mov     r4, #0                  // Display counter
        mov     r6, #1                  // Bit mask
        mov     r7, #127                // All segments on (0x7F)
        b       .hex_flood_test
        
.hex_flood_loop:
        add     r4, r4, #1
        cmp     r4, #6
        beq     .hex_flood_done
        
.hex_flood_test:
        ands    r3, r5, r6, lsl r4      // Test if display should be flooded
        beq     .hex_flood_loop
        
        mov     r1, r7                  // Pattern = 0x7F (all on)
        mov     r0, r4                  // Display position
        bl      HEX_write_digit
        b       .hex_flood_loop
        
.hex_flood_done:
        sub     sp, fp, #20
        pop     {r4, r5, r6, r7, fp, lr}
        bx      lr

// Function: HEX_write_ASM
// Parameters: 
//   r0 - Bit mask for displays to write to
//   r1 - Hex value (0-15) to display
HEX_write_ASM:
        push    {r4, r5, r6, r7, fp, lr}
        add     fp, sp, #20
        
        mov     r5, r0                  // Save display mask
        
        // Get glyph pattern for value
        cmp     r1, #15
        ldrls   r3, .LHEX_CODES_ADDR_1
        ldrbls  r7, [r3, r1]            // Load pattern if valid
        movhi   r7, #0                  // Pattern = 0 if invalid
        
        mov     r4, #0                  // Display counter
        mov     r6, #1                  // Bit mask
        b       .hex_write_asm_test
        
.hex_write_asm_loop:
        add     r4, r4, #1
        cmp     r4, #6
        beq     .hex_write_asm_done
        
.hex_write_asm_test:
        ands    r3, r5, r6, lsl r4      // Test if display should be written
        beq     .hex_write_asm_loop
        
        mov     r1, r7                  // Pattern to write
        mov     r0, r4                  // Display position
        bl      HEX_write_digit
        b       .hex_write_asm_loop
        
.hex_write_asm_done:
        sub     sp, fp, #20
        pop     {r4, r5, r6, r7, fp, lr}
        bx      lr
.LHEX_CODES_ADDR_1:
        .word   HEX_CODES

// Function: read_PB_data_ASM
// Returns: r0 - Push button data register value
read_PB_data_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r3, .LMMIO_BASE_3
        ldr     r0, [r3, #PB_DATA_OFFSET]
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_3:
        .word   MMIO_BASE

// Function: PB_data_is_pressed_ASM
// Parameters: r0 - Button mask to test
// Returns: r0 - 1 if pressed, 0 if not pressed
PB_data_is_pressed_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r3, .LMMIO_BASE_4
        ldr     r3, [r3, #PB_DATA_OFFSET]
        tst     r3, r0                  // Test if button bit is set
        movne   r0, #1                  // Return 1 if pressed
        moveq   r0, #0                  // Return 0 if not pressed
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_4:
        .word   MMIO_BASE

// Function: read_PB_edgecp_ASM
// Returns: r0 - Push button edge capture register value
read_PB_edgecp_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r3, .LMMIO_BASE_5
        ldr     r0, [r3, #PB_EDGE_OFFSET]
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_5:
        .word   MMIO_BASE

// Function: PB_edgecp_is_pressed_ASM
// Parameters: r0 - Button mask to test
// Returns: r0 - 1 if edge captured, 0 if not
PB_edgecp_is_pressed_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r3, .LMMIO_BASE_6
        ldr     r3, [r3, #PB_EDGE_OFFSET]
        tst     r3, r0                  // Test if edge bit is set
        movne   r0, #1                  // Return 1 if captured
        moveq   r0, #0                  // Return 0 if not
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_6:
        .word   MMIO_BASE

// Function: PB_clear_edgecp_ASM
// Description: Clears the push button edge capture register
PB_clear_edgecp_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r3, .LMMIO_BASE_7
        ldr     r2, [r3, #PB_EDGE_OFFSET]
        str     r2, [r3, #PB_EDGE_OFFSET]   // Write-to-clear
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_7:
        .word   MMIO_BASE

// Function: enable_PB_INT_ASM
// Parameters: r0 - Button interrupt mask to enable
enable_PB_INT_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r2, .LMMIO_BASE_8
        ldr     r3, [r2, #PB_MASK_OFFSET]
        orr     r3, r3, r0              // Set mask bits
        str     r3, [r2, #PB_MASK_OFFSET]
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_8:
        .word   MMIO_BASE

// Function: disable_PB_INT_ASM
// Parameters: r0 - Button interrupt mask to disable
disable_PB_INT_ASM:
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        
        ldr     r2, .LMMIO_BASE_9
        ldr     r3, [r2, #PB_MASK_OFFSET]
        bic     r3, r3, r0              // Clear mask bits
        str     r3, [r2, #PB_MASK_OFFSET]
        
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.LMMIO_BASE_9:
        .word   MMIO_BASE

// ==============================================================================
// Main Program
// ==============================================================================
main:
        push    {r4, r5, r6, r7, r8, r9, r10, fp, lr}
        add     fp, sp, #32
        sub     sp, sp, #12
        
        // Initialize variables
        mov     r6, #0                  // LED counter = 0
        str     r6, [fp, #-44]          // Store counter on stack
        sub     r3, fp, #44
        strh    r6, [fp, #-40]          // Clear message buffer
        mvn     r7, #0                  // previous_switches = 0xFFFFFFFF
        mov     r8, #1                  // rotate_direction = 1 (left)
        mov     r5, r3                  // r5 = message buffer pointer
        mov     r9, r6                  // r9 = 0 (for LED clear)
        ldr     r10, .LALL_LEDS_CONST   // r10 = 1023 (all LEDs on)
        b       .main_loop_start

// --- Switch Changed Handler ---
.switch_changed:
        mov     r1, r5                  // Buffer pointer
        bl      build_message_from_switches
        
        mov     r0, r9                  // Clear LEDs
        bl      write_LEDs_ASM
        
        mov     r0, r5                  // Display new message
        bl      HEX_write_six
        
        bl      PB_clear_edgecp_ASM     // Clear button presses
        
        mov     r7, r4                  // Update previous_switches
        mov     r6, #0                  // Reset LED counter
        b       .check_buttons

// --- Button Not Pressed Handler ---
.button_rotate_not_pressed:
        tst     r0, #BUTTON_ROTATE      // Check if rotate button pressed
        bne     .button_rotate_pressed
        cmp     r0, #0                  // Any button pressed?
        bne     .clear_buttons
        
// --- Main Loop Entry ---
.main_loop_start:
        bl      read_slider_switches_ASM
        mov     r4, r0                  // r4 = current switches
        eor     r3, r7, r0              // Check if changed
        tst     r3, #31                 // Test lower 5 bits (switch position)
        bne     .switch_changed

// --- Check Buttons ---
.check_buttons:
        mov     r1, r5                  // Buffer pointer
        mov     r0, r4                  // Current switches
        bl      build_message_from_switches
        cmp     r0, #0                  // Check message length
        ble     .no_message             // Skip button handling if no message
        
        bl      read_PB_edgecp_ASM      // Read button edge captures
        tst     r0, #BUTTON_TOGGLE      // Check toggle button (button 2)
        beq     .button_rotate_not_pressed
        
        // Toggle rotation direction
        eor     r8, r8, #1              // Flip direction flag
        tst     r0, #BUTTON_ROTATE
        beq     .clear_buttons

// --- Button 3 Pressed: Rotate Message ---
.button_rotate_pressed:
        cmp     r8, #0                  // Check rotation direction
        beq     .rotate_right_now
        
        // Rotate left
        mov     r0, r5
        bl      rotate_left
        b       .update_display
        
.rotate_right_now:
        // Rotate right
        mov     r0, r5
        bl      rotate_right

.update_display:
        // Update HEX display
        mov     r0, r5
        bl      HEX_write_six
        
        // Update LED counter
        cmp     r6, #LED_COUNTER_MAX
        bcs     .counter_maxed          // If counter >= 2048, max LEDs
        
        add     r6, r6, #1              // Increment counter
        cmp     r6, #LED_COUNTER_MAX
        bcc     .show_counter           // If counter < 2048, show count
        
.counter_maxed:
        mov     r0, r10                 // All LEDs on (1023)
        bl      write_LEDs_ASM
        b       .clear_buttons
        
.show_counter:
        lsl     r0, r6, #22             // Shift left 22
        lsr     r0, r0, #22             // Shift right 22 (mask to 10 bits)
        bl      write_LEDs_ASM

.clear_buttons:
        bl      PB_clear_edgecp_ASM
        b       .main_loop_start

// --- No Message Selected ---
.no_message:
        bl      read_PB_edgecp_ASM
        cmp     r0, #0
        beq     .main_loop_start        // No buttons pressed, continue
        bl      PB_clear_edgecp_ASM     // Clear any button presses
        b       .main_loop_start

.LALL_LEDS_CONST:
        .word   ALL_LEDS

// ==============================================================================
// Data Section
// ==============================================================================
        .set    HEX_CODES, . + 0

// 7-Segment Display Lookup Table (0-9, A-F)
// Index:  0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F
// Char:   0     1     2     3     4     5     6     7     8     9     A     b     C     d     E     F
        .byte   0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07
        .byte   0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71

// ==============================================================================
// End of Program
// ==============================================================================