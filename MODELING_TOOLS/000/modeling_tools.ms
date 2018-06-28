-- InstanceMgr.GetInstances $ &instances

-- select instances

fn getInstancesFN sel = 
(
	InstanceMgr.GetInstances sel &instances
	if instances.count<=1 do print "no instances"
	instances
)


fn desinstance sel =
(
-- 	all = $* as array

	-- 	InstanceMgr.GetInstances all[1] &instNodes
		if (InstanceMgr.CanMakeObjectsUnique sel) then
		(
			format "desinstance: %\n" sel.name
			InstanceMgr.MakeObjectsUnique sel #prompt
		)

)

fn centerPivotDef sel = 
(
	for s in sel do
	(
		s.pivot = s.center
	)
)
/*
fn goutteDeauFN sel =
(
	polyop.bevelFaces sel #selection 3 0
	polyop.bevelFaces sel #selection 0 -5
	polyop.bevelFaces sel #selection  -1 0
	polyop.bevelFaces sel #selection 0 -1
	polyop.bevelFaces sel #selection 1 0
	polyop.bevelFaces sel #selection 0 -5
	polyop.bevelFaces sel #selection -3 0
)

fn debordFN sel = 
(
	polyop.bevelFaces sel #selection 3 0
	polyop.bevelFaces sel #selection 0 -10
	polyop.bevelFaces sel #selection  -3 0
)
*/

--debug: make usabled on multiselection
fn makeFloorFN s outLIneVal: -15 innerAmountVal: 0 outerAmountVal: 10  collapseMesh: true =
(
	local sel =  currentSel
	-- add editpoly
-- 	for s in sel do
-- 	(
		if classof s == splineshape do
		(
			if (isClosed s 1) then
			(
			undo off
				(
					myEditPoly = Edit_Poly()
					addmodifier s myEditPoly
					convertto s editable_poly

					-- outline 15 cm
					select s
					polyop.setFaceSelection  s #all
					s.outlineAmount = outLIneVal
					s.EditablePoly.Outline ()

					-- shell 10cm
					myShell = Shell innerAmount: innerAmountVal outerAmount:outerAmountVal
					addmodifier s myShell

					-- convert to poly
					if collapseMesh then converttopoly s 

					-- material "interieur"G
-- 					sel.material = sceneMaterials["interieur"]
				)
			)
		)
-- 	)
)


fn connectRingFN s loopNum: 1 =
(
-- 	maj: init connect decay
	PolyToolsSelect.ring()
	s.connectEdgeSegments   = loopNum
	s.connectEdges()
)


-- refresh scenematerial
fn updateSceneMaterials =
 (
	 saveNodes #() "c:/temp.max"
	 deleteFile "c:/temp.max"
 )
-- updateSceneMaterials()


-- attach object select in the same object

 
fn clusterAttach objArr =
(
	j = 1
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			
			
			if classof objArr[j].baseobject != editable_Mesh then converttoMesh objArr[j]
				
			-- DESINSTANCE
			/*
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
			*/
			-- ATTACH
			attach objArr[j] objArr[j+1]
			
			deleteItem objArr (j+1)

			j += 1

			if (j + 1) > objArr.count then j = 1

		)
	)
	objArr[1]
)

-- s = $
fn explodeByElts s =
(
	local detached = #()
	if classof s == editable_poly then
	(
		facesCount = polyop.getNumFaces s
		while facesCount > 0 do
		(
			newName = uniqueName s.name
			facesToDetachs = polyop.getElementsUsingFace s #{1}
			polyop.detachFaces s facesToDetachs delete:true asNode:true name: newName
			
			newObj = getnodebyname newName
			append detached newObj
			
			facesCount = polyop.getNumFaces s
		)
		delete s
		
		
	)
	else
	(
		format "selectionnez un edtable_poly"
	)
	detached
)
detached =  explodeByElts $


-- transfert
fn transfertModifiers sel =
(
	source = sel[1]

	for i = 2 to sel.count do
	(
		for m in source.modifiers  do
		(
			addmodifier sel[i] m
		)
	)
)


fn transferColor sel =
(
	source = sel[1]

	for i = 2 to sel.count do
	(
		sel[i].material = source.material
	)
)

/*
fn createTile =
(
	meditMaterials[activeMeditSlot] = bricks()
)
*/

fn extrudeFaces size =
(
	undo on
	(
		faceList = polyop.getFaceSelection $
-- 		size = (units.decodeValue "-25cm")
-- 		polyop.extrudeFaces $ faceList size
		sizeStr = (size as string) + "cm"
		polyop.extrudeFaces $ faceList (units.decodeValue sizeStr)

		faceListToDel = polyop.getFaceSelection $
		polyop.deleteFaces $ faceListToDel
	)
)


try(destroyDialog miscRLT)catch()

