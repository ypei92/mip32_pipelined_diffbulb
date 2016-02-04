library verilog;
use verilog.vl_types.all;
entity Data_Memory is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        ex_mem_alu_result: in     vl_logic_vector(31 downto 0);
        ex_mem_reg_read_data2: in     vl_logic_vector(31 downto 0);
        ex_mem_rd       : in     vl_logic_vector(4 downto 0);
        ex_mem_mem_read : in     vl_logic;
        ex_mem_mem_write: in     vl_logic;
        ex_mem_mem_to_reg: in     vl_logic;
        ex_mem_branch   : in     vl_logic;
        ex_mem_branch_bne: in     vl_logic;
        ex_mem_branch_pridictor_bit: in     vl_logic_vector(1 downto 0);
        mem_wb_rd       : out    vl_logic_vector(4 downto 0);
        ex_mem_reg_write: in     vl_logic;
        mem_wb_mem_to_reg: out    vl_logic;
        mem_wb_reg_write: out    vl_logic;
        mem_wb_data_mem_read_data: out    vl_logic_vector(31 downto 0);
        mem_wb_data_alu_result: out    vl_logic_vector(31 downto 0);
        ex_mem_rd_out   : out    vl_logic_vector(4 downto 0);
        ex_mem_alu_result_out: out    vl_logic_vector(31 downto 0);
        ex_mem_reg_write_out: out    vl_logic;
        pridictor_wrong : out    vl_logic;
        ex_mem_branch_pridictor_bit_out: out    vl_logic_vector(1 downto 0)
    );
end Data_Memory;
