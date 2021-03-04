module LiftFSM (
    input clk, rst_n,
    input wire [2:0] in,
    output reg [1:0] out
);
    // current state, next state
    reg [3:0] crt_state;
    reg [3:0] nxt_state;
    // state-4bit 
    // [3]-idle:0, busy:1
    // [2]-UP:0, DOWN:1
    parameter [3:0] S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100,
                    S12 = 4'b1001, S21 = 4'b1101,
                    S23 = 4'b1010, S32 = 4'b1110,
                    S34 = 4'b1011, S43 = 4'b1111;

    // input-3bit
    // [2]-UP:0, DOWN:1
    parameter [2:0] _1U = 3'b001, _2U = 3'b010, _3U = 3'b011,
                    _2D = 3'b110, _3D = 3'b111, _4D = 3'b100;
                    // NO-INPUT = 3'b111,  ?

    // output-2bit
    parameter [1:0] UP = 2'b00, DOWN = 2'b01, STAY = 2'b10;

    

    always @(posedge clk ) begin
        // sync reset 
        if(!rst_n)
            crt_state <= S1;
        else
            crt_state <= nxt_state;
    end

    always @(crt_state, in) begin
        // generate the next state
        // state table
        case (crt_state)
            S1: begin
                case (in)
                    _1U: nxt_state = S2;
                    _2U: nxt_state = S23;
                    _3U: nxt_state = S34;
                    _2D: nxt_state = S21;
                    _3D: nxt_state = S32;
                    _4D: nxt_state = S43;

                    default: nxt_state = crt_state;
                endcase
            end

            S2: begin
                case (in)
                    _1U: nxt_state = S12;
                    _2U: nxt_state = S3;
                    _3U: nxt_state = S34;
                    _2D: nxt_state = S1;
                    _3D: nxt_state = S32;
                    _4D: nxt_state = S43;

                    default: nxt_state = crt_state;
                endcase
            end

            S3: begin
                case (in)
                    _1U: nxt_state = S12;
                    _2U: nxt_state = S23;
                    _3U: nxt_state = S4;
                    _2D: nxt_state = S21;
                    _3D: nxt_state = S2;
                    _4D: nxt_state = S43;

                    default: nxt_state = crt_state;
                endcase
            end

            S4: begin
                case (in)
                    _1U: nxt_state = S12;
                    _2U: nxt_state = S23;
                    _3U: nxt_state = S34;
                    _2D: nxt_state = S21;
                    _3D: nxt_state = S32;
                    _4D: nxt_state = S3;

                    default: nxt_state = crt_state;
                endcase
            end
                
            S12: nxt_state = S2;
            S21: nxt_state = S1;
            S23: nxt_state = S3;
            S32: nxt_state = S2;
            S34: nxt_state = S4;
            S43: nxt_state = S3;


            default: nxt_state = crt_state;
        endcase 

        // generate the output
        if (crt_state[3] == 1) begin
            // if at the busy state,
            // then output depends on crt_state[2].
            out = (crt_state[2] == 0)? UP : DOWN;
            
        end else begin
            // if at the idle state,
            // then output depends on the input and crt_state.
            case (crt_state)
                S1: begin
                    case (in)
                        _1U: out = UP;
                        _2U: out = UP;
                        _3U: out = UP;
                        _2D: out = UP;
                        _3D: out = UP;
                        _4D: out = UP;

                        default: out = out;
                    endcase
                end

                S2: begin
                    case (in)
                        _1U: out = DOWN;
                        _2U: out = UP;
                        _3U: out = UP;
                        _2D: out = DOWN;
                        _3D: out = UP;
                        _4D: out = UP;

                        default: out = out;
                    endcase
                end

                S3: begin
                    case (in)
                        _1U: out = DOWN;
                        _2U: out = DOWN;
                        _3U: out = UP;
                        _2D: out = DOWN;
                        _3D: out = DOWN;
                        _4D: out = UP;

                        default: out = out;
                    endcase
                end

                S4: begin
                    case (in)
                        _1U: out = DOWN;
                        _2U: out = DOWN;
                        _3U: out = DOWN;
                        _2D: out = DOWN;
                        _3D: out = DOWN;
                        _4D: out = DOWN;

                        default: out = out;
                    endcase
                end

                // if there are no inputs to be processed,  
                // then the system has to produce the output STAY and remain in the same state
                default: out = STAY;
            endcase 
        end
    
    end

    



endmodule