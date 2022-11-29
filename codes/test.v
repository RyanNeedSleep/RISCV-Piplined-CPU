module MyTest;
    
    wire [4:0] s1; 
    wire [4:0] s2;
    reg [1:0] y;

    assign s1 = 5'b10100;

    initial begin
        case(s1)
            5'b1???0: 
                y = 2'b11;
            default:
                y = 2'b00;
        endcase
        $display("%b", y);
    end

     
endmodule