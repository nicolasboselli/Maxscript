-- InstanceMgr.GetInstances $ &instances

-- select instances

filein "cleanspline.ms"
-- superclassof $.baseobject

fn inverseKnotOrder l =
(
	if superclassof l.baseobject == Shape then
	(
		max modify mode
		modPanel.setCurrentObject l.baseobject

		spCount = numSplines   l
		for i = 1 to spCount do reverse  l i 

		if l.modifiers.count > 0 then modPanel.setCurrentObject l.modifiers[1]
		
		format "make first done: %\n" l.name
	)else()
)

fn getInstancesFN sel = 
(
	InstanceMgr.GetInstances sel &instances
	if instances.count<=1 do print "no instances"
	instances
)


fn desinstance sel =
(
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

--debug: make usabled on multiselection
fn makeFloorFN s outLIneVal: -15 innerAmountVal: 0 outerAmountVal: 10  collapseMesh: true =
(
	local sel =  currentSel

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
			attach objArr[j] objArr[j+1]
			
			deleteItem objArr (j+1)

			j += 1

			if (j + 1) > objArr.count then j = 1

		)
	)
	objArr[1]
)

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

fn extrudeFaces size delFace: true =
(
	undo on
	(
		faceList = polyop.getFaceSelection $
		sizeStr = (size as string) + "cm"
		polyop.extrudeFaces $ faceList (units.decodeValue sizeStr)

		faceListToDel = polyop.getFaceSelection $
		if delFace then polyop.deleteFaces $ faceListToDel
			else redrawviews () 
	)
)


fn alignPivotOnEdge s =
(
	edg = polyop.getEdgeSelection s
	edg as array
	vx = polyop.getEdgeVerts s (edg as array)[1]
	vx1 = polyop.getVert s vx[1]
	vx2 = polyop.getVert s vx[2]

	vec1 = normalize(vx1 - vx2)
	vec2 = cross vec1 [0,0,1]
	vec3 = cross vec1 vec2

	wpTM = matrix3 vec1 vec2 vec3 [0,0,0]

	-- à partir d une face
	-- WorkingPivot.getTM() 
	WorkingPivot.setTM wpTM
)
-- alignPivotOnEdge $

fn addtolayer pack dest =
(
	l = dest.layer
	l.current = true
	for i = 1 to pack.count do l.addNode pack[i]
)

try(destroyDialog miscRLT)catch()

rollout miscRLT "Modeling Tools"
(
	local params = #("pos","outlineSP", "innerSp", "outerSp", "collapseCB", "extrusionSizeSP", "delFaceCB")
-- 	vars
	local sourceInstance
	
-- 	functions
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
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
		button cleanCombineBT "Combine"
		
		button converttopolyBT "convert to poly"		
		button explodeEltsBT "Explode mesh"
	)
	
	group "Extrusion:"
	(
		spinner extrusionSizeSP "size:" type: #worldunits range:[-1000,1000,0]
		checkbox delFaceCB "delete faces"
		button extruBT "extrusion"
	)
	
	group "splines"
	(
		button cleanSplineBT "clean splines"
		button inverseKnotOrderBT "reverse spline"
	)
	
	group "pivot"
	(
		button centerPivotBT "center pivot"
		button pivotToEdgeBT "pivot to edge" enabled: true
	)
	
	group "modifiers"
	(
		button delAllModBT "del all modifiers"
	)
	
	group "Rig"
	(
		button scale1BT "scale1"
	)
	
	group "layer"
	(
		button addToSelLayerBT "add to layer selected"
	)

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

	on makeFloorBT pressed do
	(
		sel = selection as array
		for s in sel do makeFloorFN s outLIneVal: outlineSP.value innerAmountVal: innerSp.value outerAmountVal: outerSp.value collapseMesh: collapseCB.checked
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
			
	on converttopolyBT pressed do 
	(
		sel = selection as array
		for s in sel do
		(
			converttopoly s
		)
	)
	
	on extruBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			if classof sel[1] == editable_poly then
			(
				extrudeFaces extrusionSizeSP.value delFace: delFaceCB.checked
			)
		)
	)
	
	on cleanSplineBT pressed do
	(
		sel = selection as array
		for s in sel do cleanspline s
	)
	
	on inverseKnotOrderBT pressed do
	(
		sel = selection as array
		for s in sel do inverseKnotOrder s
	)
	
	on centerPivotBT pressed do centerPivotDef (selection as array)
	
	on pivotToEdgeBT pressed do
	(
		alignPivotOnEdge $
	)
	
	on delAllModBT pressed do
	(
		undo on
		(
			sel = selection as array
			for s in sel do
			(
-- 				for m in s.modifiers do deletemodifier s m
				modcount = s.modifiers.count
				for i = 1 to modCount do deletemodifier s 1
			)
		)
	)
	
	on scale1BT pressed do
	(
		undo on
		(
			for s in selection do
			(
				format "name: % s.scale: % scale.value: % \n" s.name s.scale s.scale.controller.value
				s.scale.controller.value = [1,1,1]
			)
		)
	)
	
	on addToSelLayerBT pressed do
	(
		sel = selection as array

		dest = sel[sel.count]
		pack = for i = 1 to (sel.count - 1) collect sel[i]

		addtolayer pack dest
	)	
)
createDialog miscRLT --style: #(#style_minimizebox, #style_titlebar ,#style_border , #style_sysmenu,#style_maximizebox )
