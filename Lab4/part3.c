/*
 * ECSE 324 Lab 4 - Part 3: Game of Life
 *
 * IMPLEMENTED FUNCTIONALITY CHECKLIST:
 * [X] VGA_draw_line: COMPLETE - draws horizontal/vertical lines
 * [X] GoL_draw_grid: COMPLETE - draws 16x12 grid
 * [ ] VGA_draw_rect: YOU IMPLEMENT - draws filled rectangles
 * [ ] GoL_fill_gridxy: YOU IMPLEMENT - fills a grid cell
 * [X] GoL_draw_board: COMPLETE - draws current board state
 * [ ] Cursor movement (WASD): YOU IMPLEMENT
 * [ ] Toggle cell (SPACE): YOU IMPLEMENT
 * [ ] State update (N): YOU IMPLEMENT - the core Game of Life logic
 *
 * Controls:
 * - W/A/S/D: Move cursor
 * - SPACE: Toggle cell alive/dead
 * - N: Next generation (update game state)
 */

#include <stdlib.h>

/* ========================= CONSTANTS ========================= */
#define PS2_DATA_REG 0xff200100
#define PIXEL_BUFFER_BASE 0xc8000000
#define CHAR_BUFFER_BASE 0xc9000000

#define GRID_COLS 16
#define GRID_ROWS 12
#define CELL_SIZE 20  // Each grid cell is 20x20 pixels

// RGB565 Colors
#define COLOR_BLACK 0x0000
#define COLOR_WHITE 0xFFFF
#define COLOR_GRID 0x7BEF    // Light gray for grid lines
#define COLOR_ALIVE 0x0000   // Black for alive cells
#define COLOR_DEAD 0xFFFF    // White for dead cells
#define COLOR_CURSOR 0xF800  // Red for cursor

// PS/2 Scan Codes (MAKE codes only)
#define KEY_W 0x1D
#define KEY_A 0x1C
#define KEY_S 0x1B
#define KEY_D 0x23
#define KEY_SPACE 0x29
#define KEY_N 0x31

/* ========================= GLOBAL GAME STATE ========================= */
// Game board: 1 = alive, 0 = dead
int GoLBoard[GRID_ROWS][GRID_COLS] = {
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0},
    {0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
};

int cursor_x = 0;
int cursor_y = 0;

/* ========================= INLINE ASSEMBLY WRAPPERS ========================= */

// VGA_draw_point_ASM wrapper
void VGA_draw_point_ASM(int x, int y, short color) {
    __asm__ __volatile__(
        "push {r4, r5}\n\t"
        "cmp %0, #0\n\t"
        "blt draw_point_exit_%=\n\t"
        "ldr r4, =%3\n\t"
        "cmp %0, r4\n\t"
        "bge draw_point_exit_%=\n\t"
        "cmp %1, #0\n\t"
        "blt draw_point_exit_%=\n\t"
        "ldr r4, =%4\n\t"
        "cmp %1, r4\n\t"
        "bge draw_point_exit_%=\n\t"
        "ldr r4, =%5\n\t"
        "lsl r5, %1, #10\n\t"
        "orr r4, r4, r5\n\t"
        "lsl r5, %0, #1\n\t"
        "orr r4, r4, r5\n\t"
        "strh %2, [r4]\n\t"
        "draw_point_exit_%=:\n\t"
        "pop {r4, r5}\n\t"
        :
        : "r"(x), "r"(y), "r"(color), "i"(320), "i"(240), "i"(PIXEL_BUFFER_BASE)
        : "r4", "r5"
    );
}

// read_PS2_data_ASM wrapper
int read_PS2_data_ASM(char *data) {
    int result;
    __asm__ __volatile__(
        "ldr r1, =%1\n\t"
        "ldr r2, [r1]\n\t"
        "lsr r3, r2, #15\n\t"
        "and r3, r3, #1\n\t"
        "cmp r3, #0\n\t"
        "beq no_data_%=\n\t"
        "and r2, r2, #0xFF\n\t"
        "strb r2, [%2]\n\t"
        "mov %0, #1\n\t"
        "b end_read_%=\n\t"
        "no_data_%=:\n\t"
        "mov %0, #0\n\t"
        "end_read_%=:\n\t"
        : "=r"(result)
        : "i"(PS2_DATA_REG), "r"(data)
        : "r1", "r2", "r3"
    );
    return result;
}

