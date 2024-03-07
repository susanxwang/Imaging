		run("3D Manager Options", "volume surface compactness fit_ellipse integrated_density mean_grey_value std_dev_grey_value minimum_grey_value maximum_grey_value centroid_(pix) centroid_(unit) distance_to_surface centre_of_mass_(pix) centre_of_mass_(unit) bounding_box radial_distance closest distance_between_centers=10 distance_max_contact=1.80 drawing=Contour use_0");
		run("3D Manager");
		//Ext.Manager3D_Reset();
		Ext.Manager3D_SelectAll();
		Ext.Manager3D_Delete();

		// select the image with the labelled objects
		//selectWindow("fish_thresh_label");
		Ext.Manager3D_AddImage();
		// if list is not visible please refresh list by using Deselect
		Ext.Manager3D_Select(0);
		Ext.Manager3D_DeselectAll();
		// number of results, and arrays to store results
		Ext.Manager3D_Count(nb);
