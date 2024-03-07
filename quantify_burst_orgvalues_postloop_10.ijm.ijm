run("3D Manager");
Ext.Manager3D_Count(nb4);

if (nb4 > 0 ) {

	sc35_in=newArray(nb4);
	sc35_out=newArray(nb4);
	sc35_out_m_in=newArray(nb4);
	matrin_in=newArray(nb4);
	matrin_out=newArray(nb4);
	matrin_out_m_in=newArray(nb4);

	selectWindow("matrin_EDT_outside");
	Ext.Manager3D_Quantif();
	Ext.Manager3D_SaveQuantif("D:/Imaging/Results.tsv");
	Ext.Manager3D_CloseResult("Q");
	open("D:/Imaging/Q_Results.tsv");
	selectWindow("Q_Results.tsv");
	for (i=0;i<nb4;i++) {
		selectWindow("matrin_segmented");
		Ext.Manager3D_Quantif3D(i,"Mean",Y);
		if (Y > 150) {
			matrin_out[i] = 300;
		}
		if (Y < 150) {
			selectWindow("Q_Results.tsv");
			matrin_out[i] = Table.get("AtCenter", i);
		}	
	}
	selectWindow("Q_Results.tsv");
	run("Close");


	selectWindow("matrin_EDT_inside");
	Ext.Manager3D_Quantif();
	Ext.Manager3D_SaveQuantif("D:/Imaging/Results.tsv");
	Ext.Manager3D_CloseResult("Q");
	open("D:/Imaging/Q_Results.tsv");
	selectWindow("Q_Results.tsv");
	for (i=0;i<nb4;i++) {
		selectWindow("matrin_segmented");
		Ext.Manager3D_Quantif3D(i,"Mean",Y);
		if (Y > 150) {
			matrin_in[i] = 200;
		}
		if (Y < 150) {
			selectWindow("Q_Results.tsv");
			matrin_in[i] = Table.get("AtCenter", i);
		}	
	}
	selectWindow("Q_Results.tsv");
	run("Close");


	selectWindow("sc35_EDT_outside");
	Ext.Manager3D_Quantif();
	Ext.Manager3D_SaveQuantif("D:/Imaging/Results.tsv");
	Ext.Manager3D_CloseResult("Q");
	open("D:/Imaging/Q_Results.tsv");
	selectWindow("Q_Results.tsv");
	for (i=0;i<nb4;i++) {
		selectWindow("sc35_segmented");
		Ext.Manager3D_Quantif3D(i,"Mean",Y);
		if (Y > 150) {
			sc35_out[i] = 300;
		}
		if (Y < 150) {
			selectWindow("Q_Results.tsv");
			sc35_out[i] = Table.get("AtCenter", i);
		}	
	}
	selectWindow("Q_Results.tsv");
	run("Close");


	selectWindow("sc35_EDT_inside");
	Ext.Manager3D_Quantif();
	Ext.Manager3D_SaveQuantif("D:/Imaging/Results.tsv");
	Ext.Manager3D_CloseResult("Q");
	open("D:/Imaging/Q_Results.tsv");
	selectWindow("Q_Results.tsv");
	for (i=0;i<nb4;i++) {
		selectWindow("sc35_segmented");
		Ext.Manager3D_Quantif3D(i,"Mean",Y);
		if (Y > 150) {
			sc35_in[i] = 200;
		}
		if (Y < 150) {
			selectWindow("Q_Results.tsv");
			sc35_in[i] = Table.get("AtCenter", i);
		}	
	}
	selectWindow("Q_Results.tsv");
	run("Close");


	for (i=0;i<nb4;i++) {
		
		sc35_out[i] = toString(sc35_out[i]);
		sc35_out[i] = parseFloat(sc35_out[i]);
		sc35_in[i] = toString(sc35_in[i]);
		sc35_in[i] = parseFloat(sc35_in[i]);
		matrin_out[i] = toString(matrin_out[i]);
		matrin_out[i] = parseFloat(matrin_out[i]);
		matrin_in[i] = toString(matrin_in[i]);
		matrin_in[i] = parseFloat(matrin_in[i]);
		sc35_out_m_in[i] = sc35_out[i] - sc35_in[i];
		matrin_out_m_in[i] = matrin_out[i] - matrin_in[i];
	}

	selectWindow("sc35_segmented");
	run("Duplicate...", "title=sc35_distance duplicate");
	run("Select All");
	run("Clear", "stack");
	run("Select None");
	run("Duplicate...", "title=matrin_distance duplicate");

	for (i=0;i<nb4;i++) {
		selectWindow("sc35_distance");
		Ext.Manager3D_Select(i);
		Ext.Manager3D_FillStack((i+10), (i+10), (i+10));
		selectWindow("matrin_distance");
		Ext.Manager3D_Select(i);
		Ext.Manager3D_FillStack((i+10), (i+10), (i+10));
	}

	selectWindow("sc35_distance");
	run("Z Project...", "projection=[Max Intensity]");
	run("32-bit");
	//run("Replace/Remove Label(s)", "label(s)=1 final=1.224");
	selectWindow("matrin_distance");
	run("Z Project...", "projection=[Max Intensity]");
	run("32-bit");

	for (i=0;i<nb4;i++) {
		selectWindow("MAX_matrin_distance");
		run("Replace/Remove Label(s)", "label(s)=" + (i+ 10) +" final=" + matrin_out_m_in[i]);
		selectWindow("MAX_sc35_distance");
		run("Replace/Remove Label(s)", "label(s)=" + (i+ 10) +" final=" + sc35_out_m_in[i]);
	}

	Ext.Manager3D_DeselectAll();
	selectWindow("matrin_distance");
	close();
	selectWindow("sc35_distance");
	close();

	run("Merge Channels...", "c1=MAX_sc35_distance c2=MAX_matrin_distance create ignore");

	for (i=0;i<nb4;i++) {
		Ext.Manager3D_Select(0);
		Ext.Manager3D_Delete();
	}

}

run("Merge Channels...", "c1=burst_segmented c2=sc35_segmented c3=matrin_segmented create");

//File.delete("D:/Imaging/Q_Results.tsv");
