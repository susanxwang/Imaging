run("Options...", "iterations=1 count=1 black do=Nothing");

rename("orig");
run("Split Channels");
selectWindow("C1-orig");
rename("rna_orig_allframes");
selectWindow("C2-orig");
rename("dna_orig_allframes");




selectWindow("rna_orig_allframes");
run("Duplicate...", "title=rna_blur_orig_allframes duplicate");
run("Gaussian Blur 3D...", "x=6 y=6 z=2");

//selectWindow("rna_orig");
//run("Duplicate...", "title=nuc_orig duplicate");

getDimensions(width, height, channels, slices, frames);

for (j = 0; j < frames; j++) {
	
	
//	Step 1: identify the central nucleus being quantified	
	selectWindow("rna_blur_orig_allframes");
	Stack.setFrame((j+1));
	run("Duplicate...", "duplicate frames="+(j+1));
	rename("nuc_orig");

	selectWindow("rna_orig_allframes");
	Stack.setFrame((j+1));
	run("Duplicate...", "duplicate frames="+(j+1));
	rename("rna_orig");

	selectWindow("dna_orig_allframes");
	Stack.setFrame((j+1));
	run("Duplicate...", "duplicate frames="+(j+1));
	rename("dna_orig");

	selectWindow("nuc_orig");
	setOption("ScaleConversions", true);
	run("16-bit");

	run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack use_stack_histogram");	
	run("Distance Transform Watershed 3D", "distances=[Borgefors (3,4,5)] output=[16 bits] normalize dynamic=16 connectivity=6");
				
	
	run("3D Manager");
	Ext.Manager3D_AddImage();

	Ext.Manager3D_Count(nb);
	for (k = 1; k < nb; k++) {
		Ext.Manager3D_Measure3D(0,"Vol",quantif0);
		Ext.Manager3D_Measure3D(1,"Vol",quantif1);

		if (quantif0 > quantif1) {
			Ext.Manager3D_Select(1);
			Ext.Manager3D_FillStack(0, 0, 0);
			Ext.Manager3D_Delete();
		}
		else {
			Ext.Manager3D_Select(0);
			Ext.Manager3D_FillStack(0, 0, 0);
			Ext.Manager3D_Delete();
		}					
	}

	selectWindow("nuc_orig");
	close(); 
	
	selectWindow("nuc_origdist-watershed");
	run("8-bit");

	for (o = 0; o < slices; o++) {
		Stack.setSlice(o+1);
		changeValues(1, 255, 255);
	}
	

//Step 2: Add the individual slices of the nucei to the roi manager
//clear all pixels outside our nuclei of interest in dna and rna frames
//afterwards, raise all pixels to a value that is proportional to the mean intensity in our nucleus

	run("3D Manager");

	selectWindow("nuc_origdist-watershed");
	run("Select None");
	framesize = getValue("Area");
	framesize = toString(framesize);
	framesize = parseFloat(framesize);
	for (p = 0; p < slices; p++) {
		Stack.setSlice(p+1);
		run("Create Selection");
		
		selection_check = getValue("Area");
		selection_check = toString(selection_check);
		selection_check = parseFloat(selection_check);

		if (selection_check == framesize) {
			run("Select None");
			run("Select All");
			roiManager("Add");
		}
		else {
			roiManager("Add");
		}
				
		run("Select None");
	}

	selectWindow("rna_orig");
	for (p = 0; p < slices; p++) {
		Stack.setSlice(p+1);
		run("Select None");
		roiManager("Select", p);
		
		selection_check = getValue("Area");
		selection_check = toString(selection_check);
		selection_check = parseFloat(selection_check);

		if (selection_check == framesize) {
			run("Clear", "slice");
			run("Select None");
		}
		else {
			run("Clear Outside", "slice");
			run("Select None");
		}

	}

	selectWindow("dna_orig");
	for (p = 0; p < slices; p++) {
		Stack.setSlice(p+1);
		run("Select None");
		roiManager("Select", p);

		selection_check = getValue("Area");
		selection_check = toString(selection_check);
		selection_check = parseFloat(selection_check);

		if (selection_check == framesize) {
			run("Clear", "slice");
			run("Select None");
		}
		else {
			run("Clear Outside", "slice");
			run("Select None");
		}
				
	}

	selectWindow("rna_orig");
	Ext.Manager3D_Quantif3D(0,"Mean",rna_mean_intensity);
	rna_mean_intensity = toString(rna_mean_intensity);
	rna_mean_intensity = parseFloat(rna_mean_intensity);
	rna_filt_intensity = 1.7 * rna_mean_intensity;
	rna_filt_intensity = toString(rna_filt_intensity);
	rna_filt_intensity = parseFloat(rna_filt_intensity);
	
	selectWindow("dna_orig");
	Ext.Manager3D_Quantif3D(0,"Mean",dna_mean_intensity);
	dna_mean_intensity = toString(dna_mean_intensity);
	dna_mean_intensity = parseFloat(dna_mean_intensity);
	dna_filt_intensity = 1.7 * dna_mean_intensity;
	dna_filt_intensity = toString(dna_filt_intensity);
	dna_filt_intensity = parseFloat(dna_filt_intensity);

	selectWindow("rna_orig");
	for (p = 0; p < slices; p++) {
		Stack.setSlice(p+1);
		run("Select None");
		run("Select All");
		changeValues(0, rna_filt_intensity, rna_filt_intensity);
	}

	selectWindow("dna_orig");
	for (p = 0; p < slices; p++) {
		Stack.setSlice(p+1);
		run("Select None");
		run("Select All");
		changeValues(0, dna_filt_intensity, dna_filt_intensity);
	}
	
	selectWindow("rna_orig");
	run("Select None");
	run("Duplicate...", "title=rna_orig_gblur6 duplicate");
	selectWindow("rna_orig");
	run("Duplicate...", "title=rna_orig_gblur12 duplicate");
	selectWindow("rna_orig_gblur6");
	run("Gaussian Blur 3D...", "x=4 y=4 z=2");
	selectWindow("rna_orig_gblur12");
	run("Gaussian Blur 3D...", "x=8 y=8 z=3");
	imageCalculator("Subtract create stack", "rna_orig_gblur6","rna_orig_gblur12");
	selectWindow("Result of rna_orig_gblur6");
	rename("rna_dog");

	selectWindow("dna_orig");
	run("Select None");
	run("Duplicate...", "title=dna_orig_gblur6 duplicate");
	selectWindow("dna_orig");
	run("Duplicate...", "title=dna_orig_gblur12 duplicate");
	selectWindow("dna_orig_gblur6");
	run("Gaussian Blur 3D...", "x=4 y=4 z=2");
	selectWindow("dna_orig_gblur12");
	run("Gaussian Blur 3D...", "x=8 y=8 z=3");
	imageCalculator("Subtract create stack", "dna_orig_gblur6","dna_orig_gblur12");
	selectWindow("Result of dna_orig_gblur6");
	rename("dna_dog");

	print(rna_mean_intensity);
	selectWindow("rna_dog");
	Ext.Manager3D_Quantif3D(0,"Max",rna_max_intensity);
	print(rna_max_intensity);
	selectWindow("rna_orig_gblur6");
	Ext.Manager3D_Quantif3D(0,"Max",rna_max_intensity);
	print(rna_max_intensity);
	
	print(dna_mean_intensity);
	selectWindow("dna_dog");
	Ext.Manager3D_Quantif3D(0,"Max",dna_max_intensity);
	print(dna_max_intensity);
	selectWindow("dna_orig_gblur6");
	Ext.Manager3D_Quantif3D(0,"Max",rna_max_intensity);
	print(rna_max_intensity);

//	run("3D Manager");
//	run("Clear", "stack");
//	Ext.Manager3D_Quantif3D(0,"Max",dna_max_intensity);
//	print(dna_max_intensity);
	run("Window/Level...");
}
