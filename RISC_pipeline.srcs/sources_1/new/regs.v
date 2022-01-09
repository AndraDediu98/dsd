`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2022 01:09:06 PM
// Design Name: 
// Module Name: regs
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

module regs #(parameter A_SIZE=10 , parameter D_SIZE=32)(
    input clk,
    input rst,
    input write_reg,
    input [2:0] reg_w_op,
    input [D_SIZE -1:0] reg_result,
    input [2:0] reg_op1,
    input [2:0] reg_op2,
    output  [D_SIZE -1:0] val_reg_s1,
    output  [D_SIZE -1:0] val_reg_s2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
 );
 
 reg [D_SIZE -1:0] register [0:7];
 
integer i;
 
 always @(posedge clk)begin
    if(rst==0)begin
        for (i=0; i<8; i=i+1) register[i] <= 0;
    end
end
 always @(*)begin
    if( write_reg==1)begin
     register[reg_w_op] <= reg_result;
     end
   end
   
   assign val_reg_s1 = register[reg_op1];
   assign val_reg_s2 = register[reg_op2];
 
 
endmodule
