
all: placement routing core_layout_verification chip_assembly symbolic_to_real_conv

placement: frame_decoder_final_output.ioc frame_decoder_final_output.vst
	ocp -v -ring -ioc frame_decoder_final_output frame_decoder_final_output frame_decoder_final_output > ocp.out

routing: 
	export MBK_IN_LO=vst; \
	export MBK_OUT_PH=ap; \
	nero -V -p frame_decoder_final_output frame_decoder_final_output frame_decoder_final_output > nero.out

core_layout_verification: frame_decoder_final_output.vst frame_decoder_final_output.ap
	export MBK_OUT_LO=al; \
	export RDS_TECHNO_NAME=/home/alliance/techno/techno-035.rds; \
	cougar -v frame_decoder_final_output frame_decoder_final_output > cougar_core.out
	lvx vst al frame_decoder_final_output frame_decoder_final_output -f > lvx_core.out
		export RDS_TECHNO_NAME=/home/alliance/techno/techno-symb.rds; \
	druc frame_decoder_final_output > druc_core.out

chip_assembly: chip.rin chip.vst
	ring chip chip_layout > ring.out

symbolic_to_real_conv: chip_layout.ap
	export RDS_OUT=cif; \
	export RDS_TECHNO_NAME=/home/alliance/techno/techno-035.rds; \
	s2r -v -r chip_layout > s2r.out

chip_layout_verification: chip_layout.ap chip.vst frame_decoder_final_output.al
	export MBK_OUT_LO=al; \
	export RDS_TECHNO_NAME=/home/alliance/techno/techno-035.rds; \
	cougar -v chip_layout cougar_out_chip > cougar_chip.out
	lvx vst al chip cougar_out_chip -f > lvx_chip.out
	export RDS_TECHNO_NAME=/home/alliance/techno/techno-symb.rds; \
	druc chip_layout > druc_chip.out
