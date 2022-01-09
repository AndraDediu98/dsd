`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2022 11:40:26 AM
// Design Name: 
// Module Name: read
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


module read #(parameter A_SIZE=10 , parameter D_SIZE=32)(
    input 		rst,   
    input		clk,
    input [15:0] instruction,
    input [D_SIZE - 1:0] val_reg_s1,
    input [D_SIZE - 1:0] val_reg_s2,
    input [D_SIZE - 1:0] val_reg_execute_stage,
    input [D_SIZE - 1:0] val_reg_write_stage,
    input [2:0] reg_op_execute_stage,
    input [2:0] reg_op_write_stage,
    input jump,
    input jump_relativ,
    output reg [15:0] instruction_buff,
    output reg [2:0] reg_op_s1,
    output reg [2:0] reg_op_s2,
    output reg [D_SIZE - 1:0] reg_s1,
    output reg [D_SIZE - 1:0] reg_s2
    );
 
 
    
 always @(posedge clk) begin
    if(rst==0)
        instruction_buff <= 0;
    else if (instruction == `HALT )
          instruction_buff <= instruction_buff;
    else if (jump || jump_relativ)
          instruction_buff <= `NOP;
    else
        instruction_buff <= instruction;
end 

always @(posedge clk) begin
      if (rst==0) begin
        reg_s1 <= 0;
        reg_s2 <= 0;
       end
      else if (instruction == `HALT )begin
            reg_s1 <= reg_s1;
            reg_s2 <= reg_s2;
           end
      else begin
            if (reg_op_s1 == reg_op_execute_stage )
                 reg_s1 <= val_reg_execute_stage;
             else if (reg_op_s1 == reg_op_write_stage )
                 reg_s1 <= val_reg_write_stage;
             else
                 reg_s1 <= val_reg_s1;
           
             if (reg_op_s2 == reg_op_execute_stage )
                 reg_s2 <= val_reg_execute_stage;
             else if (reg_op_s2 == reg_op_write_stage )
                 reg_s2 <= val_reg_write_stage;
             else
                 reg_s2 <= val_reg_s2;
      end
 end
 
 always@(*)begin
    casex(instruction[15:0])
        `NOP : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `ADD : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `ADDF : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `SUB : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `SUBF : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `AND : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `OR : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `XOR : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `NAND : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `NOR :  begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end     
        `NXOR : begin
                    reg_op_s1 = instruction[5:3];
		            reg_op_s2 = instruction[2:0];
                   end
        `SHIFTR : begin
                    reg_op_s1 = instruction[8:6];
		            reg_op_s2 = instruction[5:0];
                   end
        `SHIFTRA : begin
                    reg_op_s1 = instruction[8:6];
		            reg_op_s2 = instruction[5:0];
                   end
        `SHIFTL : begin
                    reg_op_s1 = instruction[8:6];
		            reg_op_s2 = instruction[5:0];
                  end
        `LOAD :begin
                    reg_op_s1 = instruction[10:8];
		            reg_op_s2 = instruction[2:0];        
                end
        `LOADC :begin
                    reg_op_s1 = instruction[10:8];
		            reg_op_s2 = instruction[7:0];        
                end 
        `STORE :begin
                    reg_op_s1 = instruction[10:8];
		            reg_op_s2 = instruction[2:0];        
                end
        `JMPR : begin
                    reg_op_s1 = instruction[2:0];
		            reg_op_s2 = 3'b0;
                end 
        `JMPCOND : begin
                    reg_op_s1 = instruction[8:6];
		            reg_op_s2 = instruction[2:0];
                   end
        default : begin
		            reg_op_s1 = 3'b0;
		            reg_op_s2 = 3'b0;
		          end
    endcase
end

endmodule
