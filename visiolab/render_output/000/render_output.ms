try (destroydialog clientRenderOutputRLT)catch()
rollout clientRenderOutputRLT "clients render output"
(
	local params = #("pos")
	local clientImageSizeINI = getroot() + @"visiolab\clientsImageSize.ini"
	local clientLitsAr = #()
	
	local multi
	local renderOutSize
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
		
	radiobuttons  resoRB "resolution:" labels: #("1","1/2","1/4")
	
	edittext sizeET "size:" readonly: true
	button applyBT "apply"  height:40 width: 100
	
	-- functions
	fn refreshUI =
	(
		renderOutSize = try(execute(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected))catch([0,0])
		
		format "state: %\n" resoRB.state
		if resoRB.state == 1 then multi =1
		else if resoRB.state == 2 then  multi = 0.5
		else if resoRB.state == 3 then multi = 0.25
			
		renderOutSize = renderOutSize*multi
			
		sizeET.text = renderOutSize as string
	)
	
	-- actions
	
	
	on clientRenderOutputRLT open do
	(
		loadRolloutParams clientRenderOutputRLT params
		
		clientsLB.items = sort(getINISetting clientImageSizeINI)
		imageTypeLB.items = getINISetting clientImageSizeINI clientsLB.selected
-- 		renderOutSize = try(execute(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected))catch([0,0])
			
		refreshUI()
-- 		sizeET.text =  renderOutSize as string
-- 		sizeET.text = try(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected)catch("")
	)
	
	on clientRenderOutputRLT close do
	(
		writeRolloutParams clientRenderOutputRLT params
	)
	
	
	on clientsLB selected val do
	(
		imageTypeLB.items = getINISetting clientImageSizeINI clientsLB.selected
-- 		renderOutSize = try(execute(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected))catch([0,0])
			
		refreshUI()
-- 		sizeET.text =  renderOutSize as string
-- 		sizeET.text = try(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected)catch("")
	)
	
	on imageTypeLB selected val do
	(
-- 		renderOutSize = try(execute(getINISetting clientImageSizeINI clientsLB.selected imageTypeLB.selected))catch([0,0])
		refreshUI()
		
		format "sizeET.text: %\n" (execute sizeET.text)
	)

	on resoRB changed val do
	(
		refreshUI()
		
	)
	
	on applyBT pressed do
	(
		local reopen = false
		if renderSceneDialog.isOpen() then 
		(
			renderSceneDialog.close()
			reopen = true
		)
		
		renderWidth = renderOutSize[1]
		renderHeight =  renderOutSize[2]
		
		if reopen then renderSceneDialog.open()
-- 		renderSceneDialog.open()
	)
	
	on editBT pressed do
	(
		edit clientImageSizeINI
	)

)
createdialog clientRenderOutputRLT width: 300

-- edit clientImageSizeINI
