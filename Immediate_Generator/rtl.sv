
module imm_generator (
    input  logic [11:0] imm_input,
    input  logic [2:0]  fn3,
    input  logic [6:0]  opcode,
    input  logic [19:0] imm_input_uj,
    output logic [31:0] imm_output
);

    always_comb begin
        // Default: sign-extend the 12-bit immediate
        imm_output = {{20{imm_input[11]}}, imm_input};

        case (opcode)

            // Branch instructions
            7'b1100011: begin
                imm_output = {{19{imm_input[11]}},
                              imm_input, 1'b0};
            end

            // Jump and Link (JAL)
            7'b1101111: begin
                imm_output = {{11{imm_input_uj[19]}},
                              imm_input_uj, 1'b0};
            end

            // LUI and AUIPC
            7'b0110111,
            7'b0010111: begin
                imm_output = {imm_input_uj, 12'b0};
            end

            // Jump and Link Register (JALR)
            7'b1100111: begin
                imm_output = {{20{imm_input[11]}},
                              imm_input};
            end

            // Immediate ALU instructions
            7'b0010011: begin
                if (fn3 == 3'b001 || fn3 == 3'b101) begin
                    // Shift instructions: zero-extend shamt
                    imm_output = {27'b0, imm_input[4:0]};
                end
                else begin
                    // Other I-type ALU instructions
                    imm_output = {{20{imm_input[11]}},
                                  imm_input};
                end
            end

            // Loads, stores, R-type and other instructions
            default: begin
                imm_output = {{20{imm_input[11]}},
                              imm_input};
            end

        endcase
    end

endmodule
