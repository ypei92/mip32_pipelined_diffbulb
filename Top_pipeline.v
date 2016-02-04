//MIPS PIPELINE
//beta 7.0
//BY YAN PEI , WANGYANG HAN , KUAN HU
//2014.1.27

`include "DesignName_parameters.v"

/*
module Top( clk , rst_n , pc , mem_wb_data_mem_read_data , mem_wb_data_alu_result);
input clk , rst_n;
output pc , mem_wb_data_mem_read_data , mem_wb_data_alu_result;*/


module Top();
  reg clk,rst_n;
  
//From PC section
  wire [`CPU_BUS_SIZE - 1 : 0] pc;
  
//From IF stage
  wire [`CPU_BUS_SIZE - 1 : 0] pc_plus_4_wire;
  wire [`CPU_BUS_SIZE - 1 : 0] pc_jump;
  wire [`CPU_BUS_SIZE - 1 : 0] instruction; 
  wire [1:0]if_id_branch_pridictor_bit;
  wire pc_select_jump;
  wire [`CPU_BUS_SIZE-1:0]pc_branch_address;
  wire if_id_pc_src;

//From ID stage
  wire [`CPU_BUS_SIZE-1:0]id_ex_reg_read_data1;
  wire [`CPU_BUS_SIZE-1:0]id_ex_reg_read_data2;
  wire [4 : 0]id_ex_rs;
  wire [4 : 0]id_ex_rt;
  wire [4 : 0]id_ex_rd;
  wire [`CPU_BUS_SIZE-1:0]id_ex_sign_extended;
  wire [`CPU_BUS_SIZE-1:0]mem_wb_write_data;
  wire if_id_pc_write;
  wire if_id_write_from_hazard_detector;
  wire [1 : 0]id_ex_branch_pridictor_bit;
  //wire pridictor_wrong;
  //wire if_id_pc_src;

  wire id_ex_reg_dst;
  wire id_ex_alu_src;
  wire id_ex_mem_read;
  wire id_ex_mem_write;
  wire id_ex_mem_to_reg;
  wire id_ex_reg_write;
  wire [3:0]id_ex_alu_op;
  wire id_ex_branch;
  wire id_ex_branch_bne;
  
// From EX stage
  wire [`CPU_BUS_SIZE-1:0] ex_mem_alu_result;
  wire [`CPU_BUS_SIZE-1:0] ex_mem_reg_read_data2;
  wire [4:0] ex_mem_rd;

  wire ex_mem_mem_read;
  wire ex_mem_mem_write;
  wire ex_mem_mem_to_reg;
  wire ex_mem_reg_write;
  wire ex_mem_branch;
  wire ex_mem_branch_bne;

  wire [4:0]id_ex_rt_out;
  wire id_ex_mem_read_out;
  
  wire [1:0]ex_mem_branch_pridictor_bit;
  //wire [`CPU_BUS_SIZE-1:0]id_ex_alu_result_wire;
  //wire [4:0]id_ex_rd_wire_before_mux;
  //wire id_ex_reg_write_out;
  
// From MEM stage
  wire mem_wb_mem_to_reg;      			
  wire mem_wb_reg_write;						

  wire [4:0]mem_wb_rd;
  wire [`CPU_BUS_SIZE-1:0]mem_wb_data_mem_read_data;
  wire [`CPU_BUS_SIZE-1:0]mem_wb_data_alu_result;

  wire [4:0]ex_mem_rd_out;
  wire [`CPU_BUS_SIZE-1:0]ex_mem_alu_result_out;
  wire ex_mem_reg_write_out;	
  
  wire pridictor_wrong;
  wire [1:0]ex_mem_branch_pridictor_bit_out;
//  wire ex_mem_mem_read_out;
//  wire [`CPU_BUS_SIZE-1:0]ex_mem_data_mem_read_data_out;					


//-----clk and rst_n-------------------------------------------------------
  initial
  begin
    clk <= 1;
    rst_n <= 0;
    #5 rst_n <= 1;
  end

  always
  #10 clk <= ~clk;
//-------------------------------------------------------------------------

//-------------IF stage--------------------------------
Instruction_Memory if_stage(
                            .clk(clk),
                            .rst_n(rst_n),
                            .if_id_write_from_hazard_detector(if_id_write_from_hazard_detector),
                            .if_id_pc_write(if_id_pc_write),
                            .pc(pc),
                            
                            .ex_mem_branch_pridictor_bit_out(ex_mem_branch_pridictor_bit_out),
                            .pridictor_wrong(pridictor_wrong),
                            
                            .instruction(instruction),
                            .pc_plus_4_wire(pc_plus_4_wire),
                            .pc_jump(pc_jump),
                            .pc_select_jump(pc_select_jump),
                            .pc_branch_address(pc_branch_address),
                            .if_id_branch_pridictor_bit(if_id_branch_pridictor_bit),
                            .if_id_pc_src(if_id_pc_src)
                            );
                            
                            
//-------------ID stage--------------------------------
Registers id_stage(
                  .clk(clk),
                  .rst_n(rst_n),
                  
                  .instruction(instruction),
                  .id_ex_rt_in(id_ex_rt_out),
                  .id_ex_mem_read_in(id_ex_mem_read_out),
                  .mem_wb_reg_write(mem_wb_reg_write),
                  .mem_wb_mem_to_reg(mem_wb_mem_to_reg),
                  .mem_wb_rd(mem_wb_rd),
                  .mem_wb_alu_result(mem_wb_data_alu_result),
                  .mem_wb_data_mem_read_data(mem_wb_data_mem_read_data),
                  .pridictor_wrong(pridictor_wrong),
                  
                  //.id_ex_rd_wire_before_mux(id_ex_rd_wire_before_mux),
                  //.id_ex_alu_result_wire(id_ex_alu_result_wire),
                  //.id_ex_reg_write_out(id_ex_reg_write_out),
                  //.ex_mem_rd_out(ex_mem_rd_out),
                  //.ex_mem_data_mem_read_data_out(ex_mem_data_mem_read_data_out),
                  //.ex_mem_alu_result_out(ex_mem_alu_result_out),
                  //.ex_mem_reg_write_out(ex_mem_reg_write_out),
                  //.ex_mem_mem_read_out(ex_mem_mem_read_out),
                  
                  .if_id_branch_pridictor_bit(if_id_branch_pridictor_bit),
                  .id_ex_branch_pridictor_bit(id_ex_branch_pridictor_bit),
                  
                  .id_ex_reg_read_data1(id_ex_reg_read_data1),
                  .id_ex_reg_read_data2(id_ex_reg_read_data2),
                  .id_ex_rs(id_ex_rs),
                  .id_ex_rt(id_ex_rt),
                  .id_ex_rd(id_ex_rd),
                  .id_ex_sign_extended(id_ex_sign_extended),
                  .mem_wb_write_data(mem_wb_write_data),
                  
                  .if_id_pc_write(if_id_pc_write),
                  .if_id_write_from_hazard_detector(if_id_write_from_hazard_detector),
                  .id_ex_reg_dst(id_ex_reg_dst),
                  .id_ex_alu_op(id_ex_alu_op),
                  .id_ex_alu_src(id_ex_alu_src),
                  //.if_id_pc_src(if_id_pc_src),
                  .id_ex_mem_read(id_ex_mem_read),
                  .id_ex_mem_write(id_ex_mem_write),
                  .id_ex_mem_to_reg(id_ex_mem_to_reg),
                  .id_ex_reg_write(id_ex_reg_write),
                  .id_ex_branch(id_ex_branch),
                  .id_ex_branch_bne(id_ex_branch_bne)
                  //.pc_branch_address(pc_branch_address),
                  //.branch_pridictor_bit_out(branch_pridictor_bit_out),
                  //.pridictor_wrong(pridictor_wrong)
           );
           
//-------------EX stage--------------------------------
  ALU ex_stage(
                .clk(clk), 
                .rst_n(rst_n),
                .id_ex_reg_dst(id_ex_reg_dst),         	   			
                .id_ex_alu_op(id_ex_alu_op),                 
                .id_ex_alu_src(id_ex_alu_src),              
                .id_ex_mem_read(id_ex_mem_read),           			
                .id_ex_mem_write(id_ex_mem_write),          			 
                .id_ex_mem_to_reg(id_ex_mem_to_reg),         			
                .id_ex_reg_write(id_ex_reg_write),		
                .id_ex_branch(id_ex_branch),	
                .id_ex_branch_bne(id_ex_branch_bne),	        		
           
                .id_ex_reg_read_data1(id_ex_reg_read_data1),
                .id_ex_reg_read_data2(id_ex_reg_read_data2),
           
                .id_ex_rs(id_ex_rs),
                .id_ex_rt(id_ex_rt),
                .id_ex_rd(id_ex_rd),
                .id_ex_sign_extended(id_ex_sign_extended),
                
                .id_ex_branch_pridictor_bit(id_ex_branch_pridictor_bit),

                .wb_write_data(mem_wb_write_data),
                .ex_mem_alu_result(ex_mem_alu_result_out),
                .ex_mem_rd(ex_mem_rd_out),
                .mem_wb_rd(mem_wb_rd),
                .ex_mem_reg_write_in(ex_mem_reg_write_out),     						 
                .mem_wb_reg_write(mem_wb_reg_write),	
                
                .pridictor_wrong(pridictor_wrong),	        

           //output-------------------------------------------
                .ex_mem_alu_result_out(ex_mem_alu_result),
                .ex_mem_reg_read_data2(ex_mem_reg_read_data2),
                .ex_mem_rd_out(ex_mem_rd),
           
                .ex_mem_mem_read(ex_mem_mem_read),           			
                .ex_mem_mem_write(ex_mem_mem_write),          			
                .ex_mem_mem_to_reg(ex_mem_mem_to_reg),         			
                .ex_mem_reg_write(ex_mem_reg_write),			
                .ex_mem_branch(ex_mem_branch),
                .ex_mem_branch_bne(ex_mem_branch_bne)	,	       	
           
                .id_ex_rt_out(id_ex_rt_out),
                .id_ex_mem_read_out(id_ex_mem_read_out),
                
                .ex_mem_branch_pridictor_bit(ex_mem_branch_pridictor_bit)
                
                //.id_ex_alu_result_wire(id_ex_alu_result_wire),
                //.id_ex_rd_wire_before_mux(id_ex_rd_wire_before_mux),
                //.id_ex_reg_write_out(id_ex_reg_write_out)
                );
                
//--------------MEM_stage----------------------------------
  Data_Memory MEM_stage(
                      		.clk(clk),
                        .rst_n(rst_n),
                        .ex_mem_alu_result(ex_mem_alu_result),
                        .ex_mem_reg_read_data2(ex_mem_reg_read_data2),
                        .ex_mem_rd(ex_mem_rd),
                        .ex_mem_mem_read(ex_mem_mem_read),          			
                        .ex_mem_mem_write(ex_mem_mem_write),        			
                        .ex_mem_mem_to_reg(ex_mem_mem_to_reg),         			
                        .ex_mem_reg_write(ex_mem_reg_write),	
                        .ex_mem_branch(ex_mem_branch),	
                        .ex_mem_branch_bne(ex_mem_branch_bne),	
                        .ex_mem_branch_pridictor_bit(ex_mem_branch_pridictor_bit),

                        .mem_wb_mem_to_reg(mem_wb_mem_to_reg),         	
                        .mem_wb_reg_write(mem_wb_reg_write),						
                        .mem_wb_rd(mem_wb_rd),
                        .mem_wb_data_mem_read_data(mem_wb_data_mem_read_data),
                        .mem_wb_data_alu_result(mem_wb_data_alu_result),
                        .ex_mem_rd_out(ex_mem_rd_out),
                        .ex_mem_alu_result_out(ex_mem_alu_result_out),
                        .ex_mem_reg_write_out(ex_mem_reg_write_out),
                        .ex_mem_branch_pridictor_bit_out(ex_mem_branch_pridictor_bit_out),
                        .pridictor_wrong(pridictor_wrong)
                        //.ex_mem_mem_read_out(ex_mem_mem_read_out),
                        //.ex_mem_data_mem_read_data_out(ex_mem_data_mem_read_data_out)
                        );
//---------------WB stage----------------------------------
  PC_Select pc_stage(
                      .clk(clk),
                      .rst_n(rst_n),
                      .if_id_pc_src(if_id_pc_src),
                      .if_id_pc_write(if_id_pc_write),
                      .branch_pc(pc_branch_address),
                      .pc_plus_4_wire(pc_plus_4_wire),
                      .pc_jump(pc_jump),
                      .pc_select_jump(pc_select_jump),
                      
                      .pc(pc)
                      );
  


endmodule