
	selectWindow("orig");
	run("Duplicate...", "title=intermed_orig");
	roiManager("Select", 19);
	run("Clear Outside");
	run("Measure");
	k = Table.get("Median", 0);
	k = toString(k);
	k = parseFloat(k);
	print(k);
	j = k * 0.9;
	j = toString(j);
	j = parseFloat(j);
	l = k*0.055+5;
	l = toString(l);
	l = parseFloat(l);
	selectWindow("Results");
	run("Close");
	selectWindow("intermed_orig");
	run("Select None");
	changeValues(0, j, j);

	run("Duplicate...", "title=intermed_gblur6");
	selectWindow("intermed_orig");
	run("Duplicate...", "title=intermed_gblur12");
	selectWindow("intermed_gblur6");
	run("Gaussian Blur...", "sigma=6");
	selectWindow("intermed_gblur12");
	run("Gaussian Blur...", "sigma=12");
	imageCalculator("Subtract create", "intermed_gblur6","intermed_gblur12");
	selectWindow("Result of intermed_gblur6");
	rename("intermed_dog");

//	selectWindow("intermed_gblur12");
//	close();
//	selectWindow("intermed_gblur6");
//	close();
//	selectWindow("intermed_orig");
//	close();





