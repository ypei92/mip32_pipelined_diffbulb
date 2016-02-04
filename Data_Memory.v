`include "DesignName_parameters.v"
module Data_Memory(clk
                  ,rst_n
                  ,ex_mem_alu_result
                  ,ex_mem_reg_read_data2
                  ,ex_mem_rd
                  ,ex_mem_mem_read
                  ,ex_mem_mem_write
                  ,ex_mem_mem_to_reg
                  ,ex_mem_branch
                  ,ex_mem_branch_bne
                  ,ex_mem_branch_pridictor_bit
                  
                  ,mem_wb_rd
                  ,ex_mem_reg_write
                  ,mem_wb_mem_to_reg
                  ,mem_wb_reg_write
                  ,mem_wb_data_mem_read_data
                  ,mem_wb_data_alu_result
                  
                  
                  ,ex_mem_rd_out
                  ,ex_mem_alu_result_out
                  ,ex_mem_reg_write_out
                  
                  ,pridictor_wrong
                  ,ex_mem_branch_pridictor_bit_out
                  //,ex_mem_mem_read_out
                  //,ex_mem_data_mem_read_data_out
                  );

input 		clk,
        rst_n,
        ex_mem_alu_result,
        ex_mem_reg_read_data2,
        ex_mem_rd,
        ex_mem_mem_read ,          			
        ex_mem_mem_write ,        			
        ex_mem_mem_to_reg,         			
        ex_mem_reg_write,
        ex_mem_branch,
        ex_mem_branch_bne,
        ex_mem_branch_pridictor_bit;

output  mem_wb_mem_to_reg,         	
        mem_wb_reg_write,						
        mem_wb_rd,
        mem_wb_data_mem_read_data,
        mem_wb_data_alu_result,
        
        ex_mem_rd_out,
        ex_mem_alu_result_out,
        ex_mem_reg_write_out,
        
        pridictor_wrong,
        ex_mem_branch_pridictor_bit_out;
        //ex_mem_mem_read_out,
        //ex_mem_data_mem_read_data_out;

wire    clk,
        rst_n;
wire    [`CPU_BUS_SIZE-1:0]ex_mem_alu_result;
wire    [`CPU_BUS_SIZE-1:0]ex_mem_reg_read_data2;
wire    [4:0]ex_mem_rd;
wire    ex_mem_mem_read,           			
        ex_mem_mem_write ,        			
        ex_mem_mem_to_reg,         			
        ex_mem_reg_write, 			
        ex_mem_branch,
        ex_mem_branch_bne;
        
reg     mem_wb_mem_to_reg,         	
        mem_wb_reg_write;						
reg     [4:0]mem_wb_rd;
reg     [`CPU_BUS_SIZE-1:0]mem_wb_data_mem_read_data;
reg     [`CPU_BUS_SIZE-1:0]mem_wb_data_alu_result;

wire    [4:0]ex_mem_rd_out;
wire    [`CPU_BUS_SIZE-1:0]ex_mem_alu_result_out;
wire    ex_mem_reg_write_out;
//wire    [`CPU_BUS_SIZE-1:0]ex_mem_data_mem_read_data_out;
//wire    ex_mem_mem_read_out;

wire [31:0]data_mem_read_data;

wire pridictor_wrong;
wire [1:0]ex_mem_branch_pridictor_bit;
reg  [1:0]ex_mem_branch_pridictor_bit_out;

