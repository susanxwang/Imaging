
run("Set Measurements...", "area mean min median redirect=None decimal=3");
run("Bio-Formats Macro Extensions");

//GreenDir = getDirectory("Choose Green Image Directory");


//RedDir = getDirectory("Choose Red Image Directory");

//SaveDir = getDirectory("Choose a Save Directory");

GreenDir = "C:/Users/Tigetmp/Desktop/test/AIC_green_test_images/greenhdf5/";
RedDir = "C:/Users/Tigetmp/Desktop/test/AIC_green_test_images/redhdf5/";
SaveDir = "C:/Users/Tigetmp/Desktop/test/AIC_green_test_images/tif/";

setBatchMode(true);

FileListGreen = getFileList(GreenDir);

FileListRed = getFileList(RedDir);

Array.sort(FileListGreen);
Array.sort(FileListRed);

for(i=0; i<FileListGreen.length; i++) {
		filenameGreen = FileListGreen[i];
		filenameRed = FileListRed[i];
		
		print(filenameGreen);
		print(filenameRed);
		print(i);


//zplane all
		
		run("Scriptable load HDF5...", "load=" + GreenDir + filenameGreen + " datasetnames=/time1 nframes=1 nchannels=1");

//create dist transform DoG images from organelle channel

//z project average
		rename("orig1");
		selectWindow("orig1");
		run("Z Project...", "projection=[Average Intensity]");
		rename("orig");
		selectWindow("orig");

		



//cell identification and thresholding
		run("Duplicate...", "title=thresh");
		run("Subtract Background...", "rolling=128 sliding");
		run("Auto Threshold", "method=Default ignore_black ignore_white white");
		run("Adjustable Watershed", "tolerance=2");
		run("Duplicate...", "title=thresh_in");
		selectWindow("thresh");
		run("Duplicate...", "title=thresh_out");
		selectWindow("thresh_in");
		setThreshold(127, 255);



		run("Analyze Particles...", "size=20-Infinity add");
		
		nROIs = roiManager("count");
		if (nROIs < 1) {
			break;
		}

		if (nROIs > 1) {

			for (e = 0; e < (nROIs-1); e++) {
				run("Clear Results");
				roiManager("Select", 0);
				roiManager("Measure");
				roiManager("Select", 1);
				roiManager("Measure");
				if (getResult("Area", 0) >= getResult("Area", 1)) {
					roiManager("Select", 1);
					roiManager("Delete");
				}
			
				if (getResult("Area", 0) < getResult("Area", 1)) {
					roiManager("Select", 0);
					roiManager("Delete");
				}
			
			}
		}

		run("Clear Results");
		
/*		
		roiManager("Combine");
		roiManager("Add");
		for (e = 0; e < nROIs; e++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}

*/		
		selectWindow("thresh_out");
		roiManager("Select", 0);
		run("Make Inverse");
		roiManager("Add");

	
		selectWindow("orig");

		run("Duplicate...", "title=test");
		run("Subtract Background...", "rolling=128 sliding");
		roiManager("Select", 0);
		roiManager("Measure");

		k = Table.get("Median", 0);
		k = toString(k);
		k = parseFloat(k);
		j = k * 0.7;
		//.4-.6 was good on roi defined by backsub128 normal image and default autothresh
		j = toString(j);
		j = parseFloat(j);

		run("Clear Outside");
		run("Select None");

		changeValues(0, j, j);

		run("Duplicate...", "title=gblur3");
		run("Gaussian Blur...", "sigma=3");
		selectWindow("test");
		run("Duplicate...", "title=gblur1");
		run("Gaussian Blur...", "sigma=1");

		imageCalculator("Subtract create", "gblur1","gblur3");

		run("Duplicate...", "title=segment");
		run("Remove Outliers...", "radius=2 threshold=100 which=Bright");
		setOption("ScaleConversions", true);
		run("8-bit");
		run("Auto Local Threshold", "method=MidGrey radius=15 parameter_1=0 parameter_2=0 white");










//creation of distance transformed versions of thresholded images


		
		run("Duplicate...", "title=seg_int");
		selectWindow("segment");
		run("Duplicate...", "title=seg_out");
		selectWindow("seg_int");
		run("Exact Euclidean Distance Transform (3D)");
		run("In [+]");
		rename("EDT_internal");
		selectWindow("seg_out");
		run("Invert");
		run("Exact Euclidean Distance Transform (3D)");
		rename("EDT_external");


//duplicate DoG dist transformed image
		selectWindow("EDT_internal");
		run("Duplicate...", " ");
		rename("EDT_internal_2");
		run("Duplicate...", " ");
		rename("EDT_internal_3");
		run("Concatenate...", "open image1=EDT_internal_2 image2=EDT_internal_3 image3=[-- None --]");
		rename("EDT_internal_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_internal");
			run("Duplicate...", " ");
			rename("EDT_internal_2");
			run("Concatenate...", "open image1=EDT_internal_Stack image2=EDT_internal_2 image3=[-- None --]");
			rename("EDT_internal_Stack");
		}


