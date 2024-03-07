run("3D Manager");

selectWindow("burst_orig");
run("Duplicate...", "title=blank_orig duplicate");
run("Select All");
run("Clear", "stack");
run("Select None");
Ext.Manager3D_Select(1);
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