run("3D Manager");
Ext.Manager3D_Count(nb_pre);
print(nb_pre);

selectWindow("Result of burst_singcells_gblur6");
run("3D Simple Segmentation", "low_threshold=1 min_size=0 max_size=-1");
selectWindow("Seg");
Ext.Manager3D_AddImage();
Ext.Manager3D_Count(nb_post);

if ((nb_post-nb_pre) >1) {
	for (i = nb_pre; i < nb_post; i++) {
		Ext.Manager3D_Select(nb_pre);
		Ext.Manager3D_Delete();	
		print(i);	
	}
}

if ((nb_post-nb_pre) == 1) {
	selectWindow("burst_segmented");
	Ext.Manager3D_Select((nb_post - 1));
	Ext.Manager3D_FillStack(145, 145, 145);
	Ext.Manager3D_Select((nb_post - 1));
	Ext.Manager3D_Delete();	
}

selectWindow("Bin");
close();
selectWindow("Seg");
close();
selectWindow("Result of burst_singcells_gblur6");
close();