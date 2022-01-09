`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2022 02:44:04 PM
// Design Name: 
// Module Name: pipeline
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

`define ADD                 16'b0000001xxxxxxxxx
`define ADDF                16'b0000010xxxxxxxxx
`define SUB                 16'b0000011xxxxxxxxx
`define SUBF                16'b0000100xxxxxxxxx
`define AND                 16'b0000101xxxxxxxxx
`define OR                  16'b0000110xxxxxxxxx
`define XOR                 16'b0000111xxxxxxxxx
`define NAND                16'b0001000xxxxxxxxx
`define NOR                 16'b0001001xxxxxxxxx
`define NXOR                16'b0001010xxxxxxxxx
`define SHIFTR              16'b0001011xxxxxxxxx
`define SHIFTRA             16'b0001100xxxxxxxxx
`define SHIFTL              16'b0001101xxxxxxxxx
`define LOAD                16'b00100xxxxxxxxxxx
`define LOADC               16'b00101xxxxxxxxxxx
`define STORE               16'b00110xxxxxxxxxxx
`define JMP                 16'b1000xxxxxxxxxxxx
`define JMPR                16'b1001xxxxxxxxxxxx
`define JMPCOND             16'b1010xxxxxxxxxxxx
`define JMPRCOND            16'b1110xxxxxxxxxxxx
`define NOP                 16'b0000000000000000
`define HALT                16'b1111111111111111


`define R0                  3'd0
`define R1                  3'd1
`define R2                  3'd2
`define R3                  3'd3
`define R4                  3'd4
`define R5                  3'd5
`define R6                  3'd6
`define R7                  3'd7

`define N                   3'b000
`define NN                  3'b001
`define Z                   3'b010
`define NZ                  3'b011
`define RSV                 3'b1xx

module pipeline_core #(parameter A_SIZE=10 , parameter D_SIZE=32)(
    input 		rst,  
    input		clk,
    output [A_SIZE-1:0] pc,
    input        [15:0] instruction,
    output 		read,  
    output 		write, 
    output [A_SIZE-1:0]	address,
    input  [D_SIZE-1:0]	data_in,
    output [D_SIZE-1:0]	data_out
);



wire [15:0] instr_fr;
wire [15:0] instr_re;
wire [15:0] instr_ew;
wire [D_SIZE-1:0] reg_s1;
wire [D_SIZE-1:0] reg_s2;
wire [D_SIZE-1:0] result;
wire [D_SIZE-1:0] result_exec;
wire write_reg;
wire [2:0] reg_w_op;
wire [2:0] reg_op1;
wire [2:0] reg_op2;
wire jump;
wire jump_relativ;
wire signed [5:0] offset;
wire [D_SIZE-1:0] reg_result;
wire [D_SIZE-1:0] val_reg_s1;
wire [D_SIZE-1:0] val_reg_s2;


 fetch f_s(.pc(pc), .instruction(instruction), .instruction_reg(instr_fr), .clk(clk), .rst(rst), .jump(jump), 
                .jump_relativ(jump_relativ) , .jump_address(address), .jump_offset(offset));
 
 read r_s(.clk(clk), .rst(rst), .instruction(instr_fr), .val_reg_s1(val_reg_s1), .val_reg_s2(val_reg_s2),
                .reg_op_s1(reg_op1), .reg_op_s2(reg_op2), .instruction_buff(instr_re), .reg_s1(reg_s1), .reg_s2(reg_s2),  .jump(jump), 
                .jump_relativ(jump_relativ) , .val_reg_execute_stage(result), .val_reg_write_stage(reg_result), .reg_op_execute_stage(reg_op_execute_stage), .reg_op_write_stage(reg_w_op) );
                
 execute e_s(.clk(clk), .rst(rst), .instruction(instr_re), .reg_s1(reg_s1), .reg_s2(reg_s2), 
                   .address(address), .data_out(data_out), .read(read), .write(write),
                   .result_exec(result_exec), .result(result), .result_reg_op(reg_op_execute_stage), .instruction_buff(instr_ew), .offset(offset), .jump(jump), 
                .jump_relativ(jump_relativ)  );
                   
 write_back w_s(.clk(clk), .rst(rst), .result(result_exec), .instruction(instr_ew), .data_in(data_in),
                 .write_reg(write_reg), .reg_op(reg_w_op), .reg_result(reg_result)) ;
                 
 regs regs(.clk(clk), .rst(rst), .write_reg(write_reg), .reg_w_op(reg_w_op), .reg_result(reg_result), .reg_op1(reg_op1), .reg_op2(reg_op2),
                .val_reg_s1(val_reg_s1), .val_reg_s2(val_reg_s2));              
 endmodule