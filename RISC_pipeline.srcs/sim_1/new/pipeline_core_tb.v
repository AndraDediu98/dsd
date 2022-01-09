`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2022 02:57:13 PM
// Design Name: 
// Module Name: pipeline_core_tb
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

module pipeline_core_tb #(parameter A_SIZE=10 , parameter D_SIZE=32)(

    );
    wire [15:0] instruction;
    reg [15:0] instr [0 : 2**A_SIZE - 1];
    reg [D_SIZE-1:0] data_in;
    reg clk;
	reg rst;
	wire [A_SIZE-1:0] address;
	wire [D_SIZE-1:0] data_out;
	wire read;
	wire write;
	wire [A_SIZE-1:0] pc;
    reg     [D_SIZE-1:0]  memory  [0:127];
    pipeline_core dut(.clk(clk), .rst(rst), .instruction(instruction), .data_in(data_in),
                      .pc(pc), .address(address), .data_out(data_out), .read(read), .write(write));
                      
    initial begin
		
		clk = 0;

		forever #10 clk=~clk;
	end
	initial begin
	    instr[0]=16'b0010100000000111; //LOADC R0 7
        instr[1]=16'b0010100100000110; //LOADC R1 6
        instr[2]=16'b0010101000000111; //LOADC R2 7
        instr[3]=16'b0010101100000111; //LOADC R3 7
        instr[4]=16'b0010110000000001; //LOADC R4 1
        instr[5]=16'b0010110100000111; //LOADC R5 7
        instr[6]=16'b0010111000000111; //LOADC R6 7
        instr[7]=16'b0010111100000111; //LOADC R7 7
        instr[8]=16'b0000001000001011; //ADD R0 R1 R3
        instr[9]=16'b0000001010000111; //ADD R2 R0 R7
        instr[10]=16'b0000011000000001; //SUB R0 R0 R1
        instr[11]=16'b0011000000000010; //STORE M[R0] R2
        instr[12]=16'b0011010000000011; //STORE M[R4] R3
        instr[13]=16'b0010000000000000; //LOAD R0 M[R0]
           
    end
    integer index;
  initial begin
        for(index = 0; index < 128; index = index + 1)
        begin
            memory[index] =   index;
        end
  end
 initial begin
 	rst = 0;
    #15 rst=1;
    
  
   
    #1000 $finish();
end
  always@(*)
    begin
        if(read & !write)
            data_in <= memory[address];
        else if(!read & write)
            memory[address] <= data_out;
    end

assign  instruction = instr[pc]; 
endmodule
