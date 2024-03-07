selectWindow("sc35_orig");

run("3D Manager");
Ext.Manager3D_Quantif3D(1,"Mean",X);

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
	run("Auto Threshold", "method=Default ignore_black ignore_white white stack use_stack_histogram");
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
		Ext.Manager3D_Select(1);
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
	Ext.Manager3D_Select(1);
	Ext.Manager3D_FillStack(245, 245, 245);
}
