--	Multiplexer

LIBRARY sxlib_ModelSim;

ENTITY mux IS
  PORT (
		a 	: in bit_vector(3 downto 0);
		b 	: in bit_vector(3 downto 0);
		sel 	: in bit;
		s	: out bit_vector(3 downto 0);
                vdd     : in bit;
                vss     : in bit
    );
END mux;

-- Architecture Declaration

ARCHITECTURE behaviour_data_flow OF mux IS

BEGIN

with sel select
	s <= 	a 	when '0',
		b 	when '1';
END;


-- Architecture Declaration

ARCHITECTURE structural_view OF mux IS

  COMPONENT mx2_x2
    PORT (
	  cmd	 : in  BIT;
	  i0	 : in  BIT;
	  i1	 : in  BIT;
	  q	 : out BIT;
	  vdd	 : in  BIT;
	  vss	 : in  BIT);
  end component;

-- instances

BEGIN
  mux_out_0   : mx2_x2 port map(sel, a(0), b(0), s(0), vdd, vss);
  mux_out_1   : mx2_x2 port map(sel, a(1), b(1), s(1), vdd, vss);
  mux_out_2   : mx2_x2 port map(sel, a(2), b(2), s(2), vdd, vss);
  mux_out_3   : mx2_x2 port map(sel, a(3), b(3), s(3), vdd, vss);
end structural_view;
