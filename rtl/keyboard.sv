/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora
 *
 * Description:
 * Na razie kod testowy dla klawiatury 
 */

 module keyboard(
    input clk,
    input ps2_data,
    input ps2_clk,
    output reg led_g
 );

 parameter idle = 2'b01;
 parameter receive = 2'b10;
 parameter ready = 2'b11;

 reg state = idle;
 reg rxtimeout = 16'b000000000000000;
 reg rxregister = 11'b1111111111;
 reg datasr = 2'b11;
 reg clksr = 2'b11;
 reg rxdata;
 reg datafetched;
 reg rxactive;
 reg dataready;

 always @(posedge clk)
    begin
        if(datafetched==1)
            led_g <= rxdata;
    end

always @(posedge clk)
    begin
        rxtimeout <= rxtimeout+1;
        datasr <= {datasr, ps2_data};
        clksr <= {clksr, ps2_clk};

        if(clksr==2'b10)
            rxregister <= {datasr, rxregister};
        
        case(state)
            idle:
            begin
                rxregister <= 11'b1111111111;
                rxactive <= 0;
                dataready <= 0;
                rxtimeout <=16'b0000000000000000;

                if(datasr==0 && clksr==1)
                begin
                    state <= receive;
                    rxactive <= 1;
                end
            end

            receive:
            begin
                if(rxtimeout == 50000)
                    state <= idle;
                else if(rxregister == 0)
                begin
                    dataready <= 1;
                    rxdata <= rxregister;
                    state <= ready;
                    datafetched <= 1;
                end
            end

            ready:
            begin
                if(datafetched == 1)
                begin
                    state <= idle;
                    dataready <= 0;
                    rxactive <= 0;
                end
            end
        endcase
    end
 endmodule
                

