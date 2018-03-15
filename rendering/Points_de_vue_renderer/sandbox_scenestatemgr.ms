
cam = $Camera001
outputPath = @"T:\BPD Marignan\SoBlagnac_0917\Perspectives\Perspectives\ptsdevue"
num = sceneStateMgr.GetCount()   

for i = 1 to num do
(
	local oneName = sceneStateMgr.GetSceneState i
	
		-- prevoir les exception avec un find view
	local check = batchRenderMgr.FindView oneName
	if check == 0 then
	(
		local batch = batchRenderMgr.CreateView undefined
		batch.name = oneName
		batch.camera = cam
		
		local filename = outputPath + "\\" + oneName + ".jpg"
		format "path: %\n" filename
		
		batch.sceneStateName = oneName
		batch.outputFilename = filename
	)else(format "batch render deja existant: %\n" oneName)
)


sceneStateMgr.PartsCount() 
sceneStateMgr.GetParts "test"

-- create scene state
sceneStateMgr.Capture "vue02" #{2}

-- replace scenes state
	-- teste si le scene state existe
	-- delete le scene state existant
	-- créé un nouveau scene state
sceneStateMgr.MapIndexToPart 1