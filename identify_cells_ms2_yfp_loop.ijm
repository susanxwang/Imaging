//setBatchMode("hide");

rename("orig");
run("Duplicate...", "title=segmented_bursts duplicate");
getDimensions(width, height, channels, slices, frames);

for (z = 0; z < frames; z++) {
	setSlice((z+1));
	run("Select All");
	run("Clear", "slice");
	run("Select None");
}

for (z = 0; z < frames; z++) {
	selectWindow("orig");
	setSlice((z+1));	
	run("Duplicate...", "title=gblur10");
	run("Gaussian Blur...", "sigma=10");
	run("Subtract Background...", "rolling=500");
	run("Auto Threshold", "method=Mean ignore_black ignore_white white");
	run("Watershed");
	run("ROI Manager...");
	run("Analyze Particles...", "size=40.00-220.00 add");

	nb = roiManager("count");
	for (i = 0; i < nb; i++) {
		print(i);
		selectWindow("orig");
		run("Duplicate...", "title=intermed_orig");
		roiManager("Select", i);
		run("Clear Outside");
		run("Measure");
		k = Table.get("Median", 0);
		k = toString(k);
		k = parseFloat(k);
		j = k * 0.9;
		j = toString(j);
		j = parseFloat(j);
		l = k*0.055+5;
		l = toString(l);
		l = parseFloat(l);
		selectWindow("Results");
		run("Close");
		selectWindow("intermed_orig");
		run("Select None");
		changeValues(0, j, j);

		run("Duplicate...", "title=intermed_gblur6");
		selectWindow("intermed_orig");
		run("Duplicate...", "title=intermed_gblur12");
		selectWindow("intermed_gblur6");
		run("Gaussian Blur...", "sigma=6");
		selectWindow("intermed_gblur12");
		run("Gaussian Blur...", "sigma=12");
		imageCalculator("Subtract create", "intermed_gblur6","intermed_gblur12");
		selectWindow("Result of intermed_gblur6");
		rename("intermed_dog");

		setThreshold(l, 65535);
		//run("Convert to Mask", "method=Default background=Dark black");
		run("Convert to Mask");


		run("Analyze Particles...", "size=0-Infinity add");
		nbv2 = roiManager("count");
		print(nb);
		print(nbv2);
		if (nbv2 == (nb+1)) {

			selectWindow("segmented_bursts");
			setSlice((z+1));
			roiManager("Select", (nbv2-1));
			changeValues(0, k, k);
			roiManager("Select", (nbv2-1));
			roiManager("Delete");
		}
		else {
			if (nbv2> (nb+1)) {
				for (h = 0; h < (nbv2-nb); h++) {
					nbv3 = roiManager("count");
					roiManager("Select", (nbv3-1));
					roiManager("Delete");
				}							
			}
		}



		selectWindow("intermed_dog");
		close();
		selectWindow("intermed_gblur12");
		close();
		selectWindow("intermed_gblur6");
		close();
		selectWindow("intermed_orig");
		close();
	}

	selectWindow("ROI Manager");
	run("Close");

	selectWindow("gblur10");
	run("Close");
}

