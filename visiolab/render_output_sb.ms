try (destroydialog clientRenderOutputRLT)catch()
rollout clientRenderOutputRLT "clients render output"
(
	local params = #("pos")
	local clientImageSizeINI = getroot() + @"visiolab\clientsImageSize.ini"
	local clientLitsAr = #()

	-- UI
	button editBT "edit settings"
	
	group "Clients"
	(
		listbox clientsLB "clients:" height: 20
-- 		button addClientBT "add" across:2
-- 		button delClientBT "del"
	)
	
	group "Image Type"
	(
		listbox imageTypeLB "type:"  height: 10
-- 		button addTypeBT "add" across:2
-- 		button delTypeBT "del"
	)
	
	edittext sizeET "size:" readonly: true
	button applyBT "apply"  height:40 width: 100
	
	-- functions

	
	-- actions
	on clientRenderOutputRLT open do
	(
		loadRolloutParams clientRenderOutputRLT params
		
		clientsLB.items = sort(getINISetting clientImageSizeINI)
		imageTypeLB.items = getINISetting clientImageSizeINI clientsLB.selected
		sizeET.text = try(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected)catch("")
	)
	
	on clientRenderOutputRLT close do
	(
		writeRolloutParams clientRenderOutputRLT params
	)
		
	
	on clientsLB selected val do
	(
		imageTypeLB.items = getINISetting clientImageSizeINI clientsLB.selected
		sizeET.text = try(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected)catch("")
	)
	
	on imageTypeLB selected val do
	(
		sizeET.text =  try(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected)catch("")
		format "sizeET.text: %\n" (execute sizeET.text)
	)
	
	on applyBT pressed do
	(
		renderSceneDialog.close()
		
		renderWidth = (execute sizeET.text)[1]
		renderHeight =  (execute sizeET.text)[2]
		
		renderSceneDialog.open()
	)
	
	on editBT pressed do
	(
		edit clientImageSizeINI
	)

)
createdialog clientRenderOutputRLT width: 300

-- edit clientImageSizeINI
