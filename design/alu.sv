`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,
        input logic [8:0]               PC_Cur,
        input logic                     Branch,
        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0001:        // OR
                    ALUResult = SrcA | SrcB;
            4'b0010:       // ADD/ADDI / LW/SW (carregar o endereço)
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b0011: begin // JAL
                    if (Branch)
                        ALUResult = PC_Cur + 4;
            end
            4'b0100:        // SLLI
                    ALUResult = SrcA << SrcB;
            4'b0101:        // SRLI
                    ALUResult = SrcA >> SrcB;
            4'b0110:        // XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0111:        // SRAI
                    ALUResult = $signed(SrcA) >>> SrcB;
            4'b1000:        // Equal
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b1001:        // Diferent
                    ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b1010:        // Less Than
                    ALUResult = (SrcA < SrcB) ? 1 : 0;
            4'b1011:        // Greater or Equal
                    ALUResult = (SrcA >= SrcB) ? 1 : 0;
            4'b1100:        // SLTI/SLT
                   ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 1 : 0;
            4'b1111:       // SUB
                   ALUResult = $signed(SrcA) - $signed(SrcB);
            default:
                    ALUResult = 0;
            endcase
        end
endmodule