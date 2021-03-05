module E_FSM (
    input clk, rst_n,
    input [2:0] din,
    output [1:0] dout
);

    wire LiftFSMdone_to_Bufdone;
    wire BufqEmpty_to_LiftFSMqEmpty;
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
        clk, rst_n, LiftFSMdone_to_Bufdone, 
        din, 
        BufqEmpty_to_LiftFSMqEmpty, 
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
        clk, rst_n, BufqEmpty_to_LiftFSMqEmpty,
        date_Buf_to_LiftFSM,
        LiftFSMdone_to_Bufdone,
        dout
    );      

endmodule