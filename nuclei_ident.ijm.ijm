rename("orig");
run("Split Channels");
selectWindow("C1-orig");
close();
selectWindow("C2-orig");
rename("burst_orig");
selectWindow("C3-orig");
close();

selectWindow("burst_orig");
run("Duplicate...", "title=burst_orig_nucfind duplicate");

run("Gaussian Blur 3D...", "x=10 y=10 z=3");
run("Subtract Background...", "rolling=500 stack");
run("Auto Threshold", "method=Huang2 ignore_black ignore_white white stack use_stack_histogram");
//play w dynamic to get more division (lower) or less (ress) from watershed
run("Distance Transform Watershed 3D", "distances=[Borgefors (3,4,5)] output=[16 bits] normalize dynamic=16 connectivity=6");