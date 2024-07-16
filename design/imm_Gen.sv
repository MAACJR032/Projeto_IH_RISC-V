`timescale 1ns / 1ps

module imm_Gen (
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);


  always_comb
    case (inst_code[6:0])
      7'b0000011:  /*I-type load part*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0010011: begin /*I-type arithmetic part*/
          if (inst_code[14:12] == 3'b101)
              Imm_out = { 20'b0, inst_code[24:20]};
          else
              Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};
      end
      7'b0100011:  /*S-type*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:25], inst_code[11:7]};

      7'b1100011:  /*B-type*/
      Imm_out = {
        inst_code[31] ? 19'h7FFFF : 19'b0,
        inst_code[31],
        inst_code[7],
        inst_code[30:25],
        inst_code[11:8],
        1'b0
      };

      7'b1101111: /*J-TYPE*/
      Imm_out = {
          inst_code[31] ? 11'h7FF : 11'b0,  // Sign-extension of the immediate
          inst_code[31],                    // imm[20]
          inst_code[19:12],                 // imm[19:12]
          inst_code[20],                    // imm[11]
          inst_code[30:21],                 // imm[10:1]
          1'b0                              // imm[0] (LSB)
    };

      default: Imm_out = {32'b0};

    endcase

endmodule
