`define CPU_BUS_SIZE 32

`define INSTRUCTION_SIZE 32
`define INSTRUCTION_OP 26
`define INSTRUCTION_RS 21
`define INSTRUCTION_RT 16
`define INSTRUCTION_RD 11
`define INSTRUCTION_SHAMT 6
`define INSTRUCTION_FUNC 0

`define ALU_OP_SIZE 4

`define NULL_OP 4'd0
`define ADD_OP 4'd1
`define SUB_OP 4'd2
`define AND_OP 4'd3
`define OR_OP 4'd4
`define SLT_OP 4'd5
`define XOR_OP 4'd6
`define NOR_OP 4'd7

`define ADDU_OP 4'd8
`define SUBU_OP 4'd9
`define SLTU_OP 4'd10
`define SLL_OP 4'd11
`define SRL_OP 4'd12
