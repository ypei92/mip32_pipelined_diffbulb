library verilog;
use verilog.vl_types.all;
entity forwarding_2 is
    port(
        if_id_rs        : in     vl_logic_vector(4 downto 0);
        if_id_rt        : in     vl_logic_vector(4 downto 0);
        id_ex_rd        : in     vl_logic_vector(4 downto 0);
        id_ex_alu_result_out: in     vl_logic_vector(31 downto 0);
        ex_mem_rd       : in     vl_logic_vector(4 downto 0);
        ex_mem_alu_result_out: in     vl_logic_vector(31 downto 0);
        ex_mem_mem_read_data_out: in     vl_logic_vector(31 downto 0);
        read_data_wire_1: in     vl_logic_vector(31 downto 0);
        read_data_wire_2: in     vl_logic_vector(31 downto 0);
        id_ex_reg_write : in     vl_logic;
        ex_mem_reg_write: in     vl_logic;
        ex_mem_mem_read : in     vl_logic;
        equal_out       : out    vl_logic
    );
end forwarding_2;
