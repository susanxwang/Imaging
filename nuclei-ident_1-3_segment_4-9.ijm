rename("orig");
run("Split Channels");
selectWindow("C1-orig");
rename("sc35_orig");
selectWindow("C2-orig");
rename("burst_orig");
selectWindow("C3-orig");
rename("matrin_orig");


selectWindow("burst_orig");
run("Duplicate...", "title=burst_segmented duplicate");
run("Select All");
run("Clear", "stack");
run("Select None");

selectWindow("sc35_orig");
run("Duplicate...", "title=sc35_segmented duplicate");
run("Select All");
run("Clear", "stack");
run("Select None");

selectWindow("matrin_orig");
run("Duplicate...", "title=matrin_segmented duplicate");
run("Select All");
run("Clear", "stack");
run("Select None");

selectWindow("burst_orig");
run("Duplicate...", "title=burst_orig_nucfind duplicate");

run("Gaussian Blur 3D...", "x=10 y=10 z=3");
run("Subtract Background...", "rolling=500 stack");
run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack use_stack_histogram");
//play w dynamic to get more division (lower) or less (ress) from watershed
run("Distance Transform Watershed 3D", "distances=[Borgefors (3,4,5)] output=[16 bits] normalize dynamic=16 connectivity=6");

		run("3D Manager Options", "volume surface compactness fit_ellipse integrated_density mean_grey_value std_dev_grey_value minimum_grey_value maximum_grey_value centroid_(pix) centroid_(unit) distance_to_surface centre_of_mass_(pix) centre_of_mass_(unit) bounding_box radial_distance closest distance_between_centers=10 distance_max_contact=1.80 drawing=Contour use_0");
		run("3D Manager");
		//Ext.Manager3D_Reset();
		Ext.Manager3D_SelectAll();
		Ext.Manager3D_Delete();

		// select the image with the labelled objects
		//selectWindow("fish_thresh_label");
		Ext.Manager3D_AddImage();
		// if list is not visible please refresh list by using Deselect
		Ext.Manager3D_Select(0);
		Ext.Manager3D_DeselectAll();
		// number of results, and arrays to store results
		Ext.Manager3D_Count(nb);


		selectWindow("burst_orig_nucfind");
		close();
		selectWindow("burst_orig_nucfinddist-watershed");
		close();

run("3D Manager");

badnucs = newArray(0);

Ext.Manager3D_Count(nb);

for (i = 0; i < nb; i++) {
	Ext.Manager3D_Measure3D(i,"Vol",V);
	if (V> 1500) {
		badnucs = Array.concat(badnucs,i);
	}

	if (V<300) {
		badnucs = Array.concat(badnucs,i);
	}


}

Array.print(badnucs);
Array.reverse(badnucs);
Array.print(badnucs);

badnucs.length;

for (i = 0; i < badnucs.length; i++) {
	print(badnucs[i]);
	Ext.Manager3D_Select(badnucs[i]);
	Ext.Manager3D_Delete();
}

