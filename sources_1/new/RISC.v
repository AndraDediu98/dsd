`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2021 08:34:16 PM
// Design Name: 
// Module Name: RISC
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


module RISC#(parameter A_SIZE=10 , parameter D_SIZE=32)(
    input 		rst,   
    input		clk,
    output [A_SIZE-1:0] pc,
    input [15:0] instruction
    );
 wire [D_SIZE-1:0] w1,w2;
 wire [A_SIZE-1:0] w3;
 wire w4,w5;   
seq_core#(.A_SIZE(A_SIZE),.D_SIZE(D_SIZE)) sc (
.rst(rst),
.clk(clk),
.instruction(instruction),
.pc(pc),
.data_in(w1),
.data_out(w2),
.address(w3),
.read(w4),
.write(w5)
);
 memory #(.A_SIZE(A_SIZE),.D_SIZE(D_SIZE)) mem (
 .clk(clk),
 .rst(rst),
 .read(w4),
 .write(w5),
 .data_input(w2),
 .data_output(w1),
 .address(w3)
 ); 
endmodule
