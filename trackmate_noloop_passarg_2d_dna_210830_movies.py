

# The module __future__ contains some useful functions:
# https://docs.python.org/2/library/__future__.html
###from __future__ import with_statement, division
# This imports the function random from the module random.
###from random import random
# Next we import Java Classes into Jython.
# This is how we can acces the ImageJ API:
# https://imagej.nih.gov/ij/developer/api/allclasses-noframe.html

#from imagej tutorial, thought it might be useful, uncomment if needed
###from ij import IJ, WindowManager
###from ij.gui import GenericDialog

###def create_test_image():



#Default trackmate plugins from their example
import sys
import os
import csv

from fiji.plugin.trackmate import Model
from fiji.plugin.trackmate import Settings
from fiji.plugin.trackmate import TrackMate
from fiji.plugin.trackmate import SelectionModel
from fiji.plugin.trackmate import Logger
from fiji.plugin.trackmate.detection import DogDetectorFactory
from fiji.plugin.trackmate.tracking.sparselap import SparseLAPTrackerFactory
from fiji.plugin.trackmate.tracking import LAPUtils
from ij import IJ
import fiji.plugin.trackmate.visualization.hyperstack.HyperStackDisplayer as HyperStackDisplayer
import fiji.plugin.trackmate.features.FeatureFilter as FeatureFilter
import sys
import fiji.plugin.trackmate.features.track.TrackDurationAnalyzer as TrackDurationAnalyzer

#plugins from trackmate extras
import fiji.plugin.trackmate.Spot as Spot
import fiji.plugin.trackmate.Model as Model
import fiji.plugin.trackmate.Settings as Settings
import fiji.plugin.trackmate.TrackMate as TrackMate
 
import fiji.plugin.trackmate.detection.DogDetectorFactory as DogDetectorFactory
 
import fiji.plugin.trackmate.tracking.LAPUtils as LAPUtils
import fiji.plugin.trackmate.tracking.sparselap.SparseLAPTrackerFactory as SparseLAPTrackerFactory
import fiji.plugin.trackmate.extra.spotanalyzer.SpotMultiChannelIntensityAnalyzerFactory as SpotMultiChannelIntensityAnalyzerFactory
 
import ij. IJ as IJ
import java.io.File as File
import java.util.ArrayList as ArrayList

from ij import IJ
from ij import ImagePlus
import sys
import ij

from fiji.plugin.trackmate import Model
from fiji.plugin.trackmate import Settings
from fiji.plugin.trackmate import TrackMate
from fiji.plugin.trackmate import SelectionModel
from fiji.plugin.trackmate import Logger
from fiji.plugin.trackmate.detection import LogDetectorFactory
from fiji.plugin.trackmate.tracking.sparselap import SparseLAPTrackerFactory
from fiji.plugin.trackmate.tracking import LAPUtils
from fiji.plugin.trackmate.tracking.kdtree import NearestNeighborTrackerFactory

import fiji.plugin.trackmate.visualization.hyperstack.HyperStackDisplayer as HyperStackDisplayer
import fiji.plugin.trackmate.features.FeatureFilter as FeatureFilter
import fiji.plugin.trackmate.features.track.TrackDurationAnalyzer as TrackDurationAnalyzer
import fiji.plugin.trackmate.features.TrackFeatureCalculator as TrackFeatureCalculator
import fiji.plugin.trackmate.action.ExportStatsToIJAction as ExportStatsToIJAction
import fiji.plugin.trackmate.action.ExportAllSpotsStatsAction as ExportAllSpotsStatsAction
import fiji.plugin.trackmate.action.TrackBranchAnalysis as TrackBranchAnalysis

from fiji.plugin.trackmate.io import TmXmlWriter



		# Get currently selected image
		#imp = WindowManager.getCurrentImage()	

importimage = os.environ['INPUTFILE']
print(importimage)
#print(sys.argv[0])
#print(len(sys.argv))
#print(sys.argv[1])
#importimage = sys.argv[1]
#importimage = 'E:\\AIC_MFM_2019\\20191114\\red_nodecon_zproj\\sc35_+e21hr_10nM_900end_red50_0001__Ch1.tif'



#importimage = name

imp = IJ.openImage(importimage)
		#imp = IJ.openImage('C:\Users\Tigetmp\Desktop\Desktop\Dt2\Rosenfeld\Imaging\Single Molecule Tracking\SMT Analysis\Hiro analysis\Tom macro\intermediate files\RGB.tif')
print(imp)

		# Create empty model.
model = Model()

		# Send all messages to ImageJ log window.
model.setLogger(Logger.IJ_LOGGER)

		# Get the number of channels 
nChannels = imp.getNChannels()

		# Setup settings for TrackMate
		# CHANGE THESE PARAMETERS!!!