for (ii = 0; ii < nb; ii++) {

	//step4
	
	run("3D Manager");

	selectWindow("burst_orig");
	run("Duplicate...", "title=blank_orig duplicate");
	run("Select All");
	run("Clear", "stack");
	run("Select None");
	Ext.Manager3D_Select(ii);
	Ext.Manager3D_FillStack(145, 145, 145);
	setThreshold(1, 65535);
	getDimensions(width, height, channels, slices, frames);
	run("ROI Manager...");

	for (i = 0; i < slices; i++) {
		setSlice(i+1);
		run("Create Selection");
		getStatistics(area, mean, min, max, std, histogram);
		if (max>0) {
			run("Make Inverse");
			roiManager("Add");
		}
		if (max < 1) {
			run("Select All");
			roiManager("Add");
		}

	}

	roicount = roiManager("count");

	selectWindow("burst_orig");
	run("Duplicate...", "title=burst_singcells duplicate");

	for (i = 0; i < roicount; i++) {
		setSlice(i+1);
		roiManager("Select", i);
		run("Clear", "slice");
	}

	selectWindow("blank_orig");
	close();

		//step5

		run("3D Manager");
		selectWindow("burst_singcells");
		Ext.Manager3D_Quantif3D(ii,"Mean",V);
		V = toString(V);
		V = parseFloat(V);
		W = V*1.7;
		W = toString(W);
		W = parseFloat(W);		
		roicount = roiManager("count");
		for (i = 0; i < roicount; i++) {
			setSlice(i+1);
			run("Select All");
			changeValues(0, W, W);
		}

	//step6

	run("3D Manager");

	selectWindow("burst_singcells");
	run("Select None");
	run("Duplicate...", "title=burst_singcells_gblur6 duplicate");
	selectWindow("burst_singcells");
	run("Duplicate...", "title=burst_singcells_gblur12 duplicate");
	selectWindow("burst_singcells_gblur6");
	run("Gaussian Blur 3D...", "x=6 y=6 z=2");
	selectWindow("burst_singcells_gblur12");
	run("Gaussian Blur 3D...", "x=12 y=12 z=4");
	imageCalculator("Subtract create stack", "burst_singcells_gblur6","burst_singcells_gblur12");
	selectWindow("Result of burst_singcells_gblur6");


	//adjust to be dynamic for burst ident
	selectWindow("burst_singcells");
	Ext.Manager3D_Quantif3D(ii,"Mean",V);
	V = toString(V);
	V = parseFloat(V);
	W = V*0.055+10;
	W = toString(W);
	W = parseFloat(W);


	selectWindow("Result of burst_singcells_gblur6");
	setThreshold(10, 65535);
	run("Convert to Mask", "method=Default background=Default black");

	selectWindow("burst_singcells_gblur12");
	close();
	selectWindow("burst_singcells_gblur6");
	close();
	selectWindow("burst_singcells");
	close();

	//Step7

	run("3D Manager");
	Ext.Manager3D_Count(nb_pre);
	print(nb_pre);

	selectWindow("Result of burst_singcells_gblur6");
	run("3D Simple Segmentation", "low_threshold=1 min_size=0 max_size=-1");
	selectWindow("Seg");
	Ext.Manager3D_AddImage();
	Ext.Manager3D_Count(nb_post);

	if ((nb_post-nb_pre) >1) {
		for (i = nb_pre; i < nb_post; i++) {
			Ext.Manager3D_Select(nb_pre);
			Ext.Manager3D_Delete();	
			print(i);	
		}
	}

	if ((nb_post-nb_pre) == 1) {
		selectWindow("burst_segmented");
		Ext.Manager3D_Select((nb_post - 1));
		Ext.Manager3D_FillStack(145, 145, 145);
		Ext.Manager3D_Select((nb_post - 1));
		Ext.Manager3D_Delete();	
	}

	selectWindow("Bin");
	close();
	selectWindow("Seg");
	close();
	selectWindow("Result of burst_singcells_gblur6");
	close();

	//Step8
	selectWindow("sc35_orig");

	run("3D Manager");
	Ext.Manager3D_Quantif3D(ii,"Mean",X);

	if (X > 2) {
		selectWindow("sc35_orig");
		run("Duplicate...", "title=sc35_singcells duplicate");

		//MAKE SURE TO CHANGE THE VALUE OF "1" IN THE FINAL LOOP TO REFER TO THE 3DROI MANAGER CELL BEING ANALYZED

		roicount = roiManager("count");

		for (i = 0; i < roicount; i++) {
			setSlice(i+1);
			roiManager("Select", i);
			run("Clear", "slice");
		}


		selectWindow("sc35_singcells");
		Ext.Manager3D_Quantif3D(ii,"Mean",V);
		V = toString(V);
		V = parseFloat(V);
		W = V*1.2;
		W = toString(W);
		W = parseFloat(W);		
		roicount = roiManager("count");
		for (i = 0; i < roicount; i++) {
			setSlice(i+1);
			run("Select All");
			changeValues(0, W, W);
		}

		selectWindow("sc35_singcells");
		run("Select None");
		run("Duplicate...", "title=sc35_singcells_gblur6 duplicate");
		selectWindow("sc35_singcells");
		run("Duplicate...", "title=sc35_singcells_gblur12 duplicate");
		selectWindow("sc35_singcells_gblur6");
		run("Gaussian Blur 3D...", "x=6 y=6 z=2");
		selectWindow("sc35_singcells_gblur12");
		run("Gaussian Blur 3D...", "x=12 y=12 z=4");
		imageCalculator("Subtract create stack", "sc35_singcells_gblur6","sc35_singcells_gblur12");
		selectWindow("Result of sc35_singcells_gblur6");
		run("Gaussian Blur 3D...", "x=3 y=3 z=1");
		run("Auto Threshold", "method=Otsu ignore_black ignore_white white stack use_stack_histogram");
		//run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack use_stack_histogram");
		Ext.Manager3D_Count(nb_pre);

		Ext.Manager3D_AddImage();

		Ext.Manager3D_Count(nb_post);
		selectWindow("sc35_segmented");

		if ((nb_post-nb_pre) == 1) {
			Ext.Manager3D_Select((nb_post - 1));
			Ext.Manager3D_FillStack(145, 145, 145);
			Ext.Manager3D_Select((nb_post - 1));
			Ext.Manager3D_Delete();	
		}

		if (nb_post == nb_pre) {
			Ext.Manager3D_Select(ii);
			Ext.Manager3D_FillStack(245, 245, 245);
		}


		selectWindow("sc35_singcells_gblur12");
		close();
		selectWindow("sc35_singcells_gblur6");
		close();
		selectWindow("sc35_singcells");
		close();
		selectWindow("Result of sc35_singcells_gblur6");
		close();
	}

	if (X <= 2) {
		Ext.Manager3D_Select(ii);
		Ext.Manager3D_FillStack(245, 245, 245);
	}


	//Step9
	selectWindow("matrin_orig");

	run("3D Manager");
	Ext.Manager3D_Quantif3D(ii,"Mean",X);

	if (X > 2) {
		selectWindow("matrin_orig");
		run("Duplicate...", "title=matrin_singcells duplicate");

		//MAKE SURE TO CHANGE THE VALUE OF "1" IN THE FINAL LOOP TO REFER TO THE 3DROI MANAGER CELL BEING ANALYZED

		roicount = roiManager("count");

		for (i = 0; i < roicount; i++) {
			setSlice(i+1);
			roiManager("Select", i);
			run("Clear", "slice");
		}


		selectWindow("matrin_singcells");
		Ext.Manager3D_Quantif3D(ii,"Mean",V);
		V = toString(V);
		V = parseFloat(V);
		W = V*1.2;
		W = toString(W);
		W = parseFloat(W);		
		roicount = roiManager("count");
		for (i = 0; i < roicount; i++) {
			setSlice(i+1);
			run("Select All");
			changeValues(0, W, W);
		}

		selectWindow("matrin_singcells");
		run("Select None");
		run("Duplicate...", "title=matrin_singcells_gblur6 duplicate");
		selectWindow("matrin_singcells");
		run("Duplicate...", "title=matrin_singcells_gblur12 duplicate");
		selectWindow("matrin_singcells_gblur6");
		run("Gaussian Blur 3D...", "x=6 y=6 z=2");
		selectWindow("matrin_singcells_gblur12");
		run("Gaussian Blur 3D...", "x=12 y=12 z=4");
		imageCalculator("Subtract create stack", "matrin_singcells_gblur6","matrin_singcells_gblur12");
		selectWindow("Result of matrin_singcells_gblur6");
		run("Gaussian Blur 3D...", "x=3 y=3 z=1");
		run("Auto Threshold", "method=Otsu ignore_black ignore_white white stack use_stack_histogram");
		//run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack use_stack_histogram");
		Ext.Manager3D_Count(nb_pre);
	
		Ext.Manager3D_AddImage();

		Ext.Manager3D_Count(nb_post);
		selectWindow("matrin_segmented");

		if ((nb_post-nb_pre) == 1) {
			Ext.Manager3D_Select((nb_post - 1));
			Ext.Manager3D_FillStack(145, 145, 145);
			Ext.Manager3D_Select((nb_post - 1));
			Ext.Manager3D_Delete();	
		}

		if (nb_post == nb_pre) {
			Ext.Manager3D_Select(ii);
			Ext.Manager3D_FillStack(245, 245, 245);
		}


		selectWindow("matrin_singcells_gblur12");
		close();
		selectWindow("matrin_singcells_gblur6");
		close();
		selectWindow("matrin_singcells");
		close();
		selectWindow("Result of matrin_singcells_gblur6");
		close();
	}

	if (X <= 2) {
		selectWindow("matrin_segmented");
		Ext.Manager3D_Select(ii);
		Ext.Manager3D_FillStack(245, 245, 245);
	}

	roiManager("Deselect");
	roiManager("Delete");
	
}

