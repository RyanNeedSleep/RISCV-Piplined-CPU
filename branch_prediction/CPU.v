module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;



// My attempt
wire [31:0] currentPC;
wire [31:0] pc_oneStep;
wire [31:0] PCstep; 
assign PCstep = 32'h0000_0004;

wire [31:0] IFinst;
wire [31:0] IDinst;
wire [31:0] IDPC;
wire PCWrite; 
wire stall;
// wire flush;
wire [6:0] opcode;
wire [1:0] ID_ALUOp;
wire ID_ALUSrc;
wire branch;
wire ID_MemRead;
wire ID_MemWrite;
wire ID_RegWrite;
wire ID_MemtoReg;
wire [31:0] ID_imm_i; // before ImmGen
wire [31:0] ID_imm_o; // after ImmGen
wire [9:0] ID_func73;
wire [4:0] rd_addr;
wire [31:0] RS1;
wire [31:0] RS2; 
wire EX_RegWrite;
wire EX_MemtoReg;
wire EX_MemRead; 
wire EX_MemWrite;

wire [1:0] ALUOp; 
wire ALUSrc;
wire [31:0] EX_data1;
wire [31:0] EX_data2;
wire [31:0] EX_imm;

wire [9:0] EX_func73; 
wire [4:0] EX_rs1_addr;
wire [4:0] EX_rs2_addr;
wire [4:0] EX_rd_addr; 
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [31:0] mux1_o;
wire [31:0] mux2_o;
wire [31:0] MUX_o;
wire [2:0] ALUCtrl;
wire [31:0] ALUrslt;

wire MEM_RegWrite;
wire MEM_MemtoReg;
wire MEM_MemRead;
wire MEM_MemWrite;
wire [31:0] MEM_ALUrslt;
wire [4:0] MEM_rd_addr;
wire [31:0] MEM_WriteData;

wire WB_RegWrite;
wire WB_MemtoReg;

wire [4:0] WB_rd_addr;
wire [31:0] WB_ALUrslt;
wire [31:0] WB_ReadData;
wire [31:0] WB_o; 
wire [31:0] MEM_ReadData;
wire [4:0] rs1_addr;
wire [4:0] rs2_addr;
wire [31:0] pc_in;
wire [31:0] jumpimm;
wire [31:0] targetPC;
wire jump;
wire noop;
wire [31:0] pc_otherwise;
wire [31:0] pc_taken;
wire predict_taken;
wire rollback;
wire EXbranch;
wire prediction;
wire isZero;
wire EX_predict_taken;
wire [31:0] EX_pc_otherwise;

// assignments
assign rs1_addr = IDinst[19:15];
assign rs2_addr = IDinst[24:20];
assign rd_addr = IDinst[11:7]; 
assign opcode = IDinst[6:0];
assign ID_imm_i = IDinst[31:0];
assign ID_func73 = {IDinst[31:25], IDinst[14:12]};
// assign jumpimm = ID_imm_o << 1;
assign jumpimm = ID_imm_o;
// assign jump = (RS1 == RS2 && branch) ? 1 : 0; 
assign predict_taken = branch & prediction;



Adder Add_PC(
    .data1_in   (currentPC),
    .data2_in   (PCstep),
    .data_o     (pc_oneStep)
);



Adder JumpAdder(
    .data1_in   (IDPC),
    .data2_in   (jumpimm),
    .data_o     (targetPC)
);

MUX2to1 otherwise_mux(
    .data0_i(targetPC), 
    // .data1_i(pc_oneStep), // ----------------- 
    .data1_i(currentPC), 
    .select_i(predict_taken), // ----------------- 
    .data_o(pc_otherwise)
);

// MUX2to1 PCmux(
//     .data0_i(nextPC), 
//     .data1_i(branch_pc), 
//     .select_i(jump), 
//     .data_o(pc_in)
// );
MUX2to1 PCmuxRollBack(
    .data0_i(pc_taken), 
    .data1_i(EX_pc_otherwise), // ----------------- 
    .select_i(rollback), // ----------------- 
    .data_o(pc_in)
);

MUX2to1 PCmuxTaken(
    .data0_i(pc_oneStep), 
    .data1_i(targetPC),     // ----------------- 
    .select_i(predict_taken),    // ----------------- 
    .data_o(pc_taken)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (pc_in),
    .pc_o       (currentPC)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (currentPC), 
    .instr_o    (IFinst)
);


HDU HDU(
    .rst_i(rst_i),
    .isMemRead(EX_MemRead),
    .EX_Rd_addr(EX_rd_addr),
    .ID_Rs1_addr(rs1_addr),
    .ID_Rs2_addr(rs2_addr),

    .noop(noop),
    .stall(stall),
    .PCWrite(PCWrite)
);

wire IFID_flush;
assign IFID_flush = predict_taken || rollback; 

IF_ID IF_ID(
    .clk_i(clk_i),
    .stall_i(stall),
    .pc_i(currentPC),
    .instr_i(IFinst),
    .flush_i(IFID_flush),
    // .flush_predict_i(predict_taken),  // -----------------
    // .flush_roll_i(rollback), // -----------------

    .pc_o(IDPC),
    .instr_o(IDinst)
);


Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (rs1_addr),
    .RS2addr_i   (rs2_addr),
    .RDaddr_i   (WB_rd_addr), 
    .RDdata_i   (WB_o),
    .RegWrite_i (WB_RegWrite), 
    .RS1data_o   (RS1), 
    .RS2data_o   (RS2) 
);

Control Control(
    .opcode (opcode),
    .noop(noop),
    .rst_i(rst_i),
    .ALUOp_o(ID_ALUOp),
    .ALUSrc_o(ID_ALUSrc),
    .branch_o(branch),
    .MemRead_o(ID_MemRead),
    .MemWrite_o(ID_MemWrite),
    .RegWrite_o(ID_RegWrite),
    .MemtoReg_o(ID_MemtoReg)
);

