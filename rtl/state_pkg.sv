package state_pkg;
    typedef enum bit [1:0] {
        IDLE  = 2'b00,
        RIGHT = 2'b01,
        LEFT  = 2'b10
    } State;
endpackage
