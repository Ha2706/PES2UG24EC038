module ex_stage (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,
    input  logic [31:0] address,
    input  logic        branch,
    input  logic        alu_src,
    input  logic        fn7_5,
    input  logic        mux_inp,
    input  logic [2:0]  fn3,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic [6:0]  opcode,
    output logic        and_out_ex,
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out
);

    logic [31:0] alu_operand_b;
    logic [4:0]  alu_control_sig;
    logic        zero_flag;
    logic [31:0] pc_signed_offset;

    assign alu_operand_b = alu_src ? imm_out : rs2_data;

    alu_control u_alu_ctrl (
        .alu_op(aluop),
        .fn3(fn3),
        .imm11_5(imm11_5),
        .fn7_5(fn7_5),
        .control_out(alu_control_sig)
    );

    alu u_alu (
        .alu_control(alu_control_sig),
        .rs1_data(rs1_data),
        .rs2_data(alu_operand_b),
        .alu_out(alu_out),
        .zero(zero_flag)
    );

    assign pc_signed_offset = address + imm_out;

    assign pc_ex_out = mux_inp ? {alu_out[31:1], 1'b0} : pc_signed_offset;

    assign and_out_ex = (branch && zero_flag) || (opcode == 7'h6F) || (opcode == 7'h67);

endmodule