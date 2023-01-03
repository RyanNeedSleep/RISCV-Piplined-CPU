module BCU(
    rst_i,

    branch,
    taken,
    isZero,

    rollback,
);

input rst_i;
input branch;
input taken;
input isZero;
output reg rollback; 


always @(posedge rst_i) begin
    rollback <= 0;
end

always @(*) begin
    // taken + isZero
    // 1 + 0 => ok 
    // 1 + non => rollback
    // 0 + 0 => rollback
    // 0 + non => ok
    if(branch && ((taken && ~isZero) || (~taken && isZero))) begin
        rollback <= 1;
    end
    else begin 
        rollback <= 0;
    end
end
endmodule

