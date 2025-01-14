

-- attach object select in the same object
fn clusterAttach2 objArr =
(
	j = 1
	k = 0
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			
			
			if classof objArr[j].baseobject != editable_Mesh then converttoMesh objArr[j]
				
			-- DESINSTANCE
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j]) then
			(
				format "desinstance: %\n" objArr[j].name
				InstanceMgr.MakeObjectsUnique objArr[j] #prompt
			)
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j+1]) then
			(
				format "desinstance: %\n" objArr[j+1].name
				InstanceMgr.MakeObjectsUnique objArr[j+1] #prompt
			)
			
			-- ATTACH
			if k == 100 then (
			windows.ProcessPostedMessages()
			format "rest: % objects. numface [j]: % [j+1]: % \n"  objArr.count objArr[j].numfaces objArr[j+1].numfaces
			k = 0
				)
			
			
			attach objArr[j] objArr[j+1]
			
			deleteItem objArr (j+1)

			j += 1
			k += 1

			if (j + 1) > objArr.count then j = 1
			

		)
	)
	objArr[1]
)

-- clusterAttach2 (selection as array)

-- $.numfaces
layersCount = layermanager.count 
for i = 0 to (layersCount - 1) do
(
	oneL = LayerManager.getLayer i
	oneL.nodes &layerNodes
-- 	format "i: % oneL.name: % layerNodes: %\n" i oneL.name layerNodes
	if layerNodes.count > 1 then
	(
		clusterAttach2 layerNodes
	)
	format "attach done: %/%\n" i layersCount
	
-- 	if i > 1000 then exit
)