library ieee;
use ieee.std_logic_1164.all;

entity frame_decoder is
  port (
	vdd, vss, clk, reset: in bit;
	err: out bit;
	word_in: in std_logic_vector(7 downto 0);
	address, data: inout std_logic_vector(7 downto 0)
  );
end entity ; -- frame_decoder

architecture fd_fsm_mealy of frame_decoder is
	
	type STATE is (S1, S2, S3, S4, S5, S6, S7, S8, S9);
	signal current_state, next_state: STATE;
	

--two process mealy

begin

	reset_and_clk_gen : process(clk)
	begin
		if rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process ; -- reset_and_clk_gen

	next_state_generator : process(current_state, word_in, reset)
	variable vaddress : std_logic_vector(7 downto 0) := X"00";
	variable vdata : std_logic_vector(7 downto 0) := X"00";
	begin
		if reset = '1' then
			next_state <= S1;
			vaddress := X"00";
			vdata := X"00";
			err <= '0';
			data <= vdata;
			address <= vaddress;
		else
			case current_state is
			when S1 =>
				if word_in = X"7E" then			
					address <= vaddress;
					data <= vdata;
					err <= '0';
					next_state <= S2;
				else
					address <= vaddress;
					data <= vdata;
					err <= '0';		
					next_state <= S1;
				end if ;

			when S2 =>
				if word_in = X"80" then
					address <= vaddress;
					data <= vdata;
					err <= '0';
					next_state <= S3;
				elsif word_in = X"81" then
					address <= vaddress;
					data <= vdata;
					err <= '0';
					next_state <= S4;
				else
					address <= vaddress;
					data <= vdata;
					err <= '1';
					next_state <= S1;
				end if ;

			when S3 =>
				address <= word_in;
				vaddress :=  address;
				data <= vdata;
				err <= '0';
				next_state <= S5;

			when S5 =>
				address <= vaddress;
				data <= word_in;
				vdata := data;
				err <= '0';
				next_state <= S7;
			when S7 =>
				
				if word_in = X"E7" then
					address <= vaddress;
					data <= vdata;
					err <= '0';
					next_state <= S1;
				else

					address <= vaddress;
					data <= vdata;
					err <= '1';
					next_state <= S1;
				end if ;

			when S4 => 
				
				address <= word_in;
				vaddress := address;
				data <= vdata;
				err <= '0';
				next_state <= S6;

			when S6 =>
				address <= vaddress;
				data <= word_in;
				vdata := vdata;
				err <= '0';
				next_state <= S8;

			when S8 =>
				data <= word_in;
				vdata := data;
				address <= vaddress;
				err <= '0';
				next_state <= S9;

			when S9 =>
				if word_in = X"E7" then
					address <= vaddress;
					data <= vdata;
					err <= '0';
					next_state <= S1;
				else
					address <= vaddress;
					data <= vdata;
					err <= '1';		
					next_state <= S1;	
				end if ;
			end case ;
		end if ;

	end process ; -- next_state_generator

end architecture ; -- fd_fsm_mealy