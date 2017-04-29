library sxlib_ModelSim;

entity mux4 is
  port (
	x, y: in bit_vector(3 downto 0);
	slct, vdd, vss: in bit;
	muxout: out bit_vector(3 downto 0)
  ) ;
end entity mux4; -- mux4

architecture mux4_struct of mux4 is
	component mx2_x2 port(cmd	 : in  bit; i0	 : in  bit; i1	 : in  bit; q	 : out bit; vdd	 : in  bit; vss	 : in  bit);
	end component;
begin
	mux_out_0: mx2_x2 port map(slct, x(0), y(0), muxout(0), vdd, vss);
	mux_out_1: mx2_x2 port map(slct, x(1), y(1), muxout(1), vdd, vss);
	mux_out_2: mx2_x2 port map(slct, x(2), y(2), muxout(2), vdd, vss);
	mux_out_3: mx2_x2 port map(slct, x(3), y(3), muxout(3), vdd, vss);

end architecture mux4_struct; -- mux4_struct

entity fulladder1 is
  port (
	a, b, cin, vss, vdd: in bit;
	cout, s: out bit
  ) ;
end entity ; -- fulladder1

architecture fulladder1_sturct of fulladder1 is

	signal s1, s2, s3: bit;
	component na2_x1 PORT (
	  i0	 : in  BIT;
	  i1	 : in  BIT;
	  nq	 : out BIT;
	  vdd	 : in  BIT;
	  vss	 : in  BIT
	);
	end component;

	component xr2_x1 PORT (
	  i0	 : in  BIT;
	  i1	 : in  BIT;
	  q	     : out BIT;
	  vdd	 : in  BIT;
	  vss	 : in  BIT
	);
	end component;

	component o2_x2 PORT (
	  i0	 : in  BIT;
	  i1	 : in  BIT;
	  q	     : out BIT;
	  vdd	 : in  BIT;
	  vss	 : in  BIT
	);
	end component;

begin
	--nand1: na2_x1 port map (a, b, s1, vdd, vss);
	--nand2: na2_x1 port map (s1, s2, cout, vdd, vss);
	--nand3: na2_x1 port map (s3, cin, s2, vdd, vss);
	--xor1: xr2_x1 port map (a, b, s3, vdd, vss);
	--xor2: xr2_x1 port map (s3, cin, s, vdd, vss);
	xor1: xr2_x1 port map(a, b, s1, vdd, vss);
	xor2: xr2_x1 port map(s1, cin, s, vdd, vss);
	nand1: na2_x1 port map(s1, cin, s2, vdd, vss);
	nand2: na2_x1 port map(a, b, s3, vdd, vss);
	nand3: na2_x1 port map(s2, s3, cout, vdd, vss);

end architecture ; -- fulladder1_sturct

entity fulladder4 is
  port (
	a, b: in bit_vector(3 downto 0);
	c: out bit_vector(3 downto 0);
	vdd, vss, cin: in bit;
	cout: out bit
  ) ;
end entity ; -- fulladder4

architecture fulladder4_struct of fulladder4 is

	signal c1, c2, c3 : bit;
	component fulladder1 port (
		a, b, cin, vss, vdd: in bit;
		cout, s: out bit
	);
	end component;

begin
	fa0: fulladder1 port map(a(0), b(0), cin, vss, vdd, c1, c(0));
	fa1: fulladder1 port map(a(1), b(1), c1, vss, vdd, c2, c(1));
	fa2: fulladder1 port map(a(2), b(2), c2, vss, vdd, c3, c(2));
	fa3: fulladder1 port map(a(3), b(3), c3, vss, vdd, cout, c(3));

end architecture ; -- fulladder4_struct

entity accu is
  port (
	clk, vdd, vss: in bit;
	d: in bit_vector(3 downto 0);
	q: out bit_vector(3 downto 0)
  ) ;
end entity accu; -- accu

architecture accu_struct of accu is

	component sff1_x4 PORT (
	  ck	 : in  BIT;
	  i	     : in  BIT;
	  q	     : out BIT;
	  vdd	 : in  BIT;
	  vss	 : in  BIT
	);
	end component;

begin
	i0: sff1_x4 port map (clk, d(0), q(0), vdd, vss);
	i1: sff1_x4 port map (clk, d(1), q(1), vdd, vss);
	i2: sff1_x4 port map (clk, d(2), q(2), vdd, vss);
	i3: sff1_x4 port map (clk, d(3), q(3), vdd, vss);

end architecture ; -- accu_struct

entity adder_acc is
  port (
	clk, vdd, vss: in bit;
	a, b: in bit_vector(3 downto 0);
	s: inout bit_vector(3 downto 0)
  ) ;
end entity adder_acc; -- adder_acc

architecture adder_acc_struct of adder_acc is

	signal adderout, muxout : bit_vector(3 downto 0);
	signal s1: bit;

	component mux4 port (
		x, y: in bit_vector(3 downto 0);
		slct, vdd, vss: in bit;
		muxout: out bit_vector(3 downto 0)
	);
	end component;

	component accu port (
		clk, vdd, vss: in bit;
		d: in bit_vector(3 downto 0);
		q: out bit_vector(3 downto 0)
	);
	end component;

	component fulladder4 port (
		a, b: in bit_vector(3 downto 0);
		c: out bit_vector(3 downto 0);
		vdd, vss, cin: in bit;
		cout: out bit
	);
	end component;

begin
	mux: mux4 port map (s, a, clk, vdd, vss, muxout);
	adder: fulladder4 port map(muxout, b, adderout, vdd, vss, '0', s1);
	accumulator: accu port map(clk, vdd, vss, adderout, s);

end architecture ; -- adder_lec_struct

entity mux2in is 
	port(
		x,y: in std_vector(7 downto 0);
		z: out std_vector(7 downto 0);
		slct: in bit
	);
end entity;
