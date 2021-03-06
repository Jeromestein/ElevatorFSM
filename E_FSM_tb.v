`timescale 1ns/100ps

module E_FSM_tb ();
    
    reg clk, rst_n;
    reg [2:0] din;
    reg [5:0] buffer;
    reg [2:0] din_FSM; 
    reg [2:0] in_FSM; 
    wire [1:0] dout;

    /*
    instantiate
    module E_FSM (
        input clk_Buf, clk_FSM, rst_n,
        input [2:0] din,
        output [1:0] dout
    );
    */
    E_FSM U1 (clk, clk, rst_n, din, dout);

    ////////////////////
    /* get name       */
    ////////////////////
    /* define name variables */
    // state name, 3 bytes, 24 bits
    reg [23:0] crt_state_name, nxt_state_name;
    // input name, 3 bytes, 24 bits
    reg [23:0] input_name;
    // output name, 4 bytes, 32 bits
    reg [31:0] output_name;

    reg qEmpty; 
    reg done; 

    /* define name parameters */
    // state parameters
    // [3]-idle:0, busy:1
    // [2]-UP:0, DOWN:1
    parameter [3:0] S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100,
                    S12 = 4'b1001, S21 = 4'b1101,
                    S23 = 4'b1010, S32 = 4'b1110,
                    S34 = 4'b1011, S43 = 4'b1111;
    // input parameters
    // [2]-UP:0, DOWN:1
    parameter [2:0] _1U = 3'b001, _2U = 3'b010, _3U = 3'b011,
                    _2D = 3'b110, _3D = 3'b111, _4D = 3'b100,
                    _NONE = 3'b000; 
    // output parameters
    parameter [1:0] UP = 2'b00, DOWN = 2'b01, STAY = 2'b10;
                    
    always @(*) begin
        qEmpty = U1.qEmpty_Buf_to_LiftFSM;
        done = U1.done_LiftFSM_to_Buf;
        din_FSM = U1.data_Buf_to_LiftFSM;
        in_FSM = U1.FSM.in;
        buffer = U1.InputBuf.buffer;

        // get current state name
        case (U1.FSM.crt_state)
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
        
        // get next state name
        case (U1.FSM.nxt_state)
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

        // get input name
        case (din)
            _1U: input_name = "_1U"; 
            _2U: input_name = "_2U"; 
            _3U: input_name = "_3U"; 
            _2D: input_name = "_2D"; 
            _3D: input_name = "_3D"; 
            _4D: input_name = "_4D"; 

            // no default input
            //default: input_name = "_1U";
        endcase

        // get output name
        case (dout)
            UP: output_name = "UP"; 
            DOWN: output_name = "DOWN"; 
            STAY: output_name = "STAY"; 

            default: output_name = "STAY";
        endcase
        
    end    

    initial begin
        clk = 0;
        rst_n = 0;
        

        #20; 
        rst_n = 1;
        // simulate a man pressing a button
        din = _1U;
        #15
        din = _NONE;

        // simulate a man pressing a button
        #50;
        din = _3U;
        #15
        din = _NONE;

        // simulate a man pressing a button
        #50
        din = _2D;
        #15
        din = _NONE;

        // simulate a man pressing a button
        #50
        din = _2U;
        #15
        din = _NONE;

        // simulate a man pressing a button
        #50
        din = _4D;
        #15
        din = _NONE;

        // simulate a man pressing a button 
        #50
        din = _3D;
        #15
        din = _NONE;

        // simulate a man pressing a button 
        #50
        din = _2D;
        #15
        din = _NONE;

        // simulate people pressing buttons at one time
        #50
        din = _4D;
        #15
        din = _2D;
        #15
        din = _3U;
        #15
        din = _3D;
        #15
        din = _1U;
        #15
        din = _2U;
        #15
        din = _NONE;
        

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