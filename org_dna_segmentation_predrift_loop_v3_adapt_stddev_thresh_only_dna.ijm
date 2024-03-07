run("Bio-Formats Macro Extensions");

//adjust C1 and C2 comments on lines 38/39 and 126/127 (may be different because of additions to code)
//GreenDir = "G:/smt/green3/";


//REMEMBER TO REMOVE THE REORDER HYPERSTACK IF THE IMAGE IS ALREADY BEING PROPERLY READ
//CHECK THIS BEFORE RUNNING IN BATCH

RedDir = "C:/User/Tom/fast_dna_movies_8_27_8_30_9_22/z_sum_test/";
SaveDir = "C:/User/Tom/fast_dna_movies_8_27_8_30_9_22/seg_test/";

RedDir = "C:/User/Tom/fast_dna_movies_8_27_8_30_9_22/z_sum/";
SaveDir = "C:/User/Tom/fast_dna_movies_8_27_8_30_9_22/segmented/";

//setBatchMode(true);

//FileListGreen = getFileList(GreenDir);

FileListRed = getFileList(RedDir);

//Array.sort(FileListGreen);
Array.sort(FileListRed);

setBatchMode(true);

for(i=0; i<FileListRed.length; i++) {
		//filenameGreen = FileListGreen[i];
		filenameRed = FileListRed[i];
		
//		Ext.openImagePlus(RedDir + filenameRed);
		run("Bio-Formats Importer", "open="+RedDir + filenameRed + " autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

//REMEMBER TO REMOVE THE REORDER HYPERSTACK IF THE IMAGE IS ALREADY BEING PROPERLY READ
//CHECK THIS BEFORE RUNNING IN BATCH
		run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");


		run("Options...", "iterations=1 count=1 black edm=32-bit do=Nothing");

		rename("orig");
		run("16-bit");
		rename("dna_orig_allframes");

		selectWindow("dna_orig_allframes");
		run("Duplicate...", "title=dna_base duplicate");


		selectWindow("dna_orig_allframes");

		run("Duplicate...", "title=dna_blur duplicate");
		run("Gaussian Blur...", "sigma=6 stack");
//run("Subtract Background...", "rolling=300 sliding stack");

		getDimensions(width, height, channels, slices, frames);

		for (j = 0; j < frames; j++) {
			selectWindow("dna_blur");
			Stack.setFrame((j+1));

			run("Duplicate...", "use");
			rename("tempblur");
			setOption("ScaleConversions", true);
			run("16-bit");

			run("Auto Threshold", "method=Huang2 ignore_black ignore_white white");
//			run("Adjustable Watershed", "tolerance=10");
			run("Adjustable Watershed", "tolerance=5");
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

			

			selectWindow("dna_orig_allframes");
			Stack.setFrame((j+1));
			roiManager("Select", 0);
			setBackgroundColor(0, 0, 0);
			run("Clear Outside", "slice");
			run("Select None");

			roiManager("Select", 0);
			dna_mean_intensity = getValue("Mean");
			dna_mean_intensity = toString(dna_mean_intensity);
			dna_mean_intensity = parseFloat(dna_mean_intensity);
			dna_filt_intensity = dna_mean_intensity * 1.2;
			dna_filt_intensity = toString(dna_filt_intensity);
			dna_filt_intensity = parseFloat(dna_filt_intensity);

			run("Select None");
			changeValues(0, dna_filt_intensity, dna_filt_intensity);

			selectWindow("tempblur");
			close();

			if (roiManager("count") > 0) {
				roiManager("Deselect");
				roiManager("Delete");
			}
			
		}

		selectWindow("dna_blur");
		close();


		selectWindow("dna_orig_allframes");
		run("Duplicate...", "title=dna_blur4 duplicate");
		selectWindow("dna_orig_allframes");
		run("Duplicate...", "title=dna_blur8 duplicate");
		selectWindow("dna_blur4");
		run("Gaussian Blur...", "sigma=2 stack");
		selectWindow("dna_blur8");
		run("Gaussian Blur...", "sigma=4 stack");
		imageCalculator("Subtract create stack", "dna_blur4","dna_blur8");
		selectWindow("Result of dna_blur4");
		rename("dna_dog");

		selectWindow("dna_orig_allframes");
		close();
		selectWindow("dna_blur4");
		close();
		selectWindow("dna_blur8");
		close();

		selectWindow("dna_dog");
		run("Duplicate...", "title=dna_dog_template duplicate");	



		for (s = 0; s < frames; s++) {
			selectWindow("dna_dog");
			Stack.setFrame((s+1));
			run("Select None");
			run("Duplicate...", "title=dna_dog_doubletemp");
			setThreshold(1, 65535);
			run("Convert to Mask", "method=Default background=Default black");
			run("Create Selection");
			roiManager("Add");
			selectWindow("dna_dog");
			Stack.setFrame((s+1));
			run("Select None");
			roiManager("Select", 0);
			stddev_value = getValue("StdDev");
			stddev_value = toString(stddev_value);
			stddev_value = parseFloat(stddev_value);

			stddev_thresh_value = stddev_value * 9;
			stddev_thresh_value = toString(stddev_thresh_value);
			stddev_thresh_value = parseFloat(stddev_thresh_value);
			
			run("Select None");

			changeValues(stddev_thresh_value, 65535, 65535);
			changeValues(0, stddev_thresh_value, 0);

			
			selectWindow("dna_dog_doubletemp");	
			close();
				
			roiManager("Deselect");
			roiManager("Delete");
		}

		selectWindow("dna_dog");		
		setThreshold(1000, 65535);
		run("Convert to Mask", "method=Default background=Default black");
		run("Duplicate...", "title=dna_dog_output duplicate");
		run("16-bit");	
		for (s = 0; s < frames; s++) {
			selectWindow("dna_dog");
			Stack.setFrame((s+1));

			run("Analyze Particles...", "add slice");
			roinum = roiManager("count");

			for (t = 0; t < roinum; t++) {
				selectWindow("dna_dog_template");
				Stack.setFrame((s+1));
				
				roiManager("Select", t);
				
				burst_intensity = getValue("Mean");
				burst_intensity = toString(burst_intensity);
				burst_intensity = parseFloat(burst_intensity);

				burst_area = getValue("Area");
				burst_area = toString(burst_area);
				burst_area = parseFloat(burst_area);	

				burst_value = burst_intensity * burst_area;
				burst_value = toString(burst_value);
				burst_value = parseFloat(burst_value);

				run("Select None");

				selectWindow("dna_dog_output");
				Stack.setFrame((s+1));
				roiManager("Select", t);

				changeValues(1, 65536, burst_value);
				run("Select None");
				
			}

			if (roiManager("count") > 0) {
				roiManager("Deselect");
				roiManager("Delete");
			}

			
		}

		selectWindow("dna_dog");
		close();
		selectWindow("dna_dog_template");
		close();

		selectWindow("dna_base");
		run("32-bit");
		selectWindow("dna_dog_output");
		run("32-bit");

		run("Merge Channels...", "c1=dna_base c2=dna_dog_output create");

		



		saveAs("tiff", SaveDir + filenameRed);

		while (nImages>0) { 
       		selectImage(nImages); 
       		close(); 
   		} 

//      	list = getList("window.titles");
//     			for (k=0; k<list.length; k++){
//     				winame = list[k];
//      				selectWindow(winame);
//    				run("Close");
//    			}

		if (roiManager("count") > 0) {
			roiManager("Deselect");
			roiManager("Delete");
		}

      	call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");

}

setBatchMode("exit and display");



		
		