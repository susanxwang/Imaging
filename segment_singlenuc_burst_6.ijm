run("3D Manager");

selectWindow("burst_singcells");
run("Select None");
run("Duplicate...", "title=burst_singcells_gblur6 duplicate");
selectWindow("burst_singcells");
run("Duplicate...", "title=burst_singcells_gblur12 duplicate");
selectWindow("burst_singcells_gblur6");
run("Gaussian Blur 3D...", "x=6 y=6 z=2");
selectWindow("burst_singcells_gblur12");
run("Gaussian Blur 3D...", "x=12 y=12 z=4");
imageCalculator("Subtract create stack", "burst_singcells_gblur6","burst_singcells_gblur12");
selectWindow("Result of burst_singcells_gblur6");

selectWindow("burst_singcells");
Ext.Manager3D_Quantif3D(1,"Mean",V);
V = toString(V);
V = parseFloat(V);
W = V*0.055+10
W = toString(W);
W = parseFloat(W);


selectWindow("Result of burst_singcells_gblur6");
setThreshold(10, 65535);
run("Convert to Mask", "method=Default background=Default black");

selectWindow("burst_singcells_gblur12");
close();
selectWindow("burst_singcells_gblur6");
close();
selectWindow("burst_singcells");
close();

//Ext.Manager3D_AddImage();