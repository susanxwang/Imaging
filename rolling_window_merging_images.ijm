//MAKE SURE THE DELETE ALL FILES IN SAVE DIRECTORY BEFORE RUNNING!!!!!



setBatchMode(true);

rename("orig");

getDimensions(width, height, channels, slices, frames);
frames_orig = frames;

//save_directory = "E:/10-20-21_Med1_NRIP_DNA_RNA_pooled/save/"
//save_directory = "D:/test/save_medmerge/"
//save_directory = "E:/10-20-21_Med1_NRIP_DNA_RNA_pooled/save/"
//save_directory = "E:/12-7-21_MED1_BRD4/save/"
save_directory = "D:/Image analysis/4-30-23 ERa movies/output/"

rolling_window_size = 3;


for (i = 0; i < (frames-rolling_window_size + 1); i++) {
	selectWindow("orig");
	run("Duplicate...", "duplicate frames=" + (i+1));
	rename("orig_" + (i+1));
	for (j = 1; j < rolling_window_size; j++) {
		selectWindow("orig");
		run("Duplicate...", "duplicate frames=" + (i+1+j));
		rename("orig_" + (i+j+1));
		imageCalculator("Add stack", "orig_" + (i+1),"orig_" + (i+j+1));
		selectWindow("orig_" + (i+j+1));
		close(); 
		
	}

	saveAs("tiff", save_directory + "orig_" + (i+1));
	selectWindow("orig_" + (i+1) + ".tif");
	close();
}

run("Image Sequence...", "select=[" + save_directory + "] dir=[" + save_directory + "] sort");

run("Stack to Hyperstack...", "order=xyczt(default) channels=" + channels + " slices=" + slices + " frames=" + (frames - rolling_window_size + 1) +" display=Color");
setBatchMode("exit and display");