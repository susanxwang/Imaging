setBatchMode("hide");
rename("orig");
run("Split Channels");
selectWindow("C1-orig");
setThreshold(0, 20000);
run("Create Selection");
run("Set...", "value=20000 stack");
run("Select None");
run("Duplicate...", "title=gblur3 duplicate");
selectWindow("C1-orig");
run("Duplicate...", "title=gblur6 duplicate");
selectWindow("C1-orig");
selectWindow("gblur3");
//set sigma so sigma*pixel width equals .3 micron for small, or .45 for large sc35 detection
run("Gaussian Blur...", "sigma=6 stack");
selectWindow("gblur6");
run("Gaussian Blur...", "sigma=12 stack");
imageCalculator("Subtract create stack", "gblur3","gblur6");
selectWindow("Result of gblur3");
rename("dog");
run("Auto Threshold", "method=Default ignore_black ignore_white white stack");
selectWindow("gblur6");
close();
selectWindow("gblur3");
close();
selectWindow("C1-orig");
close();
selectWindow("dog");
run("Duplicate...", "title=internal duplicate");
selectWindow("dog");
run("Duplicate...", "title=external duplicate");


selectWindow("external");
Stack.setFrame(1);
run("3D Distance Map", "map=EDT image=external mask=Same threshold=1 inverse");
rename("external_EDT");
selectWindow("external");
getDimensions(width, height, channels, slices, frames);
print(frames);
for (i = 1; i < frames; i++) {
	selectWindow("external");
	Stack.setFrame((i+1));
	run("Duplicate...", " ");
	rename("external_temp");
	run("3D Distance Map", "map=EDT image=external_temp mask=Same threshold=1 inverse");
	run("Concatenate...", "open image1=external_EDT image2=EDT image3=[-- None --]");
	rename("external_EDT");
	selectWindow("external_temp");
	close();
}


selectWindow("internal");
Stack.setFrame(1);
run("3D Distance Map", "map=EDT image=internal mask=Same threshold=1");
rename("internal_EDT");
selectWindow("internal");
getDimensions(width, height, channels, slices, frames);
print(frames);
for (i = 1; i < frames; i++) {
	selectWindow("internal");
	Stack.setFrame((i+1));
	run("Duplicate...", " ");
	rename("internal_temp");
	run("3D Distance Map", "map=EDT image=internal_temp mask=Same threshold=1");
	run("Concatenate...", "open image1=internal_EDT image2=EDT image3=[-- None --]");
	rename("internal_EDT");
	selectWindow("internal_temp");
	close();
}

selectWindow("C2-orig");
run("32-bit");
run("Merge Channels...", "c1=C2-orig c2=internal_EDT c3=external_EDT create");
setBatchMode("exit and display");