settings = Settings()
settings.setFrom( imp )

	
		# Spot analyzer: we want the multi-C intensity analyzer.
settings.addSpotAnalyzerFactory( SpotMultiChannelIntensityAnalyzerFactory() )



		# Spot detector.
		#CHANGE TO DOG
settings.detectorFactory = DogDetectorFactory()
settings.detectorSettings = settings.detectorFactory.getDefaultSettings()

		# Configure detector - We use the Strings for the keys
settings.detectorSettings = { 
	   'DO_SUBPIXEL_LOCALIZATION' : True,
	   'RADIUS' : 0.4,
	   'TARGET_CHANNEL' : 1,
	   	'THRESHOLD' : 25.,
	   'DO_MEDIAN_FILTERING' : False,
}

from fiji.plugin.trackmate.features.spot import SpotIntensityAnalyzerFactory
from fiji.plugin.trackmate.features.track import TrackSpeedStatisticsAnalyzer
from fiji.plugin.trackmate.features.track import TrackBranchingAnalyzer
from fiji.plugin.trackmate.features.edges import EdgeVelocityAnalyzer

settings.addSpotAnalyzerFactory(SpotIntensityAnalyzerFactory())
settings.addTrackAnalyzer(TrackSpeedStatisticsAnalyzer())
settings.addEdgeAnalyzer(EdgeVelocityAnalyzer())


		# Configure spot filters - Classical filter on quality
filter1 = FeatureFilter('QUALITY', 10, True)
settings.addSpotFilter(filter1)
#filter2 = FeatureFilter('FRAME', 500, True)
#settings.addSpotFilter(filter2)


		#Set parameters for Spot tracker
frameGap = 3
linkingMax = 0.5
closingMax = 0.5

settings.addTrackAnalyzer(TrackDurationAnalyzer())
settings.addTrackAnalyzer(TrackBranchingAnalyzer())

		# Spot tracker.
settings.trackerFactory = SparseLAPTrackerFactory()
settings.trackerSettings = LAPUtils.getDefaultLAPSettingsMap()
settings.trackerSettings['MAX_FRAME_GAP']  = frameGap
settings.trackerSettings['LINKING_MAX_DISTANCE']  = linkingMax
settings.trackerSettings['GAP_CLOSING_MAX_DISTANCE']  = closingMax

filter3 = FeatureFilter('NUMBER_SPOTS', 5, True)
settings.addTrackFilter(filter3)


trackmate = TrackMate(model, settings)


		#process 
ok = trackmate.checkInput()
if not ok:
		sys.exit(str(trackmate.getErrorMessage()))

ok = trackmate.process()
if not ok:
	    sys.exit(str(trackmate.getErrorMessage()))
    
		#----------------
		# Display results
		#----------------
     
selectionModel = SelectionModel(model)
displayer =  HyperStackDisplayer(model, selectionModel, imp)
displayer.render()
displayer.refresh()
    
		# Echo results with the logger we set at start:
model.getLogger().log(str(model))

TrackFeatureCalculator(model,settings).process()
ExportStatsToIJAction().execute(trackmate)

print(model)

		# export needed files for further analysis

outfile = TmXmlWriter(File(importimage +'.xml'))
outfile.appendModel(model)
outfile.writeToFile()

		#outputfolder = 'C:\Users\Tigetmp\Desktop\Desktop\Dt2\Rosenfeld\Imaging\Single Molecule Tracking\SMT Analysis\Hiro analysis\Tom macro\imagetest\merged\'
		#outputfile = 'RGB'

IJ.selectWindow("Track statistics");
IJ.saveAs("txt",importimage + "tracks");
IJ.selectWindow("Spots in tracks statistics");
IJ.saveAs("txt",importimage + "spot_in_tracks");
IJ.selectWindow("Links in tracks statistics");
IJ.saveAs("txt",importimage + 'links_in_tracks');

from fiji.plugin.trackmate.action import ExportAllSpotsStatsAction
exportspotstats = ExportAllSpotsStatsAction()
exportspotstats.execute(trackmate)

IJ.selectWindow("All Spots statistics");
IJ.saveAs("results",importimage + '.csv');
		
#IJ.runMacroFile('C:\Users\Tigetmp\Desktop\Desktop\Dt2\Rosenfeld\Imaging\Single Molecule Tracking\SMT Analysis\Hiro analysis\Tom macro\close all open images')
	
#IJ.runMacroFile('C:\Users\Tigetmp\Desktop\Desktop\Dt2\Rosenfeld\Imaging\Single Molecule Tracking\SMT Analysis\Hiro analysis\Tom macro\close_non_image_windows.ijm')

imp = None
model = None
settings = None
trackmate = None
outfile = None
displayer = None
selectionModel = None
ok = None
exportspotstats = None
filter1 = None
filter2 = None
filter3 = None
nChannels = None

IJ.run("Quit")
		
