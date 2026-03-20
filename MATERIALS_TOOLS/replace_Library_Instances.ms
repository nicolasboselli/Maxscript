-- loadMaterialLibrary @"X:\MDH\_PC\St Maur_Sebastopol_0725\Perspective\Scenes 3d\GEN\St Maur_Sebastopol_0725_GEN_001.max"

saveTempMaterialLibrary  sceneMaterials @"C:\Users\nicolas\Documents\3ds Max 2024\tempLibMat.mat"
oneLib = loadTempMaterialLibrary  @"C:\Users\nicolas\Documents\3ds Max 2024\tempLibMat.mat"
oneLib.count 

-- sceneMaterials 
-- getMatLibFileName() 

-- replaceinstances scenematerials["verre"] currentMaterialLibrary["verre"]

i = 0
for m in scenematerials do
(
	i += 1
	oldMat = oneLib[m.name]
	format "oldMat: % isValidNode: %\n" oldmat (isvalidnode oldmat)
	format "i: % m: %\n" i m.name
	if oldmat != undefined then
	(
		
		replaceinstances m oldmat
	)
	else()
)