`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2021 07:23:43 PM
// Design Name: 
// Module Name: memory
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


module memory#(parameter A_SIZE=10 , parameter D_SIZE=32)(
input clk,
input rst,
input [D_SIZE-1:0] data_input,
input [A_SIZE-1:0] address,
input read,
input write,
output reg [D_SIZE-1:0] data_output
    );
reg [D_SIZE-1:0] memory [0:2**A_SIZE-1];
always@(posedge clk)begin
        if(read & !write)
            data_output <= memory[address];
        else if(!read & write)
            memory[address] <= data_input;
end
endmodule
