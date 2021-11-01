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
always@(posedge clk) begin
    if(rst==0)begin
        pc<=0;
        for (i=0; i<8; i=i+1) registru[i] <= 0;
        end
    else 
        pc<=pc+1;
end

always @(posedge clk)begin
    if(rst==1 && halt==1)begin
        casex(instruction[15:0])
            `NOP : begin
                    read    <= 1'b0;
                    write   <= 1'b0;
                    end
            `ADD : begin
                   read <= 0;
                   write <=0;
                   registru[instruction[8:6]] <= registru[instruction[5:3]]+registru[instruction[2:0]];
                   end
            `ADDF :begin
                    registru[instruction[8:6]]=registru[instruction[5:3]]+registru[instruction[2:0]];
                    read <= 0;
                    write <=0;
                    end
            `SUB :begin
                     registru[instruction[8:6]]=registru[instruction[5:3]]-registru[instruction[2:0]];
                     read <= 0;
                     write <=0;
                     end
            `SUBF :begin
                     registru[instruction[8:6]]=registru[instruction[5:3]]-registru[instruction[2:0]];
                     read <= 0;
                     write <=0;
                     end
            `AND :begin
                     registru[instruction[8:6]]=registru[instruction[5:3]] && registru[instruction[2:0]];
                     read <= 0;
                     write <=0;
                     end
            `OR : begin
                     registru[instruction[8:6]]=registru[instruction[5:3]] || registru[instruction[2:0]];
                     read <= 0;
                     write <=0;  
                     end        
           `XOR : begin
                    registru[instruction[8:6]]=registru[instruction[5:3]]^ registru[instruction[2:0]];
                    read <= 0;
                    write <=0;            
                    end
            `NAND : begin 
                    registru[instruction[8:6]]=!(registru[instruction[5:3]]&&registru[instruction[2:0]]);
                    read <= 0;
                    write <=0;
                    end
            `NOR : begin
                     registru[instruction[8:6]]=!(registru[instruction[5:3]] || registru[instruction[2:0]]);//nor
                     read <= 0;
                     write <=0;  
                     end         
            `NXOR : begin
                    registru[instruction[8:6]]=!(registru[instruction[5:3]] ^ registru[instruction[2:0]]);//nxor
                    read <= 0;
                    write <=0; 
                    end
            `SHIFTR : begin
                    registru[instruction[8:6]]=(registru[instruction[8:6]]>>registru[instruction[5:0]]);//shiftr
                    read <= 0;
                    write <=0; 
                    end
            `SHIFTRA : begin
            registru[instruction[8:6]]=(registru[instruction[8:6]]<<registru[instruction[5:0]]);//shiftl
            read <= 0;
            write <=0; 
            end
            `LOAD : begin
                    address     <= registru[instruction[2:0]][A_SIZE-1:0];
                    registru[instruction[10:8]] = data_in;
                    read <= 1;
                    write <=0; 
                    end 
            `LOADC :begin
                    registru[instruction[10:8]] <= {registru[instruction[10:8]][D_SIZE-1:8],instruction[7:0]};
                    read <= 0;
                    write <=0; 
                    end 
            `STORE : begin
                    address <= registru[instruction[10:8]][A_SIZE-1:0];
                    data_out = registru[instruction[2:0]];
                    read <= 0;
                    write <=1; 
                    end 
            `JMP : begin
                    pc=registru[instruction[2:0]];
                    read <= 0;
                    write <=0; 
                    end 
            `JMPR : begin
                    pc=pc+instruction[5:0];
                    read <= 0;
                    write <=1; 
                    end 
            `JMPCOND : begin
                       read    <= 1'b0;
                       write   <= 1'b0;
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
                                end

            `JMPRCOND : begin
                       read    <= 1'b0;
                       write   <= 1'b0;
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
                                end
            
            `HALT : begin
                    read <= 1'b0;
                    write <= 1'b0;
                    halt <= 1'b0;
                    end           
       endcase
    end
end
 memory #(.A_SIZE(A_SIZE),.D_SIZE(D_SIZE)) mem (
 .clk(clk),
 .rst(rst),
 .read(read),
 .write(write),
 .data_input(data_out),
 .data_output(data_in),
 .address(address)
 );       
        
endmodule
