module E_FSM (
    input clk, rst_n,
    input [2:0] din,
    output [1:0] dout
);

    wire done_LiftFSM_to_Buf;
    wire qEmpty_Buf_to_LiftFSM;
    wire [2:0] date_Buf_to_LiftFSM;

    /*
    instantiate Buf
    Buf (
        input clk, rst_n, done,
        input [2:0] din,
        output qEmpty,
        output [2:0] dout    
    );
    */
    Buf InputBuf (
        clk, rst_n, done_LiftFSM_to_Buf, 
        din, 
        qEmpty_Buf_to_LiftFSM, 
        date_Buf_to_LiftFSM
    );

    /*
    instantiate LiftFSM
    LiftFSM (
        input clk, rst_n, qEmpty,
        input [2:0] din,
        output done,
        output [1:0] dout
    );
    */
    LiftFSM FSM (
        clk, rst_n, qEmpty_Buf_to_LiftFSM,
        date_Buf_to_LiftFSM,
        done_LiftFSM_to_Buf,
        dout
    );      

endmodule