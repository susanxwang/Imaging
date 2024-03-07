		rename("orig");
		
		run("Split Channels");
		selectWindow("C1-orig");
		rename("sc35");
		selectWindow("C2-orig");
		rename("fish");
		selectWindow("C3-orig");
		rename("matrin");
		selectWindow("C4-orig");
		rename("dapi");

		run("ROI Manager...");



		selectWindow("dapi");
		run("Z Project...", "projection=[Average Intensity]");

		rename("dapi_zproj");
		//run("Duplicate...", "title=dapi_gblurbig");
		//selectWindow("dapi_zproj");
		run("Duplicate...", "title=dapi_gblursmall");
		//selectWindow("dapi_gblurbig");
		//run("Gaussian Blur...", "sigma=100");
		//selectWindow("dapi_gblursmall");
		run("Gaussian Blur...", "sigma=15");
		//imageCalculator("Subtract create", "dapi_gblursmall","dapi_gblurbig");
		//selectWindow("Result of dapi_gblursmall");
		//selectWindow("dapi_gblursmall");
		//run("Auto Threshold", "method=[Try all] ignore_black ignore_white white");


		run("Auto Threshold", "method=Minimum ignore_black ignore_white white");
		run("Create Selection");
		roiManager("Add");
		selectWindow("dapi_zproj");
		roiManager("Select", 0);

		selectWindow("sc35");
		roiManager("Select", 0);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside", "stack");
		selectWindow("fish");
		roiManager("Select", 0);
		run("Clear Outside", "stack");
		selectWindow("matrin");
		roiManager("Select", 0);
		run("Clear Outside", "stack");

		selectWindow("sc35");
		run("Select None");
		selectWindow("fish");
		run("Select None");
		selectWindow("matrin");
		run("Select None");
		selectWindow("dapi");
		run("Select None");

		selectWindow("dapi_gblursmall");
		close();
		selectWindow("dapi_zproj");
		close();
		selectWindow("dapi");
		close();

		selectWindow("fish");
		run("Duplicate...", "title=fish_gblur4 duplicate");
		run("Gaussian Blur 3D...", "x=4 y=4 z=4");
		selectWindow("fish");
		run("Duplicate...", "title=fish_gblur8 duplicate");
		run("Gaussian Blur 3D...", "x=8 y=8 z=8");
		imageCalculator("Subtract create stack", "fish_gblur4","fish_gblur8");
//		run("Auto Threshold", "method=Default ignore_black ignore_white white stack use_stack_histogram");
		run("3D Nuclei Segmentation (beta)", "auto_threshold=Default manual=0");
		rename("fish_thresh_label");
		run("32-bit");