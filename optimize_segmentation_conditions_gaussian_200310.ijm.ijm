rename("orig");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=1 stack");
rename("gblur1");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=2 stack");
rename("gblur2");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=3 stack");
rename("gblur3");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=4 stack");
rename("gblur4");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=5 stack");
rename("gblur5");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=7 stack");
rename("gblur7");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=10 stack");
rename("gblur10");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=20 stack");
rename("gblur20");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=40 stack");
rename("gblur40");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=80 stack");
rename("gblur80");

/*
imageCalculator("Subtract create stack", "orig","gblur1");
rename("orig_minus_gblur1")

imageCalculator("Subtract create stack", "orig","gblur2");
rename("orig_minus_gblur2")

imageCalculator("Subtract create stack", "orig","gblur3");
rename("orig_minus_gblur3")

imageCalculator("Subtract create stack", "orig","gblur4");
rename("orig_minus_gblur4")

imageCalculator("Subtract create stack", "orig","gblur5");
rename("orig_minus_gblur5")

imageCalculator("Subtract create stack", "orig","gblur10");
rename("orig_minus_gblur10")

imageCalculator("Subtract create stack", "orig","gblur20");
rename("orig_minus_gblur20")

imageCalculator("Subtract create stack", "orig","gblur40");
rename("orig_minus_gblur40")

imageCalculator("Subtract create stack", "orig","gblur80");
rename("orig_minus_gblur80")
*/

imageCalculator("Subtract create stack", "gblur2","gblur1");
rename("gblur2_minus_gblur1")

imageCalculator("Subtract create stack", "gblur2","gblur2");
rename("gblur2_minus_gblur2")

imageCalculator("Subtract create stack", "gblur2","gblur3");
rename("gblur2_minus_gblur3")

imageCalculator("Subtract create stack", "gblur2","gblur4");
rename("gblur2_minus_gblur4")

imageCalculator("Subtract create stack", "gblur2","gblur5");
rename("gblur2_minus_gblur5")

imageCalculator("Subtract create stack", "gblur2","gblur7");
rename("gblur2_minus_gblur5")

imageCalculator("Subtract create stack", "gblur2","gblur10");
rename("gblur2_minus_gblur7")

imageCalculator("Subtract create stack", "gblur2","gblur20");
rename("gblur2_minus_gblur20")

imageCalculator("Subtract create stack", "gblur2","gblur40");
rename("gblur2_minus_gblur40")

imageCalculator("Subtract create stack", "gblur2","gblur80");
rename("gblur2_minus_gblur80")

selectWindow("gblur3");
close();
selectWindow("gblur4");
close();
selectWindow("gblur5");
close();
selectWindow("gblur7");
close();
selectWindow("gblur10");
close();
selectWindow("gblur20");
close();
selectWindow("gblur40");
close();
selectWindow("gblur80");
close();