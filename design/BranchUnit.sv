`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic[1:0] ALUOp,
    input logic [31:0] AluResult,
    input logic [31:0] Reg1,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic PcSel
);

  logic Branch_Sel;
  logic Jmp_Sel;
  logic Result_Sel;
  logic [31:0] PC_Full;

  assign PC_Full = {23'b0, Cur_PC};

  assign PC_Imm = (Jmp_Sel) ? Imm + Reg1 : PC_Full + Imm;
  assign PC_Four = PC_Full + 32'b100;
  assign Branch_Sel = Branch && AluResult[0];  // 0:Branch is taken; 1:Branch is not taken
  assign Jmp_Sel = ALUOp == 2'b11 && Branch;

  assign Result_Sel = Jmp_Sel || Branch_Sel;

  assign BrPC = (Result_Sel) ? PC_Imm : 32'b0;  // Branch -> PC+Imm   // Otherwise, BrPC value is not important
  assign PcSel = Result_Sel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
