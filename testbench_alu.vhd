library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

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

	component fulladder4 is 
		port (
		a, b: in bit_vector(3 downto 0);
		c: out bit_vector(3 downto 0);
		vdd, vss, cin: in bit;
		cout: out bit
	  	) ;
	end component;

	--for dut_alu1: alu use entity work.alu(structural_view);
	for dut_alu2: fulladder4 use entity work.fulladder4(fulladder4_struct);

	signal a, b, c: bit_vector(3 downto 0) := X"0";
	signal cout: bit;
	signal b_std: std_logic_vector(3 downto 0) := X"0";

	begin

	--dut_alu1: alu port map(a,b,c,'1','0');
	dut_alu2: fulladder4 port map(a, b, c, '1', '0', '0',cout);
	alu1_sim : process
	begin
		report "STARTING TESTBENCH";

		a <= X"1";


		input_gen : for i in 0 to 15 loop
			wait for 30 ns;
			b_std <= b_std + X"1";
			b <= to_bitvector(b_std);

			assert to_stdlogicvector(c) = to_stdlogicvector(a) + to_stdlogicvector(b) report "ERROR c != a+b" severity ERROR;
		end loop ; -- input_gen
		
	end process ; -- alu1_sim

end architecture ; -- tb_alu