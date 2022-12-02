module HDU(
    isMemRead,
    EX_Rd_addr,
    ID_Rs1_addr,
    ID_Rs2_addr,

    noop,
    stall,
    PCWrite
);
    input isMemRead;
    input [4:0] EX_Rd_addr;
    input [4:0] ID_Rs1_addr;
    input [4:0] ID_Rs2_addr;

    output reg noop; 
    output reg stall;
    output reg PCWrite;


    always@(*) begin
        noop = 1'b0;
        stall = 1'b0;
        PCWrite = 1'b1;

        if(isMemRead &&(EX_Rd_addr == ID_Rs1_addr || EX_Rd_addr == ID_Rs2_addr) && (EX_Rd_addr != 0)) begin
            noop = 1'b1;
            stall = 1'b1;
            PCWrite = 1'b0;
        end
    end


    // always@(*) begin
    //     if(noop == 1 && stall == 1 && PCWrite == 0) begin
    //             noop <= 1'b0;
    //             stall <= 1'b0;
    //             PCWrite <= 1'b1;
    //             $display("here");
    //     end 
    //     else if(isMemRead) begin
    //         if(EX_Rd_addr == 0) begin 
    //             noop <= 1'b0;
    //             stall <= 1'b0;
    //             PCWrite <= 1'b1;
    //         end
    //         else if(EX_Rd_addr == ID_Rs1_addr || EX_Rd_addr == ID_Rs2_addr) begin
    //             noop <= 1'b1;
    //             stall <= 1'b1;
    //             PCWrite <= 1'b0;
    //         end
    //     end
    //     else begin
    //         noop <= 1'b0;
    //         stall <= 1'b0;
    //         PCWrite <= 1'b1;
    //     end
    // end

endmodule