Ext.Manager3D_Count(nb3);

for (i = 0; i < nb3; i++) {
	Ext.Manager3D_Select(i);
	Ext.Manager3D_Delete();	
}


run("3D Distance Map", "map=EDT image=sc35_segmented mask=Same threshold=1");
rename("sc35_EDT_inside");
run("3D Distance Map", "map=EDT image=sc35_segmented mask=Same threshold=1 inverse");
rename("sc35_EDT_outside");
run("3D Distance Map", "map=EDT image=matrin_segmented mask=Same threshold=1");
rename("matrin_EDT_inside");
run("3D Distance Map", "map=EDT image=matrin_segmented mask=Same threshold=1 inverse");
rename("matrin_EDT_outside");

selectWindow("burst_segmented");
run("3D Simple Segmentation", "low_threshold=1 min_size=0 max_size=-1");
selectWindow("Seg");
Ext.Manager3D_AddImage();



//selectWindow("sc35_EDT_inside");		
//Ext.Manager3D_Quantif();
//Ext.Manager3D_SaveQuantif("D:/Imaging/Results.tsv");
//Ext.Manager3D_CloseResult("Q");
//open("D:/Imaging/Q_Results.tsv");
//selectWindow("Q_Results.tsv");
//selectWindow("Q_Results.tsv");
//		run("Close");
