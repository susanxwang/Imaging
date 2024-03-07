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

setBatchMode(true);

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


		for (j = 0; j < frames; j++) {
				Stack.setFrame((j+1));

				run("Duplicate...", "use");
				rename("tempblur");
				setOption("ScaleConversions", true);
				run("16-bit");

				run("Auto Threshold", "method=Huang2 ignore_black ignore_white white");
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

				selectWindow("tempblur");
				roiManager("Select", 0);
				setBackgroundColor(0, 0, 0);
				run("Clear Outside");
				run("Select None");
				run("Dilate");
				run("Dilate");
				run("Dilate");
				run("Dilate");
				run("Dilate");
				run("Create Selection");
				roiManager("Add");
				selectWindow("tempblur");
				roiManager("Select", newArray(0,1));
				roiManager("XOR");
				roiManager("Add");
				close();

				selectWindow("zproj_blur");
				roiManager("Select", 0);
				medval = getValue("Median");
				medval = toString(medval);
				medval = parseFloat(medval);
				roiManager("Select", 2);
				offmedval = getValue("Median");
				offmedval = toString(offmedval);
				offmedval = parseFloat(offmedval);
				offfiltval = 0.5 * offmedval;
				offfiltval = toString(offfiltval);
				offfiltval = parseFloat(offfiltval);

				selectWindow("zproj_blur");
				roiManager("Select", 1);
				run("Make Inverse");
				changeValues(offfiltval, 65535, offfiltval);
				run("Select None");

				uppermedval = 1.5 * medval;
				uppermedval = toString(uppermedval);
				uppermedval = parseFloat(uppermedval);

				changeValues(uppermedval, 65535, uppermedval);

				roiManager("deselect");
				roiManager("delete");
		}




		run("Merge Channels...", "c1=zproj_blur c2=zproj c3=C2-orig create");
		rename("tempmerge");

//		run("Correct 3D drift", "channel=1 multi_time_scale sub_pixel only=0 lowest=1 highest=1 max_shift_x=130.000000000 max_shift_y=130.000000000 max_shift_z=10");
//		selectWindow("registered time points");
		run("HyperStackReg ", "transformation=[Rigid Body] channel1 show");

		run("Split Channels");
//		selectWindow("C1-registered time points");
		selectWindow("C1-tempmerge-registered");
		close();
//		selectWindow("C2-registered time points");
		selectWindow("C2-tempmerge-registered");
		rename("dna");
//		selectWindow("C3-registered time points");
		selectWindow("C3-tempmerge-registered");
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

setBatchMode("exit and display");