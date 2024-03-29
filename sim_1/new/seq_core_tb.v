`timescale 1ns / 1ps


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 05:33:50 PM
// Design Name: 
// Module Name: seq_core_tb
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


module seq_core_tb();
    parameter A_SIZE_tb=10 ;
    parameter D_SIZE_tb=32;
    reg		rst_tb;   
    reg		clk_tb;
    wire [A_SIZE_tb-1:0] pc_tb;
    reg[15:0] instruction_tb;
    wire                    read_tb;
    wire                    write_tb;
    wire    [A_SIZE_tb-1:0]  address_tb;
    reg     [D_SIZE_tb-1:0]  data_in_tb;
    wire    [D_SIZE_tb-1:0]  data_out_tb;
    reg [15:0] instr [0:14];
    reg     [D_SIZE_tb-1:0]  memory    [0:127];
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
        instr[14]=16'b1000000000000100; //JMP R4
           
    end
   integer index;
  initial begin
        for(index = 0; index < 128; index = index + 1)
        begin
            memory[index] =   index;
        end
  end
    initial begin
        clk_tb   = 1;
        forever #1 clk_tb = ~clk_tb;
    end
    initial begin
        rst_tb       = 1'b0;
        #1;
        rst_tb       = 1'b1;
        #86;
        rst_tb       = 1'b0;
        #1;
        rst_tb       = 1'b1;
        $stop();
    end
 always@(*) begin
    instruction_tb <= instr[pc_tb];
 end
  always@(*)
    begin
        if(read_tb & !write_tb)
            data_in_tb <= memory[address_tb];
        else if(!read_tb & write_tb)
            memory[address_tb] <= data_out_tb;
    end
seq_core #( 
                .A_SIZE(A_SIZE_tb),
                .D_SIZE(D_SIZE_tb)
              ) dut
              (
                .rst(rst_tb),
                .clk(clk_tb),
                .pc(pc_tb),
                .instruction(instruction_tb),
                .read(read_tb),
                .write(write_tb),
                .address(address_tb),
                .data_in(data_in_tb),
                .data_out(data_out_tb)
              );
endmodule
