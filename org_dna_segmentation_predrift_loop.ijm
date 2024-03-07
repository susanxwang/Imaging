run("Bio-Formats Macro Extensions");

//adjust C1 and C2 comments on lines 38/39 and 126/127 (may be different because of additions to code)
//GreenDir = "G:/smt/green3/";

RedDir = "C:/User/Tom/9-19-21/drift_correct/zproj/";
SaveDir = "C:/User/Tom/9-19-21/drift_correct/save/";

RedDir = "E:/drift_correction/zproj/";
SaveDir = "E:/drift_correction/save/";

RedDir = "D:/test/raw/";
SaveDir = "D:/test/save/";

RedDir = "E:/10-11-21/raw/";
SaveDir = "E:/10-11-21/save/";

RedDir = "C:/User/Tom/drift_correction/rawtest/";
SaveDir = "C:/User/Tom/drift_correction/savetest/";

RedDir = "C:/User/Tom/drift_correction/zproj/";
SaveDir = "C:/User/Tom/drift_correction/segmented/";

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





		run("Options...", "iterations=1 count=1 black edm=32-bit do=Nothing");

		rename("orig");
		run("16-bit");
		run("Split Channels");
		selectWindow("C1-orig");
		rename("org_orig_allframes");
		selectWindow("C2-orig");
		rename("dna_orig_allframes");

		selectWindow("dna_orig_allframes");
		run("Duplicate...", "title=dna_base duplicate");
		selectWindow("org_orig_allframes");
		run("Duplicate...", "title=org_base duplicate");

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

			selectWindow("org_orig_allframes");
			Stack.setFrame((j+1));
			roiManager("Select", 0);
			setBackgroundColor(0, 0, 0);
			run("Clear Outside", "slice");
			run("Select None");

			roiManager("Select", 0);
			org_mean_intensity = getValue("Mean");
			org_mean_intensity = toString(org_mean_intensity);
			org_mean_intensity = parseFloat(org_mean_intensity);
			org_filt_intensity = org_mean_intensity * 1.2;
			org_filt_intensity = toString(org_filt_intensity);
			org_filt_intensity = parseFloat(org_filt_intensity);

			run("Select None");
			changeValues(0, org_filt_intensity, org_filt_intensity);
			

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

		selectWindow("org_orig_allframes");
		run("Duplicate...", "title=org_blur4 duplicate");
		selectWindow("org_orig_allframes");
		run("Duplicate...", "title=org_blur8 duplicate");
		selectWindow("dna_orig_allframes");
		run("Duplicate...", "title=dna_blur4 duplicate");
		selectWindow("dna_orig_allframes");
		run("Duplicate...", "title=dna_blur8 duplicate");
		selectWindow("org_blur4");
		run("Gaussian Blur...", "sigma=4 stack");
		selectWindow("org_blur8");
		run("Gaussian Blur...", "sigma=8 stack");
		selectWindow("dna_blur4");
		run("Gaussian Blur...", "sigma=4 stack");
		selectWindow("dna_blur8");
		run("Gaussian Blur...", "sigma=8 stack");
		imageCalculator("Subtract create stack", "org_blur4","org_blur8");
		selectWindow("Result of org_blur4");
		rename("org_dog");
		imageCalculator("Subtract create stack", "dna_blur4","dna_blur8");
		selectWindow("Result of dna_blur4");
		rename("dna_dog");

		selectWindow("dna_orig_allframes");
		close();
		selectWindow("org_orig_allframes");
		close();
		selectWindow("org_blur4");
		close();
		selectWindow("org_blur8");
		close();
		selectWindow("dna_blur4");
		close();
		selectWindow("dna_blur8");
		close();

		selectWindow("dna_dog");
		run("Duplicate...", "title=dna_dog_template duplicate");	
		selectWindow("dna_dog");
		setThreshold(3000, 65535);
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

		selectWindow("org_dog");
		run("Auto Threshold", "method=Default ignore_black ignore_white white stack");
		
		selectWindow("org_dog");
		run("Duplicate...", "title=org_internal duplicate");
		run("Distance Map", "stack");
		rename("org_internal_edm");
		selectWindow("org_dog");
		run("Duplicate...", "title=org_external duplicate");
		run("Invert", "stack");
		run("Distance Map", "stack");
		rename("org_external_edm");

		selectWindow("org_internal");
		close();
		selectWindow("org_dog");
		close();
		selectWindow("org_external");
		close();

		selectWindow("dna_base");
		run("32-bit");
		selectWindow("org_base");
		run("32-bit");
		selectWindow("dna_dog_output");
		run("32-bit");

		run("Merge Channels...", "c1=org_base c2=dna_base c3=org_external_edm c4=org_internal_edm c5=dna_dog_output create");

		



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



		
		