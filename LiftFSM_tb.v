`timescale 1ns/100ps

module LiftFSM_tb (
    
);
    reg clk, rst_n;
    reg [2:0] in;
    wire [1:0] out;

    // input-3bit
    // [2]-UP:0, DOWN:1
    parameter [2:0] _1U = 3'b001, _2U = 3'b010, _3U = 3'b011,
                    _2D = 3'b110, _3D = 3'b111, _4D = 3'b100;
                    // NO-INPUT = 3'b111,  ?

    // instantiate LiftFSM
    LiftFSM U1 (clk, rst_n, in, out);

    ////////////////////
    /* get state name */
    ////////////////////
    // 3 bytes, 24 bits
    reg [23:0] nxt_state_name, crt_state_name;
    // state-4bit 
    // [3]-idle:0, busy:1
    // [2]-UP:0, DOWN:1
    parameter [3:0] S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100,
                    S12 = 4'b1001, S21 = 4'b1101,
                    S23 = 4'b1010, S32 = 4'b1110,
                    S34 = 4'b1011, S43 = 4'b1111;
                    
    always @(*) begin
        case (U1.nxt_state)
            S1: nxt_state_name = "S1"; 
            S2: nxt_state_name = "S2"; 
            S3: nxt_state_name = "S3"; 
            S4: nxt_state_name = "S4"; 

            S12: nxt_state_name = "S12"; 
            S21: nxt_state_name = "S21"; 
            S23: nxt_state_name = "S23"; 
            S32: nxt_state_name = "S32"; 
            S34: nxt_state_name = "S34"; 
            S43: nxt_state_name = "S43"; 

            default: nxt_state_name = "S1";
        endcase

        case (U1.crt_state)
            S1: crt_state_name = "S1"; 
            S2: crt_state_name = "S2"; 
            S3: crt_state_name = "S3"; 
            S4: crt_state_name = "S4"; 

            S12: crt_state_name = "S12"; 
            S21: crt_state_name = "S21"; 
            S23: crt_state_name = "S23"; 
            S32: crt_state_name = "S32"; 
            S34: crt_state_name = "S34"; 
            S43: crt_state_name = "S43"; 

            default: crt_state_name = "S1";
        endcase
    end


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