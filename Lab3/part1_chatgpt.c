/* part1_noheaders.c — ECSE 324 Lab 3, Part 1 (Polling, no headers) */

typedef unsigned int  u32;
typedef unsigned char u8;

/* Base addresses */
#define SW_ADDR      ((volatile u32*)0xFF200040)
#define LED_ADDR     ((volatile u32*)0xFF200000)
#define KEY_BASE     ((volatile u32*)0xFF200050) /* [0]=data, [2]=int mask, [3]=edge */
#define HEX_BASE0    (0xFF200020u) /* HEX0..HEX3 bytes */
#define HEX_BASE1    (0xFF200030u) /* HEX4..HEX5 bytes */

/* Write a single HEX digit byte */
static void HEX_write_digit(int d, u8 seg) {
    if (d < 4) {
        volatile u8* p = (volatile u8*)(HEX_BASE0 + d);
        *p = seg;
    } else {
        volatile u8* p = (volatile u8*)(HEX_BASE1 + (d - 4));
        *p = seg;
    }
}

/* 7-seg codes for 0..F */
static const u8 HEX_CODES[16] = {
  0x3F, 0x06, 0x5B, 0x4F,
  0x66, 0x6D, 0x7D, 0x07,
  0x7F, 0x6F, 0x77, 0x7C,
  0x39, 0x5E, 0x79, 0x71
};

u32 read_slider_switches_ASM(void) { 
    return *SW_ADDR; 
}
void write_LEDs_ASM(u32 v) { 
    *LED_ADDR = v; 
}

/* mask bits 0..5 select HEX0..HEX5 */
void HEX_clear_ASM(u32 mask) { 
    int d; 
    for (d=0; d<6; ++d) 
        if (mask&(1u<<d)) 
            HEX_write_digit(d, 0); 
}

void HEX_flood_ASM(u32 mask) { 
    int d; 
    for (d=0; d<6; ++d) 
    if (mask&(1u<<d)) 
    HEX_write_digit(d, 0x7F); 
}

void HEX_write_ASM(u32 mask, u32 val) {
    u8 seg = (val < 16u) ? HEX_CODES[val] : 0;
    int d; 
    for (d=0; d<6; ++d) 
        if (mask&(1u<<d)) 
            HEX_write_digit(d, seg);
}

/* Pushbuttons */
u32 read_PB_data_ASM(void) { 
    return KEY_BASE[0]; 
}
u32 PB_data_is_pressed_ASM(u32 idx_mask) { 
    return (KEY_BASE[0] & idx_mask) ? 1u : 0u; 
}
u32 read_PB_edgecp_ASM(void) { 
    return KEY_BASE[3]; 
}
u32 PB_edgecp_is_pressed_ASM(u32 idx_mask) { 
    return (KEY_BASE[3] & idx_mask) ? 1u : 0u; 
}
void PB_clear_edgecp_ASM(void) { 
    u32 v = KEY_BASE[3]; 
    KEY_BASE[3] = v; 
}
void enable_PB_INT_ASM(u32 mask) { 
    KEY_BASE[2] |= mask; 
}
void disable_PB_INT_ASM(u32 mask){ 
    KEY_BASE[2] &= ~mask; 
}

/* Helpers */
static u8 glyph(u8 nib) { 
    return HEX_CODES[nib & 0xF]; 
}
static void HEX_write_six(const u8 buf[6]) { 
    int i; 
    for (i=0;i<6;i++) 
    HEX_write_digit(i, buf[i]); 
}

static int build_message_from_switches(u32 sw, u8 out6[6]) {
    int i; for (i=0;i<6;i++) out6[i]=0;
    /* Messages per spec: 0x00 C0FFEE, 0x01 CAFE5, 0x02 CAb5, 0x04 ACE, else blank */
    if ((sw & 0x1Fu) == 0x00u) {
        u8 m[6] = { glyph(12), glyph(0), glyph(15), glyph(15), glyph(14), glyph(14) };
        for (i=0;i<6;i++) out6[i]=m[i]; return 6;
    } else if ((sw & 0x1Fu) == 0x01u) {
        u8 m[5] = { glyph(12), glyph(10), glyph(15), glyph(14), glyph(5) };
        for (i=0;i<5;i++) out6[i]=m[i]; return 5;
    } else if ((sw & 0x1Fu) == 0x02u) {
        u8 m[4] = { glyph(12), glyph(10), glyph(11), glyph(5) };
        for (i=0;i<4;i++) out6[i]=m[i]; return 4;
    } else if ((sw & 0x1Fu) == 0x04u) {
        u8 m[3] = { glyph(10), glyph(12), glyph(14) };
        for (i=0;i<3;i++) out6[i]=m[i]; return 3;
    } else {
        return 0;
    }
}

static void rotate_left(u8 b[6])  { u8 t=b[0]; b[0]=b[1]; b[1]=b[2]; b[2]=b[3]; b[3]=b[4]; b[4]=b[5]; b[5]=t; }
static void rotate_right(u8 b[6]) { u8 t=b[5]; b[5]=b[4]; b[4]=b[3]; b[3]=b[2]; b[2]=b[1]; b[1]=b[0]; b[0]=t; }

int main(void) {
    u8 display[6] = {0,0,0,0,0,0};
    int dir_left = 1;
    u32 prev_sw = 0xFFFFFFFFu;
    u32 rotate_count = 0;

    for (;;) {
        u32 sw = read_slider_switches_ASM();
        if ((sw & 0x1Fu) != (prev_sw & 0x1Fu)) {
            int len = build_message_from_switches(sw, display);
            (void)len;
            rotate_count = 0;
            write_LEDs_ASM(0);
            HEX_write_six(display);
            prev_sw = sw;
            PB_clear_edgecp_ASM();
        }

        /* Only act if a message is active */
        if (build_message_from_switches(sw, display) > 0) {
            u32 edges = read_PB_edgecp_ASM();
            if (edges & 0x4u) { dir_left ^= 1; }       /* PB2 reverse */
            if (edges & 0x8u) {                        /* PB3 rotate */
                if (dir_left) rotate_left(display);
                else          rotate_right(display);
                HEX_write_six(display);
                if (rotate_count <= 2047u) rotate_count++;
                if (rotate_count > 2047u) write_LEDs_ASM(0x3FFu);
                else                       write_LEDs_ASM(rotate_count & 0x3FFu);
            }
            if (edges) PB_clear_edgecp_ASM();
        } else {
            /* blank: ignore PB2/PB3; do not change count */
            u32 e = read_PB_edgecp_ASM(); if (e) PB_clear_edgecp_ASM();
        }
    }
    return 0;
}
