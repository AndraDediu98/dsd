`ifndef macro
`define macro
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
`endif macro