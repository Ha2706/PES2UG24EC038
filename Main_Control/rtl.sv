`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 15:22:10
// Design Name: 
// Module Name: main_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
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
        case (opcode)
            7'b0110011: begin memtoreg = 2'b00; branch = 1'b0; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b0; reg_write = 1'b1; aluop = 3'b000; end // R-type
            7'b0010011: begin memtoreg = 2'b00; branch = 1'b0; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b1; reg_write = 1'b1; aluop = 3'b001; end // I-type ALU
            7'b0000011: begin memtoreg = 2'b01; branch = 1'b0; mux_inp = 1'b0; memread = 1'b1; memwrite = 1'b0; alusrc = 1'b1; reg_write = 1'b1; aluop = 3'b010; end // Load
            7'b0100011: begin memtoreg = 2'b11; branch = 1'b0; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b1; alusrc = 1'b1; reg_write = 1'b0; aluop = 3'b011; end // Store
            7'b1100011: begin memtoreg = 2'b00; branch = 1'b1; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b0; reg_write = 1'b0; aluop = 3'b100; end // Branch
            7'b1101111: begin memtoreg = 2'b10; branch = 1'b0; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b1; reg_write = 1'b1; aluop = 3'b110; end // JAL
            7'b1100111: begin memtoreg = 2'b10; branch = 1'b0; mux_inp = 1'b1; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b1; reg_write = 1'b1; aluop = 3'b001; end // JALR
            7'b0110111: begin memtoreg = 2'b10; branch = 1'b0; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b1; reg_write = 1'b1; aluop = 3'b110; end // LUI
            7'b0010111: begin memtoreg = 2'b10; branch = 1'b0; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b1; reg_write = 1'b1; aluop = 3'b000; end // AUIPC
            default:    begin memtoreg = 2'b00; branch = 1'b0; mux_inp = 1'b0; memread = 1'b0; memwrite = 1'b0; alusrc = 1'b0; reg_write = 1'b0; aluop = 3'b000; end // other
        endcase
    end
endmodule