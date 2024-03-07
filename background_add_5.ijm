		run("3D Manager");
		selectWindow("burst_singcells");
		Ext.Manager3D_Quantif3D(1,"Mean",V);
		V = toString(V);
		V = parseFloat(V);
		W = V*1.7
		W = toString(W);
		W = parseFloat(W);		
		roicount = roiManager("count");
		for (i = 0; i < roicount; i++) {
			setSlice(i+1);
			run("Select All");
			changeValues(0, W, W);
		}
