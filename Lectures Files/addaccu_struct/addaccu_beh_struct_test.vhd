library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Entity declaration for your testbench. Don't declare any ports here
ENTITY testbench_beh_struct IS
END ENTITY testbench_beh_struct;

ARCHITECTURE test_addaccu_beh_struct OF testbench_beh_struct IS

-- Component Declaration for the Device Under Test (DUT)
COMPONENT addaccu IS
-- Just copy and paste the input and output ports of your module as such. 
port ( a : in std_logic_vector (3 downto 0);
       b : in std_logic_vector (3 downto 0);
     sel : in std_logic;
      ck : in std_logic;
     vdd : in std_logic;
     vss : in std_logic;
       s : inout std_logic_vector (3 downto 0)
     );
END COMPONENT addaccu;

FOR dut_beh: addaccu USE ENTITY WORK.addaccu (data_flow);
FOR dut_struct: addaccu USE ENTITY WORK.addaccu (struct);

-- Declare input signals and initialize them
SIGNAL sel : std_logic := '0';
SIGNAL clock : std_logic := '0'; 
SIGNAL vdd : std_logic := '1';
SIGNAL vss : std_logic := '0'; 
SIGNAL a : std_logic_vector (3 downto 0) := X"0";
SIGNAL b : std_logic_vector (3 downto 0) := X"0";

-- Declare two output signals and initialize them
SIGNAL s_beh : std_logic_vector (3 downto 0) := X"0";
SIGNAL s_struct : std_logic_vector (3 downto 0) := X"0";

-- Constants and Clock period definitions
constant clk_period : time := 20 ns;

BEGIN

-- Instantiate the Device Under Test (DUT)
dut_beh: addaccu PORT MAP (a, b, sel, clock, vdd, vss, s_beh);
dut_struct: addaccu PORT MAP (a, b, sel, clock, vdd, vss, s_struct);

-- Clock process definitions( clock with 50% duty cycle )
   clk_process :process
   begin
        clock <= '0';
        wait for clk_period/2;  
        clock <= '1';
        wait for clk_period/2;  
   end process;

-- Stimulus process, refer to clock signal
stim_proc: PROCESS IS
BEGIN

sel <= '0', '1' after 16*clk_period; 	-- Two cases

Report "---- case 1: a held at 2, Loop on all values of B ";
a <= X"2";
b <= X"0";

for i In 0 to 15 loop
	wait for clk_period;  -- Leave time for the output to stabilize
	-- Behavioral functionality check
	Assert s_beh = a + b 
	Report "S not equal to A+B" 
	Severity Error;
	-- Both Structural and Behavioral match at the end of the clock period
	Assert s_beh = s_struct 
	Report "Structural and Behavioral outputs don't match"
	Severity Error;
	b <= b + X"1";   -- b changes only on the next wait statement
end loop;

Report "---- End of case 1 -------------";

Report "---- case 2: a held at 0 (no effect since sel=1), Loop on all values of b ";
a <= X"0";
b <= X"0";

for i In 0 to 15 loop
	wait for clk_period;  -- Leave time for the output to stabilize
	-- Behavioral functionality check
	if i > 0 then
		Assert s_beh = b + s_beh'last_value 
		Report "S not equal to B+S'before"
		Severity Error;
	end if;
	-- Both Structural and Behavioral match at the end of the clock period
	Assert s_beh = s_struct 
	Report "Structural and Behavioral outputs don't match"
	Severity Error;
	b <= b + X"1";   -- b changes only on the next wait statement
end loop;
Report "---- End of case 2 -------------";

WAIT; -- stop process simulation run

END PROCESS;
END ARCHITECTURE test_addaccu_beh_struct;
