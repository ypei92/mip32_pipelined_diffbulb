`include "DesignName_parameters.v"
module Registers( clk 
                , rst_n
                , instruction
                , id_ex_rt_in
                , id_ex_mem_read_in
                , mem_wb_reg_write
                , mem_wb_mem_to_reg
                , mem_wb_rd
                , mem_wb_alu_result
                , mem_wb_data_mem_read_data
                
                , pridictor_wrong
                , if_id_branch_pridictor_bit
                //, id_ex_rd_wire_before_mux
                //, id_ex_alu_result_wire
                //, id_ex_reg_write_out
                //, ex_mem_rd_out
                //, ex_mem_data_mem_read_data_out
                //, ex_mem_alu_result_out
                //, ex_mem_reg_write_out
                //, ex_mem_mem_read_out
                
                
               //----output---------------- 
                , id_ex_reg_read_data1
                , id_ex_reg_read_data2
                , id_ex_rs
                , id_ex_rt
                , id_ex_rd
                , id_ex_sign_extended
                , mem_wb_write_data
                , if_id_pc_write
                , if_id_write_from_hazard_detector
                , id_ex_reg_dst
                , id_ex_alu_op
                , id_ex_alu_src
                //, if_id_pc_src
                , id_ex_mem_read
                , id_ex_mem_write
                , id_ex_mem_to_reg
                , id_ex_reg_write
                
                , id_ex_branch
                , id_ex_branch_bne
                , id_ex_branch_pridictor_bit
                );
                
  input     clk 
          , rst_n
          , instruction
          , id_ex_rt_in
          , id_ex_mem_read_in
          , mem_wb_reg_write
          , mem_wb_mem_to_reg
          , mem_wb_rd
          , mem_wb_alu_result
          , mem_wb_data_mem_read_data
          
          , pridictor_wrong
          , if_id_branch_pridictor_bit
          
          //, ex_mem_mem_read_out
          //, id_ex_rd_wire_before_mux
          //, id_ex_alu_result_wire
          //, id_ex_reg_write_out
          //, ex_mem_rd_out
          //, ex_mem_data_mem_read_data_out
          //, ex_mem_alu_result_out
          //, ex_mem_reg_write_out
          
          , if_id_branch_pridictor_bit
          ;
  output    id_ex_reg_read_data1
          , id_ex_reg_read_data2
          , id_ex_rs
          , id_ex_rt
          , id_ex_rd
          , id_ex_sign_extended
          , mem_wb_write_data
          , if_id_pc_write
          , if_id_write_from_hazard_detector
          , id_ex_reg_dst
          , id_ex_alu_op
          , id_ex_alu_src
          , id_ex_mem_read
          , id_ex_mem_write
          , id_ex_mem_to_reg
          , id_ex_reg_write
          
          , id_ex_branch
          , id_ex_branch_bne
          , id_ex_branch_pridictor_bit
          ;
          
  parameter pos_extend = 16'h0;
  parameter neg_extend = 16'hffff;
          
  wire clk,rst_n;
  wire [5:0]if_id_op;
  //wire [5:0]if_id_func;
  wire [4:0]if_id_rs , if_id_rt , if_id_rd;
  wire [15:0]if_id_immediate;
  wire [`CPU_BUS_SIZE - 1 : 0]instruction;
  
  wire [4:0]id_ex_rt_in; 
  wire id_ex_mem_read_in;
  
  wire mem_wb_reg_write;
  wire mem_wb_mem_to_reg;
  wire [4:0]mem_wb_rd;
  wire [`CPU_BUS_SIZE - 1 : 0]mem_wb_alu_result;
  wire [`CPU_BUS_SIZE - 1 : 0]mem_wb_data_mem_read_data;
  
  
  wire [`CPU_BUS_SIZE - 1 : 0]read_data1;
  wire [`CPU_BUS_SIZE - 1 : 0]read_data2;
  reg [`CPU_BUS_SIZE - 1 : 0]id_ex_reg_read_data1;
  reg [`CPU_BUS_SIZE - 1 : 0]id_ex_reg_read_data2;
  reg [4:0]id_ex_rs;
  reg [4:0]id_ex_rt;
  reg [4:0]id_ex_rd;
  reg [`CPU_BUS_SIZE - 1 : 0]id_ex_sign_extended;
  wire [`CPU_BUS_SIZE - 1 : 0]sign_extended_number;
  
  wire [`CPU_BUS_SIZE - 1 : 0]mem_wb_write_data;
  wire if_id_pc_write;
  wire if_id_write_from_hazard_detector;
  
  reg id_ex_reg_dst;
  reg id_ex_alu_src;
  reg id_ex_mem_read;
  reg id_ex_mem_write;
  reg id_ex_mem_to_reg;
  reg id_ex_reg_write;
  reg [3:0]id_ex_alu_op;
  reg id_ex_branch;
  reg id_ex_branch_bne;
  
  reg  [`CPU_BUS_SIZE - 1 : 0]registers[1 : `CPU_BUS_SIZE - 1];
  
  wire id_mux_load_use;
  wire [12:0]control_signals;
  
  //wire [4:0]id_ex_rd_wire_before_mux;
  //wire [`CPU_BUS_SIZE - 1 : 0]id_ex_alu_result_wire;
  //wire id_ex_reg_write_out;
  //wire [4:0]ex_mem_rd_out;
  //wire [`CPU_BUS_SIZE - 1 : 0]ex_mem_data_mem_read_data_out;
  //wire [`CPU_BUS_SIZE - 1 : 0]ex_mem_alu_result_out;
  //wire ex_mem_reg_write_out;
  //wire ex_mem_mem_read_out;
  wire pridictor_wrong;
  wire [1:0]if_id_branch_pridictor_bit;
  reg [1:0]id_ex_branch_pridictor_bit;
  
