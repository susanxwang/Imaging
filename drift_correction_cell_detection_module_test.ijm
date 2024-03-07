rename("orig");

selectWindow("orig");
//uncomment line below if not already z-projected; also make sure the z-proj green		
//run("Z Project...", "projection=[Sum Slices] all");
run("Split Channels");
selectWindow("C1-orig");
rename("zproj");
run("Duplicate...", "title=zproj_blur duplicate");
run("Gaussian Blur...", "sigma=6 stack");

getDimensions(width, height, channels, slices, frames);

setBatchMode(true);
for (j = 0; j < frames; j++) {
		Stack.setFrame((j+1));

		run("Duplicate...", "use");
		rename("tempblur");
		setOption("ScaleConversions", true);
		run("16-bit");

		run("Auto Threshold", "method=Huang2 ignore_black ignore_white white");
		run("Analyze Particles...", "add");

		roinum = roiManager("count");
		if (roinum > 1) {
				for (k = 1; k < roinum; k++) {
						roiManager("Select", 0);
						area0 = getValue("Area");
						roiManager("Select", 1);
						area1 = getValue("Area");
						if (area0 > area1) {
							roiManager("Select", 1);
							roiManager("Delete");
						}
						else {
							roiManager("Select", 0);
							roiManager("Delete");
						}
				}
		}

		selectWindow("tempblur");
		roiManager("Select", 0);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside");
		run("Select None");
		run("Dilate");
		run("Dilate");
		run("Dilate");
		run("Dilate");
		run("Dilate");
		run("Create Selection");
		roiManager("Add");
		selectWindow("tempblur");
		roiManager("Select", newArray(0,1));
		roiManager("XOR");
		roiManager("Add");
		close();

		selectWindow("zproj_blur");
		roiManager("Select", 0);
		medval = getValue("Median");
		medval = toString(medval);
		medval = parseFloat(medval);
		roiManager("Select", 2);
		offmedval = getValue("Median");
		offmedval = toString(offmedval);
		offmedval = parseFloat(offmedval);
		offfiltval = 0.5 * offmedval;
		offfiltval = toString(offfiltval);
		offfiltval = parseFloat(offfiltval);

		selectWindow("zproj_blur");
		roiManager("Select", 1);
		run("Make Inverse");
		changeValues(offfiltval, 65535, offfiltval);
		run("Select None");

		uppermedval = 1.5 * medval;
		uppermedval = toString(uppermedval);
		uppermedval = parseFloat(uppermedval);

		changeValues(uppermedval, 65535, uppermedval);

		roiManager("deselect");
		roiManager("delete");
}

setBatchMode("exit and display");