reg [7 : 0]data_memory[0 : 127];
  initial
    $readmemb("data_memory.txt",data_memory);

 assign data_mem_read_data[7:0]   = ex_mem_mem_read ? data_memory[ ex_mem_alu_result ]:0;
 assign data_mem_read_data[15:8]  = ex_mem_mem_read ? data_memory[ ex_mem_alu_result + 1 ]:0;
 assign data_mem_read_data[23:16] = ex_mem_mem_read ? data_memory[ ex_mem_alu_result + 2 ]:0;
 assign data_mem_read_data[31:24] = ex_mem_mem_read ? data_memory[ ex_mem_alu_result + 3 ]:0;
 
 assign pridictor_wrong = (((ex_mem_branch_pridictor_bit > 2'b01)&&(ex_mem_alu_result != 0)
                         ||(ex_mem_branch_pridictor_bit < 2'b10)&&(ex_mem_alu_result == 0))&&ex_mem_branch)
                         ||
                         (((ex_mem_branch_pridictor_bit > 2'b01)&&(ex_mem_alu_result == 0)
                         ||(ex_mem_branch_pridictor_bit < 2'b10)&&(ex_mem_alu_result != 0))&&ex_mem_branch_bne);

 always @(ex_mem_branch or ex_mem_branch_pridictor_bit or ex_mem_branch_pridictor_bit_out or pridictor_wrong )
  case({ex_mem_branch , ex_mem_branch_pridictor_bit , pridictor_wrong})
    4'b1000 : ex_mem_branch_pridictor_bit_out <= 0;
    4'b1001 : ex_mem_branch_pridictor_bit_out <= 1;
    4'b1010 : ex_mem_branch_pridictor_bit_out <= 0;
    4'b1011 : ex_mem_branch_pridictor_bit_out <= 2;
    4'b1100 : ex_mem_branch_pridictor_bit_out <= 3;
    4'b1101 : ex_mem_branch_pridictor_bit_out <= 1;
    4'b1110 : ex_mem_branch_pridictor_bit_out <= 3;
    4'b1111 : ex_mem_branch_pridictor_bit_out <= 2;
    default : ex_mem_branch_pridictor_bit_out <= ex_mem_branch_pridictor_bit;
  endcase
 
/* 
 data_memory_rom dm1(
							.a(ex_mem_alu_result[6:0]),
							.d(ex_mem_reg_read_data2[7:0]),
							.clk(clk),
							.we(ex_mem_mem_write),
							.spo(data_mem_read_data[7:0])
							);
 data_memory_rom dm2(
							.a(ex_mem_alu_result[6:0] + 7'd1),
							.d(ex_mem_reg_read_data2[15:8]),
							.clk(clk),
							.we(ex_mem_mem_write),
							.spo(data_mem_read_data[15:8])
							);
 data_memory_rom dm3(
							.a(ex_mem_alu_result[6:0] + 7'd2),
							.d(ex_mem_reg_read_data2[23:16]),
							.clk(clk),
							.we(ex_mem_mem_write),
							.spo(data_mem_read_data[23:16])
							);
 data_memory_rom dm4(
							.a(ex_mem_alu_result[6:0] + 7'd3),
							.d(ex_mem_reg_read_data2[31:24]),
							.clk(clk),
							.we(ex_mem_mem_write),
							.spo(data_mem_read_data[31:24])
							);*/
 

 assign ex_mem_rd_out =ex_mem_rd;
 assign ex_mem_alu_result_out =ex_mem_alu_result;
 assign ex_mem_reg_write_out	=ex_mem_reg_write;
 //assign ex_mem_mem_read_out = ex_mem_mem_read;
 //assign ex_mem_data_mem_read_data_out = data_mem_read_data;

always @(posedge clk or negedge rst_n)
  if(!rst_n)
  begin
  
  end
  else
    if(ex_mem_mem_write)
      begin
        data_memory[ ex_mem_alu_result ] <= ex_mem_reg_read_data2[7:0];
        data_memory[ ex_mem_alu_result + 1 ] <= ex_mem_reg_read_data2[15:8];
        data_memory[ ex_mem_alu_result + 2 ] <= ex_mem_reg_read_data2[23:16];
        data_memory[ ex_mem_alu_result + 3 ] <= ex_mem_reg_read_data2[31:24];
      end
//----------------------------mem_wb_mem_to_reg---------------------------    
always @(posedge clk or negedge rst_n)
  if(!rst_n) 
    mem_wb_mem_to_reg <= 0;
  else 
    mem_wb_mem_to_reg <= ex_mem_mem_to_reg ;
    
//----------------------------mem_wb_reg_write---------------------------    
always @(posedge clk or negedge rst_n)
  if(!rst_n) 
    mem_wb_reg_write <= 0;
  else 
    mem_wb_reg_write <= ex_mem_reg_write	;
    
//----------------------------mem_wb_rd---------------------------    
always @(posedge clk or negedge rst_n)
  if(!rst_n) 
    mem_wb_rd <= 0;
  else 
    mem_wb_rd <= ex_mem_rd;
    
//----------------------------mem_wb_data_mem_read_data---------------------------    
always @(posedge clk or negedge rst_n)
  if(!rst_n) 
    mem_wb_data_mem_read_data <= 0;
  else 
  begin
    mem_wb_data_mem_read_data <= data_mem_read_data;
  end


//----------------------------mem_wb_data_alu_result---------------------------    
always @(posedge clk or negedge rst_n)
  if(!rst_n) 
    mem_wb_data_alu_result <= 0;
  else 
    mem_wb_data_alu_result <= ex_mem_alu_result;
    
endmodule





