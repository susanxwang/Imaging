run("Bio-Formats Macro Extensions");

//GreenDir = "G:/smt/green3/";
RedDir = "E:/8-30-21_rapid_dna/dna/";
SaveDir = "E:/8-30-21_rapid_dna/save/";

RedDir = "E:/8-30-21_nrip_dna_movie/drift/";
SaveDir = "E:/8-30-21_nrip_dna_movie/save/";

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
//		uncomment line below if not already z-projected; also make sure the z-proj green		
//		run("Z Project...", "projection=[Sum Slices] all");
		run("Split Channels");
		selectWindow("C1-orig");
		rename("zproj");
		run("Duplicate...", "title=zproj_blur duplicate");
		run("Gaussian Blur...", "sigma=6 stack");

		getDimensions(width, height, channels, slices, frames);
		Stack.setFrame(1);
		medval = getValue("Median");
		medval = toString(medval);
		medval = parseFloat(medval);
		
		
		for (j = 0; j < frames; j++) {
			Stack.setFrame((j+1));
//			medval = getValue("Median");
//			medval = toString(medval);
//			medval = parseFloat(medval);
//			lowermedval = 0.25 * medval;
//			lowermedval = toString(lowermedval);
//			lowermedval = parseFloat(lowermedval);	
			uppermedval = 1.5 * medval;
			uppermedval = toString(uppermedval);
			uppermedval = parseFloat(uppermedval);
//			changeValues(0, lowermedval, 0);
			changeValues(uppermedval, 65535, uppermedval);
		}



		run("Merge Channels...", "c1=zproj_blur c2=zproj c3=C2-orig create");

		run("Correct 3D drift", "channel=1 multi_time_scale sub_pixel only=0 lowest=1 highest=1 max_shift_x=130.000000000 max_shift_y=130.000000000 max_shift_z=10");
		selectWindow("registered time points");

		run("Split Channels");
		selectWindow("C1-registered time points");
		close();
		selectWindow("C2-registered time points");
		rename("dna");
		selectWindow("C3-registered time points");
		rename("organelle");
		run("Merge Channels...", "c1=dna c2=organelle create");


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