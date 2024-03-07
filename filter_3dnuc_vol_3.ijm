run("3D Manager");

badnucs = newArray(0);

Ext.Manager3D_Count(nb);

for (i = 0; i < nb; i++) {
	Ext.Manager3D_Measure3D(i,"Vol",V);
	if (V> 1500) {
		badnucs = Array.concat(badnucs,i);
	}

	if (V<300) {
		badnucs = Array.concat(badnucs,i);
	}


}

Array.print(badnucs);
Array.reverse(badnucs);
Array.print(badnucs);

badnucs.length;

for (i = 0; i < badnucs.length; i++) {
	print(badnucs[i]);
	Ext.Manager3D_Select(badnucs[i]);
	Ext.Manager3D_Delete();
}

