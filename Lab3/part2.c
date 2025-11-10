/* part2_noheaders.c — ECSE 324 Lab 3, Part 2 (Timer + IRQ, no headers) */

typedef unsigned int  u32;
typedef unsigned char u8;

/* Peripherals */
#define SW_ADDR      ((volatile u32*)0xFF200040)
#define LED_ADDR     ((volatile u32*)0xFF200000)
#define KEY_BASE     ((volatile u32*)0xFF200050)
#define HEX_BASE0    (0xFF200020u)
#define HEX_BASE1    (0xFF200030u)

/* ARM A9 private timer */
#define PRIVTMR_BASE   ((volatile u32*)0xFFFEC600)
#define TMR_LOAD       (PRIVTMR_BASE[0])
#define TMR_COUNT      (PRIVTMR_BASE[1])
#define TMR_CONTROL    (PRIVTMR_BASE[2])
#define TMR_INTSTAT    (PRIVTMR_BASE[3])

/* GIC */
#define GIC_CPU_BASE   ((volatile u32*)0xFFFEC100)
#define GIC_DIST_BASE  ((volatile u32*)0xFFFED000)
#define ICCICR   (GIC_CPU_BASE[0x00/4])
#define ICCPMR   (GIC_CPU_BASE[0x04/4])
#define ICCIAR   (GIC_CPU_BASE[0x0C/4])
#define ICCEOIR  (GIC_CPU_BASE[0x10/4])
#define ICDDCR   (GIC_DIST_BASE[0x000/4])
#define ICDISER  ((volatile u32*)0xFFFED100)
#define ICDIPTR  ((volatile u8*) 0xFFFED800)

#define IRQ_ID_KEY     73u
#define IRQ_ID_TIMER   29u

/* HEX digit write */
static void HEX_write_digit(int d, u8 seg) {
    if (d < 4) { volatile u8* p = (volatile u8*)(HEX_BASE0 + d); *p = seg; }
    else       { volatile u8* p = (volatile u8*)(HEX_BASE1 + (d-4)); *p = seg; }
}

static const u8 HEX_CODES[16] = {
  0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71
};

static u8 glyph(u8 nib) { return HEX_CODES[nib & 0xF]; }
static void HEX_write_six(const u8 buf[6]) { int i; for (i=0;i<6;i++) HEX_write_digit(i, buf[i]); }

/* Part 1 driver names kept identical */
u32 read_slider_switches_ASM(void) { return *SW_ADDR; }
void write_LEDs_ASM(u32 v) { *LED_ADDR = v; }
void HEX_clear_ASM(u32 mask){ int d; for(d=0;d<6;++d) if(mask&(1u<<d)) HEX_write_digit(d,0); }
void HEX_flood_ASM(u32 mask){ int d; for(d=0;d<6;++d) if(mask&(1u<<d)) HEX_write_digit(d,0x7F); }
void HEX_write_ASM(u32 mask,u32 val){ u8 seg=(val<16u)?HEX_CODES[val]:0; int d; for(d=0;d<6;++d) if(mask&(1u<<d)) HEX_write_digit(d,seg); }
u32 read_PB_data_ASM(void){ return KEY_BASE[0]; }
u32 PB_data_is_pressed_ASM(u32 m){ return (KEY_BASE[0]&m)?1u:0u; }
u32 read_PB_edgecp_ASM(void){ return KEY_BASE[3]; }
u32 PB_edgecp_is_pressed_ASM(u32 m){ return (KEY_BASE[3]&m)?1u:0u; }
void PB_clear_edgecp_ASM(void){ u32 v=KEY_BASE[3]; KEY_BASE[3]=v; }
void enable_PB_INT_ASM(u32 m){ KEY_BASE[2] |= m; }
void disable_PB_INT_ASM(u32 m){ KEY_BASE[2] &= ~m; }

/* Timer drivers */
void ARM_TIM_config_ASM(u32 load, u32 ctrl_bits) { TMR_LOAD = load; TMR_CONTROL = ctrl_bits; }
u32  ARM_TIM_read_INT_ASM(void){ return (TMR_INTSTAT & 1u); }
void ARM_TIM_clear_INT_ASM(void){ TMR_INTSTAT = 1u; }

/* GIC helpers */
static void CONFIG_INTERRUPT(u32 int_id, u8 cpu_target_mask) {
    u32 reg = int_id >> 5;         /* /32 */
    u32 bit = int_id & 0x1F;       /* %32 */
    ICDISER[reg] |= (1u << bit);
    ICDIPTR[int_id] = cpu_target_mask; /* route to CPU0 */
}
static void CONFIG_GIC(void) {
    ICCPMR = 0xFFFFu;
    ICCICR = 1u;
    ICDDCR = 1u;
    CONFIG_INTERRUPT(IRQ_ID_KEY,   1);
    CONFIG_INTERRUPT(IRQ_ID_TIMER, 1);
}

/* ISR flags */
volatile u32 PB_int_flag = 0;
volatile u32 tim_int_flag = 0;

/* App state */
struct AppState {
    int speed_idx; /* 0..4 => {1/16,1/8,1/4,1/2,1}s */
    int paused;
    int dir_left;
    u8  window[6];
    const u8* msg; int msg_len; int head;
};
static const u32 LOADS[5] = { 12500000u, 25000000u, 50000000u, 100000000u, 200000000u };

