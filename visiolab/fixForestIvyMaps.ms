forestIvyMapsPath = @"M:\Biblio\VISIOLAB\7-Plugins\ItooSoftware\Forest Pack Pro\lib\ForestIvy\Climbing Plants\maps"

-- collecte des references externes
ATSOP_paths
ATSOps.GetDependentFiles (maxfilepath + maxFileName) false &ATSOP_paths IncludeOutputFiles: false

for op in ATSOP_paths do
(
	if doesFileExist (forestIvyMapsPath + "\\"+ (filenameFromPath op)) then 
	(
		format "found: %\n" (filenameFromPath op)
		ATSOps.SelectFiles op
-- 		ATSOps.SetPathOnSelection (forestIvyMapsPath + "\\"+ (filenameFromPath op))
		ATSOps.SetPathOnSelection (forestIvyMapsPath + "\\")	
	)
)

-- collecte des textures forestIvy