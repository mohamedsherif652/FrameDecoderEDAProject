library ieee;
use ieee.std_logic_1164.all;

entity testbench is

end entity ; -- testbench

architecture arch of testbench is
	signal sclk :  bit;
	signal svss: bit := '0';
	signal svdd: bit := '1';
	signal sreset: bit := '1';
	signal serr: bit;
	signal sdata: std_logic_vector(7 downto 0);
	signal saddress: std_logic_vector(7 downto 0);
	signal sword_in: std_logic_vector(7 downto 0) := X"00";

	constant clk_cycle : time := 100 ns;
	constant clk_cycle_in : time := 95 ns;	

	component frame_decoder is 
		port (
			vdd, vss, clk, reset: in bit;
			err: out bit;
			word_in: in std_logic_vector(7 downto 0);
			address, data: inout std_logic_vector(7 downto 0)
 	 	);
	end component;

	for dut: frame_decoder use entity work.frame_decoder;

	begin
	dut: frame_decoder port map('1','0',sclk,sreset,serr,sword_in,saddress,sdata);

	clk_gen : process
	begin
		sclk <= '1';
		wait for clk_cycle/2;
		sclk <= '0';
		wait for clk_cycle/2;
	end process ; -- clk_gen

	input_gen : process
	begin
		report "Beginning Test, Resetting";
		sreset <= '1';
		wait for clk_cycle;
		sreset <= '0';
		wait for clk_cycle;
		report "Reset done, starting input";
		sword_in <= X"EE";
		wait for 5 ns;
		assert serr = '0' and saddress = X"00" and sdata = X"00" report "Error in SOF" severity error;
		wait for clk_cycle_in;
		sword_in <= X"7E";
		wait for 5 ns;
		assert serr = '0' and saddress = X"00" and sdata = X"00" report "Error in SOF" severity error;
		wait for clk_cycle_in;
		sword_in <= X"FF";
		wait for 5 ns;
		assert serr = '1' and saddress = X"00" and sdata = X"00" report "Error in input not 80 or 81" severity error;
		wait for clk_cycle_in;
		sword_in <= X"7E";
		wait for 5 ns;
		assert serr = '0' and saddress = X"00" and sdata = X"00" report "Error" severity error;
		wait for clk_cycle_in;
		sword_in <= X"80";
		wait for 5 ns;
		assert serr = '0' and saddress = X"00" and sdata = X"00" report "Error" severity error;
		wait for clk_cycle_in;
		sword_in <= X"FF";
		wait for 5 ns;
		assert serr = '0' and saddress = X"FF" and sdata = X"00" report "Error in assigning address" severity error;
		wait for clk_cycle_in;
		sword_in <= X"EE";
		wait for 5 ns;
		assert serr = '0' and saddress = X"FF" and sdata = X"EE" report "Error in assigning data" severity error;
		wait for clk_cycle_in;
		sword_in <= X"E7";
		wait for 5 ns;
		assert serr = '0' and saddress = X"FF" and sdata = X"EE" report "Error in EOF" severity error;
		wait for clk_cycle_in;
		sword_in <= X"7E";
		wait for 5 ns;
		assert serr = '0' and saddress = X"FF" and sdata = X"EE" report "Error in SOF" severity error;
		wait for clk_cycle_in;
		sword_in <= X"81";
		wait for 5 ns;
		assert serr = '0' and saddress = X"FF" and sdata = X"EE" report "Error in checking ID" severity error;
		wait for clk_cycle_in;
		sword_in <= X"AC";
		wait for 5 ns;
		assert serr = '0' and saddress = X"AC" and sdata = X"EE" report "Error in Assigning Address" severity error;
		wait for clk_cycle_in;
		sword_in <= X"BF";
		wait for 5 ns;
		assert serr = '0' and saddress = X"AC" and sdata = X"BF" report "Error in assigning MSB" severity error;
		wait for clk_cycle_in;
		sword_in <= X"9F";
		wait for 5 ns;
		assert serr = '0' and saddress = X"AC" and sdata = X"9F" report "Error in assigning LSB" severity error;
		wait for clk_cycle_in;
		sword_in <= X"AA";
		wait for 5 ns;
		assert serr = '1' and saddress = X"AC" and sdata = X"9F" report "Error EOF" severity error;
		wait for clk_cycle_in;
		sword_in <= X"7F";
		wait for 5 ns;
		assert serr = '0' and saddress = X"AC" and sdata = X"9F" report "Error in SOF" severity error;
		wait for clk_cycle_in;
		sword_in <= X"FF";
		wait for 5 ns;
		assert serr = '0' and saddress = X"AC" and sdata = X"9F" report "Error in SOF" severity error;
		wait for clk_cycle_in;
		report "END TEST BENCH";
		wait for 5 ns;

	end process ; -- input_gen
end architecture ; -- arch