/*
maj:
	-- make addSweepAboveDef independant from ui, add parameters
	-- rename "remabarde_master" and copy remabarde
	-- see what to do with cleanCopyFN and ConvertToReelSplineFN
*/
Rollout RembardeCopierUi "Rembarde Builder" width: 400

(
-- 	vars
	local toto = #()
	local SuperModRef
	local NumRef
	local TempColor
	local workingCopy
	
-- 	functions
	fn CleanCopyFN s =
	(
		-- clean de la selection
		WorkingCopy = copy s
		WorkingCopy.name = uniquename "Rembarde_"
		WCModCount = WorkingCopy.modifiers.count
		for i = 1 to WCModCount do
		(
			deletemodifier WorkingCopy 1
		)
		return WorkingCopy
	)
	
	fn ConvertToReelSplineFN v2 =
	(
		addmodifier v2 (Edit_Spline ())
		converttosplineshape v2
		updateshape v2
	)
	
	-- find master to duplicate
	fn findMasterDef sel =
	(
		local master = undefined
-- 		find master
		for s in sel do
		(
			InstanceMgr.GetInstances s &instances
			print instances
			for o in instances do
			(
				if o.modifiers.count == 0 then
				(
					master = o
					break
				)
			)
		)
		return master
	)
	
	fn ApplyModelFN WorkingCopyVars =
	(
		-- application du modele a la selection
		for i = 1 to (NumRef - 1) do
		(
			CopyTemp = reference WorkingCopyVars
			CopyTemp.name = uniquename (WorkingCopyVars.name + "_inst_")
			copytemp.wirecolor = TempColor
			CopyTemp.material = toto[i].material
			ModifiersCount = toto[i].modifiers.count
			for j = ModifiersCount to 1 by -1 do
			(
				addmodifier CopyTemp toto[i].modifiers[j]
			)
		)
	)
	
	
-- 	UI
	/*
	group "building:"
	(
		button StartRembardeBT "template"  across:2
-- 		button addLiceBT "one Lice" 
	)
	*/
	
	group "building:"
	(
		button addAboveBT "add above ^" enabled: true across: 3
		button addBelowBT "add below v"  enabled: true
		spinner decaySP "decay" type: #worldunits range: [0, 200, 5]  enabled: true -- across: 3
-- 		checkbox fromSelCB "from  selection" checked: true
-- 		checkbox fromOrigCB "from  origin" 
		checkbox addDecayCB "add decay" checked: true across: 4
		checkbox profileCB "copy profile"  enabled: true
		checkbox materialCB "copy material"  enabled: true
		checkbox selectNewCB "select new"  enabled: true
	)
	
	group "copying:"
	(
-- 		pickbutton SelRefPB "Pick reference"
		button SelRefBT "Add reference >>" 
		edittext RefNameET readonly: true text: "reference"
		button ApplyModelBT "make copy"
	)

	
	-- UI functions
	
	
	fn addSweepAboveDef s state: true =
	(
		local invertVal = 1
		if state == false do invertVal = - 1
			
		local matref = s.material
		local yoffsetStart = 0
		-- find spline master
		local master = findMasterDef s
		
		-- create new sweep
		local newSweep = sweep  yOffset: 0 CurrentBuiltInShape: 2 PivotAlignment:5 SmoothPath: off
		
		-- find sweep reference
		local sweepCopy = undefined
		
		for oneMod in s.modifiers do
		(
			if classof oneMod == sweep do
			(
				sweepCopy = copy oneMod
				yoffsetStart = oneMod.yoffset
				break
			)
		)
		
		-- define sweep to paste
		local sweepToPaste = undefined
		
		if 	profileCB.state == true and sweepCopy != undefined then
		(
			sweepToPaste = sweepCopy
		)
		else
		(
			sweepToPaste = sweep  yOffset: yoffsetStart CurrentBuiltInShape: 2 PivotAlignment:5
		)
		
		-- 		add sweep
		if master != undefined then
		(
			print "master found"
			workingCopy = reference master
			
			if materialCB.state == true do workingCopy.material = matref
-- 			add y offset
			if addDecayCB.state == true do sweepToPaste.yoffset = sweepToPaste.yoffset + decaySP.value*invertVal

			addmodifier workingCopy sweepToPaste
			
			if selectNewCB.state == true do select workingCopy
		)
		else
		(
			print "no master found"
		)
	)
	
-- 	Actions
	on fromSelCB changed theState do
	(
		if theState == true then
		(
			fromOrigCB.state = false
		)
		else
		(
			fromOrigCB.state = true
		)
	)
	
	on fromOrigCB changed thestate do
	(
		if theState == true then
		(
			fromSelCB.state = false
		)
		else
		(
			fromSelCB.state = true
		)
	)
	
	on StartRembardeBT pressed do
	(
		-- cleaning
		CleanCopyFN $
		ConvertToReelSplineFN workingCopy
		
		StartRembarde = workingCopy
		StartRembarde.name = uniquename "rembarde_"
		Pas = 0
		for i = 1 to 3 do
		(
			CopyRembarde = reference StartRembarde
			CopyRembarde.name = uniquename (StartRembarde.name + "_inst_")
			
			
			
			addmodifier CopyRembarde (sweep ())
			
			CopyRembarde.modifiers[#Sweep].CurrentBuiltInShape = 4
			CopyRembarde.modifiers[#Sweep].PivotAlignment = 5
			CopyRembarde.modifiers[#Sweep].yOffset = 50 + pas
			CopyRembarde.modifiers[#Sweep].XOffset = -5
		-- 				CopyRembarde.modifiers[#Sweep][#Cylinder_Section].radius = 3	
			
			pas += 25
		)
	)
/*
	on addLiceBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			
			-- find spline master
			local master = findMasterDef sel

	-- 		add sweep
			if master != undefined then
			(
				print "master found"
				workingCopy = reference master
				
				startingSweep = sweep  yOffset: 0 CurrentBuiltInShape: 2 PivotAlignment:5
				addmodifier workingCopy startingSweep
			)
			else
			(
				print "no master found"
			)
		)
	)
*/
	on addAboveBT pressed do
	(
		sel = selection as array
		
		if sel.count == 1 then
		(
			for s in sel do
			(
				addSweepAboveDef s state: true
			)
		)
	)
	
	on addBelowBT pressed do
	(
		sel = selection as array
		
		if sel.count == 1 then
		(
			for s in sel do
			(
				addSweepAboveDef s state: false
			)
		)
	)		

	
	on SelRefBT pressed do
	(
		if selection.count == 1 then
		(
			RefNameET.text = $.name
			SuperModRef = $
		)
		else
		(
			messagebox "selectionner une seule reference"
		)
	)
		
	on ApplyModelBT pressed do
	(
		if SuperModRef != undefined then
		(
			if selection.count == 1 then
			(
				NumRef = InstanceMgr.GetInstances SuperModRef &toto
				print NumRef
				print toto
				
				TempColor = color (random 1 255) (random 1 255) (random 1 255)
			
				CleanCopyFN $
				ConvertToReelSplineFN workingCopy
				ApplyModelFN workingCopy
			)
			else 
			(
				messagebox "selectionner un objet pour appliquer le modele"
			)
		)
		else
		(
		messagebox "selectionner un modele"
		)
	)
)

createdialog RembardeCopierUi

/*



struct sweepCopierClass
(
	oneSweep,
	
)

newMod
for oneMod in $.modifiers do
(
	if classof oneMod == sweep do
	(
		print (newMod = copy sweep)
	)
)
classof oneMod

addModifier $ newMod
*/

