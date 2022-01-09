`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2022 12:24:25 PM
// Design Name: 
// Module Name: execute
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

module execute #(parameter A_SIZE=10 , parameter D_SIZE=32)(
    input clk,
    input rst,
    input [15:0] instruction,
    input [D_SIZE - 1:0] reg_s1,
    input [D_SIZE - 1:0] reg_s2,
    output reg [15:0] instruction_buff,
    output reg [D_SIZE - 1:0] result_exec,
    output reg [D_SIZE - 1:0] result,
    output reg [2:0] result_reg_op,
    output reg [A_SIZE-1:0] address,
    output reg [D_SIZE-1:0] data_out,
    output reg [5:0] offset,
    output reg read,
    output reg write,
    output reg jump,
    output reg jump_relativ
    );
    
 always @(posedge clk) begin
     if (rst==0)begin
        instruction_buff <= 16'b0;
        result_exec <= 0;
        end
      else if (instruction == `HALT ) begin
          instruction_buff<= instruction_buff;
          result_exec <= 0;
          end
        else begin
          instruction_buff <= instruction;
          result_exec <= result;
          end
end

always @* begin
    read      = 1'b0;
    write     = 1'b0;
    data_out  = 0;
    result    = 0;
    address = 0;
    casex(instruction[15:0])
            `NOP : begin
                    result = 0;
                    end
            `ADD : begin
                   result = reg_s1 + reg_s2 ;
                   end
            `ADDF :begin
                    result = reg_s1 + reg_s2 ;
                    end
            `SUB :begin
                     result = reg_s1 - reg_s2 ;
                     end
            `SUBF :begin
                     result = reg_s1 - reg_s2 ;
                     end
            `AND :begin
                     result = reg_s1 & reg_s2 ;
                     end
            `OR : begin
                     result = reg_s1 | reg_s2 ;
                     end        
           `XOR : begin
                    result = reg_s1 ^ reg_s2 ;
                    end
            `NAND : begin 
                    result = ~( reg_s1 & reg_s2 );
                    end
            `NOR : begin
                     result = ~( reg_s1 | reg_s2 );
                     end         
            `NXOR : begin
                    result = ~( reg_s1 ^ reg_s2 );
                    end
            `SHIFTR : begin
                    result = reg_s1 >> instruction[5:0] ;
                    end
            `SHIFTRA : begin
                    result = reg_s1 >>> instruction[5:0] ;
                    end
            `SHIFTL : begin
                    result = reg_s1 << instruction[5:0] ;
                    end
            `LOAD : begin
                    address = reg_s1;
				    read    = 1'b1;
                    end 
            `LOADC :begin
                    result = {reg_s1[15:8],instruction[7:0]};
                    end 
            `STORE : begin
                     address  = reg_s1;
				     write    = 1'b1;
				     data_out = reg_s2;
                    end 
            `JMP : begin
                    address = reg_s2;
                    jump = 1'b1;
                    end 
            `JMPR : begin
                    offset = instruction[5:0];
				    jump_relativ = 1'b1;
                    end 
            `JMPCOND : begin
                       casex(instruction[11:9])
                
                            `N  :   if(reg_s1[D_SIZE - 1])  begin
				                        address = reg_s2;
				                        jump    = 1'b1;
				                    end                    
                             `NN :   if(reg_s1[D_SIZE - 1] == 1'b0)  begin
				                        address = reg_s2;
				                        jump = 1'b1;
				                       end
                             `Z  :   if(reg_s1 == 0)  begin
                                        address = reg_s2;
                                        jump = 1'b1;
                                    end 
                             `NZ :   if(reg_s1 != 0) begin
                                          address = reg_s2;
                                          jump = 1'b1;
                                      end   
                             `RSV:   ;
                                                
                                    endcase
                                end

            `JMPRCOND : begin
                       casex(instruction[11:9])
                
                            `N  :   if(reg_s1[D_SIZE - 1]) begin
                                      offset = instruction[5:0];
                                      jump_relativ = 1'b1;
                                      end             
                             `NN :   if(reg_s1[D_SIZE - 1] == 1'b0) begin
                                      offset = instruction[5:0];
                                      jump_relativ = 1'b1;
                                      end           
                             `Z  :   if(reg_s1 == 1'b0) begin
                                      offset = instruction[5:0];
                                      jump_relativ = 1'b1;
                                      end
                             `NZ :   if(reg_s1 != 1'b0) begin
                                      offset = instruction[5:0];
                                      jump_relativ = 1'b1;
                                      end
                             `RSV:   ;
                                                
                                    endcase
                                end         
       endcase
end

always@(*)begin
    casex(instruction[15:0])      
        `ADD : begin
                    result_reg_op = instruction[8:6];
                   end
        `ADDF : begin
                    result_reg_op = instruction[8:6];
                   end
        `SUB : begin
                    result_reg_op = instruction[8:6];
                   end
        `SUBF : begin
                    result_reg_op = instruction[8:6];
                   end
        `AND : begin
                    result_reg_op = instruction[8:6];
                   end
        `OR : begin
                    result_reg_op = instruction[8:6];
                   end
        `XOR : begin
                    result_reg_op = instruction[8:6];
                   end
        `NAND : begin
                    result_reg_op = instruction[8:6];
                   end
        `NOR :  begin
                    result_reg_op = instruction[8:6];
                   end     
        `NXOR : begin
                    result_reg_op = instruction[8:6];
                   end
        `LOAD : begin
                    result_reg_op = instruction[2:0];
                     end 
        `STORE : begin
                    result_reg_op = instruction[10:8];
                    end 
        `LOADC : begin
                    result_reg_op = instruction[10:8];
                     end 
         default: result_reg_op = 3'bz;
         endcase
end

endmodule
