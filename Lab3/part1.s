	.cpu cortex-a9
	.eabi_attribute 20, 1	@ Tag_ABI_FP_denormal
	.eabi_attribute 21, 1	@ Tag_ABI_FP_exceptions
	.eabi_attribute 23, 3	@ Tag_ABI_FP_number_model
	.eabi_attribute 24, 1	@ Tag_ABI_align8_needed
	.eabi_attribute 25, 1	@ Tag_ABI_align8_preserved
	.eabi_attribute 26, 1	@ Tag_ABI_enum_size
	.eabi_attribute 30, 6	@ Tag_ABI_optimization_goals
	.eabi_attribute 34, 1	@ Tag_CPU_unaligned_access
	.eabi_attribute 18, 4	@ Tag_ABI_PCS_wchar_t
	.file	"part1.c"
@ GNU C99 (15:10.3-2021.07-4) version 10.3.1 20210621 (release) (arm-none-eabi)
@	compiled by GNU C version 11.2.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

@ GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
@ options passed:  -imultilib thumb/v7-a/nofp -D__USES_INITFINI__ part1.c
@ -mcpu=cortex-a9 -marm -mfpu=vfpv3 -mfloat-abi=soft
@ -mlibarch=armv7-a+mp+sec -march=armv7-a+mp+sec -auxbase-strip part1.s -g
@ -O0 -Wall -Wextra -std=c99 -fno-inline -fno-builtin
@ -fno-omit-frame-pointer -fverbose-asm
@ options enabled:  -faggressive-loop-optimizations -fallocation-dce
@ -fauto-inc-dec -fdelete-null-pointer-checks -fdwarf2-cfi-asm
@ -fearly-inlining -feliminate-unused-debug-symbols
@ -feliminate-unused-debug-types -ffp-int-builtin-inexact -ffunction-cse
@ -fgcse-lm -fgnu-unique -fident -finline-atomics -fipa-stack-alignment
@ -fira-hoist-pressure -fira-share-save-slots -fira-share-spill-slots
@ -fivopts -fkeep-static-consts -fleading-underscore -flifetime-dse
@ -fmath-errno -fmerge-debug-strings -fpeephole -fplt
@ -fprefetch-loop-arrays -freg-struct-return
@ -fsched-critical-path-heuristic -fsched-dep-count-heuristic
@ -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
@ -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
@ -fsched-stalled-insns-dep -fsemantic-interposition -fshow-column
@ -fshrink-wrap-separate -fsigned-zeros -fsplit-ivs-in-unroller
@ -fssa-backprop -fstdarg-opt -fstrict-volatile-bitfields -fsync-libcalls
@ -ftrapping-math -ftree-cselim -ftree-forwprop -ftree-loop-if-convert
@ -ftree-loop-im -ftree-loop-ivcanon -ftree-loop-optimize
@ -ftree-parallelize-loops= -ftree-phiprop -ftree-reassoc -ftree-scev-cprop
@ -funit-at-a-time -fverbose-asm -fzero-initialized-in-bss -marm -mbe32
@ -mlittle-endian -mpic-data-is-text-relative -msched-prolog
@ -munaligned-access -mvectorize-with-neon-quad

	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.align	2
	.arch armv7-a
	.arch_extension mp
	.arch_extension sec
	.syntax unified
	.arm
	.fpu softvfp
	.type	HEX_write_digit, %function
