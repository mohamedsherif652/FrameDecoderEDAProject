optimized_file=frame_decoder_j_mapped
optimized_file_syf=frame_decoder_j
looned_file=frame_decoder_j_looned
all: syf boom boog loon netlist_check


syf: frame_decoder.fsm
	@echo "Starting SYF"
	@echo "Generating with all encodings"
	syf -a -CEV frame_decoder frame_decoder_a > syf_a.out
	syf -o -CEV frame_decoder frame_decoder_o > syf_o.out
	syf -r -CEV frame_decoder frame_decoder_r > syf_r.out
	syf -m -CEV frame_decoder frame_decoder_m > syf_m.out
	syf -j -CEV frame_decoder frame_decoder_j > syf_j.out

boom: frame_decoder_a.vbe frame_decoder_j.vbe frame_decoder_m.vbe frame_decoder_r.vbe frame_decoder_o.vbe
	@echo "Starting BooM"
	@echo "Optimizing for all encodings"
	boom -V -d 60 frame_decoder_o frame_decoder_o_optimized > boom_o.out
	boom -V -d 60 frame_decoder_a frame_decoder_a_optimized > boom_a.out
	boom -V -d 60 frame_decoder_r frame_decoder_r_optimized > boom_r.out
	boom -V -d 60 frame_decoder_m frame_decoder_m_optimized > boom_m.out
	boom -V -d 60 frame_decoder_j frame_decoder_j_optimized > boom_j.out

boog: frame_decoder_j_optimized.vbe frame_decoder_m_optimized.vbe frame_decoder_r_optimized.vbe frame_decoder_a_optimized.vbe frame_decoder_o_optimized.vbe paramfile.lax
	@echo "Starting BooG"
	@echo "Mapping all encodings to sxlib"
	boog -l paramfile frame_decoder_o_optimized frame_decoder_o_mapped
	boog -l paramfile frame_decoder_a_optimized frame_decoder_a_mapped
	boog -l paramfile frame_decoder_r_optimized frame_decoder_r_mapped
	boog -l paramfile frame_decoder_m_optimized frame_decoder_m_mapped
	boog -l paramfile frame_decoder_j_optimized frame_decoder_j_mapped

longest_path_view: $(looned_file).vst 
	xsch -I vst -l $(looned_file)

loon: frame_decoder_j_mapped.vst frame_decoder_m_mapped.vst frame_decoder_r_mapped.vst frame_decoder_a_mapped.vst frame_decoder_o_mapped.vst paramfile.lax
	@echo "Starting LooN"
	loon frame_decoder_o_mapped frame_decoder_o_looned paramfile > loon_o.out
	loon frame_decoder_a_mapped frame_decoder_a_looned paramfile > loon_a.out
	loon frame_decoder_r_mapped frame_decoder_r_looned paramfile > loon_r.out
	loon frame_decoder_m_mapped frame_decoder_m_looned paramfile > loon_m.out
	loon frame_decoder_j_mapped frame_decoder_j_looned paramfile > loon_j.out

netlist_check: $(optimized_file).vst $(optimized_file_syf).vbe
	flatbeh $(optimized_file) temp_out
	proof -d $(optimized_file_syf) temp_out

scanpin: $(optimized_file).vst scanpath.path
	scapin -VRB $(optimized_file) scanpath.path frame_decoder_final_output
	
clean:
	rm -f *.vbe *.vst *.out *.enc *.xsc *~
	@echo "cleaned directory"
	@echo "Listing directory"
	ls
