`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2021 03:24:02 PM
// Design Name: 
// Module Name: seq_core
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

module seq_core #(parameter A_SIZE=10 , parameter D_SIZE=32)(
    // general
    input 		rst,   // active 0
    input		clk,
    // program memory
    output reg [A_SIZE-1:0] pc,
    input [15:0] instruction,
    // data memory
    output 	reg	read,  // active 1
    output 	reg	write, // active 1
    output reg [A_SIZE-1:0]	address,
    input [D_SIZE-1:0]	data_in,
    output reg [D_SIZE-1:0]	data_out
);
reg [D_SIZE-1:0] registru [0:7];
reg halt=1;

integer i;

always @(posedge clk)begin
    if(rst==0)begin
        pc<=0;
        for (i=0; i<8; i=i+1) registru[i] <= 0;
        end
    if(rst==1 && halt==1)begin
        casex(instruction[15:0])
            `NOP : begin
                    pc<=pc+1;
                    end
            `ADD : begin
                   registru[instruction[8:6]] <= registru[instruction[5:3]]+registru[instruction[2:0]];
                   pc<=pc+1;
                   end
            `ADDF :begin
                    registru[instruction[8:6]]=registru[instruction[5:3]]+registru[instruction[2:0]];
                    pc<=pc+1;
                    end
            `SUB :begin
                     registru[instruction[8:6]]=registru[instruction[5:3]]-registru[instruction[2:0]];
                     pc<=pc+1;
                     end
            `SUBF :begin
                     registru[instruction[8:6]]=registru[instruction[5:3]]-registru[instruction[2:0]];
                     pc<=pc+1;
                     end
            `AND :begin
                     registru[instruction[8:6]]=registru[instruction[5:3]] && registru[instruction[2:0]];
                     pc<=pc+1;
                     end
            `OR : begin
                     registru[instruction[8:6]]=registru[instruction[5:3]] || registru[instruction[2:0]];
                     pc<=pc+1;
                     end        
           `XOR : begin
                    registru[instruction[8:6]]=registru[instruction[5:3]]^ registru[instruction[2:0]];            
                    pc<=pc+1;
                    end
            `NAND : begin 
                    registru[instruction[8:6]]=!(registru[instruction[5:3]]&&registru[instruction[2:0]]);
                    read <= 0;
                    write <=0;
                    pc<=pc+1;
                    end
            `NOR : begin
                     registru[instruction[8:6]]=!(registru[instruction[5:3]] || registru[instruction[2:0]]);//nor
                     pc<=pc+1;
                     end         
            `NXOR : begin
                    registru[instruction[8:6]]=!(registru[instruction[5:3]] ^ registru[instruction[2:0]]);//nxo
                    pc<=pc+1;
                    end
            `SHIFTR : begin
                    registru[instruction[8:6]]=(registru[instruction[8:6]]>>registru[instruction[5:0]]);//shiftr
                    pc<=pc+1;
                    end
            `SHIFTRA : begin
                    registru[instruction[8:6]]=(registru[instruction[8:6]]>>>registru[instruction[5:0]]);//shiftl
                    pc<=pc+1;
                    end
            `SHIFTL : begin
                    registru[instruction[8:6]]=(registru[instruction[8:6]]<<registru[instruction[5:0]]);//shiftr
                    pc<=pc+1;
                    end
            `LOAD : begin
                    registru[instruction[10:8]] <= data_in; 
                    pc<=pc+1;
                    end 
            `LOADC :begin
                    registru[instruction[10:8]] <= {registru[instruction[10:8]][D_SIZE-1:8],instruction[7:0]};
                    pc<=pc+1;
                    end 
            `STORE : begin
                    //address <= registru[instruction[10:8]][A_SIZE-1:0];
                    //data_out <= registru[instruction[2:0]];
                    //read <= 0;
                    //write <=1; 
                    pc<=pc+1;
                    end 
            `JMP : begin
                    pc=registru[instruction[2:0]];
                    pc<=pc+1;
                    end 
            `JMPR : begin
                    pc=pc+instruction[5:0]; 
                    pc<=pc+1;
                    end 
            `JMPCOND : begin
                       casex(instruction[11:9])
                
                            `N  :   if(registru[instruction[8:6]] < 0)
                                         pc <= registru[instruction[2:0]][A_SIZE-1:0];
                                                    
                             `NN :   if(registru[instruction[8:6]] >= 0)
                                          pc <= registru[instruction[2:0]][A_SIZE-1:0];
                                                    
                             `Z  :   if(registru[instruction[8:6]] == 0)
                                          pc <= registru[instruction[2:0]][A_SIZE-1:0];
                                                    
                             `NZ :   if(registru[instruction[8:6]] != 0)
                                           pc <= registru[instruction[2:0]][A_SIZE-1:0];
                                        
                             `RSV:   ;
                                                
                                    endcase
                                pc<=pc+1;
                                end

            `JMPRCOND : begin
                       casex(instruction[11:9])
                
                            `N  :   if(registru[instruction[8:6]] < 0)
                                         pc <= pc + instruction[5:0];
                                                    
                             `NN :   if(registru[instruction[8:6]] >= 0)
                                          pc <= pc + instruction[5:0];
                                                    
                             `Z  :   if(registru[instruction[8:6]] == 0)
                                          pc <= pc + instruction[5:0];
                                                    
                             `NZ :   if(registru[instruction[8:6]] != 0)
                                           pc <= pc + instruction[5:0];
                                        
                             `RSV:   ;
                                                
                                    endcase
                                pc<=pc+1;
                                end
            
            `HALT : begin
                    halt <= 1'b0;
                    pc<=pc+1;
                    end           
       endcase
    end
end
always@(*)begin
    casex(instruction[15:0])      
        `LOAD : begin
                    address<= registru[instruction[2:0]][A_SIZE-1:0];
                    read <= 1;
                    write <=0; 
                     end 
        `STORE : begin
                    address <= registru[instruction[10:8]][A_SIZE-1:0];
                    data_out <= registru[instruction[2:0]];
                    read <= 0;
                    write <=1; 
                    end 
         default: begin
                    write <=0;
                    read<=0;
                    end
         endcase
end
endmodule
