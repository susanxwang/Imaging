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
run("Gaussian Blur...", "sigma=6 stack");
rename("gblur6");
selectWindow("orig");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=7 stack");
rename("gblur7");



imageCalculator("Subtract create stack", "gblur1","gblur2");
rename("gblur1_minus_gblur2")

imageCalculator("Subtract create stack", "gblur1","gblur3");
rename("gblur1_minus_gblur3")

imageCalculator("Subtract create stack", "gblur1","gblur4");
rename("gblur1_minus_gblur4")

imageCalculator("Subtract create stack", "gblur1","gblur5");
rename("gblur1_minus_gblur5")

imageCalculator("Subtract create stack", "gblur1","gblur6");
rename("gblur1_minus_gblur6")

imageCalculator("Subtract create stack", "gblur1","gblur7");
rename("gblur1_minus_gblur7")

imageCalculator("Subtract create stack", "gblur2","gblur3");
rename("gblur2_minus_gblur3")

imageCalculator("Subtract create stack", "gblur2","gblur4");
rename("gblur2_minus_gblur4")

imageCalculator("Subtract create stack", "gblur2","gblur5");
rename("gblur2_minus_gblur5")

imageCalculator("Subtract create stack", "gblur2","gblur6");
rename("gblur2_minus_gblur6")

imageCalculator("Subtract create stack", "gblur2","gblur7");
rename("gblur2_minus_gblur7")

imageCalculator("Subtract create stack", "gblur3","gblur4");
rename("gblur3_minus_gblur4")

imageCalculator("Subtract create stack", "gblur3","gblur5");
rename("gblur3_minus_gblur5")

imageCalculator("Subtract create stack", "gblur3","gblur6");
rename("gblur3_minus_gblur6")

imageCalculator("Subtract create stack", "gblur3","gblur7");
rename("gblur3_minus_gblur7")

imageCalculator("Subtract create stack", "gblur4","gblur5");
rename("gblur4_minus_gblur5")

imageCalculator("Subtract create stack", "gblur4","gblur6");
rename("gblur4_minus_gblur6")

imageCalculator("Subtract create stack", "gblur4","gblur7");
rename("gblur4_minus_gblur7")

imageCalculator("Subtract create stack", "gblur5","gblur6");
rename("gblur5_minus_gblur6")

imageCalculator("Subtract create stack", "gblur5","gblur7");
rename("gblur5_minus_gblur7")

imageCalculator("Subtract create stack", "gblur6","gblur7");
rename("gblur6_minus_gblur7")


selectWindow("gblur1");
close();
selectWindow("gblur2");
close();
selectWindow("gblur3");
close();
selectWindow("gblur4");
close();
selectWindow("gblur5");
close();
selectWindow("gblur6");
close();
selectWindow("gblur7");
close();
