ENTITY sff2_x4 IS
GENERIC (
  CONSTANT area 	 : NATURAL := 6000;
  CONSTANT cin_ck	 : NATURAL := 8;
  CONSTANT cin_cmd	 : NATURAL := 16;
  CONSTANT cin_i0	 : NATURAL := 8;
  CONSTANT cin_i1	 : NATURAL := 7;
  CONSTANT rdown_ck_q	 : NATURAL := 800;
  CONSTANT rup_ck_q	 : NATURAL := 890;
  CONSTANT taf_ck_q	 : NATURAL := 500;
  CONSTANT tar_ck_q	 : NATURAL := 500;
  CONSTANT thf_cmd_ck	 : NATURAL := 0;
  CONSTANT thf_i0_ck	 : NATURAL := 0;
  CONSTANT thf_i1_ck	 : NATURAL := 0;
  CONSTANT thr_cmd_ck	 : NATURAL := 0;
  CONSTANT thr_i0_ck	 : NATURAL := 0;
  CONSTANT thr_i1_ck	 : NATURAL := 0;
  CONSTANT tsf_cmd_ck	 : NATURAL := 833;
  CONSTANT tsf_i0_ck	 : NATURAL := 764;
  CONSTANT tsf_i1_ck	 : NATURAL := 764;
  CONSTANT tsr_cmd_ck	 : NATURAL := 770;
  CONSTANT tsr_i0_ck	 : NATURAL := 666;
  CONSTANT tsr_i1_ck	 : NATURAL := 666;
  CONSTANT transistors	 : NATURAL := 34
);
PORT (
  ck	 : in  BIT;
  cmd	 : in  BIT;
  i0	 : in  BIT;
  i1	 : in  BIT;
  q	 : out BIT;
  vdd	 : in  BIT;
  vss	 : in  BIT
);
END sff2_x4;

ARCHITECTURE VBE OF sff2_x4 IS

BEGIN
  ASSERT ((vdd and not (vss)) = '1')
  REPORT "power supply is missing on sff2_x4"
  SEVERITY WARNING;

  PROCESS ( ck )
  BEGIN
    IF  ((ck = '1') AND ck'EVENT)
    THEN q <= ((i1 AND cmd) OR (i0 AND NOT(cmd))) after 2000 ps;
    END IF;
  END PROCESS;
 
END;
