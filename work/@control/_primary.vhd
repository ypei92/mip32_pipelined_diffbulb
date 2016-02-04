library verilog;
use verilog.vl_types.all;
entity Control is
    generic(
        OP_TYPE_ALU     : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        OP_TYPE_JUMP    : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        OP_TYPE_BEQ     : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        OP_TYPE_BNE     : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1);
        OP_TYPE_LW      : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi0, Hi1, Hi1);
        OP_TYPE_SW      : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi1, Hi0, Hi1, Hi1);
        OP_TYPE_ADDI    : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        OP_TYPE_ANDI    : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi1, Hi1, Hi0, Hi0);
        OP_TYPE_ORI     : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi1, Hi1, Hi0, Hi1);
        OP_TYPE_SLTI    : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi1, Hi0, Hi1, Hi0);
        OP_TYPE_XORI    : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi1, Hi1, Hi1, Hi0);
        FUNC_TYPE_ADD   : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        FUNC_TYPE_SUB   : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi0, Hi1, Hi0);
        FUNC_TYPE_AND   : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi1, Hi0, Hi0);
        FUNC_TYPE_OR    : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi1, Hi0, Hi1);
        FUNC_TYPE_SLT   : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi1, Hi0, Hi1, Hi0);
        FUNC_TYPE_XOR   : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi1, Hi1, Hi0);
        FUNC_TYPE_NOR   : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi1, Hi1, Hi1)
    );
    port(
        instruction_op  : in     vl_logic_vector(5 downto 0);
        reg_dst         : out    vl_logic;
        jump            : out    vl_logic;
        mem_read        : out    vl_logic;
        mem_to_reg      : out    vl_logic;
        mem_write       : out    vl_logic;
        alu_src         : out    vl_logic;
        reg_write       : out    vl_logic;
        alu_op          : out    vl_logic_vector(3 downto 0);
        branch          : out    vl_logic;
        branch_bne      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of OP_TYPE_ALU : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_JUMP : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_BEQ : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_BNE : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_LW : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_SW : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_ADDI : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_ANDI : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_ORI : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_SLTI : constant is 1;
    attribute mti_svvh_generic_type of OP_TYPE_XORI : constant is 1;
    attribute mti_svvh_generic_type of FUNC_TYPE_ADD : constant is 1;
    attribute mti_svvh_generic_type of FUNC_TYPE_SUB : constant is 1;
    attribute mti_svvh_generic_type of FUNC_TYPE_AND : constant is 1;
    attribute mti_svvh_generic_type of FUNC_TYPE_OR : constant is 1;
    attribute mti_svvh_generic_type of FUNC_TYPE_SLT : constant is 1;
    attribute mti_svvh_generic_type of FUNC_TYPE_XOR : constant is 1;
    attribute mti_svvh_generic_type of FUNC_TYPE_NOR : constant is 1;
end Control;
