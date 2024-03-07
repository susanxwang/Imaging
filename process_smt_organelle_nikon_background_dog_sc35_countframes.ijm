

run("Bio-Formats Macro Extensions");

GreenDir = getDirectory("Choose Green Image Directory");


RedDir = getDirectory("Choose Red Image Directory");

SaveDir = getDirectory("Choose a Save Directory");

setBatchMode(true);

FileListGreen = getFileList(GreenDir);

FileListRed = getFileList(RedDir);


for(i=0; i<FileListGreen.length; i++) {
		filenameGreen = FileListGreen[i];
		filenameRed = FileListRed[i];



		Ext.openImagePlus(RedDir + filenameRed);
		rename("originalRed");
		run("32-bit");
		getDimensions(width, height, channels, slices, frames);












		
		Ext.openImagePlus(GreenDir + filenameGreen);

//create dist transform DoG images from organelle channel
		rename("orig");
		selectWindow("orig");
//		run("Z Project...", "projection=[Average Intensity]");
//		selectWindow("orig");
//		selectWindow("AVG_orig");
		run("Duplicate...", "title=thresh");
		run("Auto Threshold", "method=Default ignore_black ignore_white white");
		run("Duplicate...", "title=thresh_in");
		selectWindow("thresh");
		run("Duplicate...", "title=thresh_out");
		selectWindow("thresh_in");
		setThreshold(127, 255);
		run("Create Selection");
		selectWindow("thresh_in");
		run("ROI Manager...");
		roiManager("Add");
		selectWindow("thresh_out");
		run("Create Selection");
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
		run("Duplicate...", "title=seg_int");
		selectWindow("segment");
		run("Duplicate...", "title=seg_out");
		selectWindow("seg_int");
		run("Exact Euclidean Distance Transform (3D)");
		run("In [+]");
		rename("EDT_internal");
		selectWindow("seg_out");
		run("Invert");
		run("Exact Euclidean Distance Transform (3D)");
		rename("EDT_external");


//duplicate DoG dist transformed image
		selectWindow("EDT_internal");
		run("Duplicate...", " ");
		rename("EDT_internal_2");
		run("Duplicate...", " ");
		rename("EDT_internal_3");
		run("Concatenate...", "open image1=EDT_internal_2 image2=EDT_internal_3 image3=[-- None --]");
		rename("EDT_internal_Stack");
		for(j=0; j < (frames - 2); j++) {
			selectWindow("EDT_internal");
			run("Duplicate...", " ");
			rename("EDT_internal_2");
			run("Concatenate...", "open image1=EDT_internal_Stack image2=EDT_internal_2 image3=[-- None --]");
			rename("EDT_internal_Stack");
		}


//duplicate inverted DoG dist transformed image
		selectWindow("EDT_external");
		run("Duplicate...", " ");
		rename("EDT_external_2");
		run("Duplicate...", " ");
		rename("EDT_external_3");
		run("Concatenate...", "open image1=EDT_external_2 image2=EDT_external_3 image3=[-- None --]");
		rename("EDT_external_Stack");
		for(j=0; j < (frames - 2); j++) {
			selectWindow("EDT_external");
			run("Duplicate...", " ");
			rename("EDT_external_2");
			run("Concatenate...", "open image1=EDT_external_Stack image2=EDT_external_2 image3=[-- None --]");
			rename("EDT_external_Stack");
		}



		selectWindow("originalRed");
		run("Properties...", "channels=1 slices=1 frames="+frames+" unit=micron pixel_width=.16 pixel_height=.16 voxel_depth=1 frame=[5 ms]");

		selectWindow("EDT_internal_Stack");
		run("Properties...", "channels=1 slices=1 frames="+frames+" unit=micron pixel_width=.16 pixel_height=.16 voxel_depth=1 frame=[5 ms]");

		selectWindow("EDT_external_Stack");
		run("Properties...", "channels=1 slices=1 frames="+frames+" unit=micron pixel_width=.16 pixel_height=.16 voxel_depth=1 frame=[5 ms]");




		run("Merge Channels...", "c1=originalRed c2=EDT_internal_Stack c3=EDT_external_Stack create");



		saveAs("tiff", SaveDir + filenameRed);

		roiManager("Deselect");
		roiManager("Delete");

		while (nImages>0) { 
          		selectImage(nImages); 
          		close(); 
      		} 

      	list = getList("window.titles");
     			for (k=0; k<list.length; k++){
     				winame = list[k];
      				selectWindow(winame);
    				run("Close");
    			}

      	
}

setBatchMode("exit and display");

Ext.openImagePlus(GreenDir + filenameGreen);