rollout miscRLT "Modeling Tools"
(
	local params = #("pos","outlineSP", "innerSp", "outerSp", "collapseCB")
-- 	vars
	local sourceInstance
	
-- 	functions
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	fn writePosition cat rlt =
	(
		posBak = GetDialogPos rlt
		res = setINISetting armadasScriptsIni cat "pos" (posBak as string)
		res
		format  "position saved: %\n" res
	)
	
	fn loadPosition cat rlt =
	(
		posBak = [800,250]
		if (hasINISetting armadasScriptsIni cat "pos") then
		(
			posBakStr = getINISetting armadasScriptsIni  cat "pos"
			posBak = execute posBakStr
		)
		
		SetDialogPos rlt posBak
	)

	group "Instances:"
	(
		button getInstBT "get instances"
		button desInstBT "de-instances selection"
	)
	
	group "Make floor:"
	(
		spinner outlineSP "outline" type: #worldunits range:[-1000,1000,0]
		spinner innerSp "Inner:" type: #worldunits range:[0,1000,2]
		spinner outerSp "Outer:" type: #worldunits range:[0,1000,2]
		checkbox collapseCB "collapse mesh"
		button makeFloorBT "make floor"
	)
	
	group "Polygon:"
	(
-- 		button goutteBT "goutte d'eau"
-- 		button debordBT "debord balcon"
		

-- 		button connectRingBT "connect ring x1"
-- 		button connectRing2BT "connect ring x2"
		button cleanCombineBT "Combine"
		
		button converttopolyBT "convert to poly"		
		button explodeEltsBT "Explode mesh"
	)
	
	group "Extrusion:"
	(
		
		button extrudeBT "extrusion 25"
		button extrude34BT "extrusion 34"
	)
	
	group "pivot"
	(
		button centerPivotBT "center pivot"
		button pivotToEdgeBT "pivot to edge" enabled: false
	)

	/*
	group "instance replacer:"
	(
		button addSourceBT "add>>"
		edittext sourceET "source:"
		button replaceInstanceBT "replace by instance"
	)
	*/
-- 	Actions
	on miscRLT open do
	(
		loadRolloutParams miscRLT Params
-- 		loadPosition miscRLT.name miscRLT
	)
	
	on miscRLT close do
	(
		writeRolloutParams miscRLT Params
-- 		writePosition miscRLT.name miscRLT
	)
	
	on getInstBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			res = getInstancesFN s
			selectmore res
		)
	)
	
	on desInstBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			res = desinstance s
-- 			selectmore res
		)
	)
	
-- 	on goutteBT pressed do goutteDeauFN $	
-- 	on debordBT pressed do debordFN $
		

	on makeFloorBT pressed do
	(
		sel = selection as array
		for s in sel do makeFloorFN s outLIneVal: outlineSP.value innerAmountVal: innerSp.value outerAmountVal: outerSp.value collapseMesh: collapseCB.checked
	)
	
	on connectRingBT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			undo on
			(
				connectRingFN s loopNum:1
			)
		)
	)
	on connectRing2BT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			undo on
			(
				connectRingFN s loopNum:2
			)
		)
	)
	
		
	on cleanCombineBT pressed do
	(
		local bef = timestamp()
		clusterAttach (selection as array)
		format "attach done: % ms\n" ((timestamp()) - bef)
	)
	
	on explodeEltsBT pressed do
	(
		sel = selection as array
		clearselection()
		for s in sel do
		(
			exploded = explodeByElts s
			if not exploded == undefined then selectmore exploded
		)
	)
		
	on centerPivotBT pressed do centerPivotDef (selection as array)
	on converttopolyBT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			converttopoly s
		)
	)
	
	on extrudeBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			if classof sel[1] == editable_poly then
			(
				extrudeFaces -25
			)
		)
	)
	
	on extrude34BT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			if classof sel[1] == editable_poly then
			(
				extrudeFaces -34
			)
		)
	)
	/*
	on transferModBT pressed do
	(
		sel = selection as array
		transfertModifiers sel
	)
	
	on transferMatBT pressed do
	(
		sel = selection as array
		transferColor sel
	)
	*/
	--#### instance replacer actions ###
	/*
	on addSourceBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			testSource = sel[1]
			if superclassof testSource == geometryClass then
			(
				sourceInstance = testSource
				sourceET.text = sourceInstance.name
			)
			else
			(
				sourceInstance = undefined 
				sourceET.text = "[NONE]"
			)
		)
	)
	
	on replaceInstanceBT pressed do
	(
		if sourceInstance != undefined then
		(
			sel = selection as array
			instancereplace sel sourceInstance
		)
	)
	*/
)
createDialog miscRLT --style: #(#style_minimizebox, #style_titlebar ,#style_border , #style_sysmenu,#style_maximizebox )

-- miscRLT.collapseCB.checked