module LiftFSM (
    input clk, rst_n,
    input wire [2:0] in,
    output wire [1:0] out
);
    reg [2:0] state, nxt_state;

    // input
    parameter _1U = 3'b001, _2U = 3'b010, _3U = 3'b011
              _2D = 3'b110, _3D = 3'b111, _4D = 3'b100;
    // output
    parameter UP = 2'b00, DOWN = 2'b01, STAY = 2'b10;

    always @(posedge clk ) begin
        // sync reset 
        if(!rst_n)
            State <= S0;
        else
            State <= Next;
    end

    always @(state, in) begin
        
        
    end


endmodule