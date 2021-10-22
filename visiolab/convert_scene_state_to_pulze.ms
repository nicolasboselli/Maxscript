num = sceneStateMgr.GetCount()   

statesAr = for i = 1 to num collect sceneStateMgr.GetSceneState i

for st in statesAr do
(
	local cam = getActiveCamera()
	if isvalidnode cam then
	(
		sceneStateMgr.RestoreAllParts st
		maxOps.cloneNodes #(cam) cloneType: #copy newNodes:&copyCam
		copyCam[1].name = st
	-- 	format "cam: % st: %\n" cam st
	)
)