/* ========================= VGA DRAWING FUNCTIONS ========================= */

/*
 * VGA_draw_line - Draw a horizontal or vertical line
 * COMPLETE IMPLEMENTATION
 */
void VGA_draw_line(int x1, int y1, int x2, int y2, short color) {
    if (x1 == x2) {  // Vertical line
        int start = (y1 < y2) ? y1 : y2;
        int end = (y1 < y2) ? y2 : y1;
        for (int y = start; y <= end; y++) {
            VGA_draw_point_ASM(x1, y, color);
        }
    } else if (y1 == y2) {  // Horizontal line
        int start = (x1 < x2) ? x1 : x2;
        int end = (x1 < x2) ? x2 : x1;
        for (int x = start; x <= end; x++) {
            VGA_draw_point_ASM(x, y1, color);
        }
    }
}

/*
 * VGA_draw_rect - Draw a filled rectangle
 *
 * TODO: YOU IMPLEMENT THIS (10% of Part 3 grade)
 * INSTRUCTIONS:
 * 1. Use nested loops to draw all pixels from (x1,y1) to (x2,y2)
 * 2. Outer loop: iterate y from y1 to y2
 * 3. Inner loop: iterate x from x1 to x2
 * 4. Call VGA_draw_point_ASM(x, y, color) for each pixel
 *
 * ALTERNATIVE: You can call VGA_draw_line for each horizontal line
 */
void VGA_draw_rect(int x1, int y1, int x2, int y2, short color) {
    // TODO: Implement filled rectangle drawing
    // Option 1: Nested loops with VGA_draw_point_ASM
    // Option 2: Loop calling VGA_draw_line for each row
}

/*
 * GoL_draw_grid - Draw the 16x12 grid
 * COMPLETE IMPLEMENTATION
 */
void GoL_draw_grid(short color) {
    // Draw vertical lines
    for (int col = 0; col <= GRID_COLS; col++) {
        int x = col * CELL_SIZE;
        VGA_draw_line(x, 0, x, GRID_ROWS * CELL_SIZE - 1, color);
    }
    // Draw horizontal lines
    for (int row = 0; row <= GRID_ROWS; row++) {
        int y = row * CELL_SIZE;
        VGA_draw_line(0, y, GRID_COLS * CELL_SIZE - 1, y, color);
    }
}

/*
 * GoL_fill_gridxy - Fill a specific grid cell with color
 *
 * TODO: YOU IMPLEMENT THIS (10% of Part 3 grade)
 * INSTRUCTIONS:
 * 1. Calculate pixel coordinates from grid coordinates:
 *    - x_start = x * CELL_SIZE + 1 (offset by 1 to not overwrite grid lines)
 *    - y_start = y * CELL_SIZE + 1
 *    - x_end = (x+1) * CELL_SIZE - 1
 *    - y_end = (y+1) * CELL_SIZE - 1
 * 2. Call VGA_draw_rect to fill the cell interior
 */
void GoL_fill_gridxy(int x, int y, short color) {
    // TODO: Convert grid coordinates to pixel coordinates
    // TODO: Call VGA_draw_rect to fill the cell
}

/*
 * GoL_draw_board - Draw all alive cells on the board
 * COMPLETE IMPLEMENTATION
 */
void GoL_draw_board(short alive_color) {
    for (int y = 0; y < GRID_ROWS; y++) {
        for (int x = 0; x < GRID_COLS; x++) {
            if (GoLBoard[y][x] == 1) {
                GoL_fill_gridxy(x, y, alive_color);
            }
        }
    }
}

/*
 * GoL_clear_cells - Clear all cells to dead color
 * COMPLETE IMPLEMENTATION
 */
void GoL_clear_cells(short dead_color) {
    for (int y = 0; y < GRID_ROWS; y++) {
        for (int x = 0; x < GRID_COLS; x++) {
            GoL_fill_gridxy(x, y, dead_color);
        }
    }
}

/* ========================= GAME LOGIC FUNCTIONS ========================= */

