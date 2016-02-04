`include "DesignName_parameters.v"

module ALU(//input-------------------------------------------
           clk, rst_n,
  
           id_ex_reg_dst,         	   			//alu?????1?lw?0
           id_ex_alu_op,                 //????
           id_ex_alu_src,               	//sw?lw?1
           //id_ex_jump,           			  	//jump?????1
           id_ex_mem_read,           			 //lw?1
           id_ex_mem_write,          			 //sw?1
           id_ex_mem_to_reg,         			 //lw?1
           id_ex_reg_write,				        		//alu??????lw
           id_ex_branch,
           id_ex_branch_bne,
           
           id_ex_reg_read_data1,
           id_ex_reg_read_data2,
           
           id_ex_rs,
           id_ex_rt,
           id_ex_rd,
           id_ex_sign_extended,

           wb_write_data,
           ex_mem_alu_result,
           ex_mem_rd,
           mem_wb_rd,
           ex_mem_reg_write_in,     						  //alu??????lw
           mem_wb_reg_write,		        //alu??????lw
           
           id_ex_branch_pridictor_bit,
           pridictor_wrong,
           //output-------------------------------------------
           ex_mem_alu_result_out,
           ex_mem_reg_read_data2,
           ex_mem_rd_out,
           
           ex_mem_mem_read,           			//lw?1
           ex_mem_mem_write,          			//sw?1
           ex_mem_mem_to_reg,         			//lw?1
           ex_mem_reg_write,					       	//alu??????lw
           ex_mem_branch,
           ex_mem_branch_bne,
           
           id_ex_rt_out,
           id_ex_mem_read_out,
           
           ex_mem_branch_pridictor_bit
           
           //pridictor_wrong
           
           //id_ex_alu_result_wire,
           //id_ex_rd_wire_before_mux,
           //id_ex_reg_write_out
           );
           
input clk, rst_n;

input id_ex_reg_dst;
input [3:0] id_ex_alu_op;
input id_ex_alu_src;
//input id_ex_jump;
input id_ex_mem_read;
input id_ex_mem_write;
input id_ex_mem_to_reg;
input id_ex_reg_write;
input id_ex_branch;
input id_ex_branch_bne;

input [`CPU_BUS_SIZE-1:0] id_ex_reg_read_data1;
input [`CPU_BUS_SIZE-1:0] id_ex_reg_read_data2;

input [4:0] id_ex_rs;
input [4:0] id_ex_rt;
input [4:0] id_ex_rd;
input [`CPU_BUS_SIZE-1:0] id_ex_sign_extended;

input [`CPU_BUS_SIZE-1:0] wb_write_data;
input [`CPU_BUS_SIZE-1:0] ex_mem_alu_result;
input [4:0] ex_mem_rd;
input [4:0] mem_wb_rd;
input ex_mem_reg_write_in;
input mem_wb_reg_write;

input id_ex_branch_pridictor_bit;
input pridictor_wrong;

output [`CPU_BUS_SIZE-1:0] ex_mem_alu_result_out;
output [`CPU_BUS_SIZE-1:0] ex_mem_reg_read_data2;
output [4:0] ex_mem_rd_out;

output ex_mem_mem_read;
output ex_mem_mem_write;
output ex_mem_mem_to_reg;
output ex_mem_reg_write;
output ex_mem_branch;
output ex_mem_branch_bne;

output [4:0] id_ex_rt_out;
output id_ex_mem_read_out;

output ex_mem_branch_pridictor_bit;


//output id_ex_alu_result_wire;
//output [4:0]id_ex_rd_wire_before_mux;
//output id_ex_reg_write_out;

//definition---------------------------------------------------------------
wire clk, rst_n;

wire id_ex_reg_dst;
wire [3:0] id_ex_alu_op;
wire id_ex_alu_src;
wire id_ex_mem_read;
wire id_ex_mem_write;
wire id_ex_mem_to_reg;
wire id_ex_reg_write;
wire id_ex_branch;
wire id_ex_branch_bne;

wire [`CPU_BUS_SIZE-1:0] id_ex_reg_read_data1;
wire [`CPU_BUS_SIZE-1:0] id_ex_reg_read_data2;

