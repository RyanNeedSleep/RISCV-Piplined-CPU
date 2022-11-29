module ImmGen(
    data_i, 
    data_o
);
    input wire [31:0] data_i;
    output reg [31:0] data_o;

    wire [9:0] signal;
    assign signal = {data_i[14:12], data_i[6:0]};

    always @(data_i) begin
        case(signal)
            // addi, lw
            10'b000_0010011, 10'b010_0000011: begin
                data_o <= {{20{data_i[31]}}, data_i[31:20]};
            end
            
            // srai
            10'b101_0010011: begin
                data_o <= {{27{1'b0}}, data_i[24:20]};
            end

            // sw
            10'b010_0100011: begin
                data_o <= {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
            end 

            // beq
            10'b000_1100011: begin
                data_o <= {{19{data_i[31]}} ,data_i[31], data_i[7], data_i[30:25], data_i[11:8], 1'b0};
            end

            default:  data_o <= 0;
        endcase
    end     



   
endmodule