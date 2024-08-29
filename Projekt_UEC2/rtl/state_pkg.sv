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
        IDLE  = 2'b00,
        RIGHT = 2'b01,
        LEFT  = 2'b10
    } State;
endpackage