//---------------------------------------------------------------
  assign if_id_op[5:0] = instruction[31:26];
  assign {if_id_rs,if_id_rt,if_id_rd} = instruction[25:11];
  assign if_id_immediate[15:0] = instruction[15:0];
  
  assign sign_extended_number[15:0] = if_id_immediate[15:0];
  assign sign_extended_number[31:16] = (instruction[15])?neg_extend : pos_extend;
  
  assign read_data1 = (if_id_rs == 0)? 0 : registers[if_id_rs];
  assign read_data2 = (if_id_rt == 0)? 0 : registers[if_id_rt];

  assign mem_wb_write_data = (mem_wb_mem_to_reg)?mem_wb_data_mem_read_data : mem_wb_alu_result;
  
  
  
  Hazard_Detector hazard_dec(.if_id_rt(if_id_rt),
                             .if_id_rs(if_id_rs),
                             .id_ex_rt(id_ex_rt_in),
                             .id_ex_mem_read(id_ex_mem_read_in),
                             
                             .pridictor_wrong(pridictor_wrong),
                             //.branch_pridictor_bit(branch_pridictor_bit),
                             //.equal_out(equal_out),
                             //.branch_or_not(control_signals[11]),
                      
                             .if_id_pc_write(if_id_pc_write),
                             .if_id_write_from_hazard_detector(if_id_write_from_hazard_detector),
                             .id_mux_load_use(id_mux_load_use)
                             //.branch_pridictor_bit_out(branch_pridictor_bit_out),
                             //.pridictor_wrong(pridictor_wrong)
                             ); 
                             
  Control con(
              .instruction_op(if_id_op[5:0]),             //instruction[31:26]
              
              .reg_dst(control_signals[0]),               //alu kind op is 1, lw is 0
              .jump(control_signals[1]),                  //jump is 1
              .mem_read(control_signals[2]),              //lw is 1
              .mem_to_reg(control_signals[3]),            //lw is 1         
              .mem_write(control_signals[4]),             //sw is 1
              .alu_src(control_signals[5]),               //sw or lw is 1
              .reg_write(control_signals[6]),							      //alu and lw is 1
              .alu_op(control_signals[10:7]),              //see the promise
              .branch(control_signals[11]),                //branch is 1
              .branch_bne(control_signals[12])
              );
 /*             
  forwarding_2 for2(
                   .if_id_rs(instruction[25:21]), 
                   .if_id_rt(instruction[20:16]), 
                   .id_ex_rd(id_ex_rd_wire_before_mux), 
                   .id_ex_alu_result_out(id_ex_alu_result_wire), 
                   .ex_mem_rd(ex_mem_rd_out), 
                   .ex_mem_alu_result_out(ex_mem_alu_result_out), 
                   .ex_mem_mem_read_data_out(ex_mem_data_mem_read_data_out), 
                   
                   .read_data_wire_1(read_data1), 
                   .read_data_wire_2(read_data2), 
                   //.branch_or_not(control_signals[11]), 
                   .id_ex_reg_write(id_ex_reg_write_out), 
                   .ex_mem_reg_write(ex_mem_reg_write_out), 
                   .ex_mem_mem_read(ex_mem_mem_read_out), 
                   
                   .equal_out(equal_out)
                   );
 */ 
  
 