ImmGen ImmGen(
    .data_i(ID_imm_i),
    .data_o(ID_imm_o)
);


ID_EX ID_EX(
    .clk_i (clk_i),
    .rst_i(rst_i),
    .flush_i(rollback), // ------------
    .RegWrite_i (ID_RegWrite), 
    .MemtoReg_i(ID_MemtoReg),
    .MemRead_i(ID_MemRead), 
    .MemWrite_i(ID_MemWrite), 
    .ALUOp_i(ID_ALUOp), 
    .ALUSrc_i(ID_ALUSrc),
    .data1_i(RS1),
    .data2_i(RS2), 
    .imm_i(ID_imm_o),
    .func73_i(ID_func73), 
    .EX_rs1_i(rs1_addr),
    .EX_rs2_i(rs2_addr),
    .EX_rd_i(rd_addr),
    .pc_otherwise_i(pc_otherwise), //----------
    .predict_taken_i(predict_taken), // ---------------
    .branch_i(branch),

    .RegWrite_o(EX_RegWrite), 
    .MemtoReg_o(EX_MemtoReg),
    .MemRead_o(EX_MemRead), 
    .MemWrite_o(EX_MemWrite), 
    .ALUOp_o(ALUOp), 
    .ALUSrc_o(ALUSrc),
    .data1_o(EX_data1),
    .data2_o(EX_data2), 
    .imm_o(EX_imm),
    .func73_o(EX_func73), 
    .EX_rs1_o(EX_rs1_addr),
    .EX_rs2_o(EX_rs2_addr),
    .EX_rd_o(EX_rd_addr),
    .pc_otherwise_o(EX_pc_otherwise),  // ---------
    .predict_taken_o(EX_predict_taken), // ----------
    .branch_o(EXbranch)
);

MUX4to1 mux1(
    .data00_i(EX_data1), 
    .data01_i(WB_o), 
    .data10_i(MEM_ALUrslt),
    .data11_i(), 
    .select_i(ForwardA), 
    .data_o(mux1_o)
);

MUX4to1 mux2(
    .data00_i(EX_data2), 
    .data01_i(WB_o), 
    .data10_i(MEM_ALUrslt),
    .data11_i(), 
    .select_i(ForwardB), 
    .data_o(mux2_o)
);

MUX2to1 MUX(
    .data0_i(mux2_o), 
    .data1_i(EX_imm), 
    .select_i(ALUSrc), 
    .data_o(MUX_o)
);


ALU_Control ALU_Control(
    .func73_i(EX_func73), 
    .ALUOp_i(ALUOp), 
    .ALUCtrl_o(ALUCtrl)
);

ALU ALU (
    .data1_i(mux1_o)  ,
    .data2_i(MUX_o)  ,
    .ALUCtrl_i(ALUCtrl),
    .data_o(ALUrslt)   ,
    .Zero_o(isZero)   
);


FU FU(
    .EX_MEM_RegWrite(MEM_RegWrite), 
    .MEM_WB_RegWrite(WB_RegWrite),
    .EX_MEME_Rd(MEM_rd_addr),
    .MEM_WB_Rd(WB_rd_addr), 
    .ID_EX_Rs1(EX_rs1_addr),
    .ID_EX_Rs2(EX_rs2_addr),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);




EX_MEM EX_MEM
(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(EX_RegWrite),
    .MemtoReg_i(EX_MemtoReg),
    .MemRead_i(EX_MemRead),
    .MemWrite_i(EX_MemWrite),
    .ALU_rslt_i(ALUrslt),
    .WriteData_i(mux2_o),
    .EX_MEM_Rd_i(EX_rd_addr),
    .RegWrite_o(MEM_RegWrite),
    .MemtoReg_o(MEM_MemtoReg),
    .MemRead_o(MEM_MemRead),
    .MemWrite_o(MEM_MemWrite),
    .ALU_rslt_o(MEM_ALUrslt),
    .WriteData_o(MEM_WriteData),
    .EX_MEM_Rd_o(MEM_rd_addr)
);


Data_Memory Data_Memory
(
    .clk_i(clk_i), 
    .addr_i(MEM_ALUrslt), 
    .MemRead_i(MEM_MemRead),
    .MemWrite_i(MEM_MemWrite),
    .data_i(MEM_WriteData),
    .data_o(MEM_ReadData)
);

MEM_WB MEM_WB(
    .clk_i(clk_i),
    .RegWrite_i(MEM_RegWrite),
    .MemtoReg_i(MEM_MemtoReg),
    .ALU_rslt_i(MEM_ALUrslt),
    .ReadData_i(MEM_ReadData),
    .MEM_WB_Rd_i(MEM_rd_addr),

    .RegWrite_o(WB_RegWrite),
    .MemtoReg_o(WB_MemtoReg),
    .ALU_rslt_o(WB_ALUrslt),
    .ReadData_o(WB_ReadData),
    .MEM_WB_Rd_o(WB_rd_addr)
);


MUX2to1 WB_MUX(
    .data0_i(WB_ALUrslt), 
    .data1_i(WB_ReadData), 
    .select_i(WB_MemtoReg), 
    .data_o(WB_o)
);

branch_predictor branch_predictor(
    .clk_i(clk_i), 
    .rst_i(rst_i),

    .update_i(EXbranch),
	.result_i(isZero),
	.predict_o(prediction)
);



BCU BCU(
    .rst_i(rst_i),

    .branch(EXbranch),
    .taken(EX_predict_taken),
    .isZero(isZero),

    .rollback(rollback)
);
endmodule