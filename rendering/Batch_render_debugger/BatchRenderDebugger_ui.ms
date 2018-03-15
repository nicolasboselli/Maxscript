Global RenderList = batchRenderMgr
Global RendNum = RenderList.numViews
Global RenderListName = #()

-- update render list
fn RenderListNameUpFN BatchInter =
(
	if (classof BatchInter == interface) then
	(
		local BatchInterName = #()
		local BatchInterNum = BatchInter.numViews
		local TempRender

		for i = 1 to BatchInterNum do
		(
			TempRender = BatchInter.getview i
			append BatchInterName TempRender.name
		)
		return BatchInterName
	)
	else
	(
		print "select interface"
	)
	
)

-- active override preset
fn ActiveOverrideFN =
(
	local RenderListOver = batchRenderMgr
	local RendNum = RenderListOver.numViews
	
	for i = 1 to RendNum do
	(
		TempRender = RenderListOver.getview i
		TempRender.overridePreset = true
	)
)

-- RenderListName = RenderListNameUpFN RenderList

Global SceneCam = #()

Fn FindCameraInSceneFN =
(
	local SceneCamTemp = #()

	for o in ($* as array) do
	(
		if classof o == freecamera then append  SceneCamTemp o
		if classof o == targetcamera then append  SceneCamTemp o
		if classof o == VRayPhysicalCamera then append  SceneCamTemp o
	)
	makeuniquearray SceneCamTemp
	return SceneCamTemp
)

Global SelRender = undefined

Global RenderListRLT
Global BatchDebugRLT
global GoGoBatchRenderRLT
global SelRenderRLT


rollout BatchDebugRLT "BatchRender Debugger"
(
	subrollout SubBatchDebugRLT "Yaha!" height: 800
)

rollout RenderListRLT "Renders List" 
(
	
	group "Renders List"
	(
		MultiLIstBox RenderListMLB "Renders"
		
		button SortByNameBT "Classer par nom" across: 4
		button NewRenderBT "Nouveau"
		button DelRenderBT "Supprimer"
		button DuplicateBT "Dupliquer"
	)
	
	on RenderListRLT open do
	(
		RenderListMLB.items = RenderListNameUpFN RenderList
		ActiveOverrideFN ()
	)
	
	on DelRenderBT pressed do
	(
		SelArray = (RenderListMLB.selection as array)
		
		if (SelArray.count == 1) then 
		(
		RenderList.DeleteView SelArray[1]
		)
		
		RenderListMLB.items = RenderListNameUpFN RenderList
		
	)
	
	on NewRenderBT pressed do
	(
		RenderList.CreateView SceneCam[1]
		RenderListMLB.items = RenderListNameUpFN RenderList
		ActiveOverrideFN ()
	)
	
	
	on RenderListMLB selected SelInt do
	(
		SelArray = (RenderListMLB.selection as array)
		
		if (SelArray.count == 1) then 
		(
			SelRender = RenderList.getview SelArray[1]

			SelRenderRLT.RenderNameET.text = SelRender.name
			SelRenderRLT.OutputFileET.text = SelRender.outputFilename
			SelRenderRLT.RenderActiveCB.state = SelRender.enabled 
			
			if SelRender.camera != undefined then
			(
				SelRenderRLT.CamUsedET.text = (SelRender.camera).name
			)
			else
			(
				SelRenderRLT.CamUsedET.text = "undefined"
			)
			
			SelRenderRLT.StartFromSP.value = SelRender.startFrame
			SelRenderRLT.EndToSP.value = SelRender.endFrame
			SelRenderRLT.WidthSP.value = SelRender.width
			SelRenderRLT.HeightSP.value = SelRender.height 
		)
		else
		(
			SelRender = undefined
			
			SelRenderRLT.RenderActiveCB.state = false
			SelRenderRLT.RenderNameET.text = ""
			SelRenderRLT.OutputFileET.text = ""
			
			SelRenderRLT.CamUsedET.text = ""
			
			SelRenderRLT.StartFromSP.value = 0
			SelRenderRLT.EndToSP.value = 0
			SelRenderRLT.WidthSP.value = 0
			SelRenderRLT.HeightSP.value = 0
		)
	)
	
)