//duplicate inverted DoG dist transformed image
		selectWindow("EDT_external");
		run("Duplicate...", " ");
		rename("EDT_external_2");
		run("Duplicate...", " ");
		rename("EDT_external_3");
		run("Concatenate...", "open image1=EDT_external_2 image2=EDT_external_3 image3=[-- None --]");
		rename("EDT_external_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_external");
			run("Duplicate...", " ");
			rename("EDT_external_2");
			run("Concatenate...", "open image1=EDT_external_Stack image2=EDT_external_2 image3=[-- None --]");
			rename("EDT_external_Stack");
		}


		run("Scriptable load HDF5...", "load=" + RedDir + filenameRed + " datasetnames=/time001,/time002,/time003,/time004,/time005,/time006,/time007,/time008,/time009,/time010,/time011,/time012,/time013,/time014,/time015,/time016,/time017,/time018,/time019,/time020,/time021,/time022,/time023,/time024,/time025,/time026,/time027,/time028,/time029,/time030,/time031,/time032,/time033,/time034,/time035,/time036,/time037,/time038,/time039,/time040,/time041,/time042,/time043,/time044,/time045,/time046,/time047,/time048,/time049,/time050,/time051,/time052,/time053,/time054,/time055,/time056,/time057,/time058,/time059,/time060,/time061,/time062,/time063,/time064,/time065,/time066,/time067,/time068,/time069,/time070,/time071,/time072,/time073,/time074,/time075,/time076,/time077,/time078,/time079,/time080,/time081,/time082,/time083,/time084,/time085,/time086,/time087,/time088,/time089,/time090,/time091,/time092,/time093,/time094,/time095,/time096,/time097,/time098,/time099,/time100,/time101,/time102,/time103,/time104,/time105,/time106,/time107,/time108,/time109,/time110,/time111,/time112,/time113,/time114,/time115,/time116,/time117,/time118,/time119,/time120,/time121,/time122,/time123,/time124,/time125,/time126,/time127,/time128,/time129,/time130,/time131,/time132,/time133,/time134,/time135,/time136,/time137,/time138,/time139,/time140,/time141,/time142,/time143,/time144,/time145,/time146,/time147,/time148,/time149,/time150,/time151,/time152,/time153,/time154,/time155,/time156,/time157,/time158,/time159,/time160,/time161,/time162,/time163,/time164,/time165,/time166,/time167,/time168,/time169,/time170,/time171,/time172,/time173,/time174,/time175,/time176,/time177,/time178,/time179,/time180,/time181,/time182,/time183,/time184,/time185,/time186,/time187,/time188,/time189,/time190,/time191,/time192,/time193,/time194,/time195,/time196,/time197,/time198,/time199,/time200,/time201,/time202,/time203,/time204,/time205,/time206,/time207,/time208,/time209,/time210,/time211,/time212,/time213,/time214,/time215,/time216,/time217,/time218,/time219,/time220,/time221,/time222,/time223,/time224,/time225,/time226,/time227,/time228,/time229,/time230,/time231,/time232,/time233,/time234,/time235,/time236,/time237,/time238,/time239,/time240,/time241,/time242,/time243,/time244,/time245,/time246,/time247,/time248,/time249,/time250,/time251,/time252,/time253,/time254,/time255,/time256,/time257,/time258,/time259,/time260,/time261,/time262,/time263,/time264,/time265,/time266,/time267,/time268,/time269,/time270,/time271,/time272,/time273,/time274,/time275,/time276,/time277,/time278,/time279,/time280,/time281,/time282,/time283,/time284,/time285,/time286,/time287,/time288,/time289,/time290,/time291,/time292,/time293,/time294,/time295,/time296,/time297,/time298,/time299,/time300,/time301,/time302,/time303,/time304,/time305,/time306,/time307,/time308,/time309,/time310,/time311,/time312,/time313,/time314,/time315,/time316,/time317,/time318,/time319,/time320,/time321,/time322,/time323,/time324,/time325,/time326,/time327,/time328,/time329,/time330,/time331,/time332,/time333,/time334,/time335,/time336,/time337,/time338,/time339,/time340,/time341,/time342,/time343,/time344,/time345,/time346,/time347,/time348,/time349,/time350,/time351,/time352,/time353,/time354,/time355,/time356,/time357,/time358,/time359,/time360,/time361,/time362,/time363,/time364,/time365,/time366,/time367,/time368,/time369,/time370,/time371,/time372,/time373,/time374,/time375,/time376,/time377,/time378,/time379,/time380,/time381,/time382,/time383,/time384,/time385,/time386,/time387,/time388,/time389,/time390,/time391,/time392,/time393,/time394,/time395,/time396,/time397,/time398,/time399,/time400,/time401,/time402,/time403,/time404,/time405,/time406,/time407,/time408,/time409,/time410,/time411,/time412,/time413,/time414,/time415,/time416,/time417,/time418,/time419,/time420,/time421,/time422,/time423,/time424,/time425,/time426,/time427,/time428,/time429,/time430,/time431,/time432,/time433,/time434,/time435,/time436,/time437,/time438,/time439,/time440,/time441,/time442,/time443,/time444,/time445,/time446,/time447,/time448,/time449,/time450,/time451,/time452,/time453,/time454,/time455,/time456,/time457,/time458,/time459,/time460,/time461,/time462,/time463,/time464,/time465,/time466,/time467,/time468,/time469,/time470,/time471,/time472,/time473,/time474,/time475,/time476,/time477,/time478,/time479,/time480,/time481,/time482,/time483,/time484,/time485,/time486,/time487,/time488,/time489,/time490,/time491,/time492,/time493,/time494,/time495,/time496,/time497,/time498,/time499,/time500,/time501,/time502,/time503,/time504,/time505,/time506,/time507,/time508,/time509,/time510,/time511,/time512,/time513,/time514,/time515,/time516,/time517,/time518,/time519,/time520,/time521,/time522,/time523,/time524,/time525,/time526,/time527,/time528,/time529,/time530,/time531,/time532,/time533,/time534,/time535,/time536,/time537,/time538,/time539,/time540,/time541,/time542,/time543,/time544,/time545,/time546,/time547,/time548,/time549,/time550,/time551,/time552,/time553,/time554,/time555,/time556,/time557,/time558,/time559,/time560,/time561,/time562,/time563,/time564,/time565,/time566,/time567,/time568,/time569,/time570,/time571,/time572,/time573,/time574,/time575,/time576,/time577,/time578,/time579,/time580,/time581,/time582,/time583,/time584,/time585,/time586,/time587,/time588,/time589,/time590,/time591,/time592,/time593,/time594,/time595,/time596,/time597,/time598,/time599,/time600,/time601,/time602,/time603,/time604,/time605,/time606,/time607,/time608,/time609,/time610,/time611,/time612,/time613,/time614,/time615,/time616,/time617,/time618,/time619,/time620,/time621,/time622,/time623,/time624,/time625,/time626,/time627,/time628,/time629,/time630,/time631,/time632,/time633,/time634,/time635,/time636,/time637,/time638,/time639,/time640,/time641,/time642,/time643,/time644,/time645,/time646,/time647,/time648,/time649,/time650,/time651,/time652,/time653,/time654,/time655,/time656,/time657,/time658,/time659,/time660,/time661,/time662,/time663,/time664,/time665,/time666,/time667,/time668,/time669,/time670,/time671,/time672,/time673,/time674,/time675,/time676,/time677,/time678,/time679,/time680,/time681,/time682,/time683,/time684,/time685,/time686,/time687,/time688,/time689,/time690,/time691,/time692,/time693,/time694,/time695,/time696,/time697,/time698,/time699,/time700,/time701,/time702,/time703,/time704,/time705,/time706,/time707,/time708,/time709,/time710,/time711,/time712,/time713,/time714,/time715,/time716,/time717,/time718,/time719,/time720,/time721,/time722,/time723,/time724,/time725,/time726,/time727,/time728,/time729,/time730,/time731,/time732,/time733,/time734,/time735,/time736,/time737,/time738,/time739,/time740,/time741,/time742,/time743,/time744,/time745,/time746,/time747,/time748,/time749,/time750,/time751,/time752,/time753,/time754,/time755,/time756,/time757,/time758,/time759,/time760,/time761,/time762,/time763,/time764,/time765,/time766,/time767,/time768,/time769,/time770,/time771,/time772,/time773,/time774,/time775,/time776,/time777,/time778,/time779,/time780,/time781,/time782,/time783,/time784,/time785,/time786,/time787,/time788,/time789,/time790,/time791,/time792,/time793,/time794,/time795,/time796,/time797,/time798,/time799,/time800,/time801,/time802,/time803,/time804,/time805,/time806,/time807,/time808,/time809,/time810,/time811,/time812,/time813,/time814,/time815,/time816,/time817,/time818,/time819,/time820,/time821,/time822,/time823,/time824,/time825,/time826,/time827,/time828,/time829,/time830,/time831,/time832,/time833,/time834,/time835,/time836,/time837,/time838,/time839,/time840,/time841,/time842,/time843,/time844,/time845,/time846,/time847,/time848,/time849,/time850,/time851,/time852,/time853,/time854,/time855,/time856,/time857,/time858,/time859,/time860,/time861,/time862,/time863,/time864,/time865,/time866,/time867,/time868,/time869,/time870,/time871,/time872,/time873,/time874,/time875,/time876,/time877,/time878,/time879,/time880,/time881,/time882,/time883,/time884,/time885,/time886,/time887,/time888,/time889,/time890,/time891,/time892,/time893,/time894,/time895,/time896,/time897,/time898,/time899,/time900 nframes=900 nchannels=1");
			
		rename("originalRed");


		selectWindow("originalRed");
		run("32-bit");

		selectWindow("originalRed");
		run("Z Project...", "projection=[Sum Slices] all");
		rename("zprojRed");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_internal_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_external_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");




		run("Merge Channels...", "c1=zprojRed c2=EDT_internal_Stack c3=EDT_external_Stack create");



		saveAs("tiff", SaveDir + filenameRed + "all");

		roiManager("Deselect");
		roiManager("Delete");

		while (nImages>0) { 
          		selectImage(nImages); 
          		close(); 
      		} 

      	list = getList("window.titles");
     			for (k=0; k<list.length; k++){
     				winame = list[k];
      				selectWindow(winame);
    				run("Close");
    			}

