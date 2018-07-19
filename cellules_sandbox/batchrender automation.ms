
-- outputPath = @"T:\Kaufman\Amiens_0518\Prevue\Cellule\T2"
outputPath = @"T:\Kaufman\Amiens_0518\Cellules\CELLULES TYPE\T2_amenagement\rendus"

cams = for c in cameras where classof c != Targetobject collect c
pref = "59241"
suf = "3D"
ssmCount = sceneStateMgr.GetCount()   
for id = 1 to ssmCount do 
(
	sceneStateName = 	sceneStateMgr.GetSceneState id
	format "sceneStateName: %\n" sceneStateName
	-- check scene state
	local check = batchRenderMgr.FindView  sceneStateName
	if check == 0 then
	(
		local batch = batchRenderMgr.CreateView undefined
		batch.name = sceneStateName
		-- trouver camera
		camCandidate = getNodebyname sceneStateName
		if superclassof camCandidate == camera then 	batch.camera = camCandidate
		
		-- trouver le nom de fichier correpondant
		local fileNameAr = filterString sceneStateName "_"
		local filename = outputPath + "\\" + pref + "_" + fileNameAr[fileNameAr.count] +"_"+ suf + ".jpg"
		
		batch.sceneStateName = sceneStateName
		batch.outputFilename = filename
	)
)
