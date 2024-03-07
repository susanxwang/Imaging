run("Duplicate...", "title=cell duplicate");
run("Gaussian Blur...", "sigma=4 stack");
run("8-bit");
run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack use_stack_histogram");

getDimensions(width, height, channels, slices, frames);

for (i = 0; i < frames; i++) {
	run("Analyze Particles...", "add slice");
	roiManager("count");
	
}