//zplane all end

//zplane 1-3 begin

		run("Scriptable load HDF5...", "load=" + GreenDir + filenameGreen + " datasetnames=/time1 nframes=1 nchannels=1");

//create dist transform DoG images from organelle channel

//z project average
		rename("orig1");
		selectWindow("orig1");
		run("Z Project...", "stop=3 projection=[Average Intensity]");
//		run("Z Project...", "projection=[Average Intensity]");
		rename("orig");
		selectWindow("orig");

		



//cell identification and thresholding
		run("Duplicate...", "title=thresh");
		run("Subtract Background...", "rolling=128 sliding");
		run("Auto Threshold", "method=Default ignore_black ignore_white white");
		run("Adjustable Watershed", "tolerance=2");
		run("Duplicate...", "title=thresh_in");
		selectWindow("thresh");
		run("Duplicate...", "title=thresh_out");
		selectWindow("thresh_in");
		setThreshold(127, 255);



		run("Analyze Particles...", "size=20-Infinity add");
		
		nROIs = roiManager("count");
		if (nROIs < 1) {
			break;
		}

		if (nROIs > 1) {

			for (e = 0; e < (nROIs-1); e++) {
				run("Clear Results");
				roiManager("Select", 0);
				roiManager("Measure");
				roiManager("Select", 1);
				roiManager("Measure");
				if (getResult("Area", 0) >= getResult("Area", 1)) {
					roiManager("Select", 1);
					roiManager("Delete");
				}
			
				if (getResult("Area", 0) < getResult("Area", 1)) {
					roiManager("Select", 0);
					roiManager("Delete");
				}
			
			}
		}

		run("Clear Results");
		
/*		
		roiManager("Combine");
		roiManager("Add");
		for (e = 0; e < nROIs; e++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}

*/		
		selectWindow("thresh_out");
		roiManager("Select", 0);
		run("Make Inverse");
		roiManager("Add");

	
		selectWindow("orig");

		run("Duplicate...", "title=test");
		run("Subtract Background...", "rolling=128 sliding");
		roiManager("Select", 0);
		roiManager("Measure");

		k = Table.get("Median", 0);
		k = toString(k);
		k = parseFloat(k);
		j = k * 0.7;
		//.4-.6 was good on roi defined by backsub128 normal image and default autothresh
		j = toString(j);
		j = parseFloat(j);

		run("Clear Outside");
		run("Select None");

		changeValues(0, j, j);

		run("Duplicate...", "title=gblur3");
		run("Gaussian Blur...", "sigma=3");
		selectWindow("test");
		run("Duplicate...", "title=gblur1");
		run("Gaussian Blur...", "sigma=1");

		imageCalculator("Subtract create", "gblur1","gblur3");

		run("Duplicate...", "title=segment");
		run("Remove Outliers...", "radius=2 threshold=100 which=Bright");
		setOption("ScaleConversions", true);
		run("8-bit");
		run("Auto Local Threshold", "method=MidGrey radius=15 parameter_1=0 parameter_2=0 white");










//creation of distance transformed versions of thresholded images


		
		run("Duplicate...", "title=seg_int");
		selectWindow("segment");
		run("Duplicate...", "title=seg_out");
		selectWindow("seg_int");
		run("Exact Euclidean Distance Transform (3D)");
		run("In [+]");
		rename("EDT_internal");
		selectWindow("seg_out");
		run("Invert");
		run("Exact Euclidean Distance Transform (3D)");
		rename("EDT_external");


//duplicate DoG dist transformed image
		selectWindow("EDT_internal");
		run("Duplicate...", " ");
		rename("EDT_internal_2");
		run("Duplicate...", " ");
		rename("EDT_internal_3");
		run("Concatenate...", "open image1=EDT_internal_2 image2=EDT_internal_3 image3=[-- None --]");
		rename("EDT_internal_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_internal");
			run("Duplicate...", " ");
			rename("EDT_internal_2");
			run("Concatenate...", "open image1=EDT_internal_Stack image2=EDT_internal_2 image3=[-- None --]");
			rename("EDT_internal_Stack");
		}


