rename("orig");

selectWindow("orig");
run("Z Project...", "projection=[Sum Slices] all");
rename("zproj");
run("Duplicate...", "title=zproj_blur duplicate");
run("Gaussian Blur...", "sigma=6 stack");

getDimensions(width, height, channels, slices, frames);
for (i = 0; i < frames; i++) {
	Stack.setFrame((i+1));
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