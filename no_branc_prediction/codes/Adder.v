module Adder(data1_in, data2_in, data_o);
input [31:0] data1_in, data2_in;
output reg [31:0] data_o;

always @(data1_in or data2_in) begin 
    data_o = data1_in + data2_in;
end
endmodule
