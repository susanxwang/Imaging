rename("orig");
run("Duplicate...", "title=gblur3 duplicate");
run("Gaussian Blur...", "sigma=3 stack");
run("Duplicate...", "title=gblur3_thresh duplicate");
close();
run("Duplicate...", "duplicate");
run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack");
run("Make Binary", "method=Default background=Default calculate black");
run("Open", "stack");
setOption("BlackBackground", true);
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
run("Erode", "stack");
selectWindow("gblur3");
getDimensions(width, height, channels, slices, frames);
run("ROI Manager...");
for (i = 0; i < frames; i++) {


	selectWindow("gblur3-1");
	setSlice(i+1);
	run("Create Selection");
	roiManager("Add");
	selectWindow("gblur3");
	setSlice(i+1);
	roiManager("Select", 0);
	run("Make Inverse");
	run("Gaussian Blur...", "sigma=5");
	roiManager("Select", 0);
	roiManager("Delete");
	selectWindow("gblur3-1");
	run("Select None");
	selectWindow("gblur3");
	run("Select None");
}