//duplicate inverted DoG dist transformed image
		selectWindow("EDT_external");
		run("Duplicate...", " ");
		rename("EDT_external_2");
		run("Duplicate...", " ");
		rename("EDT_external_3");
		run("Concatenate...", "open image1=EDT_external_2 image2=EDT_external_3 image3=[-- None --]");
		rename("EDT_external_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_external");
			run("Duplicate...", " ");
			rename("EDT_external_2");
			run("Concatenate...", "open image1=EDT_external_Stack image2=EDT_external_2 image3=[-- None --]");
			rename("EDT_external_Stack");
		}


		run("Scriptable load HDF5...", "load=" + RedDir + filenameRed + " datasetnames=/time001,/time002,/time003,/time004,/time005,/time006,/time007,/time008,/time009,/time010,/time011,/time012,/time013,/time014,/time015,/time016,/time017,/time018,/time019,/time020,/time021,/time022,/time023,/time024,/time025,/time026,/time027,/time028,/time029,/time030,/time031,/time032,/time033,/time034,/time035,/time036,/time037,/time038,/time039,/time040,/time041,/time042,/time043,/time044,/time045,/time046,/time047,/time048,/time049,/time050,/time051,/time052,/time053,/time054,/time055,/time056,/time057,/time058,/time059,/time060,/time061,/time062,/time063,/time064,/time065,/time066,/time067,/time068,/time069,/time070,/time071,/time072,/time073,/time074,/time075,/time076,/time077,/time078,/time079,/time080,/time081,/time082,/time083,/time084,/time085,/time086,/time087,/time088,/time089,/time090,/time091,/time092,/time093,/time094,/time095,/time096,/time097,/time098,/time099,/time100,/time101,/time102,/time103,/time104,/time105,/time106,/time107,/time108,/time109,/time110,/time111,/time112,/time113,/time114,/time115,/time116,/time117,/time118,/time119,/time120,/time121,/time122,/time123,/time124,/time125,/time126,/time127,/time128,/time129,/time130,/time131,/time132,/time133,/time134,/time135,/time136,/time137,/time138,/time139,/time140,/time141,/time142,/time143,/time144,/time145,/time146,/time147,/time148,/time149,/time150,/time151,/time152,/time153,/time154,/time155,/time156,/time157,/time158,/time159,/time160,/time161,/time162,/time163,/time164,/time165,/time166,/time167,/time168,/time169,/time170,/time171,/time172,/time173,/time174,/time175,/time176,/time177,/time178,/time179,/time180,/time181,/time182,/time183,/time184,/time185,/time186,/time187,/time188,/time189,/time190,/time191,/time192,/time193,/time194,/time195,/time196,/time197,/time198,/time199,/time200,/time201,/time202,/time203,/time204,/time205,/time206,/time207,/time208,/time209,/time210,/time211,/time212,/time213,/time214,/time215,/time216,/time217,/time218,/time219,/time220,/time221,/time222,/time223,/time224,/time225,/time226,/time227,/time228,/time229,/time230,/time231,/time232,/time233,/time234,/time235,/time236,/time237,/time238,/time239,/time240,/time241,/time242,/time243,/time244,/time245,/time246,/time247,/time248,/time249,/time250,/time251,/time252,/time253,/time254,/time255,/time256,/time257,/time258,/time259,/time260,/time261,/time262,/time263,/time264,/time265,/time266,/time267,/time268,/time269,/time270,/time271,/time272,/time273,/time274,/time275,/time276,/time277,/time278,/time279,/time280,/time281,/time282,/time283,/time284,/time285,/time286,/time287,/time288,/time289,/time290,/time291,/time292,/time293,/time294,/time295,/time296,/time297,/time298,/time299,/time300,/time301,/time302,/time303,/time304,/time305,/time306,/time307,/time308,/time309,/time310,/time311,/time312,/time313,/time314,/time315,/time316,/time317,/time318,/time319,/time320,/time321,/time322,/time323,/time324,/time325,/time326,/time327,/time328,/time329,/time330,/time331,/time332,/time333,/time334,/time335,/time336,/time337,/time338,/time339,/time340,/time341,/time342,/time343,/time344,/time345,/time346,/time347,/time348,/time349,/time350,/time351,/time352,/time353,/time354,/time355,/time356,/time357,/time358,/time359,/time360,/time361,/time362,/time363,/time364,/time365,/time366,/time367,/time368,/time369,/time370,/time371,/time372,/time373,/time374,/time375,/time376,/time377,/time378,/time379,/time380,/time381,/time382,/time383,/time384,/time385,/time386,/time387,/time388,/time389,/time390,/time391,/time392,/time393,/time394,/time395,/time396,/time397,/time398,/time399,/time400,/time401,/time402,/time403,/time404,/time405,/time406,/time407,/time408,/time409,/time410,/time411,/time412,/time413,/time414,/time415,/time416,/time417,/time418,/time419,/time420,/time421,/time422,/time423,/time424,/time425,/time426,/time427,/time428,/time429,/time430,/time431,/time432,/time433,/time434,/time435,/time436,/time437,/time438,/time439,/time440,/time441,/time442,/time443,/time444,/time445,/time446,/time447,/time448,/time449,/time450,/time451,/time452,/time453,/time454,/time455,/time456,/time457,/time458,/time459,/time460,/time461,/time462,/time463,/time464,/time465,/time466,/time467,/time468,/time469,/time470,/time471,/time472,/time473,/time474,/time475,/time476,/time477,/time478,/time479,/time480,/time481,/time482,/time483,/time484,/time485,/time486,/time487,/time488,/time489,/time490,/time491,/time492,/time493,/time494,/time495,/time496,/time497,/time498,/time499,/time500,/time501,/time502,/time503,/time504,/time505,/time506,/time507,/time508,/time509,/time510,/time511,/time512,/time513,/time514,/time515,/time516,/time517,/time518,/time519,/time520,/time521,/time522,/time523,/time524,/time525,/time526,/time527,/time528,/time529,/time530,/time531,/time532,/time533,/time534,/time535,/time536,/time537,/time538,/time539,/time540,/time541,/time542,/time543,/time544,/time545,/time546,/time547,/time548,/time549,/time550,/time551,/time552,/time553,/time554,/time555,/time556,/time557,/time558,/time559,/time560,/time561,/time562,/time563,/time564,/time565,/time566,/time567,/time568,/time569,/time570,/time571,/time572,/time573,/time574,/time575,/time576,/time577,/time578,/time579,/time580,/time581,/time582,/time583,/time584,/time585,/time586,/time587,/time588,/time589,/time590,/time591,/time592,/time593,/time594,/time595,/time596,/time597,/time598,/time599,/time600,/time601,/time602,/time603,/time604,/time605,/time606,/time607,/time608,/time609,/time610,/time611,/time612,/time613,/time614,/time615,/time616,/time617,/time618,/time619,/time620,/time621,/time622,/time623,/time624,/time625,/time626,/time627,/time628,/time629,/time630,/time631,/time632,/time633,/time634,/time635,/time636,/time637,/time638,/time639,/time640,/time641,/time642,/time643,/time644,/time645,/time646,/time647,/time648,/time649,/time650,/time651,/time652,/time653,/time654,/time655,/time656,/time657,/time658,/time659,/time660,/time661,/time662,/time663,/time664,/time665,/time666,/time667,/time668,/time669,/time670,/time671,/time672,/time673,/time674,/time675,/time676,/time677,/time678,/time679,/time680,/time681,/time682,/time683,/time684,/time685,/time686,/time687,/time688,/time689,/time690,/time691,/time692,/time693,/time694,/time695,/time696,/time697,/time698,/time699,/time700,/time701,/time702,/time703,/time704,/time705,/time706,/time707,/time708,/time709,/time710,/time711,/time712,/time713,/time714,/time715,/time716,/time717,/time718,/time719,/time720,/time721,/time722,/time723,/time724,/time725,/time726,/time727,/time728,/time729,/time730,/time731,/time732,/time733,/time734,/time735,/time736,/time737,/time738,/time739,/time740,/time741,/time742,/time743,/time744,/time745,/time746,/time747,/time748,/time749,/time750,/time751,/time752,/time753,/time754,/time755,/time756,/time757,/time758,/time759,/time760,/time761,/time762,/time763,/time764,/time765,/time766,/time767,/time768,/time769,/time770,/time771,/time772,/time773,/time774,/time775,/time776,/time777,/time778,/time779,/time780,/time781,/time782,/time783,/time784,/time785,/time786,/time787,/time788,/time789,/time790,/time791,/time792,/time793,/time794,/time795,/time796,/time797,/time798,/time799,/time800,/time801,/time802,/time803,/time804,/time805,/time806,/time807,/time808,/time809,/time810,/time811,/time812,/time813,/time814,/time815,/time816,/time817,/time818,/time819,/time820,/time821,/time822,/time823,/time824,/time825,/time826,/time827,/time828,/time829,/time830,/time831,/time832,/time833,/time834,/time835,/time836,/time837,/time838,/time839,/time840,/time841,/time842,/time843,/time844,/time845,/time846,/time847,/time848,/time849,/time850,/time851,/time852,/time853,/time854,/time855,/time856,/time857,/time858,/time859,/time860,/time861,/time862,/time863,/time864,/time865,/time866,/time867,/time868,/time869,/time870,/time871,/time872,/time873,/time874,/time875,/time876,/time877,/time878,/time879,/time880,/time881,/time882,/time883,/time884,/time885,/time886,/time887,/time888,/time889,/time890,/time891,/time892,/time893,/time894,/time895,/time896,/time897,/time898,/time899,/time900 nframes=900 nchannels=1");
			
		rename("originalRed");


		selectWindow("originalRed");
		run("32-bit");

		selectWindow("originalRed");
		run("Z Project...", "stop=3 projection=[Sum Slices] all");
//		run("Z Project...", "projection=[Sum Slices] all");
		rename("zprojRed");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_internal_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_external_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");




		run("Merge Channels...", "c1=zprojRed c2=EDT_internal_Stack c3=EDT_external_Stack create");



		saveAs("tiff", SaveDir + filenameRed + "1-3");

		roiManager("Deselect");
		roiManager("Delete");

		while (nImages>0) { 
          		selectImage(nImages); 
          		close(); 
      		} 

      	list = getList("window.titles");
     			for (k=0; k<list.length; k++){
     				winame = list[k];
      				selectWindow(winame);
    				run("Close");
    			}

