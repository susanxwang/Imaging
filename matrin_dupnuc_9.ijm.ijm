selectWindow("matrin_orig");

run("3D Manager");
Ext.Manager3D_Quantif3D(1,"Mean",X);

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
	Ext.Manager3D_Quantif3D(1,"Mean",V);
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
	run("Auto Threshold", "method=Default ignore_black ignore_white white stack use_stack_histogram");
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
		Ext.Manager3D_Select(1);
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
	Ext.Manager3D_Select(1);
	Ext.Manager3D_FillStack(245, 245, 245);
}