		rename("orig");



		run("Clear Results");


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


		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");


		selectWindow("sc35");
		run("Duplicate...", "title=sc35_gblur4 duplicate");
		run("Gaussian Blur 3D...", "x=4 y=4 z=4");
		selectWindow("sc35");
		run("Duplicate...", "title=sc35_gblur8 duplicate");
		run("Gaussian Blur 3D...", "x=8 y=8 z=8");
		imageCalculator("Subtract create stack", "sc35_gblur4","sc35_gblur8");
		run("Auto Threshold", "method=Default ignore_black ignore_white white stack use_stack_histogram");
		run("3D Nuclei Segmentation (beta)", "auto_threshold=Default manual=1");
		rename("sc35_thresh_label");
		//run("Duplicate...", "title=sc35_thresh_bin duplicate");
		//setThreshold(1, 65535);
		//run("Make Binary", "method=Default background=Dark black");
		run("3D Distance Map", "map=EDT image=sc35_thresh_label mask=Same threshold=1");
		rename("sc35_EDT_inside");
		run("3D Distance Map", "map=EDT image=sc35_thresh_label mask=Same threshold=1 inverse");
		rename("sc35_EDT_outside");

		selectWindow("sc35_thresh_label");
		close();
		selectWindow("Result of sc35_gblur4");
		close();
		selectWindow("sc35_gblur8");
		close();
		selectWindow("sc35_gblur4");
		close();
		selectWindow("sc35");
		close();

		
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");



		selectWindow("matrin");
		run("Duplicate...", "title=matrin_gblur4 duplicate");
		//run("Gaussian Blur 3D...", "x=12 y=12 z=12");
		run("Gaussian Blur 3D...", "x=8 y=8 z=8");
		selectWindow("matrin");
		run("Duplicate...", "title=matrin_gblur8 duplicate");
		//run("Gaussian Blur 3D...", "x=16 y=16 z=16");
		run("Gaussian Blur 3D...", "x=12 y=12 z=12");
		imageCalculator("Subtract create stack", "matrin_gblur4","matrin_gblur8");
		rename("matrin_thresh_bin");
		//run("Auto Threshold", "method=Intermodes ignore_black ignore_white white stack use_stack_histogram");
		run("Auto Threshold", "method=Huang ignore_black ignore_white white stack use_stack_histogram");
		run("Close-", "stack");
		run("Open", "stack");
		run("3D Distance Map", "map=EDT image=matrin_thresh_bin mask=Same threshold=1");
		rename("matrin_EDT_inside");
		run("3D Distance Map", "map=EDT image=matrin_thresh_bin mask=Same threshold=1 inverse");
		rename("matrin_EDT_outside");

		selectWindow("matrin");
		close();
		selectWindow("matrin_thresh_bin");
		close();
		selectWindow("matrin_gblur8");
		close();
		selectWindow("matrin_gblur4");
		close();


		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");



		selectWindow("fish");
		run("Duplicate...", "title=fish_gblur4 duplicate");
		run("Gaussian Blur 3D...", "x=4 y=4 z=4");
		selectWindow("fish");
		run("Duplicate...", "title=fish_gblur8 duplicate");
		run("Gaussian Blur 3D...", "x=8 y=8 z=8");
		imageCalculator("Subtract create stack", "fish_gblur4","fish_gblur8");
		run("Auto Threshold", "method=Default ignore_black ignore_white white stack use_stack_histogram");
		run("3D Nuclei Segmentation (beta)", "auto_threshold=Default manual=1");
		rename("fish_thresh_label");
		run("32-bit");

		selectWindow("Result of fish_gblur4");
		close();
		selectWindow("fish_gblur8");
		close();
		selectWindow("fish_gblur4");
		close();

		selectWindow("fish");
		close();

		
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");