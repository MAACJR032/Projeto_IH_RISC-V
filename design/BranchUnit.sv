`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic [6:0] Opcode,
    input logic [1:0] ALUOp,
    input logic [31:0] Reg1,
    input logic [31:0] AluResult,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic PcSel
);

  logic Branch_Sel;
  logic JmpR_Sel;
  logic [31:0] PC_Full;
  
  logic [6:0] J, JR;
  assign J = 7'b1101111;
  assign JR = 7'b1100111;

  assign PC_Full = {23'b0, Cur_PC};

  assign JmpR_Sel = (Opcode == JR && ALUOp == 2'b11);
  assign PC_Imm = (JmpR_Sel) ? Imm + Reg1 : PC_Full + Imm;
  assign PC_Four = PC_Full + 32'b100;
  
  assign Branch_Sel = (Branch && AluResult[0]) || (ALUOp == 2'b11 && Opcode == J) || JmpR_Sel;  // 0:Branch is taken; 1:Branch is not taken

  assign BrPC = (Branch_Sel) ? PC_Imm : 32'b0;  // Branch -> PC+Imm   // Otherwise, BrPC value is not important
  assign PcSel = Branch_Sel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule