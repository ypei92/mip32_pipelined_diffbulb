`include "DesignName_parameters.v"

module forwarding_2( if_id_rs 
                   , if_id_rt
                   , id_ex_rd
                   , id_ex_alu_result_out
                   , ex_mem_rd
                   , ex_mem_alu_result_out
                   , ex_mem_mem_read_data_out
                   
                   , read_data_wire_1
                   , read_data_wire_2
                   , id_ex_reg_write
                   , ex_mem_reg_write
                   , ex_mem_mem_read
                   
                   , equal_out
                   );
  input if_id_rs 
      , if_id_rt
      , id_ex_rd
      , id_ex_alu_result_out
      , ex_mem_rd
      , ex_mem_alu_result_out
      , ex_mem_mem_read_data_out
      
      , read_data_wire_1
      , read_data_wire_2
      , id_ex_reg_write
      , ex_mem_reg_write
      , ex_mem_mem_read;
    
  output equal_out;

 
  wire [4:0]if_id_rs;
  wire [4:0]if_id_rt;
  wire [4:0]id_ex_rd;
  wire [4:0]ex_mem_rd;
  
  wire [`CPU_BUS_SIZE-1:0]id_ex_alu_result_out;
  wire [`CPU_BUS_SIZE-1:0]ex_mem_alu_result_out;
  wire [`CPU_BUS_SIZE-1:0]ex_mem_mem_read_data_out;
  
  wire [`CPU_BUS_SIZE-1:0]read_data_wire_1;
  wire [`CPU_BUS_SIZE-1:0]read_data_wire_2;
  
 // wire branch_or_not;
  wire id_ex_reg_write;
  wire ex_mem_reg_write;
  wire ex_mem_mem_read;
  
  wire equal_out;
  
  wire [1:0]ex_forwarding;
  wire [1:0]mem_forwarding;
  
  reg [`CPU_BUS_SIZE-1:0]compare_num1;
  reg [`CPU_BUS_SIZE-1:0]compare_num2;
  wire [`CPU_BUS_SIZE-1:0]compare1;
  wire [`CPU_BUS_SIZE-1:0]compare2;
  
  assign ex_forwarding[0]  = (id_ex_reg_write)  && (id_ex_rd[4:0]  == if_id_rs[4:0]);
  assign ex_forwarding[1]  = (id_ex_reg_write)  && (id_ex_rd[4:0]  == if_id_rt[4:0]);
  assign mem_forwarding[0] = (ex_mem_reg_write) && (ex_mem_rd[4:0] == if_id_rs[4:0]);
  assign mem_forwarding[1] = (ex_mem_reg_write) && (ex_mem_rd[4:0] == if_id_rt[4:0]);
  
  
  always @(mem_forwarding or ex_forwarding or compare_num1 or compare_num2 or 
           read_data_wire_1 or read_data_wire_2 or id_ex_alu_result_out or ex_mem_alu_result_out)
  case({mem_forwarding[1:0],ex_forwarding[1:0]})
    4'b0000 : {compare_num1 , compare_num2} <= {read_data_wire_1 , read_data_wire_2};
    4'b0001 : {compare_num1 , compare_num2} <= {id_ex_alu_result_out , read_data_wire_2};
    4'b0010 : {compare_num1 , compare_num2} <= {read_data_wire_1 , id_ex_alu_result_out};
    4'b0100 : {compare_num1 , compare_num2} <= {ex_mem_alu_result_out , read_data_wire_2};
    4'b0101 : {compare_num1 , compare_num2} <= {id_ex_alu_result_out , read_data_wire_2};
    4'b0110 : {compare_num1 , compare_num2} <= {ex_mem_alu_result_out , id_ex_alu_result_out};
    4'b1000 : {compare_num1 , compare_num2} <= {read_data_wire_1 , ex_mem_alu_result_out};
    4'b1001 : {compare_num1 , compare_num2} <= {id_ex_alu_result_out , ex_mem_alu_result_out};
    4'b1010 : {compare_num1 , compare_num2} <= {read_data_wire_1 , id_ex_alu_result_out};
    default : {compare_num1 , compare_num2} <= 0;
  endcase
  
  assign compare1 = compare_num1;
  assign compare2 = ex_mem_mem_read ? ex_mem_mem_read_data_out : compare_num2;
  
  assign equal_out = (compare1 == compare2);
  //assign if_id_pc_src = branch_or_not ? equal_out : 0;
  
endmodule

    
  