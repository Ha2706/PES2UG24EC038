
module main_control (
    input  logic [6:0] opcode,
    input  logic [2:0] fn3,

    output logic [1:0] memtoreg,
    output logic       branch,
    output logic       mux_inp,
    output logic       memread,
    output logic       memwrite,
    output logic       alusrc,
    output logic       reg_write,
    output logic [2:0] aluop
);

    always_comb begin

        // Default control signals for unsupported instructions
        memtoreg  = 2'b00;
        branch    = 1'b0;
        mux_inp   = 1'b0;
        memread   = 1'b0;
        memwrite  = 1'b0;
        alusrc    = 1'b0;
        reg_write = 1'b0;
        aluop     = 3'b000;

        case (opcode)

            // R-type instructions
            7'b0110011: begin
                memtoreg  = 2'b00;
                reg_write = 1'b1;
                aluop     = 3'b000;
            end

            // I-type ALU instructions
            7'b0010011: begin
                alusrc    = 1'b1;
                reg_write = 1'b1;
                aluop     = 3'b001;
            end

            // Load instructions
            7'b0000011: begin
                memtoreg  = 2'b01;
                memread   = 1'b1;
                alusrc    = 1'b1;
                reg_write = 1'b1;
                aluop     = 3'b010;
            end

            // Store instructions
            7'b0100011: begin
                memtoreg  = 2'b11;
                memwrite  = 1'b1;
                alusrc    = 1'b1;
                aluop     = 3'b011;
            end

            // Conditional branch instructions
            7'b1100011: begin
                branch = 1'b1;
                aluop  = 3'b100;
            end

            // JAL instruction
            7'b1101111: begin
                memtoreg  = 2'b10;
                reg_write = 1'b1;
                aluop     = 3'b110;
            end

            // JALR instruction
            7'b1100111: begin
                memtoreg  = 2'b10;
                mux_inp   = 1'b1;
                reg_write = 1'b1;
                aluop     = 3'b001;
            end

            // LUI instruction
            7'b0110111: begin
                memtoreg  = 2'b10;
                reg_write = 1'b1;
                aluop     = 3'b110;
            end

            // AUIPC instruction
            7'b0010111: begin
                memtoreg  = 2'b10;
                reg_write = 1'b1;
                aluop     = 3'b000;
            end

            // Other or unsupported instructions
            default: begin
                memtoreg  = 2'b00;
                branch    = 1'b0;
                mux_inp   = 1'b0;
                memread   = 1'b0;
                memwrite  = 1'b0;
                alusrc    = 1'b0;
                reg_write = 1'b0;
                aluop     = 3'b000;
            end

        endcase
    end

endmodule