wire [4:0] id_ex_rs;
wire [4:0] id_ex_rt;
wire [4:0] id_ex_rd;
wire [`CPU_BUS_SIZE-1:0] id_ex_sign_extended;

wire [`CPU_BUS_SIZE-1:0] wb_write_data;
wire [`CPU_BUS_SIZE-1:0] ex_mem_alu_result;
wire [4:0] ex_mem_rd;
wire [4:0] mem_wb_rd;
wire ex_mem_reg_write_in;
wire mem_wb_reg_write;

reg [`CPU_BUS_SIZE-1:0] ex_mem_alu_result_out;
reg [`CPU_BUS_SIZE-1:0] ex_mem_reg_read_data2;
reg [4:0] ex_mem_rd_out;

reg ex_mem_mem_read;
reg ex_mem_mem_write;
reg ex_mem_mem_to_reg;
reg ex_mem_reg_write;

wire [4:0] id_ex_rt_out;
wire id_ex_mem_read_out;

wire [1:0]id_ex_branch_pridictor_bit;
reg [1:0]ex_mem_branch_pridictor_bit;
reg ex_mem_branch;
reg ex_mem_branch_bne;
wire pridictor_wrong;
//wire [`CPU_BUS_SIZE-1:0]id_ex_alu_result_wire;
//wire [4:0]id_ex_rd_wire_before_mux;
//wire id_ex_reg_write_out;

//extra definition------------------------------------------------------------
parameter OP_TYPE_ALU = 6'b000000;
parameter OP_TYPE_JUMP = 6'b000010;
parameter OP_TYPE_BEQ = 6'b000100;
parameter OP_TYPE_BNE = 6'b000101;
parameter OP_TYPE_LW = 6'b100011;
parameter OP_TYPE_SW = 6'b101011;

parameter FUNC_TYPE_ADD = 6'b100000;
parameter FUNC_TYPE_SUB = 6'b100010;
parameter FUNC_TYPE_AND = 6'b100100;
parameter FUNC_TYPE_OR = 6'b100101;
parameter FUNC_TYPE_SLT = 6'b101010;
parameter FUNC_TYPE_XOR = 6'b100110;
parameter FUNC_TYPE_NOR = 6'b100111;

parameter FUNC_TYPE_ADDU = 6'b100001;
parameter FUNC_TYPE_SUBU = 6'b100011;
parameter FUNC_TYPE_SLTU = 6'b101011;

parameter FUNC_TYPE_SLL = 6'b000000;
parameter FUNC_TYPE_SRL = 6'b000010;

