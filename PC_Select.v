`include "DesignName_parameters.v"
module PC_Select( clk
                 ,rst_n
                 ,if_id_pc_write
                 ,if_id_pc_src
                 ,branch_pc
                 ,pc_plus_4_wire
                 ,pc_jump
                 ,pc_select_jump
                 
                 ,pc
                 );

input clk ,
      rst_n,
      if_id_pc_src,
      if_id_pc_write,
      branch_pc,
      pc_plus_4_wire,
      pc_jump,
      pc_select_jump;
output pc;

reg [`CPU_BUS_SIZE-1:0]pc;
wire clk,rst_n;
wire if_id_pc_src;
wire if_id_pc_write;
wire pc_select_jump;
wire [`CPU_BUS_SIZE-1:0]branch_pc;
wire [`CPU_BUS_SIZE-1:0]pc_plus_4_wire;
wire [`CPU_BUS_SIZE-1:0]pc_jump;

wire [`CPU_BUS_SIZE-1:0]pc_result_0;
wire [`CPU_BUS_SIZE-1:0]pc_result;

assign pc_result_0 = pc_select_jump ? pc_jump : pc_plus_4_wire;
assign pc_result = if_id_pc_src ? branch_pc : pc_result_0;

always @(posedge clk or negedge rst_n)   
begin
  if (!rst_n)
    pc <= 32'b0;
  else if(if_id_pc_write)
    pc <= pc_result;
end

endmodule