//-----------------id_ex_rs---------------------------------------------- 
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_rs <= 0;
  else
    id_ex_rs <= if_id_rs;
  
//-----------------id_ex_rt----------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_rt <= 0;
  else
    id_ex_rt <= if_id_rt;
    
//-----------------id_ex_rd----------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_rd <= 0;
  else
    id_ex_rd <= if_id_rd;
    
//-----------------id_ex_sign_extended----------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_sign_extended <= 0;
  else
    id_ex_sign_extended <= sign_extended_number;
     
//-----------------id_ex_reg_read_data1----------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_reg_read_data1 <= 0;
  else
    id_ex_reg_read_data1 <= read_data1;
    
//-----------------id_ex_reg_read_data2----------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_reg_read_data2 <= 0;
  else
    id_ex_reg_read_data2 <= read_data2;
       
    
//-------------------id_ex_reg_dst-------------------------------------------- 
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_reg_dst <= 0;
  else
    if(id_mux_load_use)
      id_ex_reg_dst <= control_signals[0];
    else
      id_ex_reg_dst <= 0;
  
//-------------------id_ex_mem_read--------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_mem_read <= 0;
  else
    if(id_mux_load_use)
      id_ex_mem_read <= control_signals[2];
    else
      id_ex_mem_read <= 0;
    
//-------------------id_ex_mem_to_reg--------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_mem_to_reg <= 0;
  else
    if(id_mux_load_use)
      id_ex_mem_to_reg <= control_signals[3];
    else
      id_ex_mem_to_reg <= 0;
    
//-------------------id_ex_mem_write--------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_mem_write <= 0;
  else
    if(id_mux_load_use)
      id_ex_mem_write <= control_signals[4];
    else
      id_ex_mem_write <= 0;
      
      
//-------------------id_ex_alu_src-------------------------------------------- 
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_alu_src <= 0;
  else
    if(id_mux_load_use)
      id_ex_alu_src <= control_signals[5];
    else
      id_ex_alu_src <= 0;
  
//-------------------id_ex_reg_write-------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_reg_write <= 0;
  else
    if(id_mux_load_use)
      id_ex_reg_write <= control_signals[6];
    else
      id_ex_reg_write <= 0;
    
//-------------------id_ex_alu_op-------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_alu_op <= 0;
  else
    if(id_mux_load_use)
      id_ex_alu_op <= control_signals[10:7];
    else
      id_ex_alu_op <= 0;
//-------------------id_ex_branch-------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_branch <= 0;
  else
    if(id_mux_load_use)
      id_ex_branch <= control_signals[11];
    else
      id_ex_branch <= 0;    
      
//-------------------id_ex_branch_bne-------------------------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_branch_bne <= 0;
  else
    if(id_mux_load_use)
      id_ex_branch_bne <= control_signals[12];
    else
      id_ex_branch_bne <= 0; 

//--------------------id_ex_branch_pridictor_bit----------------------------
  always@(posedge clk or negedge rst_n)
  if(!rst_n)
    id_ex_branch_pridictor_bit <= 1; 
  else
    id_ex_branch_pridictor_bit <= if_id_branch_pridictor_bit;
   
    
    
//-------------------registers--------------------------------------------
  always@(negedge clk or negedge rst_n)
  if(!rst_n)
  begin
    registers[1]  <= 32'b0;
    registers[2]  <= 32'b0;
    registers[3]  <= 32'b0;
    registers[4]  <= 32'b0;
    registers[5]  <= 32'b0;
    registers[6]  <= 32'b0;
    registers[7]  <= 32'b0;
    registers[8]  <= 32'b0;
    registers[9]  <= 32'b0;
    registers[10] <= 32'b0;
    registers[11] <= 32'b0;
    registers[12] <= 32'b0;
    registers[13] <= 32'b0;
    registers[14] <= 32'b0;
    registers[15] <= 32'b0;
    registers[16] <= 32'b0;
    registers[17] <= 32'b0;
    registers[18] <= 32'b0;
    registers[19] <= 32'b0;
    registers[20] <= 32'b0;
    registers[21] <= 32'b0;
    registers[22] <= 32'b0;
    registers[23] <= 32'b0;
    registers[24] <= 32'b0;
    registers[25] <= 32'b0;
    registers[26] <= 32'b0;
    registers[27] <= 32'b0;
    registers[28] <= 32'b0;
    registers[29] <= 32'b0;
    registers[30] <= 32'b0;
    registers[31] <= 32'b0;
  end
  else
    if(mem_wb_reg_write)
      registers[mem_wb_rd] <= mem_wb_write_data;
      
endmodule
    

    
  
  
  
  
  
  
