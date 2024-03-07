
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
run("Duplicate...", "title=dapi_gblur125 duplicate");
run("Gaussian Blur 3D...", "x=125 y=125 z=125");
selectWindow("dapi");
run("Duplicate...", "title=dapi_gblur100 duplicate");
run("Gaussian Blur 3D...", "x=100 y=100 z=100");
selectWindow("dapi");
run("Duplicate...", "title=dapi_gblur75 duplicate");
run("Gaussian Blur 3D...", "x=75 y=75 z=75");
selectWindow("dapi");
run("Duplicate...", "title=dapi_gblur50 duplicate");
run("Gaussian Blur 3D...", "x=50 y=50 z=50");


/*imageCalculator("Subtract create stack", "dapi_gblur125","dapi_gblur150");
selectWindow("Result of dapi_gblur125");
rename("dgb125-gdb150");
*/
imageCalculator("Subtract create stack", "dapi_gblur100","dapi_gblur150");
selectWindow("Result of dapi_gblur100");
rename("dgb100-gdb150");
/*
imageCalculator("Subtract create stack", "dapi_gblur75","dapi_gblur150");
selectWindow("Result of dapi_gblur75");
rename("dgb75-gdb150");
imageCalculator("Subtract create stack", "dapi_gblur50","dapi_gblur150");
selectWindow("Result of dapi_gblur50");
rename("dgb50-gdb150");
imageCalculator("Subtract create stack", "dapi_gblur100","dapi_gblur125");
selectWindow("Result of dapi_gblur100");
rename("dgb100-gdb125");
imageCalculator("Subtract create stack", "dapi_gblur75","dapi_gblur125");
selectWindow("Result of dapi_gblur75");
rename("dgb75-gdb125");
imageCalculator("Subtract create stack", "dapi_gblur50","dapi_gblur125");
selectWindow("Result of dapi_gblur50");
rename("dgb50-gdb125");
imageCalculator("Subtract create stack", "dapi_gblur75","dapi_gblur100");
selectWindow("Result of dapi_gblur75");
rename("dgb75-gdb100");
imageCalculator("Subtract create stack", "dapi_gblur50","dapi_gblur100");
selectWindow("Result of dapi_gblur50");
rename("dgb50-gdb100");
imageCalculator("Subtract create stack", "dapi_gblur50","dapi_gblur75");
selectWindow("Result of dapi_gblur50");
rename("dgb50-gdb75");
*/

/*
selectWindow("dgb125-gdb150");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");
*/


selectWindow("dgb100-gdb150");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

/*
selectWindow("dgb75-gdb150");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

selectWindow("dgb50-gdb150");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

selectWindow("dgb100-gdb125");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

selectWindow("dgb75-gdb125");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

selectWindow("dgb50-gdb125");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

selectWindow("dgb75-gdb100");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

selectWindow("dgb50-gdb100");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");

selectWindow("dgb50-gdb75");
run("3D Nuclei Segmentation (beta)", "auto_threshold=Huang manual=0");
setThreshold(1, 65535);
run("Make Binary", "method=Default background=Dark black");
run("Close-", "stack");
run("Create Selection");
roiManager("Add");
/*




