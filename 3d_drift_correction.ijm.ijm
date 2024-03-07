		run("Options...", "iterations=1 count=1 black do=Nothing");

		
		rename("orig");

		selectWindow("orig");
//		uncomment line below if not already z-projected; also make sure the z-proj green		
//		run("Z Project...", "projection=[Sum Slices] all");
//		corrent version assumes DNA is C2 and RNA or organelle is C1
		run("Split Channels");
//		selectWindow("C1-orig");
		selectWindow("C2-orig");
		rename("zproj");
		run("Duplicate...", "title=zproj_blur duplicate");
		run("Gaussian Blur 3D...", "x=6 y=6 z=2");
//		run("Subtract Background...", "rolling=300 sliding stack");
		selectWindow("zproj_blur");
		getDimensions(width, height, channels, slices, frames);

		for (j = 0; j < frames; j++) {
				selectWindow("zproj_blur");
				Stack.setFrame((j+1));
				run("Duplicate...", "duplicate frames="+(j+1));
				rename("tempblur");
				setOption("ScaleConversions", true);
				run("16-bit");

				run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack use_stack_histogram");	
				run("Distance Transform Watershed 3D", "distances=[Borgefors (3,4,5)] output=[16 bits] normalize dynamic=8 connectivity=6");
				
				run("3D Manager");
				Ext.Manager3D_AddImage();

				Ext.Manager3D_Count(nb);
				for (k = 1; k < nb; k++) {
					Ext.Manager3D_Measure3D(0,"Vol",quantif0);
					Ext.Manager3D_Measure3D(1,"Vol",quantif1);

					if (quantif0 > quantif1) {
						Ext.Manager3D_Select(1);
						Ext.Manager3D_FillStack(0, 0, 0);
						Ext.Manager3D_Delete();
					}
					else {
						Ext.Manager3D_Select(0);
						Ext.Manager3D_FillStack(0, 0, 0);
						Ext.Manager3D_Delete();
					}					
				}

				selectWindow("tempblur");
				close();
				selectWindow("tempblurdist-watershed");
				rename("tempblur");
				run("8-bit");

				run("Duplicate...", "title=backthreshfind duplicate");


//				Here's where I start identifying the background intensity
				backintensetotal = 0.0;
				slicecount = 0.0;
				run("Select None");
				framesize = getValue("Area");
				framesize = toString(framesize);
				framesize = parseFloat(framesize);
				run("ROI Manager...");

				for (l = 0; l < slices; l++) {
					selectWindow("backthreshfind");
					Stack.setSlice(l+1);
					run("Select None");
					changeValues(1, 255, 255);
					run("Create Selection");
					selectionsize = getValue("Area");
					selectionsize = toString(selectionsize);
					selectionsize = parseFloat(selectionsize);
					if (selectionsize < framesize) {
						roiManager("Add");
						run("Select None");
						run("Dilate", "slice");
						run("Dilate", "slice");
						run("Dilate", "slice");
						run("Dilate", "slice");
						run("Dilate", "slice");
						run("Create Selection");
						roiManager("Add");
						selectWindow("backthreshfind");
						roiManager("Select", newArray(0,1));
						roiManager("XOR");
						roiManager("Add");

						selectWindow("zproj_blur");
						Stack.setSlice(l+1);
						roiManager("Select", 2);
						offmedval = getValue("Median");
						offmedval = toString(offmedval);
						offmedval = parseFloat(offmedval);

						backintensetotal = backintensetotal + offmedval;
						slicecount = slicecount + 1;

						roiManager("deselect");
						roiManager("delete");
					}					
				}

				
				backvalue = backintensetotal/slicecount;
				backvalue = toString(backvalue);
				backvalue = parseFloat(backvalue);

				backfiltvalue = 0.5 * backvalue;
				backfiltvalue = toString(backfiltvalue);
				backfiltvalue = parseFloat(backfiltvalue);

				selectWindow("zproj_blur");
				run("Select None");
				Ext.Manager3D_Quantif3D(0,"Mean",cellmeanintensity);
				cellmeanintensity = toString(cellmeanintensity);
				cellmeanintensity = parseFloat(cellmeanintensity);

				cellmeanfiltintensity = 1.5 * cellmeanintensity;
				cellmeanfiltintensity = toString(cellmeanfiltintensity);
				cellmeanfiltintensity = parseFloat(cellmeanfiltintensity);
				
				
//	setting area outsite cell to a minimum proportional to the background value
//	setting area inside cell to a maximum proportional to the mean value
				for (m = 0; m < slices; m++) {
					selectWindow("backthreshfind");
					Stack.setSlice(m+1);
					run("Select None");
					run("Create Selection");
					selectionsize = getValue("Area");
					selectionsize = toString(selectionsize);
					selectionsize = parseFloat(selectionsize);
					if (selectionsize < framesize) {
						roiManager("Add");
						run("Select None");
						

						selectWindow("zproj_blur");
						Stack.setSlice(m+1);
						run("Select None");
						roiManager("Select", 0);
						run("Make Inverse");
						changeValues(backfiltvalue, 65535, backfiltvalue);
						run("Select None");

						changeValues(cellmeanfiltintensity, 65535, cellmeanfiltintensity);

						roiManager("deselect");
						roiManager("delete");
					}		
				}

				selectWindow("backthreshfind");
				close();
				selectWindow("tempblur");
				close();
				
				Ext.Manager3D_Select(0);
				Ext.Manager3D_Delete();				
		}

		run("Merge Channels...", "c1=zproj_blur c2=zproj c3=C1-orig create");
		rename("tempmerge");

		run("HyperStackReg ", "transformation=[Rigid Body] channel1 show");
		
		run("Split Channels");
//		selectWindow("C1-registered time points");
		selectWindow("C1-tempmerge-registered");
		rename("blur");
//		selectWindow("C2-registered time points");
		selectWindow("C2-tempmerge-registered");
		rename("dna");
//		selectWindow("C3-registered time points");
		selectWindow("C3-tempmerge-registered");
		rename("organelle");
		run("Merge Channels...", "c1=dna c2=organelle c3=blur create");