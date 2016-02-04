`include "DesignName_parameters.v"
module Hazard_Detector( if_id_rt
                      , if_id_rs
                      , id_ex_rt
                      , id_ex_mem_read
                      , pridictor_wrong
                      
                      , if_id_pc_write
                      , if_id_write_from_hazard_detector
                      , id_mux_load_use
                      );
  input if_id_rt, if_id_rs, id_ex_rt, id_ex_mem_read ,pridictor_wrong;
  output if_id_pc_write, if_id_write_from_hazard_detector, id_mux_load_use;
  
  wire [4:0]if_id_rt , if_id_rs , id_ex_rt;
  wire id_ex_mem_read;
  
  wire if_id_pc_write;
  wire if_id_write_from_hazard_detector;
  wire if_mux_load_use;
  
  wire load_use_or_not;
  
  assign load_use_or_not = (id_ex_mem_read)&((id_ex_rt == if_id_rt)|(id_ex_rt == if_id_rs));
  assign if_id_pc_write = (load_use_or_not &&(!pridictor_wrong))?0:1;
  //assign if_id_pc_write = (load_use_or_not)?0:1;
  assign if_id_write_from_hazard_detector = (load_use_or_not || pridictor_wrong )?0:1;
  assign id_mux_load_use = (load_use_or_not || pridictor_wrong )?0:1;
  
endmodule
