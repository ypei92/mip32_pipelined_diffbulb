`include "DesignName_parameters.v"

module Control(instruction_op        //instruction[31:26]
              
              ,reg_dst               //alu kind op is 1, lw is 0, i-type is 0
              ,jump                  //jump is 1              
              ,mem_read              //lw is 1
              ,mem_to_reg            //lw is 1              
              ,mem_write             //sw is 1
              ,alu_src               //sw or lw is 1, i-type is 1
              ,reg_write							      //alu and lw is 1
              ,alu_op                //see the promise
              ,branch                //branch is 1
              ,branch_bne
              );
              
parameter OP_TYPE_ALU = 6'b000000;
parameter OP_TYPE_JUMP = 6'b000010;
parameter OP_TYPE_BEQ = 6'b000100;
parameter OP_TYPE_BNE = 6'b000101;
parameter OP_TYPE_LW = 6'b100011;
parameter OP_TYPE_SW = 6'b101011;

parameter OP_TYPE_ADDI = 6'b001000;
parameter OP_TYPE_ANDI = 6'b001100;
parameter OP_TYPE_ORI = 6'b001101;
parameter OP_TYPE_SLTI = 6'b001010;
parameter OP_TYPE_XORI = 6'b001110;

parameter FUNC_TYPE_ADD = 6'b100000;
parameter FUNC_TYPE_SUB = 6'b100010;
parameter FUNC_TYPE_AND = 6'b100100;
parameter FUNC_TYPE_OR = 6'b100101;
parameter FUNC_TYPE_SLT = 6'b101010;
parameter FUNC_TYPE_XOR = 6'b100110;
parameter FUNC_TYPE_NOR = 6'b100111;

              
input [5:0] instruction_op;
//input [5:0] instruction_func;
output reg_dst;
output jump;
output branch;
output branch_bne;
output mem_read;
output mem_to_reg;
output alu_op;
output mem_write;
output alu_src;
output reg_write;

reg [3:0]alu_op;


//----------------Control-------------------------------------------------------------------------
assign reg_dst = (instruction_op == OP_TYPE_ALU);
assign jump = (instruction_op == OP_TYPE_JUMP);
assign branch = (instruction_op == OP_TYPE_BEQ); 
assign branch_bne = (instruction_op == OP_TYPE_BNE);
assign mem_read = (instruction_op == OP_TYPE_LW);
assign mem_to_reg = (instruction_op == OP_TYPE_LW);
assign mem_write = (instruction_op == OP_TYPE_SW);
assign alu_src = (instruction_op == OP_TYPE_LW)
               ||(instruction_op == OP_TYPE_SW)
               ||(instruction_op == OP_TYPE_ADDI)
               ||(instruction_op == OP_TYPE_ANDI)
               ||(instruction_op == OP_TYPE_ORI)
               ||(instruction_op == OP_TYPE_SLTI)
               ||(instruction_op == OP_TYPE_XORI);
assign reg_write = (instruction_op == OP_TYPE_ALU)
                 ||(instruction_op == OP_TYPE_LW)
                 ||(instruction_op == OP_TYPE_ADDI)
                 ||(instruction_op == OP_TYPE_ANDI)
                 ||(instruction_op == OP_TYPE_ORI)
                 ||(instruction_op == OP_TYPE_SLTI)
                 ||(instruction_op == OP_TYPE_XORI);
//------------------------------------------------------------------------------------------------


//----------------ALU Control---------------------------------------------------------------------
always @(instruction_op)  //alu-type operation
if (instruction_op == OP_TYPE_ALU)
  alu_op <= 4'b0010;
else if (instruction_op == OP_TYPE_BEQ)
  alu_op <= 4'b0001;
else if (instruction_op == OP_TYPE_LW)
  alu_op <= 4'b0000;
else if (instruction_op == OP_TYPE_SW)
  alu_op <= 4'b0000;
else if (instruction_op == OP_TYPE_ADDI)
  alu_op <= 4'b0100;
else if (instruction_op == OP_TYPE_ANDI)
  alu_op <= 4'b0101;
else if (instruction_op == OP_TYPE_ORI)
  alu_op <= 4'b0110;
else if (instruction_op == OP_TYPE_SLTI)
  alu_op <= 4'b0111;
else if (instruction_op == OP_TYPE_XORI)
  alu_op <= 4'b1000;
else
  alu_op <= 4'b1111;   //wrong

//------------------------------------------------------------------------------------------------


endmodule
