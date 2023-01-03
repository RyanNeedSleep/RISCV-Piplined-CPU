module MUX2to1(
    data0_i, 
    data1_i, 
    select_i, 
    data_o
);
input select_i;
input [31:0] data0_i, data1_i;
output reg [31:0] data_o;

always @(select_i or data0_i or data1_i) 
    begin
        if(~select_i)
            data_o <= data0_i;
        else
            data_o <= data1_i;

    end 
endmodule