reg [1:0] forward_a;
reg [1:0] forward_b;
reg [`CPU_BUS_SIZE-1:0] alu_operand1_before_mux;
reg [`CPU_BUS_SIZE-1:0] alu_operand2_before_mux;
wire [`CPU_BUS_SIZE-1:0] alu_operand_2_without_shift;
wire signed [`CPU_BUS_SIZE-1:0] alu_operand_1;
wire signed [`CPU_BUS_SIZE-1:0] alu_operand_2;
reg [`ALU_OP_SIZE-1:0] alu_op;
reg [`CPU_BUS_SIZE-1:0] alu_result;


//-------------------assign directly without waiting for clk---------------------------
assign id_ex_rt_out = (pridictor_wrong)?5'b0 : id_ex_rt;
assign id_ex_mem_read_out = (pridictor_wrong)? 0 : id_ex_mem_read;
//assign id_ex_alu_result_wire = alu_result;
//assign id_ex_rd_wire_before_mux = id_ex_rd;
//assign id_ex_reg_write_out = id_ex_reg_write;


//--------------------without operation but wait posedge clk---------------------------
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_mem_read <= 0;
else if(!pridictor_wrong)
  ex_mem_mem_read <= id_ex_mem_read;
else ex_mem_mem_read <= 0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_mem_write <= 0;
else if(!pridictor_wrong)
  ex_mem_mem_write <= id_ex_mem_write;
else ex_mem_mem_write <= 0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_mem_to_reg <= 0;
else if(!pridictor_wrong)
  ex_mem_mem_to_reg <= id_ex_mem_to_reg;
else ex_mem_mem_to_reg <= 0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_reg_write <= 0;
else if(!pridictor_wrong)
  ex_mem_reg_write <= id_ex_reg_write;
else ex_mem_reg_write <= 0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_branch <= 0;
else if(!pridictor_wrong)
  ex_mem_branch <= id_ex_branch;
else ex_mem_branch <= 0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_branch_bne <= 0;
else if(!pridictor_wrong)
  ex_mem_branch_bne <= id_ex_branch_bne;
else ex_mem_branch <= 0;
  
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_branch_pridictor_bit <= 0;
else
  ex_mem_branch_pridictor_bit <= id_ex_branch_pridictor_bit;
//------------------------------ex_mem_rd[4:0]-----------------------------------------
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_rd_out[4:0] <= 5'b0;
else if (pridictor_wrong)
  ex_mem_rd_out[4:0] <= 5'b0;
else if (id_ex_reg_dst == 1)
  ex_mem_rd_out <= id_ex_rd;
else
  ex_mem_rd_out <= id_ex_rt;
  
  
//---------------forwarding unit A-----------------------------------------------------
always @(ex_mem_reg_write_in or mem_wb_reg_write
         or id_ex_rs or ex_mem_rd or mem_wb_rd)
if ( (ex_mem_reg_write_in	== 1 && ex_mem_rd != 5'b0)
     && (ex_mem_rd == id_ex_rs) )
  forward_a <= 2'b10;
else if ( (mem_wb_reg_write	== 1 && mem_wb_rd != 5'b0)
     && ~( (ex_mem_reg_write_in	== 1 && ex_mem_rd != 5'b0)
         && (ex_mem_rd == id_ex_rs) )
    && (mem_wb_rd == id_ex_rs) )
  forward_a <= 2'b01;
else
  forward_a <= 2'b00;
  
//---------------forwarding unit B-----------------------------------------------------
always @(ex_mem_reg_write_in or mem_wb_reg_write
         or id_ex_rt or ex_mem_rd or mem_wb_rd)
if ( (ex_mem_reg_write_in	== 1 && ex_mem_rd != 5'b0)
     && (ex_mem_rd == id_ex_rt) )
  forward_b <= 2'b10;
else if ( (mem_wb_reg_write	== 1 && mem_wb_rd != 5'b0)
     && ~( (ex_mem_reg_write_in	== 1 && ex_mem_rd != 5'b0)
         && (ex_mem_rd == id_ex_rt) )
    && (mem_wb_rd == id_ex_rt) )
  forward_b <= 2'b01;
else
  forward_b <= 2'b00;
  

//---------------------alu_operand1_before_mux_----------------------------------------
always @(id_ex_reg_read_data1 or ex_mem_alu_result or wb_write_data or forward_a)
case (forward_a)
  2'b00: alu_operand1_before_mux <= id_ex_reg_read_data1;
  2'b10: alu_operand1_before_mux <= ex_mem_alu_result;
  2'b01: alu_operand1_before_mux <= wb_write_data;
  default: alu_operand1_before_mux <= `CPU_BUS_SIZE'b0;   //not necessary
endcase


//---------------------alu_operand2_before_mux-----------------------------------------
always @(id_ex_reg_read_data2 or ex_mem_alu_result or wb_write_data or forward_b)
case (forward_b)
  2'b00: alu_operand2_before_mux <= id_ex_reg_read_data2;
  2'b10: alu_operand2_before_mux <= ex_mem_alu_result;
  2'b01: alu_operand2_before_mux <= wb_write_data;
  default: alu_operand2_before_mux <= `CPU_BUS_SIZE'b0;   //not necessary
endcase
  

//---------------------alu_operand_1---------------------------------------------------
assign alu_operand_1 = (alu_op == `SLL_OP || alu_op == `SRL_OP)?
                       alu_operand2_before_mux : alu_operand1_before_mux;


//---------------------alu_operand_2_without_shift-------------------------------------
assign alu_operand_2_without_shift = (id_ex_alu_src == 1)?
                       id_ex_sign_extended : alu_operand2_before_mux;


//---------------------alu_operand_2---------------------------------------------------
assign alu_operand_2 = (alu_op == `SLL_OP || alu_op == `SRL_OP)?
                       {27'b0,id_ex_sign_extended[10:6]} : alu_operand_2_without_shift;


//---------------------ALU Control-----------------------------------------------------
always @(id_ex_alu_op or id_ex_sign_extended[5:0])
if (id_ex_alu_op == 4'b0010)
  case (id_ex_sign_extended[5:0])
    FUNC_TYPE_ADD: alu_op <= `ADD_OP;
    FUNC_TYPE_SUB: alu_op <= `SUB_OP;
    FUNC_TYPE_AND: alu_op <= `AND_OP;
    FUNC_TYPE_OR: alu_op <= `OR_OP;
    FUNC_TYPE_SLT: alu_op <= `SLT_OP;
    FUNC_TYPE_XOR: alu_op <= `XOR_OP;
    FUNC_TYPE_NOR: alu_op <= `NOR_OP;
    FUNC_TYPE_ADDU: alu_op <= `ADDU_OP;
    FUNC_TYPE_SUBU: alu_op <= `SUBU_OP;
    FUNC_TYPE_SLTU: alu_op <= `SLTU_OP;
    FUNC_TYPE_SLL: alu_op <= `SLL_OP;
    FUNC_TYPE_SRL: alu_op <= `SRL_OP;
    default: alu_op <= `NULL_OP;
  endcase
else if (id_ex_alu_op == 4'b0000)
  alu_op <= `ADD_OP;
else if (id_ex_alu_op == 4'b0001)
  alu_op <= `SUB_OP;
else if (id_ex_alu_op == 4'b0100)
  alu_op <= `ADD_OP;
else if (id_ex_alu_op == 4'b0101)
  alu_op <= `AND_OP;
else if (id_ex_alu_op == 4'b0110)
  alu_op <= `OR_OP;
else if (id_ex_alu_op == 4'b0111)
  alu_op <= `SLT_OP;
else if (id_ex_alu_op == 4'b1000)
  alu_op <= `XOR_OP;
else
  alu_op <= `NULL_OP;
  
  
//---------------------ALU-------------------------------------------------------------
always @(alu_operand_1 or alu_operand_2 or alu_op)
begin
  case (alu_op)
    `ADD_OP: alu_result <= alu_operand_1 + alu_operand_2;
    `SUB_OP: alu_result <= alu_operand_1 - alu_operand_2;
    `AND_OP: alu_result <= alu_operand_1 & alu_operand_2;
    `OR_OP: alu_result <= alu_operand_1 | alu_operand_2;
    `SLT_OP: alu_result <= (alu_operand_1 < alu_operand_2);
    `XOR_OP: alu_result <= alu_operand_1 ^ alu_operand_2;
    `NOR_OP: alu_result <= ~(alu_operand_1 | alu_operand_2);
    `ADDU_OP: alu_result <= alu_operand_1 + alu_operand_2;
    `SUBU_OP: alu_result <= alu_operand_1 - alu_operand_2;
    `SLTU_OP: alu_result <= ($unsigned(alu_operand_1) < $unsigned(alu_operand_2));
    `SLL_OP: alu_result <= alu_operand_1 << alu_operand_2;
    `SRL_OP: alu_result <= alu_operand_1 >> alu_operand_2;
    default: alu_result <= `CPU_BUS_SIZE'b0;
  endcase
end


//---------------------ex_mem_reg_read_data2-------------------------------------------
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_reg_read_data2 <= `CPU_BUS_SIZE'b0;
else if(pridictor_wrong)
  ex_mem_reg_read_data2 <= `CPU_BUS_SIZE'b0;
else
  ex_mem_reg_read_data2 <= alu_operand2_before_mux;


//---------------------ex_mem_alu_result_out-------------------------------------------
always @(posedge clk or negedge rst_n)
if (!rst_n)
  ex_mem_alu_result_out <= `CPU_BUS_SIZE'b0;
else if(pridictor_wrong)
  ex_mem_alu_result_out <= `CPU_BUS_SIZE'b0;
else
  ex_mem_alu_result_out <= alu_result;




endmodule