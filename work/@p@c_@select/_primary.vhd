library verilog;
use verilog.vl_types.all;
entity PC_Select is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        if_id_pc_write  : in     vl_logic;
        if_id_pc_src    : in     vl_logic;
        branch_pc       : in     vl_logic_vector(31 downto 0);
        pc_plus_4_wire  : in     vl_logic_vector(31 downto 0);
        pc_jump         : in     vl_logic_vector(31 downto 0);
        pc_select_jump  : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0)
    );
end PC_Select;
