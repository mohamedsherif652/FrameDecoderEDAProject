library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Adder accumulator 4 std_logics

entity addaccu is 
port ( a : in std_logic_vector (3 downto 0);
       b : in std_logic_vector (3 downto 0);
     sel : in std_logic;
      ck : in std_logic;
     vdd : in std_logic;
     vss : in std_logic;
       s : inout std_logic_vector (3 downto 0)
     );
end addaccu;


ARCHITECTURE struct OF addaccu IS

-- Signals, declared as bits since all standard cells are bits
SIGNAL a_bit : bit_vector(3 downto 0);
SIGNAL b_bit : bit_vector(3 downto 0);
SIGNAL sel_bit : bit;
SIGNAL ck_bit : bit;
SIGNAL vdd_bit : bit := '1';
SIGNAL vss_bit : bit := '0';
SIGNAL s_bit : bit_vector(3 downto 0);
SIGNAL mux_out : bit_vector(3 downto 0);
SIGNAL reg_out: bit_vector(3 downto 0);

-- Model Declaration :

-- Multiplexer

COMPONENT mux 
  PORT (
		a 	: in bit_vector(3 downto 0);
		b 	: in bit_vector(3 downto 0);
		sel 	: in bit;
		s	: out bit_vector(3 downto 0);
                vdd     : in bit;
                vss     : in bit
    );
END COMPONENT;

-- Adder 

COMPONENT  alu 
  PORT (
		a 	: in bit_vector(3 downto 0);
		b 	: in bit_vector(3 downto 0);
		s	: out bit_vector(3 downto 0);
                vdd     : in bit;
                vss     : in bit
    );
END  COMPONENT;

-- Accumulator

COMPONENT accu 
  PORT (
		i 	: in bit_vector(3 downto 0);
		ck 	: in bit;
		o	: out bit_vector(3 downto 0);
                vdd     : in bit;
                vss     : in bit
    );
END COMPONENT;

-- Use either behavioral or structural instances
-- Behavioral instances
-- FOR accumulator	: accu USE ENTITY WORK.accu (behaviour_data_flow);
-- FOR adder 	: alu  USE ENTITY WORK.alu (behaviour_data_flow);
-- FOR multiplexer	: mux USE ENTITY WORK.mux (behaviour_data_flow);

-- Structural instances
FOR accumulator	: accu USE ENTITY WORK.accu (structural_view);
FOR adder 	: alu  USE ENTITY WORK.alu (structural_view);
FOR multiplexer	: mux USE ENTITY WORK.mux (structural_view);

begin

-- Type conversion from std_logic to bit (all standard cells use bit)
a_bit <= to_bitvector(a);
b_bit <= to_bitvector(b);
sel_bit <= to_bit(sel);
ck_bit <= to_bit(ck);
vdd_bit <= to_bit(vdd);
vss_bit <= to_bit(vss);

-- instances
adder 		: alu 	PORT MAP (b_bit,mux_out,s_bit,vdd_bit,vss_bit);
accumulator	: accu	PORT MAP (s_bit,ck_bit,reg_out,vdd_bit,vss_bit);
multiplexer	: mux	PORT MAP (a_bit,reg_out,sel_bit,mux_out,vdd_bit,vss_bit);

-- Output Type conversion from bit to std_logic
s <= to_stdlogicvector(s_bit);

end struct;
