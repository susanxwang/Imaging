//selectWindow("Q_ResultsMeasure.csv");
//atcenter = Table.get("Min", 0);

//run("Clear Results");
//run("Results... ", "open=D:/Q_ResultsMeasure.csv");
//print(getResultString("AtCenter", 1));
//print(atcenter);

//getInfo("window.type");
//getResultLabel(1);

//print(getResult("label", 1));

run("3D Manager");
selectWindow("fish_thresh_label");
Ext.Manager3D_AddImage();
		// if list is not visible please refresh list by using Deselect
Ext.Manager3D_Select(0);
Ext.Manager3D_Delete();
selectWindow("sc35_EDT_outside");
Ext.Manager3D_Quantif();
Ext.Manager3D_SaveQuantif("D:\Results.tsv");
Ext.Manager3D_CloseResult("Q");
//run("Results... ", "open=D:\Q_Tom_ResultsQuantif.tsv");
open("D:/Q_Results.tsv");
print(getResult("AtCenter", 0));
selectWindow("Q_Results.tsv");
Table.get("AtCenter", 0);
run("Close");
File.delete("D:/Q_Results.tsv");
Ext.Manager3D_Select(0);
Ext.Manager3D_DeselectAll();
//selectWindow("sc35_EDT_inside");
//selectWindow("sc35_EDT_outside");
selectWindow("matrin_EDT_inside");
//selectWindow("matrin_EDT_outside");
Ext.Manager3D_Quantif();
Ext.Manager3D_SaveQuantif("D:\Results.tsv");
Ext.Manager3D_CloseResult("Q");
open("D:/Q_Results.tsv");
print(getResult("AtCenter", 0));
selectWindow("Q_Results.tsv");
Table.get("AtCenter", 0);
File.delete("D:/Q_Results.tsv");
Ext.Manager3D_Select(0);

