/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * State package.
 */
package state_pkg;
    typedef enum logic [1:0] {
        IDLE1  = 2'b00,
        RIGHT1 = 2'b01,
        LEFT1  = 2'b10
    } State1;

    typedef enum logic [1:0] {
        IDLE2  = 2'b00,
        RIGHT2 = 2'b01,
        LEFT2 = 2'b10
    } State2;

    typedef enum logic [1:0] {START, LEVEL_1, FINISH} g_state;
endpackage
