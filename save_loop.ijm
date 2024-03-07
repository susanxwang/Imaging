timepoints = 3;
folder = "E:/12-14-20_N4.4_scma_overnight/"
file = "E:/12-14-20_N4.4_scma_overnight/t13-15_multitimepoint_test.tif"

for (iiii = 0; iiii < timepoints; iiii++) {

	run("Bio-Formats", "open=" + file + " color_mode=Default open_files specify_range view=Hyperstack stack_order=XYCZT t_begin=" + (iiii+1) +" t_end=" + (iiii+1) + " t_step=1");



	save(folder + "temporarysave" + iiii + ".tif");
}