//zplane 1-3 end

//zplane 4-6 begin

		run("Scriptable load HDF5...", "load=" + GreenDir + filenameGreen + " datasetnames=/time1 nframes=1 nchannels=1");

//create dist transform DoG images from organelle channel

//z project average
		rename("orig1");
		selectWindow("orig1");
		run("Z Project...", "start=4 stop=6 projection=[Average Intensity]");
//		run("Z Project...", "projection=[Average Intensity]");
		rename("orig");
		selectWindow("orig");

		



//cell identification and thresholding
		run("Duplicate...", "title=thresh");
		run("Subtract Background...", "rolling=128 sliding");
		run("Auto Threshold", "method=Default ignore_black ignore_white white");
		run("Adjustable Watershed", "tolerance=2");
		run("Duplicate...", "title=thresh_in");
		selectWindow("thresh");
		run("Duplicate...", "title=thresh_out");
		selectWindow("thresh_in");
		setThreshold(127, 255);



		run("Analyze Particles...", "size=20-Infinity add");
		
		nROIs = roiManager("count");
		if (nROIs < 1) {
			break;
		}

		if (nROIs > 1) {

			for (e = 0; e < (nROIs-1); e++) {
				run("Clear Results");
				roiManager("Select", 0);
				roiManager("Measure");
				roiManager("Select", 1);
				roiManager("Measure");
				if (getResult("Area", 0) >= getResult("Area", 1)) {
					roiManager("Select", 1);
					roiManager("Delete");
				}
			
				if (getResult("Area", 0) < getResult("Area", 1)) {
					roiManager("Select", 0);
					roiManager("Delete");
				}
			
			}
		}

		run("Clear Results");
		
/*		
		roiManager("Combine");
		roiManager("Add");
		for (e = 0; e < nROIs; e++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}

*/		
		selectWindow("thresh_out");
		roiManager("Select", 0);
		run("Make Inverse");
		roiManager("Add");

	
		selectWindow("orig");

		run("Duplicate...", "title=test");
		run("Subtract Background...", "rolling=128 sliding");
		roiManager("Select", 0);
		roiManager("Measure");

		k = Table.get("Median", 0);
		k = toString(k);
		k = parseFloat(k);
		j = k * 0.7;
		//.4-.6 was good on roi defined by backsub128 normal image and default autothresh
		j = toString(j);
		j = parseFloat(j);

		run("Clear Outside");
		run("Select None");

		changeValues(0, j, j);

		run("Duplicate...", "title=gblur3");
		run("Gaussian Blur...", "sigma=3");
		selectWindow("test");
		run("Duplicate...", "title=gblur1");
		run("Gaussian Blur...", "sigma=1");

		imageCalculator("Subtract create", "gblur1","gblur3");

		run("Duplicate...", "title=segment");
		run("Remove Outliers...", "radius=2 threshold=100 which=Bright");
		setOption("ScaleConversions", true);
		run("8-bit");
		run("Auto Local Threshold", "method=MidGrey radius=15 parameter_1=0 parameter_2=0 white");










//creation of distance transformed versions of thresholded images


		
		run("Duplicate...", "title=seg_int");
		selectWindow("segment");
		run("Duplicate...", "title=seg_out");
		selectWindow("seg_int");
		run("Exact Euclidean Distance Transform (3D)");
		run("In [+]");
		rename("EDT_internal");
		selectWindow("seg_out");
		run("Invert");
		run("Exact Euclidean Distance Transform (3D)");
		rename("EDT_external");


//duplicate DoG dist transformed image
		selectWindow("EDT_internal");
		run("Duplicate...", " ");
		rename("EDT_internal_2");
		run("Duplicate...", " ");
		rename("EDT_internal_3");
		run("Concatenate...", "open image1=EDT_internal_2 image2=EDT_internal_3 image3=[-- None --]");
		rename("EDT_internal_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_internal");
			run("Duplicate...", " ");
			rename("EDT_internal_2");
			run("Concatenate...", "open image1=EDT_internal_Stack image2=EDT_internal_2 image3=[-- None --]");
			rename("EDT_internal_Stack");
		}