/*
 * count_neighbors - Count alive neighbors of cell (x, y)
 *
 * TODO: YOU IMPLEMENT THIS (Part of 20% state update grade)
 * INSTRUCTIONS:
 * 1. Check all 8 neighbors (N, S, E, W, NE, NW, SE, SW)
 * 2. Handle edge cases: cells on borders have fewer neighbors
 * 3. Use bounds checking: if (nx >= 0 && nx < GRID_COLS && ny >= 0 && ny < GRID_ROWS)
 * 4. Return count of alive neighbors
 *
 * HINT: Use a loop with dx in {-1, 0, 1} and dy in {-1, 0, 1}, skip (0,0)
 */
int count_neighbors(int x, int y) {
    int count = 0;
    // TODO: Implement neighbor counting
    // Iterate through all 8 surrounding cells
    // Check bounds and count alive cells
    return count;
}

/*
 * update_game_state - Apply Game of Life rules to update the board
 *
 * TODO: YOU IMPLEMENT THIS (20% of Part 3 grade)
 * INSTRUCTIONS:
 * 1. Create a temporary board to store next state
 * 2. For each cell, count its neighbors using count_neighbors()
 * 3. Apply Game of Life rules:
 *    - Alive cell with 0-1 neighbors: dies (underpopulation)
 *    - Alive cell with 2-3 neighbors: lives
 *    - Alive cell with 4+ neighbors: dies (overpopulation)
 *    - Dead cell with exactly 3 neighbors: becomes alive (reproduction)
 * 4. Copy temporary board back to GoLBoard
 *
 * IMPORTANT: Don't modify GoLBoard directly while iterating!
 * Use a temp array to avoid affecting neighbor counts.
 */
void update_game_state() {
    int nextBoard[GRID_ROWS][GRID_COLS];

    // TODO: Iterate through all cells
    // TODO: For each cell, count neighbors
    // TODO: Apply Game of Life rules to determine next state
    // TODO: Store result in nextBoard[y][x]

    // TODO: Copy nextBoard back to GoLBoard
}

/* ========================= INPUT HANDLING ========================= */

/*
 * handle_input - Process keyboard input
 *
 * TODO: YOU IMPLEMENT THIS (10% of Part 3 grade)
 * INSTRUCTIONS:
 * 1. Call read_PS2_data_ASM to get a scan code
 * 2. If no data, return immediately
 * 3. Compare scan code to KEY_* constants
 * 4. For WASD:
 *    - Update cursor_x/cursor_y
 *    - Check bounds: 0 <= cursor_x < GRID_COLS, 0 <= cursor_y < GRID_ROWS
 *    - Redraw the board
 * 5. For SPACE:
 *    - Toggle GoLBoard[cursor_y][cursor_x]
 *    - Redraw the board
 * 6. For N:
 *    - Call update_game_state()
 *    - Redraw the board
 *
 * HINT: After ANY key press, you need to:
 *   - Clear cells (GoL_clear_cells)
 *   - Draw board (GoL_draw_board)
 *   - Draw cursor at new position
 */
void handle_input() {
    char scan_code;

    if (!read_PS2_data_ASM(&scan_code)) {
        return;  // No data available
    }

    // TODO: Check which key was pressed
    // TODO: Handle W (up): cursor_y--
    // TODO: Handle A (left): cursor_x--
    // TODO: Handle S (down): cursor_y++
    // TODO: Handle D (right): cursor_x++
    // TODO: Handle SPACE: toggle GoLBoard[cursor_y][cursor_x]
    // TODO: Handle N: update_game_state()

    // TODO: Redraw the screen after any input
}

/* ========================= MAIN PROGRAM ========================= */

int main() {
    // Initialize display
    // Clear pixel buffer (you can implement this or use a loop)
    for (int y = 0; y < 240; y++) {
        for (int x = 0; x < 320; x++) {
            VGA_draw_point_ASM(x, y, COLOR_WHITE);
        }
    }

    // Draw initial state
    GoL_draw_grid(COLOR_GRID);
    GoL_draw_board(COLOR_ALIVE);

    // Draw initial cursor
    GoL_fill_gridxy(cursor_x, cursor_y, COLOR_CURSOR);

    // Main game loop
    while (1) {
        handle_input();
    }

    return 0;
}
