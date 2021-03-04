`timescale 1ns/100ps

module LiftFSM_tb (
    
);
    reg clk, rst_n;
    reg [2:0] in;
    reg [1:0] out;

    // input-3bit
    // [2]-UP:0, DOWN:1
    parameter [2:0] _1U = 3'b001, _2U = 3'b010, _3U = 3'b011,
                    _2D = 3'b110, _3D = 3'b111, _4D = 3'b100;
                    // NO-INPUT = 3'b111,  ?

    LiftFSM U1 (clk, rst_n, in, out);

    initial begin
        clk = 0;
        rst_n = 0;

        #20 
        rst_n = 1;
        in = _1U;

        #50
        in = _3U;

        #100
        in = _2D;

        #150
        in = _2U;

        #200
        in = _4D;

        #250
        in = _3D;

        #300
        in = _2D;

        #350
        in = _4D;

        #600  
        $display("Running testbench");
        $stop;    
    end
    
    // set clock period as 10ns
    parameter clk_period = 10;
    always begin
        #(clk_period/2) 
        clk = ~clk;
    end          

endmodule