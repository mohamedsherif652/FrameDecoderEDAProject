entity alu_testbench is

end entity ; -- alu_testbench

architecture alu_tb of alu_testbench is
	
	component fulladder4
	port (
	a, b: in bit_vector(3 downto 0);
	c: out bit_vector(3 downto 0);
	vdd, vss, cin: in bit;
	cout: out bit
  ) ;
    end component;

    for dut: fulladder4 use entity work.fulladder4(fulladder4_struct);

	signal x, y : bit_vector(3 downto 0);
	signal cout : bit;
	signal z: bit_vector(3 downto 0);

	constant clk_period: time := 50ns;

	begin
		dut: fulladder4 port map (x,y,z,'1','0','0',cout);
		--clk_gen : process
		--begin
		--	clk <= '1';
		--	wait for clk_period/2;
		--	clk <= '0';
		--	wait for clk_period/2;
		--end process; -- clk_gen

		testing_process : process
		begin
			x <= "0000";
			y <= "0000";
			wait for 50 ns;
			assert z = "0000" report "Error Case 1 Failed" severity error;
			--wait for clk_period;
			x <= "1111";
			y <= "1111";
			wait for 50 ns;
			assert z = "0000" report "Error Case 2 Failed" severity error;
			--wait for clk_period;
			x <= "0110";
			y <= "1101";
			wait for 50 ns;
			assert z = "0011" report "Error Case 3 Failed" severity error;
			--wait for clk_period;
			x <= "0001";
			y <= "1000";
			wait for 50 ns;
			assert z = "1001" report "Error Case 4 Failed" severity error;
			--wait for clk_period;
		end process ; -- testing_process

end architecture ; -- alu_td