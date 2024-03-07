
run("Split Channels");
selectWindow("C1-cropped_-e2 dapi_Out.tif");
rename("sc35");
selectWindow("C2-cropped_-e2 dapi_Out.tif");
rename("fish");
selectWindow("C3-cropped_-e2 dapi_Out.tif");
rename("matrin");
selectWindow("C4-cropped_-e2 dapi_Out.tif");
rename("dapi");

run("ROI Manager...");

/*
selectWindow("sc35");
run("Duplicate...", "title=sc35_gblur4 duplicate");
run("Gaussian Blur 3D...", "x=4 y=4 z=4");
selectWindow("sc35");
run("Duplicate...", "title=sc35_gblur8 duplicate");
run("Gaussian Blur 3D...", "x=8 y=8 z=8");
imageCalculator("Subtract create stack", "sc35_gblur4","sc35_gblur8");
*/

selectWindow("dapi");
run("Duplicate...", "title=dapi_gblur150 duplicate");
run("Gaussian Blur 3D...", "x=150 y=150 z=150");
selectWindow("dapi");
run("Duplicate...", "title=dapi_gblur100 duplicate");
run("Gaussian Blur 3D...", "x=100 y=100 z=100");


imageCalculator("Subtract create stack", "dapi_gblur100","dapi_gblur150");
selectWindow("Result of dapi_gblur100");
rename("dgb100-gdb150");


selectWindow("dgb100-gdb150");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
//run("Create Selection");
//roiManager("Add");

//run("3D Manager");
//Ext.Manager3D_AddImage();
//selectWindow("dapi");
//Ext.Manager3D_Select(0);
//setBackgroundColor(0, 0, 0);
//run("Clear Outside", "stack");

selectWindow("dapi");
getDimensions(width, height, channels, slices, frames);

for (i = 0; i < slices; i++) {
	selectWindow("dgb100-gdb150_segNuclei");
	Stack.setSlice(i+1);
	run("Create Selection");
	roiManager("Add");
	selectWindow("sc35");
	Stack.setSlice(i+1);
	roiManager("Select", 0);
	
}



