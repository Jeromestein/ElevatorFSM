module Buf (
    input clk, rst_n, done,
    input [2:0] din,
    output qEmpty,
    output [2:0] dout    
);
    // define buf as register
    // buf[5] : is1U
    // buf[4] : is2U
    // buf[3] : is3U
    // buf[2] : is2D
    // buf[1] : is3D
    // buf[0] : is4D
    reg [5:0] buffer;
    reg [2:0] in, out;

    // input-3bit
    // [2]-UP:0, DOWN:1
    parameter [2:0] _1U = 3'b001, _2U = 3'b010, _3U = 3'b011,
                    _2D = 3'b110, _3D = 3'b111, _4D = 3'b100,
                    _NONE = 3'b000;  
    
    // assign one same reg type in two different always block is illegal for systhesis
    always @(posedge clk ) begin
        if (!rst_n) begin
            buffer <= 6'b000000;
        end else begin
            case (din)
                _1U: buffer[5] <= 1;
                _2U: buffer[4] <= 1;
                _3U: buffer[3] <= 1;
                _2D: buffer[2] <= 1;
                _3D: buffer[1] <= 1;
                _4D: buffer[0] <= 1;

                default:  buffer <= buffer;
            endcase 
        end

        
        // done == 1 means FSM is ready to process the next input
        if (done) begin
            casex (buffer) 
                6'b1?????: begin
                    out = _1U;
                    buffer[5] <= 0;
                end
                6'b01????: begin
                    out = _2U;
                    buffer[4] <= 0;
                end
                6'b001???: begin
                    out = _3U;
                    buffer[3] <= 0;
                end
                6'b0001??: begin
                    out = _2D;
                    buffer[2] <= 0;
                end
                6'b00001?: begin
                    out = _3D;
                    buffer[1] <= 0;
                end
                6'b000001: begin
                    out = _4D;
                    buffer[0] <= 0;
                end

                default: out = _NONE;
            endcase
        end else begin
            out = _NONE;
        end   
    end
     
    assign dout = out;
    assign qEmpty = (buffer == 6'b000000)? 1 : 0;

endmodule