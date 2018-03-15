--maj:
	-- delete des asset presents dans la scene

-- asset node explorer
try(destroydialog assetNodeExplorerRLT)catch()
rollout assetNodeExplorerRLT "Asset Nodes Explorer"
(
-- 	vars
	local menuRC
	local assetNodesAr
	local curAssetNode
	local btnSel
	local modf
	local oneState
	
-- 	functions
	fn initAssetNodeAr =
	(
		assetNodesAr = for o in objects where o.modifiers[#Content_Node] != undefined collect o
	)
	
-- 	UI
	listbox assetNodesLB "Asset Nodes:"
	button refreshBT "Refresh"
	
	group "Display/Select:"
	(
		checkbutton RootCB "ROOT" highlightColor: orange width: 100 checked: true  pos: [15,210] --across: 2
		button RootBT "..." pos: [120,210]
		
		checkbutton MainCtrlCB "MAIN_CTRL" highlightColor: (color 27 177 27) width: 100 checked: true pos:[15,235] --across: 2
		button MainCtrlBT "..."  pos: [120,235]
		
		checkbutton ScdCtrlCB "SECOND_CTRL" highlightColor: blue width: 100 checked: true pos:[15,260] --across: 2
		button ScdCtrlBT "..." pos: [120,260]
		
		checkbutton FacialCB "FACIAL" highlightColor: (color 177 88 27) width: 100 checked: true pos:[15,285]  --across: 2
		button FacialBT "..." pos: [120,285]
		
		checkbutton RigCB "RIG" highlightColor: red width: 100 checked: true pos:[15,310] --across: 2
		button RigBT "..." pos: [120,310]
		
		checkbutton MdlCB "MDL" highlightColor: (color 177 148 27) width: 100 checked: true pos:[15,335] --across: 2
		button MDLBT "..." pos: [120,335]
		button AllCtrlsBT "All Ctrls" across: 2
		button AllBT "All"
	)
	
	group "Tools:"
	(
		button checkBT "Check" across: 2
		button forceBT "Force"
	)
	
-- 	UI functions
	fn refreshUI =
	(
		assetNodesLB.items = for a in assetNodesAr collect a.name
	)
	
	fn hideToggle btn state=
	(
-- 		format "btn.text: %\n" btn.text
		curAssetNode = assetNodesAr[assetNodesLB.selection]
		attr = curAssetNode.modifiers[#Content_Node]
		
		res = finditem attr.catNameList btn.text
		if state then attr.unhideCat res else attr.hideCat res
		
		redrawviews()
	)
	
	fn selectCat search clean: true =
	(
		curAssetNode = assetNodesAr[assetNodesLB.selection]
		attr = curAssetNode.modifiers[#Content_Node]
		
		res = finditem attr.catNameList search
		attr.selectCat res clean: clean
	)
	
	fn createRCMenu =
	(
		rcmenu menuRC
		(
			menuItem addIT "add"
			menuItem remIT "remove" 
			
			on addIT picked do	
			(	
				curAssetNode = assetNodesAr[assetNodesLB.selection]
				attr = curAssetNode.modifiers[#Content_Node]
								
-- 				rlt =attr.allContentRLT
-- 				format "btnSel.text: %\n" btnSel.text
				
				id = finditem attr.catNameList btnSel.text
-- 				format "id: %\n" id
-- 				format "cat: %\n" attr.catNameList[id]
				
				attr.addNode2 id
				attr.writeNodeTab ()
				attr.loadNodeTab ()
				hideToggle btnSel oneState
				
			)
			
			on remIT picked do 
			(
				/*
				catId = CatLB.selection
				objId = ContentsLB.selection
				
				format "remove object: %\n" catContentList[catId][objId].name
				*/
			)
		)
	)
	
-- 	Actions
	on assetNodeExplorerRLT open do
	(
		createRCMenu()
		initAssetNodeAr()
		refreshUI()
		
		
		try(
-- 			select assetNodesAr[1]
			assetNodesAr[1].modifiers[#Content_Node].loadNodeTab()
		)catch(format "ERROR: %\n" getcurrentexception())
	)
	
	
	on refreshBT pressed do
	(
		initAssetNodeAr()
		refreshUI()
		
		
		try(
-- 			select assetNodesAr[1]
			assetNodesAr[1].modifiers[#Content_Node].loadNodeTab()
		)catch(format "ERROR: %\n" getcurrentexception())
	)
	
	on assetNodesLB selected obj do
	(
		select assetNodesAr[obj]
		modf = assetNodesAr[obj].modifiers[#Content_Node] 
		modf.loadNodeTab ()
	)
	
	on RootCB changed state do hideToggle RootCB state
	on RootCB rightclick do 	
	(
		btnSel = RootCB
		oneState = RootCB.state
		popUpMenu menuRC rollout: assetNodeExplorerRLT
	)
	on RootBT pressed do selectCat "ROOT"
	
	on MainCtrlCB changed state do hideToggle MainCtrlCB state
	on MainCtrlCB rightclick do 	
	(
		btnSel = MainCtrlCB
		oneState = MainCtrlCB.state
		popUpMenu menuRC rollout: assetNodeExplorerRLT
	)
	on MainCtrlBT pressed do selectCat "MAIN_CTRL"
	
	on ScdCtrlCB changed state do hideToggle ScdCtrlCB state
	on ScdCtrlCB rightclick do
	(
		btnSel = ScdCtrlCB
		oneState = MainCtrlCB.state
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	on ScdCtrlBT pressed do selectCat "SECOND_CTRL"
	
	on RigCB changed state do hideToggle RigCB state
	on RigCB rightclick do
	(
		btnSel = RigCB
		oneState = RigCB.state
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	on RigBT pressed do  selectCat "RIG"
	
	on MdlCB changed state do hideToggle MdlCB state
	on MdlCB rightclick do
	(
		btnSel = MdlCB
		oneState = MdlCB.state
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	on MDLBT pressed do  selectCat "MDL"
	
	on FacialCB changed state do hideToggle FacialCB state
	on FacialCB rightclick do
	(
		btnSel = FacialCB
		oneState = FacialCB.state
		popUpMenu menuRC  rollout: assetNodeExplorerRLT
	)
	on FacialBT pressed do  selectCat "FACIAL" 
	
	on AllCtrlsBT pressed do
	(
		
		curAssetNode = assetNodesAr[assetNodesLB.selection]
		attr = curAssetNode.modifiers[#Content_Node]
		
		clearselection()
		selectCat "ROOT" clean: false
		selectCat "FACIAL" clean: false
		selectCat "MAIN_CTRL"  clean: false
		selectCat "SECOND_CTRL"  clean: false
	)
	
	on AllBT pressed do 
	(
		curAssetNode = assetNodesAr[assetNodesLB.selection]
		attr = curAssetNode.modifiers[#Content_Node]
		clearselection()
		for s in attr.allContentList do selectmore s
-- 		for s in attr.allContentList[1] do selectmore s
-- 		for s in attr.allContentList[2] do selectmore s
-- 		for s in attr.allContentList[3] do selectmore s
	)
	
	on checkBT pressed do
	(
		id  =  assetNodesLB.selection
		assetNodesAr[id].modifiers[#Content_Node].checkNodeTab()
	)
	
	on forceBT pressed do
	(
		id  =  assetNodesLB.selection
		assetNodesAr[id].modifiers[#Content_Node].writeNodeTab()
		assetNodesAr[id].modifiers[#Content_Node].loadNodeTab()
	)

)
createdialog assetNodeExplorerRLT


-- $.modifiers[#Content_Node].Content_Node.allContentList
