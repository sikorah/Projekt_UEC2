/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * State package.
 */
package state_pkg;
    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        RIGHT1 = 3'b001,
        LEFT1  = 3'b010,
        RIGHT2 = 3'b011,
        LEFT2 = 3'b100
    } State;
endpackage