rollout SelRenderRLT "Seleted Render Properties"
(
-- 	vars
	checkbox RenderActiveCB "Render Active :"
	
	group "Frame Range"
	(
		spinner StartFromSP "Render From Frame :" range: [-1000, 10000, 0] type: #integer across: 2
		spinner EndToSP "to :" range: [-1000, 10000, 0] type: #integer
	)
	
	group "Size"
	(
		spinner WidthSP "Largeur :" range: [0, 10000, 0] type: #integer across: 2
		spinner HeightSP "Hauteur :" range: [0, 10000, 0] type: #integer
	)
	
	group "cameras"
	(
		edittext CamUsedET "Camera used:" readonly: true across: 3
		label rien ""
		dropdownlist CameraDPL "Select Cameras:"
	)
	
	group "Layer"
	(
		dropdownlist LayerAssetDPL "Layer Assets:"
	)
	
	group "output"
	(
		edittext RenderNameET "Render Name :" text: ""
		edittext OutputFileET "Output : " text: ""
		button OutputFileBT "..."
	)
	
	on RenderActiveCB changed TheState do
	(
		SelRender.enabled = TheState
	)
	
	on SelRenderRLT open do
	(
		LayerAssetDPL.enabled = false
		
		SceneCam = FindCameraInSceneFN ()
		CameraDPL.items = for o in SceneCam collect o.name
	)
	
	on RenderNameET changed RenderVar do
	(
		SelRender.name = RenderNameET.text
		RenderListRLT.RenderListMLB.items = RenderListNameUpFN RenderList
	)
	
	on CameraDPL selected CamSelInt do
	(
		SelRender.camera = SceneCam[CamSelInt]
		CamUsedET.text = (SelRender.camera).name
	)
	

	
	on StartFromSP changed StartFrom do
	(
		SelRender.startFrame = StartFrom
	)
	
	on EndToSP changed EndFrame do
	(
		SelRender.endFrame = EndFrame
	)
	
	on WidthSP changed WidthVal do
	(
		SelRender.width = WidthVal
	)

	on HeightSP changed HeightVal do
	(
		SelRender.height = HeightVal
	)
	
	on OutputFileBT pressed do
	(
	SelRender.outputFilename = selectSaveBitMap caption: ""
	OutputFileET.text = SelRender.outputFilename
	)
)


rollout GoGoBatchRenderRLT "Send BatchRenders Debugged"
(
	checkbox NetRenderCB "Net Render" across: 3
-- 	button BadSendBT "Send BatchRenders Bugged" 
	button GoodSendBT "Send Render Active" 
	button SendSelRendBT "Send Render Selected" 
	
	on GoGoBatchRenderRLT open do
	(
		NetRenderCB.state = RenderList.netRender 
	)
	
	on NetRenderCB changed thestate do
	(
		RenderList.netRender = thestate
	)
		
	on BadSendBT pressed do
	(
		renderSceneDialog.close()
		
		rendTimeType = 1
		
		renderSceneDialog.commit ()

		batchRenderMgr.render ()
		
		renderSceneDialog.open()
	)
	
	on GoodSendBT pressed do
	(
		renderSceneDialog.close()

		BakrendTimeType = rendTimeType

		rendTimeType = 2

		renderSceneDialog.commit ()

		batchRenderMgr.render ()

		rendTimeType = BakrendTimeType

		renderSceneDialog.open()
	)
)



Createdialog BatchDebugRLT  width: 1000

AddSubRollout BatchDebugRLT.SubBatchDebugRLT RenderListRLT
AddSubRollout BatchDebugRLT.SubBatchDebugRLT SelRenderRLT
AddSubRollout BatchDebugRLT.SubBatchDebugRLT GoGoBatchRenderRLT

