entity testbench_alu is

end entity ; -- testbench_alu

architecture tb_alu of testbench_alu is
	component alu is
		PORT (
		a 	: in bit_vector(3 downto 0);
		b 	: in bit_vector(3 downto 0);
		s	: out bit_vector(3 downto 0);
                vdd     : in bit;
                vss     : in bit
    );
	end component;

	for dut_alu1: alu use entity work.alu(structural_view);

	signal a, b, c: bit_vector(3 downto 0);
	BEGIN
	dut_alu1: alu port map(a,b,c,'1','0');


	alu1_sim : process
	begin
		report "STARTING TESTBENCH";

		a <= X"1";

		input_gen : for i in 0 to 15 loop
			wait for 30 ns;
			b <= b + X"1";

			assert c = a + b report "ERROR c != a+b" severity ERROR;
		end loop ; -- input_gen
		
	end process ; -- alu1_sim

end architecture ; -- tb_alu