//duplicate inverted DoG dist transformed image
		selectWindow("EDT_external");
		run("Duplicate...", " ");
		rename("EDT_external_2");
		run("Duplicate...", " ");
		rename("EDT_external_3");
		run("Concatenate...", "open image1=EDT_external_2 image2=EDT_external_3 image3=[-- None --]");
		rename("EDT_external_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_external");
			run("Duplicate...", " ");
			rename("EDT_external_2");
			run("Concatenate...", "open image1=EDT_external_Stack image2=EDT_external_2 image3=[-- None --]");
			rename("EDT_external_Stack");
		}


		run("Scriptable load HDF5...", "load=" + RedDir + filenameRed + " datasetnames=/time001,/time002,/time003,/time004,/time005,/time006,/time007,/time008,/time009,/time010,/time011,/time012,/time013,/time014,/time015,/time016,/time017,/time018,/time019,/time020,/time021,/time022,/time023,/time024,/time025,/time026,/time027,/time028,/time029,/time030,/time031,/time032,/time033,/time034,/time035,/time036,/time037,/time038,/time039,/time040,/time041,/time042,/time043,/time044,/time045,/time046,/time047,/time048,/time049,/time050,/time051,/time052,/time053,/time054,/time055,/time056,/time057,/time058,/time059,/time060,/time061,/time062,/time063,/time064,/time065,/time066,/time067,/time068,/time069,/time070,/time071,/time072,/time073,/time074,/time075,/time076,/time077,/time078,/time079,/time080,/time081,/time082,/time083,/time084,/time085,/time086,/time087,/time088,/time089,/time090,/time091,/time092,/time093,/time094,/time095,/time096,/time097,/time098,/time099,/time100,/time101,/time102,/time103,/time104,/time105,/time106,/time107,/time108,/time109,/time110,/time111,/time112,/time113,/time114,/time115,/time116,/time117,/time118,/time119,/time120,/time121,/time122,/time123,/time124,/time125,/time126,/time127,/time128,/time129,/time130,/time131,/time132,/time133,/time134,/time135,/time136,/time137,/time138,/time139,/time140,/time141,/time142,/time143,/time144,/time145,/time146,/time147,/time148,/time149,/time150,/time151,/time152,/time153,/time154,/time155,/time156,/time157,/time158,/time159,/time160,/time161,/time162,/time163,/time164,/time165,/time166,/time167,/time168,/time169,/time170,/time171,/time172,/time173,/time174,/time175,/time176,/time177,/time178,/time179,/time180,/time181,/time182,/time183,/time184,/time185,/time186,/time187,/time188,/time189,/time190,/time191,/time192,/time193,/time194,/time195,/time196,/time197,/time198,/time199,/time200,/time201,/time202,/time203,/time204,/time205,/time206,/time207,/time208,/time209,/time210,/time211,/time212,/time213,/time214,/time215,/time216,/time217,/time218,/time219,/time220,/time221,/time222,/time223,/time224,/time225,/time226,/time227,/time228,/time229,/time230,/time231,/time232,/time233,/time234,/time235,/time236,/time237,/time238,/time239,/time240,/time241,/time242,/time243,/time244,/time245,/time246,/time247,/time248,/time249,/time250,/time251,/time252,/time253,/time254,/time255,/time256,/time257,/time258,/time259,/time260,/time261,/time262,/time263,/time264,/time265,/time266,/time267,/time268,/time269,/time270,/time271,/time272,/time273,/time274,/time275,/time276,/time277,/time278,/time279,/time280,/time281,/time282,/time283,/time284,/time285,/time286,/time287,/time288,/time289,/time290,/time291,/time292,/time293,/time294,/time295,/time296,/time297,/time298,/time299,/time300,/time301,/time302,/time303,/time304,/time305,/time306,/time307,/time308,/time309,/time310,/time311,/time312,/time313,/time314,/time315,/time316,/time317,/time318,/time319,/time320,/time321,/time322,/time323,/time324,/time325,/time326,/time327,/time328,/time329,/time330,/time331,/time332,/time333,/time334,/time335,/time336,/time337,/time338,/time339,/time340,/time341,/time342,/time343,/time344,/time345,/time346,/time347,/time348,/time349,/time350,/time351,/time352,/time353,/time354,/time355,/time356,/time357,/time358,/time359,/time360,/time361,/time362,/time363,/time364,/time365,/time366,/time367,/time368,/time369,/time370,/time371,/time372,/time373,/time374,/time375,/time376,/time377,/time378,/time379,/time380,/time381,/time382,/time383,/time384,/time385,/time386,/time387,/time388,/time389,/time390,/time391,/time392,/time393,/time394,/time395,/time396,/time397,/time398,/time399,/time400,/time401,/time402,/time403,/time404,/time405,/time406,/time407,/time408,/time409,/time410,/time411,/time412,/time413,/time414,/time415,/time416,/time417,/time418,/time419,/time420,/time421,/time422,/time423,/time424,/time425,/time426,/time427,/time428,/time429,/time430,/time431,/time432,/time433,/time434,/time435,/time436,/time437,/time438,/time439,/time440,/time441,/time442,/time443,/time444,/time445,/time446,/time447,/time448,/time449,/time450,/time451,/time452,/time453,/time454,/time455,/time456,/time457,/time458,/time459,/time460,/time461,/time462,/time463,/time464,/time465,/time466,/time467,/time468,/time469,/time470,/time471,/time472,/time473,/time474,/time475,/time476,/time477,/time478,/time479,/time480,/time481,/time482,/time483,/time484,/time485,/time486,/time487,/time488,/time489,/time490,/time491,/time492,/time493,/time494,/time495,/time496,/time497,/time498,/time499,/time500,/time501,/time502,/time503,/time504,/time505,/time506,/time507,/time508,/time509,/time510,/time511,/time512,/time513,/time514,/time515,/time516,/time517,/time518,/time519,/time520,/time521,/time522,/time523,/time524,/time525,/time526,/time527,/time528,/time529,/time530,/time531,/time532,/time533,/time534,/time535,/time536,/time537,/time538,/time539,/time540,/time541,/time542,/time543,/time544,/time545,/time546,/time547,/time548,/time549,/time550,/time551,/time552,/time553,/time554,/time555,/time556,/time557,/time558,/time559,/time560,/time561,/time562,/time563,/time564,/time565,/time566,/time567,/time568,/time569,/time570,/time571,/time572,/time573,/time574,/time575,/time576,/time577,/time578,/time579,/time580,/time581,/time582,/time583,/time584,/time585,/time586,/time587,/time588,/time589,/time590,/time591,/time592,/time593,/time594,/time595,/time596,/time597,/time598,/time599,/time600,/time601,/time602,/time603,/time604,/time605,/time606,/time607,/time608,/time609,/time610,/time611,/time612,/time613,/time614,/time615,/time616,/time617,/time618,/time619,/time620,/time621,/time622,/time623,/time624,/time625,/time626,/time627,/time628,/time629,/time630,/time631,/time632,/time633,/time634,/time635,/time636,/time637,/time638,/time639,/time640,/time641,/time642,/time643,/time644,/time645,/time646,/time647,/time648,/time649,/time650,/time651,/time652,/time653,/time654,/time655,/time656,/time657,/time658,/time659,/time660,/time661,/time662,/time663,/time664,/time665,/time666,/time667,/time668,/time669,/time670,/time671,/time672,/time673,/time674,/time675,/time676,/time677,/time678,/time679,/time680,/time681,/time682,/time683,/time684,/time685,/time686,/time687,/time688,/time689,/time690,/time691,/time692,/time693,/time694,/time695,/time696,/time697,/time698,/time699,/time700,/time701,/time702,/time703,/time704,/time705,/time706,/time707,/time708,/time709,/time710,/time711,/time712,/time713,/time714,/time715,/time716,/time717,/time718,/time719,/time720,/time721,/time722,/time723,/time724,/time725,/time726,/time727,/time728,/time729,/time730,/time731,/time732,/time733,/time734,/time735,/time736,/time737,/time738,/time739,/time740,/time741,/time742,/time743,/time744,/time745,/time746,/time747,/time748,/time749,/time750,/time751,/time752,/time753,/time754,/time755,/time756,/time757,/time758,/time759,/time760,/time761,/time762,/time763,/time764,/time765,/time766,/time767,/time768,/time769,/time770,/time771,/time772,/time773,/time774,/time775,/time776,/time777,/time778,/time779,/time780,/time781,/time782,/time783,/time784,/time785,/time786,/time787,/time788,/time789,/time790,/time791,/time792,/time793,/time794,/time795,/time796,/time797,/time798,/time799,/time800,/time801,/time802,/time803,/time804,/time805,/time806,/time807,/time808,/time809,/time810,/time811,/time812,/time813,/time814,/time815,/time816,/time817,/time818,/time819,/time820,/time821,/time822,/time823,/time824,/time825,/time826,/time827,/time828,/time829,/time830,/time831,/time832,/time833,/time834,/time835,/time836,/time837,/time838,/time839,/time840,/time841,/time842,/time843,/time844,/time845,/time846,/time847,/time848,/time849,/time850,/time851,/time852,/time853,/time854,/time855,/time856,/time857,/time858,/time859,/time860,/time861,/time862,/time863,/time864,/time865,/time866,/time867,/time868,/time869,/time870,/time871,/time872,/time873,/time874,/time875,/time876,/time877,/time878,/time879,/time880,/time881,/time882,/time883,/time884,/time885,/time886,/time887,/time888,/time889,/time890,/time891,/time892,/time893,/time894,/time895,/time896,/time897,/time898,/time899,/time900 nframes=900 nchannels=1");
			
		rename("originalRed");


		selectWindow("originalRed");
		run("32-bit");

		selectWindow("originalRed");
		run("Z Project...", "start=4 stop=6 projection=[Sum Slices] all");
//		run("Z Project...", "projection=[Sum Slices] all");
		rename("zprojRed");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_internal_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_external_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");




		run("Merge Channels...", "c1=zprojRed c2=EDT_internal_Stack c3=EDT_external_Stack create");



		saveAs("tiff", SaveDir + filenameRed + "4-6");

		roiManager("Deselect");
		roiManager("Delete");

		while (nImages>0) { 
          		selectImage(nImages); 
          		close(); 
      		} 

      	list = getList("window.titles");
     			for (k=0; k<list.length; k++){
     				winame = list[k];
      				selectWindow(winame);
    				run("Close");
    			}

//zplane 4-6 end

//zplane 7-9 begin

		run("Scriptable load HDF5...", "load=" + GreenDir + filenameGreen + " datasetnames=/time1 nframes=1 nchannels=1");

