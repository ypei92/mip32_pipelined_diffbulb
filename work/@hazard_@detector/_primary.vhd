library verilog;
use verilog.vl_types.all;
entity Hazard_Detector is
    port(
        if_id_rt        : in     vl_logic_vector(4 downto 0);
        if_id_rs        : in     vl_logic_vector(4 downto 0);
        id_ex_rt        : in     vl_logic_vector(4 downto 0);
        id_ex_mem_read  : in     vl_logic;
        pridictor_wrong : in     vl_logic;
        if_id_pc_write  : out    vl_logic;
        if_id_write_from_hazard_detector: out    vl_logic;
        id_mux_load_use : out    vl_logic
    );
end Hazard_Detector;
