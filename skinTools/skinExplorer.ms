-- fix:
	-- au remove d'un bone faire une refresh pour mettre à jour les noms

filein "skinAddWeight.ms"

try(destroydialog skinExpRLT)catch()
rollout skinExpRLT "Skin Explorer"
(

-- 	vars
	local s
	local skinBonesAr
	local skinBonesToDisp
	local skinMaxBones
	local m
	local skinNEC
	local skinNECSub
	
	local hiddenToggle = true
	local lockedToggle = true
	
-- Structures
	struct boneStruct 
	(
		id,  
		name = (skinOps.GetBoneName m id 0),
		node = getnodebyname name,
		isLocked = false,
		isHidden = false,
		fn displayName = 
		(
			lockTag = if isLocked == false then "" else "_(L)"
			hideTag =  if isHidden == false then "" else "_(H)"
			name + lockTag + hideTag
		),
		fn lockToggle = isLocked = not isLocked,
		fn hideToggle = isHidden = not isHidden
	)
	
-- 	UI
	edittext nodeET "Node Selected:" readonly: true
	edittext skinModET "Modifier:" readonly: true
-- 	button loadSkinBT "Load"
	
	group "Actions:"
	(
		button addBt "Add Bones" enabled: false across: 2
		button removeBT "Remove" enabled: false

	)
	group "Sets:"
	(
		button lockBT "Lock/Unlock" across: 4
		button lockAllBT "Lock/Unlock All" 
		button hideBT "Hide/Unhide"
		button hideAllBT "Hide/Unhide All"
	)
	group "display:"
	(
		checkbox hiddenCB "hidden" checked: true across: 2
		checkbox lockedCB "locked" checked: true
		edittext searchET "Search:" 
	)
	group "vertex tools:"
	(
		button additionToolBT "weight addition"
	)
	
	listbox bonesListLB "Bones:" height: 20
	
-- function UI dependant	
	fn refreshSel =
	(
		local sel = selection  as array
		if sel.count == 1 then 
		(
			s = sel[1]
			m = modPanel.getCurrentObject()
		)
		else
		(
			s = undefined
			m = undefined
		)
	)
		
	fn collectArray  = 
	(
		skinMaxBones = 0
		skinBonesAr = #()
		
		if classof m == skin then
		(
-- 			format "m: %\n" m
			skinMaxBones = skinOps.GetNumberBones m
			skinBonesAr = for i = 1 to skinMaxBones collect (boneStruct id: i)
		)
	)
	
	fn displayFilter displayHidden: true displayLocked: true =
	(
		skinBonesToDisp = #()
		
		for bn in skinBonesAr do 
		(
			displayBone = true
			
			if not displayHidden and bn.isHidden then displayBone = false
			if not displayLocked and bn.isLocked then displayBone = false

			if displayBone then append skinBonesToDisp  bn
		)
	)
	
	fn refreshList =
	(	
		bonesListLB.items = for o in skinBonesToDisp collect o.displayName()
		if s != undefined then nodeET.text = s.name else nodeET.text = "[NONE]"
		try(skinModET.text = m.name)catch(skinModET.text = "[NONE]")
	)
	
-- Node Event callback
	fn refreshUI_NEC ev nd = 
	(
-- 		format "node event\n"
		refreshSel()
		collectArray()
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
	)

	
	fn boneSelected_NEC ev nd =
	(
-- 		format "subobject event\n"
		local mToTest
		mToTest = modPanel.getCurrentObject()
		
		if classof mToTest == skin and mToTest == m then
		(
			local id = skinOps.GetSelectedBone m
-- 			format "id: %\n" id
			local res = finditem skinBonesToDisp skinBonesAr[id]
-- 			format "disp id: % \n" res
-- 			bonesListLB.selection = id
			bonesListLB.selection = res
		)
		else
		(
			refreshSel()
			collectArray()
			displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
			refreshList()
		)
	)
	
	-- 	Actions
	on skinExpRLT open do
	(
		refreshSel()
		collectArray()
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
		
		skinNEC = NodeEventCallback  selectionChanged: refreshUI_NEC
		skinNECSub = NodeEventCallback subobjectSelectionChanged: boneSelected_NEC
	)
	
	on skinExpRLT close do
	(
		skinNEC = undefined
		skinNECSub = undefined
		gc light:true
	)
	
	
	on bonesListLB selected id do
	(
		skinOps.SelectBone m skinBonesToDisp[id].id
	)
	
	on lockBT pressed do
	(
		skinBonesToDisp[bonesListLB.selection].lockToggle()
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
	)
	
	on lockAllBT pressed do
	(
		lockedToggle = not lockedToggle
		for bn in skinBonesAr do bn.isLocked = lockedToggle
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
	)
	
	on hideBT pressed do
	(
		skinBonesToDisp[bonesListLB.selection].hideToggle()
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
	)
	
	on hideAllBT pressed do
	(
		hiddenToggle = not hiddenToggle
		for bn in skinBonesAr do bn.isHidden = hiddenToggle
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
	)
	
	on additionToolBT pressed do
	(
		try(destroydialog addWtRLT)catch()
		createdialog addWtRLT
		addWtRLT.parentRLT = skinExpRLT
	)
	
	on lockedCB changed arg do
	(
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
	)
	
	on hiddenCB changed arg do
	(
		displayFilter displayHidden: hiddenCB.state displayLocked: lockedCB.state
		refreshList()
	)
	
)
createdialog skinExpRLT width: 400 