fn clusterAttach objArr =
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
-- 				format "desinstance: %\n" objArr[j].name
				InstanceMgr.MakeObjectsUnique objArr[j] #prompt
			)
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j+1]) then
			(
-- 				format "desinstance: %\n" objArr[j+1].name
				InstanceMgr.MakeObjectsUnique objArr[j+1] #prompt
			)
			
			-- ATTACH
			if k == 100 then 
			(
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




sel = selection as Array
maxOps.CloneNodes sel cloneType: #copy  newNodes: &copySel
-- select copySel

explodeGroup copySel
copySel = for s in copySel where isValidNode s collect s
meshToproxy = clusterAttach copySel

meshToproxy.pivot = point3 0 0 0
ResetXForm meshToProxy
converttopoly meshToProxy

meshFileName = maxFilePath  + (getFilenameFile maxFileName )
vrayProxies = vrayMeshExport nodes: meshToProxy  meshFile:meshFileName autoCreateProxies: true -- exportMultiple: false -- createMultiMtl: true condenseMultiMtl: true

vrPoxyMat = materialLibrary  meshToProxy.material
saveTempMaterialLibrary vrPoxyMat (meshFileName + ".vrmesh.mat")

select meshToProxy
