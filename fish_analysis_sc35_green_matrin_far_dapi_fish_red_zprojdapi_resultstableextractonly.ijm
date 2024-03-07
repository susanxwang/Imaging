// use plugins/macros/record to record the necessary opening and channel splitting
// 3 images are opened in this example : labels.tif with segmented object, C1-signal.tif and C2-signal.tif with signals to quantify
// select measurments in Manager3D Options, select Plugins/Record to record
run("3D Manager Options", "volume surface compactness fit_ellipse integrated_density mean_grey_value std_dev_grey_value minimum_grey_value maximum_grey_value centroid_(pix) centroid_(unit) distance_to_surface centre_of_mass_(pix) centre_of_mass_(unit) bounding_box radial_distance closest distance_between_centers=10 distance_max_contact=1.80 drawing=Contour use_0");
run("3D Manager");
// select the image with the labelled objects
selectWindow("fish_thresh_label");
Ext.Manager3D_AddImage();
// if list is not visible please refresh list by using Deselect
Ext.Manager3D_Select(0);
Ext.Manager3D_DeselectAll();
// number of results, and arrays to store results
Ext.Manager3D_Count(nb);
// get object labels
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