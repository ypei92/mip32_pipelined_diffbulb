library verilog;
use verilog.vl_types.all;
entity Registers is
    generic(
        pos_extend      : vl_logic_vector(0 to 15) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        neg_extend      : vl_logic_vector(0 to 15) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        instruction     : in     vl_logic_vector(31 downto 0);
        id_ex_rt_in     : in     vl_logic_vector(4 downto 0);
        id_ex_mem_read_in: in     vl_logic;
        mem_wb_reg_write: in     vl_logic;
        mem_wb_mem_to_reg: in     vl_logic;
        mem_wb_rd       : in     vl_logic_vector(4 downto 0);
        mem_wb_alu_result: in     vl_logic_vector(31 downto 0);
        mem_wb_data_mem_read_data: in     vl_logic_vector(31 downto 0);
        pridictor_wrong : in     vl_logic;
        if_id_branch_pridictor_bit: in     vl_logic_vector(1 downto 0);
        id_ex_reg_read_data1: out    vl_logic_vector(31 downto 0);
        id_ex_reg_read_data2: out    vl_logic_vector(31 downto 0);
        id_ex_rs        : out    vl_logic_vector(4 downto 0);
        id_ex_rt        : out    vl_logic_vector(4 downto 0);
        id_ex_rd        : out    vl_logic_vector(4 downto 0);
        id_ex_sign_extended: out    vl_logic_vector(31 downto 0);
        mem_wb_write_data: out    vl_logic_vector(31 downto 0);
        if_id_pc_write  : out    vl_logic;
        if_id_write_from_hazard_detector: out    vl_logic;
        id_ex_reg_dst   : out    vl_logic;
        id_ex_alu_op    : out    vl_logic_vector(3 downto 0);
        id_ex_alu_src   : out    vl_logic;
        id_ex_mem_read  : out    vl_logic;
        id_ex_mem_write : out    vl_logic;
        id_ex_mem_to_reg: out    vl_logic;
        id_ex_reg_write : out    vl_logic;
        id_ex_branch    : out    vl_logic;
        id_ex_branch_bne: out    vl_logic;
        id_ex_branch_pridictor_bit: out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of pos_extend : constant is 1;
    attribute mti_svvh_generic_type of neg_extend : constant is 1;
end Registers;
