ENTITY sff1_x4 IS
GENERIC (
  CONSTANT area 	 : NATURAL := 4500;
  CONSTANT cin_ck	 : NATURAL := 8;
  CONSTANT cin_i	 : NATURAL := 8;
  CONSTANT rdown_ck_q	 : NATURAL := 800;
  CONSTANT rup_ck_q	 : NATURAL := 890;
  CONSTANT taf_ck_q	 : NATURAL := 500;
  CONSTANT tar_ck_q	 : NATURAL := 500;
  CONSTANT thf_i_ck	 : NATURAL := 0;
  CONSTANT thr_i_ck	 : NATURAL := 0;
  CONSTANT tsf_i_ck	 : NATURAL := 585;
  CONSTANT tsr_i_ck	 : NATURAL := 476;
  CONSTANT transistors	 : NATURAL := 26
);
PORT (
  ck	 : in  BIT;
  i	 : in  BIT;
  q	 : out BIT;
  vdd	 : in  BIT;
  vss	 : in  BIT
);
END sff1_x4;

ARCHITECTURE VBE OF sff1_x4 IS

BEGIN
  ASSERT ((vdd and not (vss)) = '1')
  REPORT "power supply is missing on sff1_x4"
  SEVERITY WARNING;

  PROCESS ( ck )
  BEGIN
    IF  ((ck = '1') AND ck'EVENT)
    THEN q <= i after 1700 ps;
    END IF;
  END PROCESS;
END;