//create dist transform DoG images from organelle channel

//z project average
		rename("orig1");
		selectWindow("orig1");
		run("Z Project...", "start=7 projection=[Average Intensity]");
//		run("Z Project...", "projection=[Average Intensity]");
		rename("orig");
		selectWindow("orig");

		



//cell identification and thresholding
		run("Duplicate...", "title=thresh");
		run("Subtract Background...", "rolling=128 sliding");
		run("Auto Threshold", "method=Default ignore_black ignore_white white");
		run("Adjustable Watershed", "tolerance=2");
		run("Duplicate...", "title=thresh_in");
		selectWindow("thresh");
		run("Duplicate...", "title=thresh_out");
		selectWindow("thresh_in");
		setThreshold(127, 255);



		run("Analyze Particles...", "size=20-Infinity add");
		
		nROIs = roiManager("count");
		if (nROIs < 1) {
			break;
		}

		if (nROIs > 1) {

			for (e = 0; e < (nROIs-1); e++) {
				run("Clear Results");
				roiManager("Select", 0);
				roiManager("Measure");
				roiManager("Select", 1);
				roiManager("Measure");
				if (getResult("Area", 0) >= getResult("Area", 1)) {
					roiManager("Select", 1);
					roiManager("Delete");
				}
			
				if (getResult("Area", 0) < getResult("Area", 1)) {
					roiManager("Select", 0);
					roiManager("Delete");
				}
			
			}
		}

		run("Clear Results");
		
/*		
		roiManager("Combine");
		roiManager("Add");
		for (e = 0; e < nROIs; e++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}

*/		
		selectWindow("thresh_out");
		roiManager("Select", 0);
		run("Make Inverse");
		roiManager("Add");

	
		selectWindow("orig");

		run("Duplicate...", "title=test");
		run("Subtract Background...", "rolling=128 sliding");
		roiManager("Select", 0);
		roiManager("Measure");

		k = Table.get("Median", 0);
		k = toString(k);
		k = parseFloat(k);
		j = k * 0.7;
		//.4-.6 was good on roi defined by backsub128 normal image and default autothresh
		j = toString(j);
		j = parseFloat(j);

		run("Clear Outside");
		run("Select None");

		changeValues(0, j, j);

		run("Duplicate...", "title=gblur3");
		run("Gaussian Blur...", "sigma=3");
		selectWindow("test");
		run("Duplicate...", "title=gblur1");
		run("Gaussian Blur...", "sigma=1");

		imageCalculator("Subtract create", "gblur1","gblur3");

		run("Duplicate...", "title=segment");
		run("Remove Outliers...", "radius=2 threshold=100 which=Bright");
		setOption("ScaleConversions", true);
		run("8-bit");
		run("Auto Local Threshold", "method=MidGrey radius=15 parameter_1=0 parameter_2=0 white");










//creation of distance transformed versions of thresholded images


		
		run("Duplicate...", "title=seg_int");
		selectWindow("segment");
		run("Duplicate...", "title=seg_out");
		selectWindow("seg_int");
		run("Exact Euclidean Distance Transform (3D)");
		run("In [+]");
		rename("EDT_internal");
		selectWindow("seg_out");
		run("Invert");
		run("Exact Euclidean Distance Transform (3D)");
		rename("EDT_external");


//duplicate DoG dist transformed image
		selectWindow("EDT_internal");
		run("Duplicate...", " ");
		rename("EDT_internal_2");
		run("Duplicate...", " ");
		rename("EDT_internal_3");
		run("Concatenate...", "open image1=EDT_internal_2 image2=EDT_internal_3 image3=[-- None --]");
		rename("EDT_internal_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_internal");
			run("Duplicate...", " ");
			rename("EDT_internal_2");
			run("Concatenate...", "open image1=EDT_internal_Stack image2=EDT_internal_2 image3=[-- None --]");
			rename("EDT_internal_Stack");
		}


