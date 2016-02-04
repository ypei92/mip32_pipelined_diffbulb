library verilog;
use verilog.vl_types.all;
entity Instruction_Memory is
    generic(
        pos_extend      : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        neg_extend      : vl_logic_vector(0 to 15) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        if_id_write_from_hazard_detector: in     vl_logic;
        if_id_pc_write  : in     vl_logic;
        pc              : in     vl_logic_vector(31 downto 0);
        ex_mem_branch_pridictor_bit_out: in     vl_logic_vector(1 downto 0);
        pridictor_wrong : in     vl_logic;
        instruction     : out    vl_logic_vector(31 downto 0);
        pc_plus_4_wire  : out    vl_logic_vector(31 downto 0);
        pc_jump         : out    vl_logic_vector(31 downto 0);
        pc_select_jump  : out    vl_logic;
        pc_branch_address: out    vl_logic_vector(31 downto 0);
        if_id_branch_pridictor_bit: out    vl_logic_vector(1 downto 0);
        if_id_pc_src    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of pos_extend : constant is 1;
    attribute mti_svvh_generic_type of neg_extend : constant is 1;
end Instruction_Memory;