static void set_speed(struct AppState* s, int idx) {
    if (idx<0) idx=0; if (idx>4) idx=4;
    s->speed_idx = idx;
    ARM_TIM_config_ASM(LOADS[idx], (1u<<2) | (1u<<1) | (1u<<0)); /* IRQ|AR|EN */
    if (s->paused) { write_LEDs_ASM(0); return; }
    /* LEDs: 2 per level */
    u32 leds = (u32)((idx+1)*2);
    u32 mask = (leds>=10u)?0x3FFu:((1u<<leds)-1u);
    write_LEDs_ASM(mask);
}

static void apply_switch_message(struct AppState* s, u32 sw) {
    static const u8 C0FFEE[6] = { glyph(12),glyph(0),glyph(15),glyph(15),glyph(14),glyph(14) };
    static const u8 CAFE5[5]  = { glyph(12),glyph(10),glyph(15),glyph(14),glyph(5) };
    static const u8 CAb5[4]   = { glyph(12),glyph(10),glyph(11),glyph(5) };
    static const u8 ACE[3]    = { glyph(10),glyph(12),glyph(14) };
    static const u8 SLOWMSG[10]= { glyph(7),glyph(0),glyph(10),glyph(13),glyph(5),glyph(7),glyph(0),glyph(0),glyph(1),glyph(5) };
    static const u8 LONGMSG[16]= { glyph(12),glyph(10),glyph(15),glyph(14),0,
                                   glyph(11),glyph(14),glyph(14),glyph(15),0,
                                   glyph(12),glyph(0),glyph(15),glyph(15),glyph(14),glyph(14) };
    const u8* m = 0; int L = 0;
    if (((sw & 0x1Fu) == 0x10u)) { m = LONGMSG; L = 16; }
    else if (((sw & 0x1Fu) == 0x08u)) { m = SLOWMSG; L = 10; }
    else if ((sw & 0x1Fu) == 0x00u) { m = C0FFEE; L = 6; }
    else if ((sw & 0x1Fu) == 0x01u) { m = CAFE5;  L = 5; }
    else if ((sw & 0x1Fu) == 0x02u) { m = CAb5;   L = 4; }
    else if ((sw & 0x1Fu) == 0x04u) { m = ACE;    L = 3; }
    s->msg = m; s->msg_len = L; s->head = 0;
    /* Left-justify initial window */
    {
        int i; for (i=0;i<6;i++) s->window[i] = (m && i<L) ? m[i] : 0;
        HEX_write_six(s->window);
    }
}

static void advance_window(struct AppState* s) {
    if (!s->msg || s->msg_len==0) return;
    if (s->dir_left) s->head = (s->head + 1) % s->msg_len;
    else             s->head = (s->head - 1 + s->msg_len) % s->msg_len;
    {
        int i; for (i=0;i<6;i++) {
            int idx = (s->head + i) % s->msg_len;
            s->window[i] = s->msg[idx];
        }
        HEX_write_six(s->window);
    }
}

/* ISRs called from vector stub */
void KEY_ISR(void) { u32 e = KEY_BASE[3]; PB_int_flag = e; KEY_BASE[3] = 0xFu; }
void ARM_TIM_ISR(void) { tim_int_flag = 1; ARM_TIM_clear_INT_ASM(); }

/* IRQ dispatcher called from vector stub */
void IRQ_handler_C(void) {
    u32 id = ICCIAR;
    if (id == IRQ_ID_KEY) KEY_ISR();
    else if (id == IRQ_ID_TIMER) ARM_TIM_ISR();
    ICCEOIR = id;
}

/* Main loop */
void main_loop(void) {
    struct AppState S;
    S.speed_idx = 2; S.paused = 0; S.dir_left = 1;
    S.msg = 0; S.msg_len = 0; S.head = 0;

    CONFIG_GIC();
    enable_PB_INT_ASM(0xFu);

    apply_switch_message(&S, read_slider_switches_ASM());
    set_speed(&S, 2);

    for (;;) {
        u32 sw = read_slider_switches_ASM();
        static u32 prev_sw = 0xFFFFFFFFu;
        if ((sw & 0x1Fu) != (prev_sw & 0x1Fu)) {
            apply_switch_message(&S, sw);
            prev_sw = sw;
        }

        /* PB edges latched in ISR */
        if (PB_int_flag) {
            u32 edges = PB_int_flag; PB_int_flag = 0;
            if (!S.paused) {
                if (edges & 0x4u) S.dir_left ^= 1;                 /* PB2 reverse */
                if (edges & 0x2u) { if (S.speed_idx < 4) set_speed(&S, S.speed_idx+1); } /* PB1 faster */
                if (edges & 0x1u) { if (S.speed_idx > 0) set_speed(&S, S.speed_idx-1); } /* PB0 slower */
            }
            if (edges & 0x8u) { /* PB3 pause toggle */
                S.paused ^= 1;
                if (S.paused) write_LEDs_ASM(0);
                else set_speed(&S, S.speed_idx);
            }
        }

        if (tim_int_flag) {
            tim_int_flag = 0;
            if (!S.paused && S.msg && S.msg_len>0) advance_window(&S);
        }
    }
}
