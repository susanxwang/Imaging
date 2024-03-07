run("Bio-Formats Macro Extensions");

//GreenDir = "G:/smt/green3/";
RedDir = "E:/8-30-21_rapid_dna/dna/";
SaveDir = "E:/8-30-21_rapid_dna/save/";

//setBatchMode(true);

//FileListGreen = getFileList(GreenDir);

FileListRed = getFileList(RedDir);

//Array.sort(FileListGreen);
Array.sort(FileListRed);


for(i=0; i<FileListRed.length; i++) {
		//filenameGreen = FileListGreen[i];
		filenameRed = FileListRed[i];
		
		Ext.openImagePlus(RedDir + filenameRed);

		rename("orig");

		selectWindow("orig");
		run("Z Project...", "projection=[Sum Slices] all");
		rename("zproj");
		run("Duplicate...", "title=zproj_blur duplicate");
		run("Gaussian Blur...", "sigma=6 stack");

		getDimensions(width, height, channels, slices, frames);
		for (j = 0; j < frames; j++) {
			Stack.setFrame((j+1));
			medval = getValue("Median");
			medval = toString(medval);
			medval = parseFloat(medval);
			lowermedval = 0.25 * medval;
			lowermedval = toString(lowermedval);
			lowermedval = parseFloat(lowermedval);	
			uppermedval = 1.5 * medval;
			uppermedval = toString(uppermedval);
			uppermedval = parseFloat(uppermedval);
			changeValues(0, lowermedval, 0);
			changeValues(uppermedval, 65535, uppermedval);
		}



		run("Merge Channels...", "c1=zproj_blur c2=zproj create");

		run("Correct 3D drift", "channel=1 multi_time_scale sub_pixel only=30 lowest=1 highest=1 max_shift_x=10.000000000 max_shift_y=10.000000000 max_shift_z=10");
		selectWindow("registered time points");

		run("Split Channels");
		selectWindow("C1-registered time points");
		close();
		selectWindow("C2-registered time points");

		saveAs("tiff", SaveDir + filenameRed);

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

      	call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");

}

//setBatchMode("exit and display");