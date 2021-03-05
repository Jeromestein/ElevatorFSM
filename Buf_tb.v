`timescale 1ns/100ps

module Buf_tb ();

    reg clk, rst_n, done;
    reg [2:0] din;
    wire [2:0] dout;

    // input-3bit
    // [2]-UP:0, DOWN:1
    parameter [2:0] _1U = 3'b001, _2U = 3'b010, _3U = 3'b011,
                    _2D = 3'b110, _3D = 3'b111, _4D = 3'b100,
                    _NONE = 3'b000; 

    // instantiate Buf
    /*
    module Buf (
        input clk, rst_n, done,
        input [2:0] din,
        output qEmpty,
        output [2:0] dout    
    );
    */
    Buf U1 (clk, rst_n, done, din, qEmpty, dout);
    
    reg [5:0] buffer;
    always @(*) begin
        // get buffer
        buffer = U1.buffer;
    end

    initial begin
        clk = 0;
        rst_n = 0;

        #20 
        rst_n = 1;
        done = 1;
        // the input is like pressing button
        din = _1U;
        #15
        din = _NONE;

        #50
        done = 0;

        #50
        done = 1;
        din = _3U;
        #15
        din = _NONE;

        #50
        done = 0;

        #50
        done = 1;
        din = _2D;
        #15
        din = _NONE;

        #50
        din = _2U;

        #100
        done = 0;
        din = _4D;
        #15
        din = _NONE;
        din = _2D;
        #15
        din = _NONE;
        din = _3U;
        #15
        din = _NONE;
        din = _2U;
        #15
        din = _NONE;

        #80
        done = 1;

        #50
        din = _3D;
        #15
        din = _NONE;

        #50
        din = _2D;
        #15
        din = _NONE;

        #50
        din = _4D;
        #15
        din = _NONE;
        done = 1;

        #600;  
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