
setBatchMode(true);



run("Bio-Formats Macro Extensions");

GreenDir = getDirectory("Choose Image Directory");

FileListGreen = getFileList(GreenDir);

Array.sort(FileListGreen);


for(j=0; j<FileListGreen.length; j++) {
		filenameGreen = FileListGreen[j];




		Ext.openImagePlus(GreenDir + filenameGreen);

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
		run("Clear", "stack");
		selectWindow("fish");
		roiManager("Select", 0);
		run("Clear", "stack");
		selectWindow("matrin");
		roiManager("Select", 0);
		run("Clear", "stack");

		selectWindow("sc35");
		run("Select None");
		selectWindow("fish");
		run("Select None");
		selectWindow("matrin");
		run("Select None");
		selectWindow("dapi");
		run("Select None");


		selectWindow("sc35");
		run("Duplicate...", "title=sc35_gblur4 duplicate");
		run("Gaussian Blur 3D...", "x=4 y=4 z=4");
		selectWindow("sc35");
		run("Duplicate...", "title=sc35_gblur8 duplicate");
		run("Gaussian Blur 3D...", "x=8 y=8 z=8");
		imageCalculator("Subtract create stack", "sc35_gblur4","sc35_gblur8");
		run("3D Nuclei Segmentation (beta)", "auto_threshold=Default manual=0");
		rename("sc35_thresh_label");
		//run("Duplicate...", "title=sc35_thresh_bin duplicate");
		//setThreshold(1, 65535);
		//run("Make Binary", "method=Default background=Dark black");
		run("3D Distance Map", "map=EDT image=sc35_thresh_label mask=Same threshold=1");
		rename("sc35_EDT_inside");
		run("3D Distance Map", "map=EDT image=sc35_thresh_label mask=Same threshold=1 inverse");
		rename("sc35_EDT_outside");

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


		selectWindow("fish");
		run("Duplicate...", "title=fish_gblur4 duplicate");
		run("Gaussian Blur 3D...", "x=4 y=4 z=4");
		selectWindow("fish");
		run("Duplicate...", "title=fish_gblur8 duplicate");
		run("Gaussian Blur 3D...", "x=8 y=8 z=8");
		imageCalculator("Subtract create stack", "fish_gblur4","sc35_gblur8");
		run("3D Nuclei Segmentation (beta)", "auto_threshold=Default manual=0");
		rename("fish_thresh_label");
		run("32-bit");

		//run("Merge Channels...", "c1=sc35_EDT_inside c2=sc35_EDT_outside c3=matrin_EDT_inside c4=matrin_EDT_outside c5=fish_thresh_label keep");

		// use plugins/macros/record to record the necessary opening and channel splitting
		// 3 images are opened in this example : labels.tif with segmented object, C1-signal.tif and C2-signal.tif with signals to quantify
		// select measurments in Manager3D Options, select Plugins/Record to record

		run("3D Manager Options", "volume surface compactness fit_ellipse integrated_density mean_grey_value std_dev_grey_value minimum_grey_value maximum_grey_value centroid_(pix) centroid_(unit) distance_to_surface centre_of_mass_(pix) centre_of_mass_(unit) bounding_box radial_distance closest distance_between_centers=10 distance_max_contact=1.80 drawing=Contour use_0");
		run("3D Manager");
		//Ext.Manager3D_Reset();
		Ext.Manager3D_SelectAll();
		Ext.Manager3D_Delete();

		// select the image with the labelled objects
		selectWindow("fish_thresh_label");
		Ext.Manager3D_AddImage();
		// if list is not visible please refresh list by using Deselect
		Ext.Manager3D_Select(0);
		Ext.Manager3D_DeselectAll();
		// number of results, and arrays to store results
		Ext.Manager3D_Count(nb);
		// get object labels

		image_name=newArray(nb);
		for (i=0;i<nb; i++) {
			image_name[i] = filenameGreen;
		}


		
		labels=newArray(nb);
		//vols=newArray(nb);
		selectWindow("fish_thresh_label");
		// loop over objects
		for(i=0;i<nb;i++){
			 Ext.Manager3D_Quantif3D(i,"Mean",quantif); // quantification, use IntDen, Mean, Min,Max, Sigma
			 labels[i]=quantif;
		//	  Ext.Manager3D_Measure3D(i,"Vol",vol); // volume
		//	  vols[i]=vol;
		}

		sc35_in=newArray(nb);
		selectWindow("sc35_EDT_inside");
		// loop over objects
		for(i=0;i<nb;i++){
			 Ext.Manager3D_Quantif3D(i,"Mean",quantif); // quantification, use IntDen, Mean, Min,Max, Sigma
			 sc35_in[i]=quantif;
		}

		sc35_out=newArray(nb);
		selectWindow("sc35_EDT_outside");
		// loop over objects
		for(i=0;i<nb;i++){
			 Ext.Manager3D_Quantif3D(i,"Mean",quantif); // quantification, use IntDen, Mean, Min,Max, Sigma
			 sc35_out[i]=quantif;
		}

		matrin_in=newArray(nb);
		selectWindow("matrin_EDT_inside");
		// loop over objects
		for(i=0;i<nb;i++){
			 Ext.Manager3D_Quantif3D(i,"Mean",quantif); // quantification, use IntDen, Mean, Min,Max, Sigma
			 matrin_in[i]=quantif;
		}

		matrin_out=newArray(nb);
		selectWindow("matrin_EDT_outside");
		// loop over objects
		for(i=0;i<nb;i++){
			 Ext.Manager3D_Quantif3D(i,"Mean",quantif); // quantification, use IntDen, Mean, Min,Max, Sigma
			 matrin_out[i]=quantif;
		}



		
		// create results Table
		for(i=0;i<nb;i++){
			setResult("image_name", i, image_name[i]);
			setResult("label", i, labels[i]);
			setResult("sc35_in", i, sc35_in[i]);
			setResult("sc35_out", i, sc35_out[i]);
			setResult("matrin_in", i, matrin_in[i]);
			setResult("matrin_out", i, matrin_out[i]);
		}
		updateResults();

		run("Read and Write Excel");



		// if list is not visible please refresh list by using Deselect
		//Ext.Manager3D_Select(0);
		//Ext.Manager3D_DeselectAll();



		Ext.Manager3D_Close();
//		list = getList("window.titles");
//		     for (i=0; i<list.length; i++){
//		     winame = list[i];
//		      selectWindow(winame);
//		     run("Close");
//		     }
//
//		while (nImages>0) { 
//		          selectImage(nImages); 
//		          close(); 
//		      } 


}
setBatchMode("exit and display");
