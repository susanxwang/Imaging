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

