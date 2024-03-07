//create dist transform DoG images from organelle channel
		rename("orig");
		selectWindow("orig");
		run("Duplicate...", "title=orig1");
//		run("Z Project...", "projection=[Average Intensity]");
//		run("Z Project...", "stop=3 projection=[Average Intensity]");
//		run("Z Project...", "start=7 projection=[Average Intensity]");
//		run("Z Project...", "start=4 stop=6 projection=[Average Intensity]");
		selectWindow("orig");
//		selectWindow("AVG_orig");
		run("Duplicate...", "title=thresh");
		run("Subtract Background...", "rolling=50");
		run("Auto Threshold", "method=Default ignore_black ignore_white white");
		run("Duplicate...", "title=thresh_in");
		selectWindow("thresh");
		run("Duplicate...", "title=thresh_out");
		selectWindow("thresh_in");
		setThreshold(127, 255);
		

		run("Analyze Particles...", "size=40-Infinity add");

		nROIs = roiManager("count");


		
		roiManager("Combine");
		roiManager("Add");
		for (e = 0; e < nROIs; e++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}
		selectWindow("thresh_out");
		roiManager("Select", 0);
		run("Make Inverse");
		roiManager("Add");


		selectWindow("orig");
		roiManager("Select", 0);
		run("Measure");
		internalmean = (getResult("Mean", 0));
		selectWindow("orig");
		run("Select None");
		run("Duplicate...", "title=manip");
		roiManager("Select", 1);
		run("Set...", "value="+internalmean);
		selectWindow("manip");
		run("Duplicate...", "title=manip-gblur2");
		run("Duplicate...", "title=manip-gblur4");
		selectWindow("manip-gblur2");
		run("Select None");
		run("Gaussian Blur...", "sigma=1");
		selectWindow("manip-gblur4");
		run("Select None");
		run("Gaussian Blur...", "sigma=3");
		imageCalculator("Subtract create", "manip-gblur2","manip-gblur4");
		selectWindow("Result of manip-gblur2");
		roiManager("Select", 0);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside");
		run("Select None");

//run("Auto Threshold", "method=[Try all] ignore_black ignore_white white");

		run("Duplicate...", "title=segment");
		run("Auto Threshold", "method=Otsu ignore_black ignore_white white");

/*
		roiManager("Deselect");
		roiManager("Delete");
		
		selectWindow("Result of manip-gblur2");
		close();
		selectWindow("manip-gblur4");
		close();
		selectWindow("manip-gblur2");
		close();
		selectWindow("manip");
		close();
		selectWindow("orig");
		close();
		selectWindow("thresh_out");
		close();
		selectWindow("thresh_in");
		close();
		selectWindow("thresh");
		close();
*/	