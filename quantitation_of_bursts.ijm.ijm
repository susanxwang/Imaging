//require 3 windows:
//original yfp-ms2 window re-labelled "orig"
//segmented image re-labelled "bursts"
//thresholded version of segmented image labelled "thresh"

//setBatchMode("hide");

selectWindow("thresh");
getDimensions(width, height, channels, slices, frames);
//run("Analyze Particles...", "add stack");
//nb = roiManager("count");
burst_frame=newArray(1);
burst_median=newArray(1);
cell_median=newArray(1);
burst_area=newArray(1);
burst_frame[0]=0;
burst_median[0]=0;
cell_median[0]=0;
burst_area[0]=0;
//selectWindow("ROI Manager");
//run("Close");
getDimensions(width, height, channels, slices, frames);
for (i = 0; i < frames; i++) {
	selectWindow("thresh");
	setSlice((i+1));
	selectWindow("bursts");
	setSlice((i+1));
	selectWindow("orig");
	setSlice((i+1));
	selectWindow("thresh");
	run("Analyze Particles...", "add slice");
	nb2 = roiManager("count");
	if (nb2>0) {
		for (j = 0; j < nb2; j++) {
			selectWindow("bursts");
			roiManager("Select", j);
			roiManager("Measure");
			cell_median=Array.concat(cell_median, Table.get("Median", 0));
			burst_area=Array.concat(burst_area, Table.get("Area", 0));
			selectWindow("Results");
			run("Close");
			burst_frame=Array.concat(burst_frame,(i+1));
			selectWindow("orig");
			roiManager("Select", j);
			roiManager("Measure");
			burst_median=Array.concat(burst_median, Table.get("Median", 0));
			selectWindow("Results");
			run("Close");
		}
	}
	selectWindow("ROI Manager");
	run("Close");
}

for (i = 0; i < burst_frame.length; i++) {
	setResult("Burst_Frame", i, burst_frame[i]);
	setResult("Burst_Median_Intensity", i, burst_median[i]);			
	setResult("Burst_Area", i, burst_area[i]);
	setResult("Cell_Median_Intensity", i, cell_median[i]);
}

updateResults();

run("Read and Write Excel");

//setBatchMode("exit and display");