//duplicate inverted DoG dist transformed image
		selectWindow("EDT_external");
		run("Duplicate...", " ");
		rename("EDT_external_2");
		run("Duplicate...", " ");
		rename("EDT_external_3");
		run("Concatenate...", "open image1=EDT_external_2 image2=EDT_external_3 image3=[-- None --]");
		rename("EDT_external_Stack");
		for(j=0; j < 898; j++) {
			selectWindow("EDT_external");
			run("Duplicate...", " ");
			rename("EDT_external_2");
			run("Concatenate...", "open image1=EDT_external_Stack image2=EDT_external_2 image3=[-- None --]");
			rename("EDT_external_Stack");
		}


		run("Scriptable load HDF5...", "load=" + RedDir + filenameRed + " datasetnames=/time001,/time002,/time003,/time004,/time005,/time006,/time007,/time008,/time009,/time010,/time011,/time012,/time013,/time014,/time015,/time016,/time017,/time018,/time019,/time020,/time021,/time022,/time023,/time024,/time025,/time026,/time027,/time028,/time029,/time030,/time031,/time032,/time033,/time034,/time035,/time036,/time037,/time038,/time039,/time040,/time041,/time042,/time043,/time044,/time045,/time046,/time047,/time048,/time049,/time050,/time051,/time052,/time053,/time054,/time055,/time056,/time057,/time058,/time059,/time060,/time061,/time062,/time063,/time064,/time065,/time066,/time067,/time068,/time069,/time070,/time071,/time072,/time073,/time074,/time075,/time076,/time077,/time078,/time079,/time080,/time081,/time082,/time083,/time084,/time085,/time086,/time087,/time088,/time089,/time090,/time091,/time092,/time093,/time094,/time095,/time096,/time097,/time098,/time099,/time100,/time101,/time102,/time103,/time104,/time105,/time106,/time107,/time108,/time109,/time110,/time111,/time112,/time113,/time114,/time115,/time116,/time117,/time118,/time119,/time120,/time121,/time122,/time123,/time124,/time125,/time126,/time127,/time128,/time129,/time130,/time131,/time132,/time133,/time134,/time135,/time136,/time137,/time138,/time139,/time140,/time141,/time142,/time143,/time144,/time145,/time146,/time147,/time148,/time149,/time150,/time151,/time152,/time153,/time154,/time155,/time156,/time157,/time158,/time159,/time160,/time161,/time162,/time163,/time164,/time165,/time166,/time167,/time168,/time169,/time170,/time171,/time172,/time173,/time174,/time175,/time176,/time177,/time178,/time179,/time180,/time181,/time182,/time183,/time184,/time185,/time186,/time187,/time188,/time189,/time190,/time191,/time192,/time193,/time194,/time195,/time196,/time197,/time198,/time199,/time200,/time201,/time202,/time203,/time204,/time205,/time206,/time207,/time208,/time209,/time210,/time211,/time212,/time213,/time214,/time215,/time216,/time217,/time218,/time219,/time220,/time221,/time222,/time223,/time224,/time225,/time226,/time227,/time228,/time229,/time230,/time231,/time232,/time233,/time234,/time235,/time236,/time237,/time238,/time239,/time240,/time241,/time242,/time243,/time244,/time245,/time246,/time247,/time248,/time249,/time250,/time251,/time252,/time253,/time254,/time255,/time256,/time257,/time258,/time259,/time260,/time261,/time262,/time263,/time264,/time265,/time266,/time267,/time268,/time269,/time270,/time271,/time272,/time273,/time274,/time275,/time276,/time277,/time278,/time279,/time280,/time281,/time282,/time283,/time284,/time285,/time286,/time287,/time288,/time289,/time290,/time291,/time292,/time293,/time294,/time295,/time296,/time297,/time298,/time299,/time300,/time301,/time302,/time303,/time304,/time305,/time306,/time307,/time308,/time309,/time310,/time311,/time312,/time313,/time314,/time315,/time316,/time317,/time318,/time319,/time320,/time321,/time322,/time323,/time324,/time325,/time326,/time327,/time328,/time329,/time330,/time331,/time332,/time333,/time334,/time335,/time336,/time337,/time338,/time339,/time340,/time341,/time342,/time343,/time344,/time345,/time346,/time347,/time348,/time349,/time350,/time351,/time352,/time353,/time354,/time355,/time356,/time357,/time358,/time359,/time360,/time361,/time362,/time363,/time364,/time365,/time366,/time367,/time368,/time369,/time370,/time371,/time372,/time373,/time374,/time375,/time376,/time377,/time378,/time379,/time380,/time381,/time382,/time383,/time384,/time385,/time386,/time387,/time388,/time389,/time390,/time391,/time392,/time393,/time394,/time395,/time396,/time397,/time398,/time399,/time400,/time401,/time402,/time403,/time404,/time405,/time406,/time407,/time408,/time409,/time410,/time411,/time412,/time413,/time414,/time415,/time416,/time417,/time418,/time419,/time420,/time421,/time422,/time423,/time424,/time425,/time426,/time427,/time428,/time429,/time430,/time431,/time432,/time433,/time434,/time435,/time436,/time437,/time438,/time439,/time440,/time441,/time442,/time443,/time444,/time445,/time446,/time447,/time448,/time449,/time450,/time451,/time452,/time453,/time454,/time455,/time456,/time457,/time458,/time459,/time460,/time461,/time462,/time463,/time464,/time465,/time466,/time467,/time468,/time469,/time470,/time471,/time472,/time473,/time474,/time475,/time476,/time477,/time478,/time479,/time480,/time481,/time482,/time483,/time484,/time485,/time486,/time487,/time488,/time489,/time490,/time491,/time492,/time493,/time494,/time495,/time496,/time497,/time498,/time499,/time500,/time501,/time502,/time503,/time504,/time505,/time506,/time507,/time508,/time509,/time510,/time511,/time512,/time513,/time514,/time515,/time516,/time517,/time518,/time519,/time520,/time521,/time522,/time523,/time524,/time525,/time526,/time527,/time528,/time529,/time530,/time531,/time532,/time533,/time534,/time535,/time536,/time537,/time538,/time539,/time540,/time541,/time542,/time543,/time544,/time545,/time546,/time547,/time548,/time549,/time550,/time551,/time552,/time553,/time554,/time555,/time556,/time557,/time558,/time559,/time560,/time561,/time562,/time563,/time564,/time565,/time566,/time567,/time568,/time569,/time570,/time571,/time572,/time573,/time574,/time575,/time576,/time577,/time578,/time579,/time580,/time581,/time582,/time583,/time584,/time585,/time586,/time587,/time588,/time589,/time590,/time591,/time592,/time593,/time594,/time595,/time596,/time597,/time598,/time599,/time600,/time601,/time602,/time603,/time604,/time605,/time606,/time607,/time608,/time609,/time610,/time611,/time612,/time613,/time614,/time615,/time616,/time617,/time618,/time619,/time620,/time621,/time622,/time623,/time624,/time625,/time626,/time627,/time628,/time629,/time630,/time631,/time632,/time633,/time634,/time635,/time636,/time637,/time638,/time639,/time640,/time641,/time642,/time643,/time644,/time645,/time646,/time647,/time648,/time649,/time650,/time651,/time652,/time653,/time654,/time655,/time656,/time657,/time658,/time659,/time660,/time661,/time662,/time663,/time664,/time665,/time666,/time667,/time668,/time669,/time670,/time671,/time672,/time673,/time674,/time675,/time676,/time677,/time678,/time679,/time680,/time681,/time682,/time683,/time684,/time685,/time686,/time687,/time688,/time689,/time690,/time691,/time692,/time693,/time694,/time695,/time696,/time697,/time698,/time699,/time700,/time701,/time702,/time703,/time704,/time705,/time706,/time707,/time708,/time709,/time710,/time711,/time712,/time713,/time714,/time715,/time716,/time717,/time718,/time719,/time720,/time721,/time722,/time723,/time724,/time725,/time726,/time727,/time728,/time729,/time730,/time731,/time732,/time733,/time734,/time735,/time736,/time737,/time738,/time739,/time740,/time741,/time742,/time743,/time744,/time745,/time746,/time747,/time748,/time749,/time750,/time751,/time752,/time753,/time754,/time755,/time756,/time757,/time758,/time759,/time760,/time761,/time762,/time763,/time764,/time765,/time766,/time767,/time768,/time769,/time770,/time771,/time772,/time773,/time774,/time775,/time776,/time777,/time778,/time779,/time780,/time781,/time782,/time783,/time784,/time785,/time786,/time787,/time788,/time789,/time790,/time791,/time792,/time793,/time794,/time795,/time796,/time797,/time798,/time799,/time800,/time801,/time802,/time803,/time804,/time805,/time806,/time807,/time808,/time809,/time810,/time811,/time812,/time813,/time814,/time815,/time816,/time817,/time818,/time819,/time820,/time821,/time822,/time823,/time824,/time825,/time826,/time827,/time828,/time829,/time830,/time831,/time832,/time833,/time834,/time835,/time836,/time837,/time838,/time839,/time840,/time841,/time842,/time843,/time844,/time845,/time846,/time847,/time848,/time849,/time850,/time851,/time852,/time853,/time854,/time855,/time856,/time857,/time858,/time859,/time860,/time861,/time862,/time863,/time864,/time865,/time866,/time867,/time868,/time869,/time870,/time871,/time872,/time873,/time874,/time875,/time876,/time877,/time878,/time879,/time880,/time881,/time882,/time883,/time884,/time885,/time886,/time887,/time888,/time889,/time890,/time891,/time892,/time893,/time894,/time895,/time896,/time897,/time898,/time899,/time900 nframes=900 nchannels=1");
			
		rename("originalRed");


		selectWindow("originalRed");
		run("32-bit");

		selectWindow("originalRed");
		run("Z Project...", "start=7 projection=[Sum Slices] all");
//		run("Z Project...", "projection=[Sum Slices] all");
		rename("zprojRed");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_internal_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");

		selectWindow("EDT_external_Stack");
		run("Properties...", "channels=1 slices=1 frames=900 unit=micrometer pixel_width=.120 pixel_height=.120 voxel_depth=.427 frame=[30 msec]");




		run("Merge Channels...", "c1=zprojRed c2=EDT_internal_Stack c3=EDT_external_Stack create");



		saveAs("tiff", SaveDir + filenameRed + "7-9");

		roiManager("Deselect");
		roiManager("Delete");

		while (nImages>0) { 
          		selectImage(nImages); 
          		close(); 
      		} 

      	list = getList("window.titles");
     			for (k=0; k<list.length; k++){
     				winame = list[k];
      				selectWindow(winame);
    				run("Close");
    			}

//zplane 7-9 end

      	call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");
		call("java.lang.System.gc");

      	
}

setBatchMode("exit and display");

Ext.openImagePlus(GreenDir + filenameGreen);