HEX_write_digit:
.LFB0:
	.file 1 "part1.c"
	.loc 1 14 44
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #20	@,,
	str	r0, [fp, #-16]	@ d, d
	mov	r3, r1	@ tmp117, seg
	strb	r3, [fp, #-17]	@ tmp118, seg
@ part1.c:15:     if (d < 4) {
	.loc 1 15 8
	ldr	r3, [fp, #-16]	@ tmp119, d
	cmp	r3, #3	@ tmp119,
	bgt	.L2		@,
.LBB2:
@ part1.c:16:         volatile u8* p = (volatile u8*)(HEX_BASE0 + d);
	.loc 1 16 51
	ldr	r2, [fp, #-16]	@ d.0_1, d
	mov	r3, #32	@ _2,
	movt	r3, 65312	@ _2,
	add	r3, r2, r3	@ _2, d.0_1, _2
@ part1.c:16:         volatile u8* p = (volatile u8*)(HEX_BASE0 + d);
	.loc 1 16 22
	str	r3, [fp, #-12]	@ _2, p
@ part1.c:17:         *p = seg;
	.loc 1 17 12
	ldr	r3, [fp, #-12]	@ tmp120, p
	ldrb	r2, [fp, #-17]	@ tmp121, seg
	strb	r2, [r3]	@ tmp121, *p_11
.LBE2:
@ part1.c:22: }
	.loc 1 22 1
	b	.L4		@
.L2:
.LBB3:
@ part1.c:19:         volatile u8* p = (volatile u8*)(HEX_BASE1 + (d - 4));
	.loc 1 19 51
	ldr	r2, [fp, #-16]	@ d.1_3, d
	mov	r3, #44	@ _4,
	movt	r3, 65312	@ _4,
	add	r3, r2, r3	@ _4, d.1_3, _4
@ part1.c:19:         volatile u8* p = (volatile u8*)(HEX_BASE1 + (d - 4));
	.loc 1 19 22
	str	r3, [fp, #-8]	@ _4, p
@ part1.c:20:         *p = seg;
	.loc 1 20 12
	ldr	r3, [fp, #-8]	@ tmp122, p
	ldrb	r2, [fp, #-17]	@ tmp123, seg
	strb	r2, [r3]	@ tmp123, *p_7
.L4:
.LBE3:
@ part1.c:22: }
	.loc 1 22 1
	nop	
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE0:
	.size	HEX_write_digit, .-HEX_write_digit
	.section	.rodata
	.align	2
	.type	HEX_CODES, %object
	.size	HEX_CODES, 16
HEX_CODES:
	.ascii	"?\006[Ofm}\007\177ow|9^yq"
	.text
	.align	2
	.global	read_slider_switches_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	read_slider_switches_ASM, %function
read_slider_switches_ASM:
.LFB1:
	.loc 1 32 36
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
@ part1.c:33:     return *SW_ADDR; 
	.loc 1 33 12
	mov	r3, #64	@ _1,
	movt	r3, 65312	@ _1,
	ldr	r3, [r3]	@ _3, *_1
@ part1.c:34: }
	.loc 1 34 1
	mov	r0, r3	@, <retval>
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE1:
	.size	read_slider_switches_ASM, .-read_slider_switches_ASM
	.align	2
	.global	write_LEDs_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	write_LEDs_ASM, %function
write_LEDs_ASM:
.LFB2:
	.loc 1 35 28
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #12	@,,
	str	r0, [fp, #-8]	@ v, v
@ part1.c:36:     *LED_ADDR = v; 
	.loc 1 36 5
	mov	r3, #0	@ _1,
	movt	r3, 65312	@ _1,
@ part1.c:36:     *LED_ADDR = v; 
	.loc 1 36 15
	ldr	r2, [fp, #-8]	@ tmp114, v
	str	r2, [r3]	@ tmp114, *_1
@ part1.c:37: }
	.loc 1 37 1
	nop	
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE2:
	.size	write_LEDs_ASM, .-write_LEDs_ASM
	.align	2
	.global	HEX_clear_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	HEX_clear_ASM, %function
HEX_clear_ASM:
.LFB3:
	.loc 1 40 30
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}	@
	.cfi_def_cfa_offset 8
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	add	fp, sp, #4	@,,
	.cfi_def_cfa 11, 4
	sub	sp, sp, #16	@,,
	str	r0, [fp, #-16]	@ mask, mask
@ part1.c:42:     for (d=0; d<6; ++d) 
	.loc 1 42 11
	mov	r3, #0	@ tmp115,
	str	r3, [fp, #-8]	@ tmp115, d
@ part1.c:42:     for (d=0; d<6; ++d) 
	.loc 1 42 5
	b	.L9		@
.L11:
@ part1.c:43:         if (mask&(1u<<d)) 
	.loc 1 43 21
	mov	r2, #1	@ tmp116,
	ldr	r3, [fp, #-8]	@ tmp117, d
	lsl	r2, r2, r3	@ _1, tmp116, tmp117
@ part1.c:43:         if (mask&(1u<<d)) 
	.loc 1 43 17
	ldr	r3, [fp, #-16]	@ tmp118, mask
	and	r3, r3, r2	@ _2, tmp118, _1
@ part1.c:43:         if (mask&(1u<<d)) 
	.loc 1 43 12
	cmp	r3, #0	@ _2,
	beq	.L10		@,
@ part1.c:44:             HEX_write_digit(d, 0); 
	.loc 1 44 13
	mov	r1, #0	@,
	ldr	r0, [fp, #-8]	@, d
	bl	HEX_write_digit		@
.L10:
@ part1.c:42:     for (d=0; d<6; ++d) 
	.loc 1 42 20 discriminator 2
	ldr	r3, [fp, #-8]	@ tmp120, d
	add	r3, r3, #1	@ tmp119, tmp120,
	str	r3, [fp, #-8]	@ tmp119, d
.L9:
@ part1.c:42:     for (d=0; d<6; ++d) 
	.loc 1 42 5 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp121, d
	cmp	r3, #5	@ tmp121,
	ble	.L11		@,
@ part1.c:45: }
	.loc 1 45 1
	nop	
	nop	
	sub	sp, fp, #4	@,,
	.cfi_def_cfa 13, 8
	@ sp needed	@
	pop	{fp, pc}	@
	.cfi_endproc
.LFE3:
	.size	HEX_clear_ASM, .-HEX_clear_ASM
	.align	2
	.global	HEX_flood_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	HEX_flood_ASM, %function
HEX_flood_ASM:
.LFB4:
	.loc 1 47 30
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}	@
	.cfi_def_cfa_offset 8
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	add	fp, sp, #4	@,,
	.cfi_def_cfa 11, 4
	sub	sp, sp, #16	@,,
	str	r0, [fp, #-16]	@ mask, mask
@ part1.c:49:     for (d=0; d<6; ++d) 
	.loc 1 49 11
	mov	r3, #0	@ tmp115,
	str	r3, [fp, #-8]	@ tmp115, d
@ part1.c:49:     for (d=0; d<6; ++d) 
	.loc 1 49 5
	b	.L13		@
.L15:
@ part1.c:50:     if (mask&(1u<<d)) 
	.loc 1 50 17
	mov	r2, #1	@ tmp116,
	ldr	r3, [fp, #-8]	@ tmp117, d
	lsl	r2, r2, r3	@ _1, tmp116, tmp117
@ part1.c:50:     if (mask&(1u<<d)) 
	.loc 1 50 13
	ldr	r3, [fp, #-16]	@ tmp118, mask
	and	r3, r3, r2	@ _2, tmp118, _1
@ part1.c:50:     if (mask&(1u<<d)) 
	.loc 1 50 8
	cmp	r3, #0	@ _2,
	beq	.L14		@,
@ part1.c:51:     HEX_write_digit(d, 0x7F); 
	.loc 1 51 5
	mov	r1, #127	@,
	ldr	r0, [fp, #-8]	@, d
	bl	HEX_write_digit		@
.L14:
@ part1.c:49:     for (d=0; d<6; ++d) 
	.loc 1 49 20 discriminator 2
	ldr	r3, [fp, #-8]	@ tmp120, d
	add	r3, r3, #1	@ tmp119, tmp120,
	str	r3, [fp, #-8]	@ tmp119, d
.L13:
@ part1.c:49:     for (d=0; d<6; ++d) 
	.loc 1 49 5 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp121, d
	cmp	r3, #5	@ tmp121,
	ble	.L15		@,
@ part1.c:52: }
	.loc 1 52 1
	nop	
	nop	
	sub	sp, fp, #4	@,,
	.cfi_def_cfa 13, 8
	@ sp needed	@
	pop	{fp, pc}	@
	.cfi_endproc
.LFE4:
	.size	HEX_flood_ASM, .-HEX_flood_ASM
	.align	2
	.global	HEX_write_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	HEX_write_ASM, %function
HEX_write_ASM:
.LFB5:
	.loc 1 54 39
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}	@
	.cfi_def_cfa_offset 8
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	add	fp, sp, #4	@,,
	.cfi_def_cfa 11, 4
	sub	sp, sp, #16	@,,
	str	r0, [fp, #-16]	@ mask, mask
	str	r1, [fp, #-20]	@ val, val
@ part1.c:55:     u8 seg = (val < 16u) ? HEX_CODES[val] : 0;
	.loc 1 55 8
	ldr	r3, [fp, #-20]	@ tmp116, val
	cmp	r3, #15	@ tmp116,
	bhi	.L17		@,
@ part1.c:55:     u8 seg = (val < 16u) ? HEX_CODES[val] : 0;
	.loc 1 55 8 is_stmt 0 discriminator 1
	movw	r3, #:lower16:HEX_CODES	@ tmp117,
	movt	r3, #:upper16:HEX_CODES	@ tmp117,
	ldr	r2, [fp, #-20]	@ tmp119, val
	add	r3, r3, r2	@ tmp118, tmp117, tmp119
	ldrb	r3, [r3]	@ zero_extendqisi2	@ iftmp.2_4, HEX_CODES[val_7(D)]
	b	.L18		@
.L17:
@ part1.c:55:     u8 seg = (val < 16u) ? HEX_CODES[val] : 0;
	.loc 1 55 8 discriminator 2
	mov	r3, #0	@ iftmp.2_4,
.L18:
@ part1.c:55:     u8 seg = (val < 16u) ? HEX_CODES[val] : 0;
	.loc 1 55 8 discriminator 4
	strb	r3, [fp, #-9]	@ tmp120, seg
@ part1.c:57:     for (d=0; d<6; ++d) 
	.loc 1 57 11 is_stmt 1 discriminator 4
	mov	r3, #0	@ tmp121,
	str	r3, [fp, #-8]	@ tmp121, d
@ part1.c:57:     for (d=0; d<6; ++d) 
	.loc 1 57 5 discriminator 4
	b	.L19		@
.L21:
@ part1.c:58:         if (mask&(1u<<d)) 
	.loc 1 58 21
	mov	r2, #1	@ tmp122,
	ldr	r3, [fp, #-8]	@ tmp123, d
	lsl	r2, r2, r3	@ _1, tmp122, tmp123
@ part1.c:58:         if (mask&(1u<<d)) 
	.loc 1 58 17
	ldr	r3, [fp, #-16]	@ tmp124, mask
	and	r3, r3, r2	@ _2, tmp124, _1
@ part1.c:58:         if (mask&(1u<<d)) 
	.loc 1 58 12
	cmp	r3, #0	@ _2,
	beq	.L20		@,
@ part1.c:59:             HEX_write_digit(d, seg);
	.loc 1 59 13
	ldrb	r3, [fp, #-9]	@ zero_extendqisi2	@ tmp125, seg
	mov	r1, r3	@, tmp125
	ldr	r0, [fp, #-8]	@, d
	bl	HEX_write_digit		@
.L20:
@ part1.c:57:     for (d=0; d<6; ++d) 
	.loc 1 57 20 discriminator 2
	ldr	r3, [fp, #-8]	@ tmp127, d
	add	r3, r3, #1	@ tmp126, tmp127,
	str	r3, [fp, #-8]	@ tmp126, d
.L19:
@ part1.c:57:     for (d=0; d<6; ++d) 
	.loc 1 57 5 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp128, d
	cmp	r3, #5	@ tmp128,
	ble	.L21		@,
@ part1.c:60: }
	.loc 1 60 1
	nop	
	nop	
	sub	sp, fp, #4	@,,
	.cfi_def_cfa 13, 8
	@ sp needed	@
	pop	{fp, pc}	@
	.cfi_endproc
.LFE5:
	.size	HEX_write_ASM, .-HEX_write_ASM
	.align	2
	.global	read_PB_data_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	read_PB_data_ASM, %function
read_PB_data_ASM:
.LFB6:
	.loc 1 63 28
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
@ part1.c:64:     return KEY_BASE[0]; 
	.loc 1 64 20
	mov	r3, #80	@ _1,
	movt	r3, 65312	@ _1,
	ldr	r3, [r3]	@ _3, *_1
@ part1.c:65: }
	.loc 1 65 1
	mov	r0, r3	@, <retval>
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE6:
	.size	read_PB_data_ASM, .-read_PB_data_ASM
	.align	2
	.global	PB_data_is_pressed_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	PB_data_is_pressed_ASM, %function
PB_data_is_pressed_ASM:
.LFB7:
	.loc 1 66 42
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #12	@,,
	str	r0, [fp, #-8]	@ idx_mask, idx_mask
@ part1.c:67:     return (KEY_BASE[0] & idx_mask) ? 1u : 0u; 
	.loc 1 67 21
	mov	r3, #80	@ _1,
	movt	r3, 65312	@ _1,
	ldr	r2, [r3]	@ _2, *_1
@ part1.c:67:     return (KEY_BASE[0] & idx_mask) ? 1u : 0u; 
	.loc 1 67 25
	ldr	r3, [fp, #-8]	@ tmp118, idx_mask
	and	r3, r3, r2	@ _3, tmp118, _2
@ part1.c:67:     return (KEY_BASE[0] & idx_mask) ? 1u : 0u; 
	.loc 1 67 42
	cmp	r3, #0	@ _3,
	beq	.L25		@,
@ part1.c:67:     return (KEY_BASE[0] & idx_mask) ? 1u : 0u; 
	.loc 1 67 42 is_stmt 0 discriminator 1
	mov	r3, #1	@ iftmp.3_4,
	b	.L27		@
.L25:
@ part1.c:67:     return (KEY_BASE[0] & idx_mask) ? 1u : 0u; 
	.loc 1 67 42 discriminator 2
	mov	r3, #0	@ iftmp.3_4,
.L27:
@ part1.c:68: }
	.loc 1 68 1 is_stmt 1 discriminator 5
	mov	r0, r3	@, <retval>
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE7:
	.size	PB_data_is_pressed_ASM, .-PB_data_is_pressed_ASM
	.align	2
	.global	read_PB_edgecp_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	read_PB_edgecp_ASM, %function
read_PB_edgecp_ASM:
.LFB8:
	.loc 1 69 30
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
@ part1.c:70:     return KEY_BASE[3]; 
	.loc 1 70 20
	mov	r3, #92	@ _1,
	movt	r3, 65312	@ _1,
	ldr	r3, [r3]	@ _3, *_1
@ part1.c:71: }
	.loc 1 71 1
	mov	r0, r3	@, <retval>
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE8:
	.size	read_PB_edgecp_ASM, .-read_PB_edgecp_ASM
	.align	2
	.global	PB_edgecp_is_pressed_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	PB_edgecp_is_pressed_ASM, %function
PB_edgecp_is_pressed_ASM:
.LFB9:
	.loc 1 72 44
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #12	@,,
	str	r0, [fp, #-8]	@ idx_mask, idx_mask
@ part1.c:73:     return (KEY_BASE[3] & idx_mask) ? 1u : 0u; 
	.loc 1 73 21
	mov	r3, #92	@ _1,
	movt	r3, 65312	@ _1,
	ldr	r2, [r3]	@ _2, *_1
@ part1.c:73:     return (KEY_BASE[3] & idx_mask) ? 1u : 0u; 
	.loc 1 73 25
	ldr	r3, [fp, #-8]	@ tmp118, idx_mask
	and	r3, r3, r2	@ _3, tmp118, _2
@ part1.c:73:     return (KEY_BASE[3] & idx_mask) ? 1u : 0u; 
	.loc 1 73 42
	cmp	r3, #0	@ _3,
	beq	.L31		@,
@ part1.c:73:     return (KEY_BASE[3] & idx_mask) ? 1u : 0u; 
	.loc 1 73 42 is_stmt 0 discriminator 1
	mov	r3, #1	@ iftmp.4_4,
	b	.L33		@
.L31:
@ part1.c:73:     return (KEY_BASE[3] & idx_mask) ? 1u : 0u; 
	.loc 1 73 42 discriminator 2
	mov	r3, #0	@ iftmp.4_4,
.L33:
@ part1.c:74: }
	.loc 1 74 1 is_stmt 1 discriminator 5
	mov	r0, r3	@, <retval>
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE9:
	.size	PB_edgecp_is_pressed_ASM, .-PB_edgecp_is_pressed_ASM
	.align	2
	.global	PB_clear_edgecp_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	PB_clear_edgecp_ASM, %function
PB_clear_edgecp_ASM:
.LFB10:
	.loc 1 75 32
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #12	@,,
@ part1.c:76:     u32 v = KEY_BASE[3]; 
	.loc 1 76 21
	mov	r3, #92	@ _1,
	movt	r3, 65312	@ _1,
@ part1.c:76:     u32 v = KEY_BASE[3]; 
	.loc 1 76 9
	ldr	r3, [r3]	@ tmp115, *_1
	str	r3, [fp, #-8]	@ tmp115, v
@ part1.c:77:     KEY_BASE[3] = v; 
	.loc 1 77 13
	mov	r3, #92	@ _2,
	movt	r3, 65312	@ _2,
@ part1.c:77:     KEY_BASE[3] = v; 
	.loc 1 77 17
	ldr	r2, [fp, #-8]	@ tmp116, v
	str	r2, [r3]	@ tmp116, *_2
@ part1.c:78: }
	.loc 1 78 1
	nop	
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE10:
	.size	PB_clear_edgecp_ASM, .-PB_clear_edgecp_ASM
	.align	2
	.global	enable_PB_INT_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	enable_PB_INT_ASM, %function
enable_PB_INT_ASM:
.LFB11:
	.loc 1 79 34
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #12	@,,
	str	r0, [fp, #-8]	@ mask, mask
@ part1.c:80:     KEY_BASE[2] |= mask; 
	.loc 1 80 17
	mov	r3, #88	@ _1,
	movt	r3, 65312	@ _1,
	ldr	r1, [r3]	@ _2, *_1
	mov	r3, #88	@ _3,
	movt	r3, 65312	@ _3,
	ldr	r2, [fp, #-8]	@ tmp117, mask
	orr	r2, r1, r2	@ _4, _2, tmp117
	str	r2, [r3]	@ _4, *_3
@ part1.c:81: }
	.loc 1 81 1
	nop	
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE11:
	.size	enable_PB_INT_ASM, .-enable_PB_INT_ASM
	.align	2
	.global	disable_PB_INT_ASM
	.syntax unified
	.arm
	.fpu softvfp
	.type	disable_PB_INT_ASM, %function
disable_PB_INT_ASM:
.LFB12:
	.loc 1 82 34
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #12	@,,
	str	r0, [fp, #-8]	@ mask, mask
@ part1.c:83:     KEY_BASE[2] &= ~mask; 
	.loc 1 83 17
	mov	r3, #88	@ _1,
	movt	r3, 65312	@ _1,
	ldr	r1, [r3]	@ _2, *_1
@ part1.c:83:     KEY_BASE[2] &= ~mask; 
	.loc 1 83 20
	ldr	r3, [fp, #-8]	@ tmp118, mask
	mvn	r2, r3	@ _3, tmp118
@ part1.c:83:     KEY_BASE[2] &= ~mask; 
	.loc 1 83 17
	mov	r3, #88	@ _4,
	movt	r3, 65312	@ _4,
	and	r2, r2, r1	@ _5, _3, _2
	str	r2, [r3]	@ _5, *_4
@ part1.c:84: }
	.loc 1 84 1
	nop	
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE12:
	.size	disable_PB_INT_ASM, .-disable_PB_INT_ASM
	.align	2
	.syntax unified
	.arm
	.fpu softvfp
	.type	glyph, %function
glyph:
.LFB13:
	.loc 1 87 25
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #12	@,,
	mov	r3, r0	@ tmp117, nib
	strb	r3, [fp, #-5]	@ tmp118, nib
@ part1.c:88:     return HEX_CODES[nib & 0xF]; 
	.loc 1 88 26
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2	@ _1, nib
	and	r2, r3, #15	@ _2, _1,
@ part1.c:88:     return HEX_CODES[nib & 0xF]; 
	.loc 1 88 21
	movw	r3, #:lower16:HEX_CODES	@ tmp119,
	movt	r3, #:upper16:HEX_CODES	@ tmp119,
	ldrb	r3, [r3, r2]	@ zero_extendqisi2	@ _5, HEX_CODES[_2]
@ part1.c:89: }
	.loc 1 89 1
	mov	r0, r3	@, <retval>
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE13:
	.size	glyph, .-glyph
	.align	2
	.syntax unified
	.arm
	.fpu softvfp
	.type	HEX_write_six, %function
HEX_write_six:
.LFB14:
	.loc 1 90 44
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}	@
	.cfi_def_cfa_offset 8
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	add	fp, sp, #4	@,,
	.cfi_def_cfa 11, 4
	sub	sp, sp, #16	@,,
	str	r0, [fp, #-16]	@ buf, buf
@ part1.c:92:     for (i=0;i<6;i++) 
	.loc 1 92 11
	mov	r3, #0	@ tmp116,
	str	r3, [fp, #-8]	@ tmp116, i
@ part1.c:92:     for (i=0;i<6;i++) 
	.loc 1 92 5
	b	.L40		@
.L41:
@ part1.c:93:     HEX_write_digit(i, buf[i]); 
	.loc 1 93 27 discriminator 3
	ldr	r3, [fp, #-8]	@ i.5_1, i
	ldr	r2, [fp, #-16]	@ tmp117, buf
	add	r3, r2, r3	@ _2, tmp117, i.5_1
@ part1.c:93:     HEX_write_digit(i, buf[i]); 
	.loc 1 93 5 discriminator 3
	ldrb	r3, [r3]	@ zero_extendqisi2	@ _3, *_2
	mov	r1, r3	@, _3
	ldr	r0, [fp, #-8]	@, i
	bl	HEX_write_digit		@
@ part1.c:92:     for (i=0;i<6;i++) 
	.loc 1 92 19 discriminator 3
	ldr	r3, [fp, #-8]	@ tmp119, i
	add	r3, r3, #1	@ tmp118, tmp119,
	str	r3, [fp, #-8]	@ tmp118, i
.L40:
@ part1.c:92:     for (i=0;i<6;i++) 
	.loc 1 92 5 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp120, i
	cmp	r3, #5	@ tmp120,
	ble	.L41		@,
@ part1.c:94: }
	.loc 1 94 1
	nop	
	nop	
	sub	sp, fp, #4	@,,
	.cfi_def_cfa 13, 8
	@ sp needed	@
	pop	{fp, pc}	@
	.cfi_endproc
.LFE14:
	.size	HEX_write_six, .-HEX_write_six
	.align	2
	.syntax unified
	.arm
	.fpu softvfp
	.type	build_message_from_switches, %function
build_message_from_switches:
.LFB15:
	.loc 1 96 60
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}	@
	.cfi_def_cfa_offset 8
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	add	fp, sp, #4	@,,
	.cfi_def_cfa 11, 4
	sub	sp, sp, #40	@,,
	str	r0, [fp, #-40]	@ sw, sw
	str	r1, [fp, #-44]	@ out6, out6
@ part1.c:97:     int i; for (i=0;i<6;i++) out6[i]=0;
	.loc 1 97 18
	mov	r3, #0	@ tmp151,
	str	r3, [fp, #-8]	@ tmp151, i
@ part1.c:97:     int i; for (i=0;i<6;i++) out6[i]=0;
	.loc 1 97 12
	b	.L43		@
.L44:
@ part1.c:97:     int i; for (i=0;i<6;i++) out6[i]=0;
	.loc 1 97 34 discriminator 3
	ldr	r3, [fp, #-8]	@ i.6_1, i
	ldr	r2, [fp, #-44]	@ tmp152, out6
	add	r3, r2, r3	@ _2, tmp152, i.6_1
@ part1.c:97:     int i; for (i=0;i<6;i++) out6[i]=0;
	.loc 1 97 37 discriminator 3
	mov	r2, #0	@ tmp153,
	strb	r2, [r3]	@ tmp154, *_2
@ part1.c:97:     int i; for (i=0;i<6;i++) out6[i]=0;
	.loc 1 97 26 discriminator 3
	ldr	r3, [fp, #-8]	@ tmp156, i
	add	r3, r3, #1	@ tmp155, tmp156,
	str	r3, [fp, #-8]	@ tmp155, i
.L43:
@ part1.c:97:     int i; for (i=0;i<6;i++) out6[i]=0;
	.loc 1 97 12 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp157, i
	cmp	r3, #5	@ tmp157,
	ble	.L44		@,
@ part1.c:99:     if ((sw & 0x1Fu) == 0x00u) {
	.loc 1 99 13
	ldr	r3, [fp, #-40]	@ tmp158, sw
	and	r3, r3, #31	@ _3, tmp158,
@ part1.c:99:     if ((sw & 0x1Fu) == 0x00u) {
	.loc 1 99 8
	cmp	r3, #0	@ _3,
	bne	.L45		@,
.LBB4:
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 21
	mov	r0, #12	@,
	bl	glyph		@
	mov	r3, r0	@ tmp159,
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 12
	strb	r3, [fp, #-16]	@ tmp160, m[0]
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 32
	mov	r0, #0	@,
	bl	glyph		@
	mov	r3, r0	@ tmp161,
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 12
	strb	r3, [fp, #-15]	@ tmp162, m[1]
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 42
	mov	r0, #15	@,
	bl	glyph		@
	mov	r3, r0	@ tmp163,
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 12
	strb	r3, [fp, #-14]	@ tmp164, m[2]
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 53
	mov	r0, #15	@,
	bl	glyph		@
	mov	r3, r0	@ tmp165,
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 12
	strb	r3, [fp, #-13]	@ tmp166, m[3]
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 64
	mov	r0, #14	@,
	bl	glyph		@
	mov	r3, r0	@ tmp167,
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 12
	strb	r3, [fp, #-12]	@ tmp168, m[4]
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 75
	mov	r0, #14	@,
	bl	glyph		@
	mov	r3, r0	@ tmp169,
@ part1.c:100:         u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
	.loc 1 100 12
	strb	r3, [fp, #-11]	@ tmp170, m[5]
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 15
	mov	r3, #0	@ tmp171,
	str	r3, [fp, #-8]	@ tmp171, i
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 9
	b	.L46		@
.L47:
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 31 discriminator 3
	ldr	r3, [fp, #-8]	@ i.7_10, i
	ldr	r2, [fp, #-44]	@ tmp172, out6
	add	r3, r2, r3	@ _11, tmp172, i.7_10
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 36 discriminator 3
	sub	r1, fp, #16	@ tmp173,,
	ldr	r2, [fp, #-8]	@ tmp175, i
	add	r2, r1, r2	@ tmp174, tmp173, tmp175
	ldrb	r2, [r2]	@ zero_extendqisi2	@ _12, m[i_38]
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 34 discriminator 3
	strb	r2, [r3]	@ tmp176, *_11
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 23 discriminator 3
	ldr	r3, [fp, #-8]	@ tmp178, i
	add	r3, r3, #1	@ tmp177, tmp178,
	str	r3, [fp, #-8]	@ tmp177, i
.L46:
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 9 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp179, i
	cmp	r3, #5	@ tmp179,
	ble	.L47		@,
@ part1.c:101:         for (i=0;i<6;i++) out6[i]=m[i]; return 6;
	.loc 1 101 48 discriminator 4
	mov	r3, #6	@ _42,
	b	.L48		@
.L45:
.LBE4:
@ part1.c:102:     } else if ((sw & 0x1Fu) == 0x01u) {
	.loc 1 102 20
	ldr	r3, [fp, #-40]	@ tmp180, sw
	and	r3, r3, #31	@ _13, tmp180,
@ part1.c:102:     } else if ((sw & 0x1Fu) == 0x01u) {
	.loc 1 102 15
	cmp	r3, #1	@ _13,
	bne	.L49		@,
.LBB5:
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 21
	mov	r0, #12	@,
	bl	glyph		@
	mov	r3, r0	@ tmp181,
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 12
	strb	r3, [fp, #-24]	@ tmp182, m[0]
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 32
	mov	r0, #10	@,
	bl	glyph		@
	mov	r3, r0	@ tmp183,
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 12
	strb	r3, [fp, #-23]	@ tmp184, m[1]
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 43
	mov	r0, #15	@,
	bl	glyph		@
	mov	r3, r0	@ tmp185,
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 12
	strb	r3, [fp, #-22]	@ tmp186, m[2]
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 54
	mov	r0, #14	@,
	bl	glyph		@
	mov	r3, r0	@ tmp187,
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 12
	strb	r3, [fp, #-21]	@ tmp188, m[3]
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 65
	mov	r0, #5	@,
	bl	glyph		@
	mov	r3, r0	@ tmp189,
@ part1.c:103:         u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
	.loc 1 103 12
	strb	r3, [fp, #-20]	@ tmp190, m[4]
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 15
	mov	r3, #0	@ tmp191,
	str	r3, [fp, #-8]	@ tmp191, i
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 9
	b	.L50		@
.L51:
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 31 discriminator 3
	ldr	r3, [fp, #-8]	@ i.8_19, i
	ldr	r2, [fp, #-44]	@ tmp192, out6
	add	r3, r2, r3	@ _20, tmp192, i.8_19
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 36 discriminator 3
	sub	r1, fp, #24	@ tmp193,,
	ldr	r2, [fp, #-8]	@ tmp195, i
	add	r2, r1, r2	@ tmp194, tmp193, tmp195
	ldrb	r2, [r2]	@ zero_extendqisi2	@ _21, m[i_39]
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 34 discriminator 3
	strb	r2, [r3]	@ tmp196, *_20
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 23 discriminator 3
	ldr	r3, [fp, #-8]	@ tmp198, i
	add	r3, r3, #1	@ tmp197, tmp198,
	str	r3, [fp, #-8]	@ tmp197, i
.L50:
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 9 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp199, i
	cmp	r3, #4	@ tmp199,
	ble	.L51		@,
@ part1.c:104:         for (i=0;i<5;i++) out6[i]=m[i]; return 5;
	.loc 1 104 48 discriminator 4
	mov	r3, #5	@ _42,
	b	.L48		@
.L49:
.LBE5:
@ part1.c:105:     } else if ((sw & 0x1Fu) == 0x02u) {
	.loc 1 105 20
	ldr	r3, [fp, #-40]	@ tmp200, sw
	and	r3, r3, #31	@ _22, tmp200,
@ part1.c:105:     } else if ((sw & 0x1Fu) == 0x02u) {
	.loc 1 105 15
	cmp	r3, #2	@ _22,
	bne	.L52		@,
.LBB6:
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 21
	mov	r0, #12	@,
	bl	glyph		@
	mov	r3, r0	@ tmp201,
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 12
	strb	r3, [fp, #-28]	@ tmp202, m[0]
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 32
	mov	r0, #10	@,
	bl	glyph		@
	mov	r3, r0	@ tmp203,
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 12
	strb	r3, [fp, #-27]	@ tmp204, m[1]
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 43
	mov	r0, #11	@,
	bl	glyph		@
	mov	r3, r0	@ tmp205,
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 12
	strb	r3, [fp, #-26]	@ tmp206, m[2]
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 54
	mov	r0, #5	@,
	bl	glyph		@
	mov	r3, r0	@ tmp207,
@ part1.c:106:         u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
	.loc 1 106 12
	strb	r3, [fp, #-25]	@ tmp208, m[3]
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 15
	mov	r3, #0	@ tmp209,
	str	r3, [fp, #-8]	@ tmp209, i
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 9
	b	.L53		@
.L54:
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 31 discriminator 3
	ldr	r3, [fp, #-8]	@ i.9_27, i
	ldr	r2, [fp, #-44]	@ tmp210, out6
	add	r3, r2, r3	@ _28, tmp210, i.9_27
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 36 discriminator 3
	sub	r1, fp, #28	@ tmp211,,
	ldr	r2, [fp, #-8]	@ tmp213, i
	add	r2, r1, r2	@ tmp212, tmp211, tmp213
	ldrb	r2, [r2]	@ zero_extendqisi2	@ _29, m[i_40]
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 34 discriminator 3
	strb	r2, [r3]	@ tmp214, *_28
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 23 discriminator 3
	ldr	r3, [fp, #-8]	@ tmp216, i
	add	r3, r3, #1	@ tmp215, tmp216,
	str	r3, [fp, #-8]	@ tmp215, i
.L53:
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 9 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp217, i
	cmp	r3, #3	@ tmp217,
	ble	.L54		@,
@ part1.c:107:         for (i=0;i<4;i++) out6[i]=m[i]; return 4;
	.loc 1 107 48 discriminator 4
	mov	r3, #4	@ _42,
	b	.L48		@
.L52:
.LBE6:
@ part1.c:108:     } else if ((sw & 0x1Fu) == 0x04u) {
	.loc 1 108 20
	ldr	r3, [fp, #-40]	@ tmp218, sw
	and	r3, r3, #31	@ _30, tmp218,
@ part1.c:108:     } else if ((sw & 0x1Fu) == 0x04u) {
	.loc 1 108 15
	cmp	r3, #4	@ _30,
	bne	.L55		@,
.LBB7:
@ part1.c:109:         u8 m[3] = { glyph(10), glyph(12), glyph(14) };
	.loc 1 109 21
	mov	r0, #10	@,
	bl	glyph		@
	mov	r3, r0	@ tmp219,
@ part1.c:109:         u8 m[3] = { glyph(10), glyph(12), glyph(14) };
	.loc 1 109 12
	strb	r3, [fp, #-32]	@ tmp220, m[0]
@ part1.c:109:         u8 m[3] = { glyph(10), glyph(12), glyph(14) };
	.loc 1 109 32
	mov	r0, #12	@,
	bl	glyph		@
	mov	r3, r0	@ tmp221,
@ part1.c:109:         u8 m[3] = { glyph(10), glyph(12), glyph(14) };
	.loc 1 109 12
	strb	r3, [fp, #-31]	@ tmp222, m[1]
@ part1.c:109:         u8 m[3] = { glyph(10), glyph(12), glyph(14) };
	.loc 1 109 43
	mov	r0, #14	@,
	bl	glyph		@
	mov	r3, r0	@ tmp223,
@ part1.c:109:         u8 m[3] = { glyph(10), glyph(12), glyph(14) };
	.loc 1 109 12
	strb	r3, [fp, #-30]	@ tmp224, m[2]
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 15
	mov	r3, #0	@ tmp225,
	str	r3, [fp, #-8]	@ tmp225, i
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 9
	b	.L56		@
.L57:
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 31 discriminator 3
	ldr	r3, [fp, #-8]	@ i.10_34, i
	ldr	r2, [fp, #-44]	@ tmp226, out6
	add	r3, r2, r3	@ _35, tmp226, i.10_34
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 36 discriminator 3
	sub	r1, fp, #32	@ tmp227,,
	ldr	r2, [fp, #-8]	@ tmp229, i
	add	r2, r1, r2	@ tmp228, tmp227, tmp229
	ldrb	r2, [r2]	@ zero_extendqisi2	@ _36, m[i_41]
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 34 discriminator 3
	strb	r2, [r3]	@ tmp230, *_35
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 23 discriminator 3
	ldr	r3, [fp, #-8]	@ tmp232, i
	add	r3, r3, #1	@ tmp231, tmp232,
	str	r3, [fp, #-8]	@ tmp231, i
.L56:
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 9 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp233, i
	cmp	r3, #2	@ tmp233,
	ble	.L57		@,
@ part1.c:110:         for (i=0;i<3;i++) out6[i]=m[i]; return 3;
	.loc 1 110 48 discriminator 4
	mov	r3, #3	@ _42,
	b	.L48		@
.L55:
.LBE7:
@ part1.c:112:         return 0;
	.loc 1 112 16
	mov	r3, #0	@ _42,
.L48:
@ part1.c:114: }
	.loc 1 114 1 discriminator 1
	mov	r0, r3	@, <retval>
	sub	sp, fp, #4	@,,
	.cfi_def_cfa 13, 8
	@ sp needed	@
	pop	{fp, pc}	@
	.cfi_endproc
.LFE15:
	.size	build_message_from_switches, .-build_message_from_switches
	.align	2
	.syntax unified
	.arm
	.fpu softvfp
	.type	rotate_left, %function
rotate_left:
.LFB16:
	.loc 1 116 35
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #20	@,,
	str	r0, [fp, #-16]	@ b, b
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 40
	ldr	r3, [fp, #-16]	@ tmp123, b
	ldrb	r3, [r3]	@ tmp124, *b_12(D)
	strb	r3, [fp, #-5]	@ tmp124, t
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 52
	ldr	r3, [fp, #-16]	@ tmp125, b
	ldrb	r2, [r3, #1]	@ zero_extendqisi2	@ _1, MEM[(u8 *)b_12(D) + 1B]
	ldr	r3, [fp, #-16]	@ tmp126, b
	strb	r2, [r3]	@ tmp127, *b_12(D)
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 60
	ldr	r3, [fp, #-16]	@ tmp128, b
	add	r3, r3, #1	@ _2, tmp128,
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 63
	ldr	r2, [fp, #-16]	@ tmp129, b
	ldrb	r2, [r2, #2]	@ zero_extendqisi2	@ _3, MEM[(u8 *)b_12(D) + 2B]
	strb	r2, [r3]	@ tmp130, *_2
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 71
	ldr	r3, [fp, #-16]	@ tmp131, b
	add	r3, r3, #2	@ _4, tmp131,
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 74
	ldr	r2, [fp, #-16]	@ tmp132, b
	ldrb	r2, [r2, #3]	@ zero_extendqisi2	@ _5, MEM[(u8 *)b_12(D) + 3B]
	strb	r2, [r3]	@ tmp133, *_4
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 82
	ldr	r3, [fp, #-16]	@ tmp134, b
	add	r3, r3, #3	@ _6, tmp134,
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 85
	ldr	r2, [fp, #-16]	@ tmp135, b
	ldrb	r2, [r2, #4]	@ zero_extendqisi2	@ _7, MEM[(u8 *)b_12(D) + 4B]
	strb	r2, [r3]	@ tmp136, *_6
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 93
	ldr	r3, [fp, #-16]	@ tmp137, b
	add	r3, r3, #4	@ _8, tmp137,
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 96
	ldr	r2, [fp, #-16]	@ tmp138, b
	ldrb	r2, [r2, #5]	@ zero_extendqisi2	@ _9, MEM[(u8 *)b_12(D) + 5B]
	strb	r2, [r3]	@ tmp139, *_8
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 104
	ldr	r3, [fp, #-16]	@ tmp140, b
	add	r3, r3, #5	@ _10, tmp140,
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 107
	ldrb	r2, [fp, #-5]	@ tmp141, t
	strb	r2, [r3]	@ tmp141, *_10
@ part1.c:116: static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
	.loc 1 116 111
	nop	
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE16:
	.size	rotate_left, .-rotate_left
	.align	2
	.syntax unified
	.arm
	.fpu softvfp
	.type	rotate_right, %function
rotate_right:
.LFB17:
	.loc 1 117 35
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!	@,
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -4
	add	fp, sp, #0	@,,
	.cfi_def_cfa_register 11
	sub	sp, sp, #20	@,,
	str	r0, [fp, #-16]	@ b, b
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 40
	ldr	r3, [fp, #-16]	@ tmp123, b
	ldrb	r3, [r3, #5]	@ tmp124, MEM[(u8 *)b_12(D) + 5B]
	strb	r3, [fp, #-5]	@ tmp124, t
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 49
	ldr	r3, [fp, #-16]	@ tmp125, b
	add	r3, r3, #5	@ _1, tmp125,
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 52
	ldr	r2, [fp, #-16]	@ tmp126, b
	ldrb	r2, [r2, #4]	@ zero_extendqisi2	@ _2, MEM[(u8 *)b_12(D) + 4B]
	strb	r2, [r3]	@ tmp127, *_1
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 60
	ldr	r3, [fp, #-16]	@ tmp128, b
	add	r3, r3, #4	@ _3, tmp128,
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 63
	ldr	r2, [fp, #-16]	@ tmp129, b
	ldrb	r2, [r2, #3]	@ zero_extendqisi2	@ _4, MEM[(u8 *)b_12(D) + 3B]
	strb	r2, [r3]	@ tmp130, *_3
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 71
	ldr	r3, [fp, #-16]	@ tmp131, b
	add	r3, r3, #3	@ _5, tmp131,
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 74
	ldr	r2, [fp, #-16]	@ tmp132, b
	ldrb	r2, [r2, #2]	@ zero_extendqisi2	@ _6, MEM[(u8 *)b_12(D) + 2B]
	strb	r2, [r3]	@ tmp133, *_5
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 82
	ldr	r3, [fp, #-16]	@ tmp134, b
	add	r3, r3, #2	@ _7, tmp134,
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 85
	ldr	r2, [fp, #-16]	@ tmp135, b
	ldrb	r2, [r2, #1]	@ zero_extendqisi2	@ _8, MEM[(u8 *)b_12(D) + 1B]
	strb	r2, [r3]	@ tmp136, *_7
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 93
	ldr	r3, [fp, #-16]	@ tmp137, b
	add	r3, r3, #1	@ _9, tmp137,
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 98
	ldr	r2, [fp, #-16]	@ tmp138, b
	ldrb	r2, [r2]	@ zero_extendqisi2	@ _10, *b_12(D)
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 96
	strb	r2, [r3]	@ tmp139, *_9
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 107
	ldr	r3, [fp, #-16]	@ tmp140, b
	ldrb	r2, [fp, #-5]	@ tmp141, t
	strb	r2, [r3]	@ tmp141, *b_12(D)
@ part1.c:117: static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }
	.loc 1 117 111
	nop	
	add	sp, fp, #0	@,,
	.cfi_def_cfa_register 13
	@ sp needed	@
	ldr	fp, [sp], #4	@,
	.cfi_restore 11
	.cfi_def_cfa_offset 0
	bx	lr	@
	.cfi_endproc
.LFE17:
	.size	rotate_right, .-rotate_right
	.section	.rodata
	.align	2
.LC0:
	.ascii	"\000\000\000\000\000\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu softvfp
	.type	main, %function
main:
.LFB18:
	.loc 1 119 16
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}	@
	.cfi_def_cfa_offset 8
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	add	fp, sp, #4	@,,
	.cfi_def_cfa 11, 4
	sub	sp, sp, #40	@,,
@ part1.c:120:     u8 display[6] = {0,0,0,0,0,0};
	.loc 1 120 8
	movw	r2, #:lower16:.LC0	@ tmp120,
	movt	r2, #:upper16:.LC0	@ tmp120,
	sub	r3, fp, #40	@ tmp121,,
	ldm	r2, {r0, r1}	@ tmp122,,
	str	r0, [r3]	@, display
	add	r3, r3, #4	@ tmp121, tmp121,
	strh	r1, [r3]	@ movhi	@, display
@ part1.c:121:     int dir_left = 1;
	.loc 1 121 9
	mov	r3, #1	@ tmp123,
	str	r3, [fp, #-8]	@ tmp123, dir_left
@ part1.c:122:     u32 prev_sw = 0xFFFFFFFFu;
	.loc 1 122 9
	mvn	r3, #0	@ tmp124,
	str	r3, [fp, #-12]	@ tmp124, prev_sw
@ part1.c:123:     u32 rotate_count = 0;
	.loc 1 123 9
	mov	r3, #0	@ tmp125,
	str	r3, [fp, #-16]	@ tmp125, rotate_count
.L70:
.LBB8:
@ part1.c:126:         u32 sw = read_slider_switches_ASM();
	.loc 1 126 18
	bl	read_slider_switches_ASM		@
	str	r0, [fp, #-20]	@, sw
@ part1.c:127:         if ((sw & 0x1Fu) != (prev_sw & 0x1Fu)) {
	.loc 1 127 26
	ldr	r2, [fp, #-20]	@ tmp126, sw
	ldr	r3, [fp, #-12]	@ tmp127, prev_sw
	eor	r3, r3, r2	@ _1, tmp127, tmp126
	and	r3, r3, #31	@ _2, _1,
@ part1.c:127:         if ((sw & 0x1Fu) != (prev_sw & 0x1Fu)) {
	.loc 1 127 12
	cmp	r3, #0	@ _2,
	beq	.L61		@,
.LBB9:
@ part1.c:128:             int len = build_message_from_switches(sw, display);
	.loc 1 128 23
	sub	r3, fp, #40	@ tmp128,,
	mov	r1, r3	@, tmp128
	ldr	r0, [fp, #-20]	@, sw
	bl	build_message_from_switches		@
	str	r0, [fp, #-24]	@, len
@ part1.c:130:             rotate_count = 0;
	.loc 1 130 26
	mov	r3, #0	@ tmp129,
	str	r3, [fp, #-16]	@ tmp129, rotate_count
@ part1.c:131:             write_LEDs_ASM(0);
	.loc 1 131 13
	mov	r0, #0	@,
	bl	write_LEDs_ASM		@
@ part1.c:132:             HEX_write_six(display);
	.loc 1 132 13
	sub	r3, fp, #40	@ tmp130,,
	mov	r0, r3	@, tmp130
	bl	HEX_write_six		@
@ part1.c:133:             prev_sw = sw;
	.loc 1 133 21
	ldr	r3, [fp, #-20]	@ tmp131, sw
	str	r3, [fp, #-12]	@ tmp131, prev_sw
@ part1.c:134:             PB_clear_edgecp_ASM();
	.loc 1 134 13
	bl	PB_clear_edgecp_ASM		@
.L61:
.LBE9:
@ part1.c:138:         if (build_message_from_switches(sw, display) > 0) {
	.loc 1 138 13
	sub	r3, fp, #40	@ tmp132,,
	mov	r1, r3	@, tmp132
	ldr	r0, [fp, #-20]	@, sw
	bl	build_message_from_switches		@
	mov	r3, r0	@ _3,
@ part1.c:138:         if (build_message_from_switches(sw, display) > 0) {
	.loc 1 138 12
	cmp	r3, #0	@ _3,
	ble	.L62		@,
.LBB10:
@ part1.c:139:             u32 edges = read_PB_edgecp_ASM();
	.loc 1 139 25
	bl	read_PB_edgecp_ASM		@
	str	r0, [fp, #-32]	@, edges
@ part1.c:140:             if (edges & 0x4u) { dir_left ^= 1; }       /* PB2 reverse */
	.loc 1 140 23
	ldr	r3, [fp, #-32]	@ tmp133, edges
	and	r3, r3, #4	@ _4, tmp133,
@ part1.c:140:             if (edges & 0x4u) { dir_left ^= 1; }       /* PB2 reverse */
	.loc 1 140 16
	cmp	r3, #0	@ _4,
	beq	.L63		@,
@ part1.c:140:             if (edges & 0x4u) { dir_left ^= 1; }       /* PB2 reverse */
	.loc 1 140 42 discriminator 1
	ldr	r3, [fp, #-8]	@ tmp135, dir_left
	eor	r3, r3, #1	@ tmp134, tmp135,
	str	r3, [fp, #-8]	@ tmp134, dir_left
.L63:
@ part1.c:141:             if (edges & 0x8u) {                        /* PB3 rotate */
	.loc 1 141 23
	ldr	r3, [fp, #-32]	@ tmp136, edges
	and	r3, r3, #8	@ _5, tmp136,
@ part1.c:141:             if (edges & 0x8u) {                        /* PB3 rotate */
	.loc 1 141 16
	cmp	r3, #0	@ _5,
	beq	.L64		@,
@ part1.c:142:                 if (dir_left) rotate_left(display);
	.loc 1 142 20
	ldr	r3, [fp, #-8]	@ tmp137, dir_left
	cmp	r3, #0	@ tmp137,
	beq	.L65		@,
@ part1.c:142:                 if (dir_left) rotate_left(display);
	.loc 1 142 31 discriminator 1
	sub	r3, fp, #40	@ tmp138,,
	mov	r0, r3	@, tmp138
	bl	rotate_left		@
	b	.L66		@
.L65:
@ part1.c:143:                 else          rotate_right(display);
	.loc 1 143 31
	sub	r3, fp, #40	@ tmp139,,
	mov	r0, r3	@, tmp139
	bl	rotate_right		@
.L66:
@ part1.c:144:                 HEX_write_six(display);
	.loc 1 144 17
	sub	r3, fp, #40	@ tmp140,,
	mov	r0, r3	@, tmp140
	bl	HEX_write_six		@
@ part1.c:145:                 if (rotate_count <= 2047u) rotate_count++;
	.loc 1 145 20
	ldr	r3, [fp, #-16]	@ tmp141, rotate_count
	cmp	r3, #2048	@ tmp141,
	bcs	.L67		@,
@ part1.c:145:                 if (rotate_count <= 2047u) rotate_count++;
	.loc 1 145 56 discriminator 1
	ldr	r3, [fp, #-16]	@ tmp143, rotate_count
	add	r3, r3, #1	@ tmp142, tmp143,
	str	r3, [fp, #-16]	@ tmp142, rotate_count
.L67:
@ part1.c:146:                 if (rotate_count > 2047u) write_LEDs_ASM(0x3FFu);
	.loc 1 146 20
	ldr	r3, [fp, #-16]	@ tmp144, rotate_count
	cmp	r3, #2048	@ tmp144,
	bcc	.L68		@,
@ part1.c:146:                 if (rotate_count > 2047u) write_LEDs_ASM(0x3FFu);
	.loc 1 146 43 discriminator 1
	movw	r0, #1023	@,
	bl	write_LEDs_ASM		@
	b	.L64		@
.L68:
@ part1.c:147:                 else                       write_LEDs_ASM(rotate_count & 0x3FFu);
	.loc 1 147 44
	ldr	r3, [fp, #-16]	@ tmp145, rotate_count
	ubfx	r3, r3, #0, #10	@ _6, tmp145,,
	mov	r0, r3	@, _6
	bl	write_LEDs_ASM		@
.L64:
@ part1.c:149:             if (edges) PB_clear_edgecp_ASM();
	.loc 1 149 16
	ldr	r3, [fp, #-32]	@ tmp146, edges
	cmp	r3, #0	@ tmp146,
	beq	.L70		@,
@ part1.c:149:             if (edges) PB_clear_edgecp_ASM();
	.loc 1 149 24 discriminator 1
	bl	PB_clear_edgecp_ASM		@
	b	.L70		@
.L62:
.LBE10:
.LBB11:
@ part1.c:152:             u32 e = read_PB_edgecp_ASM(); if (e) PB_clear_edgecp_ASM();
	.loc 1 152 21
	bl	read_PB_edgecp_ASM		@
	str	r0, [fp, #-28]	@, e
@ part1.c:152:             u32 e = read_PB_edgecp_ASM(); if (e) PB_clear_edgecp_ASM();
	.loc 1 152 46
	ldr	r3, [fp, #-28]	@ tmp147, e
	cmp	r3, #0	@ tmp147,
	beq	.L70		@,
@ part1.c:152:             u32 e = read_PB_edgecp_ASM(); if (e) PB_clear_edgecp_ASM();
	.loc 1 152 50 discriminator 1
	bl	PB_clear_edgecp_ASM		@
.LBE11:
.LBE8:
@ part1.c:125:     for (;;) {
	.loc 1 125 14 discriminator 1
	b	.L70		@
	.cfi_endproc
.LFE18:
	.size	main, .-main
.Letext0:
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0x543
	.2byte	0x4
	.4byte	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.4byte	.LASF30
	.byte	0xc
	.4byte	.LASF31
	.4byte	.LASF32
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	.Ldebug_line0
	.uleb128 0x2
	.ascii	"u32\000"
	.byte	0x1
	.byte	0x3
	.byte	0x17
	.4byte	0x31
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.4byte	.LASF0
	.uleb128 0x2
	.ascii	"u8\000"
	.byte	0x1
	.byte	0x4
	.byte	0x17
	.4byte	0x4d
	.uleb128 0x4
	.4byte	0x38
	.uleb128 0x5
	.4byte	0x38
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.4byte	.LASF1
	.uleb128 0x6
	.4byte	0x43
	.4byte	0x64
	.uleb128 0x7
	.4byte	0x31
	.byte	0xf
	.byte	0
	.uleb128 0x4
	.4byte	0x54
	.uleb128 0x8
	.4byte	.LASF2
	.byte	0x1
	.byte	0x19
	.byte	0x11
	.4byte	0x64
	.uleb128 0x5
	.byte	0x3
	.4byte	HEX_CODES
	.uleb128 0x9
	.4byte	.LASF18
	.byte	0x1
	.byte	0x77
	.byte	0x5
	.4byte	0x13b
	.4byte	.LFB18
	.4byte	.LFE18-.LFB18
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x13b
	.uleb128 0x8
	.4byte	.LASF3
	.byte	0x1
	.byte	0x78
	.byte	0x8
	.4byte	0x142
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x8
	.4byte	.LASF4
	.byte	0x1
	.byte	0x79
	.byte	0x9
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0x8
	.4byte	.LASF5
	.byte	0x1
	.byte	0x7a
	.byte	0x9
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.uleb128 0x8
	.4byte	.LASF6
	.byte	0x1
	.byte	0x7b
	.byte	0x9
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xa
	.4byte	.LBB8
	.4byte	.LBE8-.LBB8
	.uleb128 0xb
	.ascii	"sw\000"
	.byte	0x1
	.byte	0x7e
	.byte	0xd
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xc
	.4byte	.LBB9
	.4byte	.LBE9-.LBB9
	.4byte	0x105
	.uleb128 0xb
	.ascii	"len\000"
	.byte	0x1
	.byte	0x80
	.byte	0x11
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.uleb128 0xc
	.4byte	.LBB10
	.4byte	.LBE10-.LBB10
	.4byte	0x122
	.uleb128 0x8
	.4byte	.LASF7
	.byte	0x1
	.byte	0x8b
	.byte	0x11
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.byte	0
	.uleb128 0xa
	.4byte	.LBB11
	.4byte	.LBE11-.LBB11
	.uleb128 0xb
	.ascii	"e\000"
	.byte	0x1
	.byte	0x98
	.byte	0x11
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xd
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x6
	.4byte	0x38
	.4byte	0x152
	.uleb128 0x7
	.4byte	0x31
	.byte	0x5
	.byte	0
	.uleb128 0xe
	.4byte	.LASF8
	.byte	0x1
	.byte	0x75
	.byte	0xd
	.4byte	.LFB17
	.4byte	.LFE17-.LFB17
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x183
	.uleb128 0xf
	.ascii	"b\000"
	.byte	0x1
	.byte	0x75
	.byte	0x1d
	.4byte	0x183
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xb
	.ascii	"t\000"
	.byte	0x1
	.byte	0x75
	.byte	0x28
	.4byte	0x38
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.byte	0
	.uleb128 0x10
	.byte	0x4
	.4byte	0x38
	.uleb128 0xe
	.4byte	.LASF9
	.byte	0x1
	.byte	0x74
	.byte	0xd
	.4byte	.LFB16
	.4byte	.LFE16-.LFB16
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x1ba
	.uleb128 0xf
	.ascii	"b\000"
	.byte	0x1
	.byte	0x74
	.byte	0x1c
	.4byte	0x183
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xb
	.ascii	"t\000"
	.byte	0x1
	.byte	0x74
	.byte	0x28
	.4byte	0x38
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.byte	0
	.uleb128 0x11
	.4byte	.LASF12
	.byte	0x1
	.byte	0x60
	.byte	0xc
	.4byte	0x13b
	.4byte	.LFB15
	.4byte	.LFE15-.LFB15
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x267
	.uleb128 0xf
	.ascii	"sw\000"
	.byte	0x1
	.byte	0x60
	.byte	0x2c
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x12
	.4byte	.LASF10
	.byte	0x1
	.byte	0x60
	.byte	0x33
	.4byte	0x183
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0xb
	.ascii	"i\000"
	.byte	0x1
	.byte	0x61
	.byte	0x9
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.uleb128 0xc
	.4byte	.LBB4
	.4byte	.LBE4-.LBB4
	.4byte	0x219
	.uleb128 0xb
	.ascii	"m\000"
	.byte	0x1
	.byte	0x64
	.byte	0xc
	.4byte	0x142
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0xc
	.4byte	.LBB5
	.4byte	.LBE5-.LBB5
	.4byte	0x234
	.uleb128 0xb
	.ascii	"m\000"
	.byte	0x1
	.byte	0x67
	.byte	0xc
	.4byte	0x267
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.uleb128 0xc
	.4byte	.LBB6
	.4byte	.LBE6-.LBB6
	.4byte	0x24f
	.uleb128 0xb
	.ascii	"m\000"
	.byte	0x1
	.byte	0x6a
	.byte	0xc
	.4byte	0x277
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0xa
	.4byte	.LBB7
	.4byte	.LBE7-.LBB7
	.uleb128 0xb
	.ascii	"m\000"
	.byte	0x1
	.byte	0x6d
	.byte	0xc
	.4byte	0x287
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.byte	0
	.byte	0
	.uleb128 0x6
	.4byte	0x38
	.4byte	0x277
	.uleb128 0x7
	.4byte	0x31
	.byte	0x4
	.byte	0
	.uleb128 0x6
	.4byte	0x38
	.4byte	0x287
	.uleb128 0x7
	.4byte	0x31
	.byte	0x3
	.byte	0
	.uleb128 0x6
	.4byte	0x38
	.4byte	0x297
	.uleb128 0x7
	.4byte	0x31
	.byte	0x2
	.byte	0
	.uleb128 0x13
	.4byte	.LASF11
	.byte	0x1
	.byte	0x5a
	.byte	0xd
	.4byte	.LFB14
	.4byte	.LFE14-.LFB14
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2ca
	.uleb128 0xf
	.ascii	"buf\000"
	.byte	0x1
	.byte	0x5a
	.byte	0x24
	.4byte	0x2ca
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xb
	.ascii	"i\000"
	.byte	0x1
	.byte	0x5b
	.byte	0x9
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x10
	.byte	0x4
	.4byte	0x43
	.uleb128 0x14
	.4byte	.LASF13
	.byte	0x1
	.byte	0x57
	.byte	0xb
	.4byte	0x38
	.4byte	.LFB13
	.4byte	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x2fa
	.uleb128 0xf
	.ascii	"nib\000"
	.byte	0x1
	.byte	0x57
	.byte	0x14
	.4byte	0x38
	.uleb128 0x2
	.byte	0x91
	.sleb128 -9
	.byte	0
	.uleb128 0x15
	.4byte	.LASF15
	.byte	0x1
	.byte	0x52
	.byte	0x6
	.4byte	.LFB12
	.4byte	.LFE12-.LFB12
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x320
	.uleb128 0x12
	.4byte	.LASF14
	.byte	0x1
	.byte	0x52
	.byte	0x1d
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x15
	.4byte	.LASF16
	.byte	0x1
	.byte	0x4f
	.byte	0x6
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x346
	.uleb128 0x12
	.4byte	.LASF14
	.byte	0x1
	.byte	0x4f
	.byte	0x1c
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x15
	.4byte	.LASF17
	.byte	0x1
	.byte	0x4b
	.byte	0x6
	.4byte	.LFB10
	.4byte	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x36a
	.uleb128 0xb
	.ascii	"v\000"
	.byte	0x1
	.byte	0x4c
	.byte	0x9
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x16
	.4byte	.LASF19
	.byte	0x1
	.byte	0x48
	.byte	0x5
	.4byte	0x25
	.4byte	.LFB9
	.4byte	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x394
	.uleb128 0x12
	.4byte	.LASF20
	.byte	0x1
	.byte	0x48
	.byte	0x22
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x17
	.4byte	.LASF22
	.byte	0x1
	.byte	0x45
	.byte	0x5
	.4byte	0x25
	.4byte	.LFB8
	.4byte	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x16
	.4byte	.LASF21
	.byte	0x1
	.byte	0x42
	.byte	0x5
	.4byte	0x25
	.4byte	.LFB7
	.4byte	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x3d4
	.uleb128 0x12
	.4byte	.LASF20
	.byte	0x1
	.byte	0x42
	.byte	0x20
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x17
	.4byte	.LASF23
	.byte	0x1
	.byte	0x3f
	.byte	0x5
	.4byte	0x25
	.4byte	.LFB6
	.4byte	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x18
	.4byte	.LASF24
	.byte	0x1
	.byte	0x36
	.byte	0x6
	.4byte	.LFB5
	.4byte	.LFE5-.LFB5
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x43b
	.uleb128 0x12
	.4byte	.LASF14
	.byte	0x1
	.byte	0x36
	.byte	0x18
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xf
	.ascii	"val\000"
	.byte	0x1
	.byte	0x36
	.byte	0x22
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xb
	.ascii	"seg\000"
	.byte	0x1
	.byte	0x37
	.byte	0x8
	.4byte	0x38
	.uleb128 0x2
	.byte	0x91
	.sleb128 -13
	.uleb128 0xb
	.ascii	"d\000"
	.byte	0x1
	.byte	0x38
	.byte	0x9
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x18
	.4byte	.LASF25
	.byte	0x1
	.byte	0x2f
	.byte	0x6
	.4byte	.LFB4
	.4byte	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x46e
	.uleb128 0x12
	.4byte	.LASF14
	.byte	0x1
	.byte	0x2f
	.byte	0x18
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xb
	.ascii	"d\000"
	.byte	0x1
	.byte	0x30
	.byte	0x9
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x18
	.4byte	.LASF26
	.byte	0x1
	.byte	0x28
	.byte	0x6
	.4byte	.LFB3
	.4byte	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4a1
	.uleb128 0x12
	.4byte	.LASF14
	.byte	0x1
	.byte	0x28
	.byte	0x18
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xb
	.ascii	"d\000"
	.byte	0x1
	.byte	0x29
	.byte	0x9
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x15
	.4byte	.LASF27
	.byte	0x1
	.byte	0x23
	.byte	0x6
	.4byte	.LFB2
	.4byte	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x4c5
	.uleb128 0xf
	.ascii	"v\000"
	.byte	0x1
	.byte	0x23
	.byte	0x19
	.4byte	0x25
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.uleb128 0x17
	.4byte	.LASF28
	.byte	0x1
	.byte	0x20
	.byte	0x5
	.4byte	0x25
	.4byte	.LFB1
	.4byte	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xe
	.4byte	.LASF29
	.byte	0x1
	.byte	0xe
	.byte	0xd
	.4byte	.LFB0
	.4byte	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.4byte	0x540
	.uleb128 0xf
	.ascii	"d\000"
	.byte	0x1
	.byte	0xe
	.byte	0x21
	.4byte	0x13b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.uleb128 0xf
	.ascii	"seg\000"
	.byte	0x1
	.byte	0xe
	.byte	0x27
	.4byte	0x38
	.uleb128 0x2
	.byte	0x91
	.sleb128 -21
	.uleb128 0xc
	.4byte	.LBB2
	.4byte	.LBE2-.LBB2
	.4byte	0x528
	.uleb128 0xb
	.ascii	"p\000"
	.byte	0x1
	.byte	0x10
	.byte	0x16
	.4byte	0x540
	.uleb128 0x2
	.byte	0x91
	.sleb128 -16
	.byte	0
	.uleb128 0xa
	.4byte	.LBB3
	.4byte	.LBE3-.LBB3
	.uleb128 0xb
	.ascii	"p\000"
	.byte	0x1
	.byte	0x13
	.byte	0x16
	.4byte	0x540
	.uleb128 0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.byte	0
	.uleb128 0x10
	.byte	0x4
	.4byte	0x48
	.byte	0
	.section	.debug_abbrev,"",%progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2117
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",%progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.Ltext0
	.4byte	.Letext0-.Ltext0
	.4byte	0
	.4byte	0
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF15:
	.ascii	"disable_PB_INT_ASM\000"
.LASF11:
	.ascii	"HEX_write_six\000"
.LASF25:
	.ascii	"HEX_flood_ASM\000"
.LASF27:
	.ascii	"write_LEDs_ASM\000"
.LASF10:
	.ascii	"out6\000"
.LASF23:
	.ascii	"read_PB_data_ASM\000"
.LASF2:
	.ascii	"HEX_CODES\000"
.LASF31:
	.ascii	"part1.c\000"
.LASF5:
	.ascii	"prev_sw\000"
.LASF6:
	.ascii	"rotate_count\000"
.LASF1:
	.ascii	"unsigned char\000"
.LASF9:
	.ascii	"rotate_left\000"
.LASF21:
	.ascii	"PB_data_is_pressed_ASM\000"
.LASF29:
	.ascii	"HEX_write_digit\000"
.LASF12:
	.ascii	"build_message_from_switches\000"
.LASF18:
	.ascii	"main\000"
.LASF22:
	.ascii	"read_PB_edgecp_ASM\000"
.LASF28:
	.ascii	"read_slider_switches_ASM\000"
.LASF0:
	.ascii	"unsigned int\000"
.LASF3:
	.ascii	"display\000"
.LASF20:
	.ascii	"idx_mask\000"
.LASF13:
	.ascii	"glyph\000"
.LASF7:
	.ascii	"edges\000"
.LASF26:
	.ascii	"HEX_clear_ASM\000"
.LASF8:
	.ascii	"rotate_right\000"
.LASF4:
	.ascii	"dir_left\000"
.LASF14:
	.ascii	"mask\000"
.LASF30:
	.ascii	"GNU C99 10.3.1 20210621 (release) -mcpu=cortex-a9 -"
	.ascii	"marm -mfpu=vfpv3 -mfloat-abi=soft -march=armv7-a+mp"
	.ascii	"+sec -g -O0 -std=c99 -fno-inline -fno-builtin -fno-"
	.ascii	"omit-frame-pointer\000"
.LASF24:
	.ascii	"HEX_write_ASM\000"
.LASF32:
	.ascii	"/mnt/c/Users/jrog1/OneDrive/Desktop/Semester 5/ECSE"
	.ascii	" 324/Lab3\000"
.LASF16:
	.ascii	"enable_PB_INT_ASM\000"
.LASF19:
	.ascii	"PB_edgecp_is_pressed_ASM\000"
.LASF17:
	.ascii	"PB_clear_edgecp_ASM\000"
	.ident	"GCC: (15:10.3-2021.07-4) 10.3.1 20210621 (release)"
