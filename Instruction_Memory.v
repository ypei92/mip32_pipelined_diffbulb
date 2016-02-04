`include "DesignName_parameters.v"
module Instruction_Memory( clk
                          ,rst_n
                          ,if_id_write_from_hazard_detector
                          ,if_id_pc_write
                          ,pc
                          ,ex_mem_branch_pridictor_bit_out
                          ,pridictor_wrong
                          
                          ,instruction
                          ,pc_plus_4_wire
                          ,pc_jump
                          ,pc_select_jump
                          
                          ,pc_branch_address
                          ,if_id_branch_pridictor_bit
                          ,if_id_pc_src
                          );
   
input  clk,
       rst_n,
       if_id_write_from_hazard_detector,
       pc,
       if_id_pc_write,
       ex_mem_branch_pridictor_bit_out,
       pridictor_wrong
       ;
output instruction,
       pc_plus_4_wire,
       pc_jump,
       pc_select_jump,
       pc_branch_address,
       if_id_branch_pridictor_bit,
       if_id_pc_src
       ;
       
  parameter pos_extend = 16'h0;
  parameter neg_extend = 16'hffff;

wire clk,
     rst_n,
     if_id_write_from_hazard_detector,
     if_id_pc_write;
       
wire [`CPU_BUS_SIZE-1:0]pc;
wire [`CPU_BUS_SIZE-1:0]pc_plus_4_wire;
wire [`CPU_BUS_SIZE-1:0]pc_jump;
wire [`CPU_BUS_SIZE-1:0]pc_plus_4_shift_2;

wire [`INSTRUCTION_SIZE-1:0]get_instruction;

reg [7 : 0]instruction_memory[0 : 127];
reg [31:0]instruction;
reg  [1:0]if_id_branch_pridictor_bit;

reg  [`CPU_BUS_SIZE-1:0]flush_address0;
reg  [`CPU_BUS_SIZE-1:0]flush_address1;
reg  [`CPU_BUS_SIZE-1:0]flush_address2;
wire [`CPU_BUS_SIZE-1:0]pc_branch_address;
wire [`CPU_BUS_SIZE-1:0]pc_branch_address0;
wire [`CPU_BUS_SIZE-1:0]pc_branch_address1;
wire [`CPU_BUS_SIZE-1:0]sign_extended_number;
wire [1:0]ex_mem_branch_pridictor_bit_out;
wire if_id_pc_src;
wire branch_or_not;

  
  initial
    $readmemb("instruction_memory.txt",instruction_memory);
    
  assign get_instruction[7 : 0] = instruction_memory[ pc ];
  assign get_instruction[15: 8] = instruction_memory[ pc + 32'd1 ];
  assign get_instruction[23:16] = instruction_memory[ pc + 32'd2 ];
  assign get_instruction[31:24] = instruction_memory[ pc + 32'd3 ];
 /* 
  instruction_memory_rom get1(
										.a(pc[6:0]),
										.spo(get_instruction[7:0])
										);
  instruction_memory_rom get2(
										.a(pc[6:0] + 7'd1),
										.spo(get_instruction[15:8])
										);
  instruction_memory_rom get3(
										.a(pc[6:0] + 7'd2),
										.spo(get_instruction[23:16])
										);
  instruction_memory_rom get4(
										.a(pc[6:0] + 7'd3),
										.spo(get_instruction[31:24])
										);
*/

//------------------JUMP-----------------  
  assign pc_plus_4_shift_2 = get_instruction << 2 ;  
  assign pc_select_jump = (get_instruction[31:26] == 6'b000010);
  assign pc_jump[`CPU_BUS_SIZE-1:0] = {pc_plus_4_wire[31:28],pc_plus_4_shift_2[27:0]};
//------------------branch_addr---------------
  assign sign_extended_number[15:0] = get_instruction[15:0];
  assign sign_extended_number[31:16] = (get_instruction[15])?neg_extend : pos_extend;
  assign pc_branch_address0 = (sign_extended_number << 2) + pc_plus_4_wire;
  assign pc_branch_address1 =  flush_address2;
  assign pc_branch_address  = (pridictor_wrong)?pc_branch_address1 : pc_branch_address0; 
  
  assign branch_or_not = (get_instruction[31:26] == 6'b000100);
  assign if_id_pc_src = (branch_or_not&&(ex_mem_branch_pridictor_bit_out > 1))||(pridictor_wrong);

  assign pc_plus_4_wire = pc + 32'd4;

//---------------------bit_pridictor-------------------
always @(posedge clk or negedge rst_n)
  if (!rst_n)
    if_id_branch_pridictor_bit <= 0;
  else 
    if_id_branch_pridictor_bit <= ex_mem_branch_pridictor_bit_out;
//----------------------flush_address------------------
always @(posedge clk or negedge rst_n)
  if (!rst_n)
    flush_address0 <= 32'b0;
  else if(!if_id_pc_write)
    flush_address0 <= flush_address0;
  else if(!branch_or_not)
    flush_address0 <= 32'b0;
  else if(ex_mem_branch_pridictor_bit_out < 2)
    flush_address0 <= pc_branch_address0;
  else
    flush_address0 <= pc_plus_4_wire;
    
always @(posedge clk or negedge rst_n)
  if (!rst_n)
    flush_address1 <= 0;
  else if(!if_id_pc_write)
    flush_address1 <= flush_address1;
  else
    flush_address1 <= flush_address0;
    
always @(posedge clk or negedge rst_n)
  if (!rst_n)
    flush_address2 <= 0;
  else if(!if_id_pc_write)
    flush_address2 <= flush_address2;
  else
    flush_address2 <= flush_address1;

//---------------------instruction--------------
always @(posedge clk or negedge rst_n)   
  if (!rst_n)
    instruction <= 32'b0;
  else if(pridictor_wrong)
    instruction <= 32'b0;
  else if(if_id_write_from_hazard_detector)
    instruction <= get_instruction;


endmodule