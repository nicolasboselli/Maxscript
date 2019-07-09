/*
maj
add param:  center pivot,  add uvwmap, add mat, setup sweep, 

faire fonction sur modifier edit_poly


debug:
x-sur des murs orienter en z l estract de spline est décalé
*/

fn round_to val n = 
(
	local mult = 10.0 ^ n
	(floor ((val * mult) + 0.5)) / mult
)

modPanel.getCurrentObject()


/*
fn createBoxOrient s =
(
	faceSel = polyop.getfaceselection s 
	posObj = s.pos
	posCenter = polyop.getFaceCenter s (faceSel as array)[1]
	theZ = polyop.getFaceNormal s (faceSel as array)[1]
	theY = normalize (cross [0,0,1] theZ )
	theX = normalize (cross theY theZ)
	theTM = matrix3   theX theY theZ posCenter

	rep = box transform: theTM
)
*/
fn createBoxOrient2 s =
(
	faceSel = polyop.getfaceselection s 
	posObj = s.pos
	posCenter = polyop.getFaceCenter s (faceSel as array)[1]
	theZ = polyop.getFaceNormal s (faceSel as array)[1]
	for i = 1 to 3 do theZ[i] = round_to theZ[i] 4
		
	theY = normalize (cross [0,0,1] theZ )
	theX = normalize (cross theY theZ)
	theTM = matrix3   theX theY theZ posCenter

	box transform: theTM
)
-- createBoxOrient2 $

fn createBoxOrientOnMod s =
(
	s.edit_poly.GetSelection  #face
	fSel = (s.edit_poly.GetSelection  #face) as array
	
	-- recupération des id de points 
	pts = for i = 1 to 3 collect s.edit_poly.GetFaceVertex  fSel[1] i
		
	-- recuperation des position de points
	ptsPos = for p in pts collect s.edit_poly.getVertex p 
		
	-- calcul des vecteurs
	v1 = normalize(ptsPos[1] - ptsPos[2])
	v2 = normalize(ptsPos[2] - ptsPos[3])
	
	-- cross vecteurs
	theZ = normalize (cross v1 v2)
	theY = normalize (cross [0,0,1] theZ )
	theX = normalize (cross theY theZ)
	theTM = matrix3   theX theY theZ ptsPos[1]

	box transform: theTM
)

fn resetInPlace2 s tmpParent =
(
	bakparent = s.parent
	
-- 	tmpParent = point transform: s.transform

	tmpParent.scale = [1,1,1]

	s.parent = tmpParent

	resetxform s
	
	s.parent = bakparent
	
	/*
	bakPos = s.pos
	s.rotation = tmpParent.rotation
	s.pos = bakPos
	*/
)

fn removeEdgeAndVerticesFN sel =
(
	sel.EditablePoly.ConvertSelection #Edge #Vertex
	sel.EditablePoly.Remove selLevel: #Edge
		-- check vertex
	-- get vertex selection 
	local vertBitAr = sel.GetSelection #vertex
	local vertAr = vertBitAr as array
	-- for each vertex
		-- if vertex edge num <= 3 collect vertex
	local vertToDel = #()
	for id in vertAr do
	(
		num = sel.GetVertexEdgeCount  id
		if num <=2 then
		(
			append vertToDel id
		)
	)
	vertToDelBit = vertToDel as bitarray
	-- set vertex selection with good vertex
	sel.setSelection #vertex vertToDelBit
	sel.EditablePoly.Remove selLevel: #Vertex
)


try(destroyDialog edgeToShapeOnModRLT)catch()

rollout edgeToShapeOnModRLT "edge to shape"
(
-- 	vars
-- 	local maxIni = getMAXIniFile()
-- 	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	
-- 	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
	local extSize  = 100
	local selLev 
	local boxorient 
	
	local Params = #("pos","size","addExtrusionCB", "addSweepCB", "extSizeSP", "addExtrusionCB", \
		"removeEdgeCB", "resetXformCB", "collapseXformCB", \
		"createBoxOrientCB", "xformOnBoxCB", 	"collapseXformCB2", \
		"delBoxOrientCB", "keepSelCB")
-- function
	
	fn writePosition rlt =
	(
		posBak = GetDialogPos rlt
		res = setINISetting armadasScriptsIni rlt.name "pos" (posBak as string)
		res
		format  "position saved: %\n" res
	)
	
	fn loadPosition rlt =
	(
		posBak = [800,250]

		if (hasINISetting armadasScriptsIni rlt.name "pos") then
		(
			posBakStr = getINISetting armadasScriptsIni  rlt.name "pos"
			posBak = execute posBakStr
		)
		
		SetDialogPos rlt posBak
	)
	
-- 	ui
	checkbox addSweepCB "add Sweep"
	group "Extrusion options:"
	(
		checkbox addExtrusionCB "add extrusion" 
		checkbox addMatCB "add grid base material" enabled: false
		spinner extSizeSP "extrusion size:" range: [0, 1000, extSize] type: #worldunits

	)
	checkbox removeEdgeCB "remove edge selection"
	
	group "reset x form (world):"
	(
		checkbox resetXformCB "reset x form"
		checkbox collapseXformCB "collapse x form"
	)
	
	group "reset x form (normale):"
	(
		checkbox createBoxOrientCB "Create Box Orient"
		checkbox xformOnBoxCB "reset x form"
		checkbox collapseXformCB2 "collapse x form"
		checkbox delBoxOrientCB "delete Box orient"
	)
	
	checkbox keepSelCB "keep selection"
	
-- 	group "box orient:"
-- 	(
-- 		button boxOrientBT "create Box Orient"
-- 	)
	
	button extractBT "extract"
	
	on extractBT pressed do
	(
		sel = selection as array
		s = sel[1]
		
		undo on
		(

-- 				local goNext = true
			format "traitement start: %\n" s.name
-- 				select s
			-- ignore les objets avec des modifier edit_poly sans selection de face
			if classof (modPanel.getCurrentObject()) == Editable_Poly and  (polyop.getfaceselection s.baseobject).count > 0 then
			(
				format "faces selection on editable_poly: %\n" s.name
-- 					select s
			)
			else if classof (modPanel.getCurrentObject()) == Edit_Poly and ((s.edit_poly.GetSelection  #face) as array).count > 0 then
			(
-- 				select s
				format "faces selection on edit_poly modifier: %\n" s.name
			)
			else if classof (modPanel.getCurrentObject()) == Edit_Poly and ((s.edit_poly.GetSelection  #edge) as array).count > 0 then
			(
-- 					selLev = 2
				format "edges selection on edit_poly modifier: %\n" s.name
-- 					continue
			)
			else
			(
				format "ignore %\n" s.name
				continue
			)
											
			-- create box orient sur une selection de face
			if createBoxOrientCB.state == true and subobjectLevel == 4 then
			(
				if classof (modPanel.getCurrentObject()) == Editable_Poly and  (polyop.getfaceselection s).count > 0 then
				(
					boxorient = createBoxOrient2 s
				)
				else if classof (modPanel.getCurrentObject()) == Edit_Poly and ((s.edit_poly.GetSelection  #face) as array).count > 0 then
				(
					boxorient = createBoxOrientOnMod s
				)
				else(boxorient = undefined)
			)else  (format "select faces\n")
				
			-- convert face selection en sdge selection si necessaire
			if subObjectLevel == 4 then
			(
				if classof (modPanel.getCurrentObject()) == Editable_Poly then
				(
					s.ConvertSelectionToBorder #Face #Edge
					selLev = 4
				)
				else if classof (modPanel.getCurrentObject()) == Edit_Poly then
				(
					s.modifiers[#Edit_Poly].ConvertSelectionToBorder #Face #Edge
					selLev = 4
				)
				else(boxorient = undefined)
			)else (selLev = 2)
			
			-- create shape
			objSCount = objects.count
			newName = uniqueName (s.name + "_shape")
			
			if classof (modPanel.getCurrentObject()) == Editable_Poly then
			(
				s.createShape  newName  false s
			)
			else if classof (modPanel.getCurrentObject()) == Edit_Poly then
			(
				s.Edit_Poly.CreateShape newName
			)
			else(boxorient = undefined)
			
			newShapes = for i = objSCount + 1  to objects.count collect objects[i]
			if newShapes.count > 0 then for s in newShapes do updateshape s
			format "newShapes:%\n" newShapes
-- 			newShape = getnodebyname newName
-- 			if isvalidnode newShape then updateshape newShape
			
			-- reset xform 
			if isvalidnode boxOrient and xformOnBoxCB.state == true then 
			(
				-- on box orient
-- 				format "reset on box Start\n"
				
				for ns in newShapes do
				(
					resetInPlace2 ns boxOrient
					if collapseXformCB2.state do
					(
						converttosplineshape  ns
						updateshape ns
					)
				)
			)
			else if resetXformCB.state then
			(
				-- on world
				for ns in newShapes do
				(
					resetxform ns 
					if collapseXformCB.state  do
					(
						converttosplineshape ns
						updateshape ns
					)
				)
			)else()
			
			
			if delBoxOrientCB.state and  isvalidnode boxorient then delete boxorient
			
			-- option: remove edge
			if removeEdgeCB.state == True do removeEdgeAndVerticesFN s
			
			if addExtrusionCB.state == true and  newShapes.count > 0 do
			(
				myExtrusion = Extrude amount: extSize capStart: off capEnd: off
				for ns in newShapes do addmodifier ns myExtrusion
			)
			
			-- option: add sweep
			if addSweepCB.state == true and newShapes.count > 0 do
			(
				
				mySweep = Sweep CurrentBuiltInShape: 2 PivotAlignment:8 SmoothPath: false
				mySmooth = Smooth name: "my_Smooth" autosmooth: on
				
-- 				addmodifier newShape mySweep
				for ns in newShapes do
				(
					addmodifier ns mySweep
						
					redrawViews()
					
					newSweep = getnodebyname ns.name

					ns.Sweep[4].length = 20
					ns.Sweep[4].width = 20
				)
			)
			-- option keep selection
-- 			format "current: %\n"  (modPanel.getCurrentObject())
				
				
			if classof (modPanel.getCurrentObject()) == Editable_Poly then
			(
				format "sel: %\n" sel
				if keepSelCB.state then
				(
-- 					select sel
					if sel.count == 1 then
					(
						format "Keep Editable poly\n"
						modPanel.setCurrentObject s
						subobjectLevel = selLev
					)
				)
				else
				(
					subobjectLevel = 0		
					select newShapes
				)
			)
			else if classof (modPanel.getCurrentObject()) == Edit_Poly then
			(
				if keepSelCB.state == true then
				(
-- 					select sel
					subobjectLevel = selLev
				)
				else
				(
					subobjectLevel = 0		
					select newShapes
				)
			)
			else()
		)
	)
	
	on resetXformCB changed state do
	(
		collapseXformCB.state = state
		
		if state then
		(
			createBoxOrientCB.state = not state
			xformOnBoxCB.state = not state
			collapseXformCB2.state = not state
			delBoxOrientCB.state = not state
		)

	)
	
	on xformOnBoxCB changed state do
	(
		if state then
		(
			resetXformCB.state = not state
			collapseXformCB.state = not state
		)
		
		createBoxOrientCB.state =  state
-- 		xformOnBoxCB.state =  state
		collapseXformCB2.state =  state
		delBoxOrientCB.state =  state

	)
	
	on addSweepCB changed theState do
	(
		addExtrusionCB.state = false
		addMatCB.enabled = false
		extSizeSP.enabled = false
	)
	
	on extSizeSP changed size do
	(
		extSize = size
	)
	
	on addExtrusionCB changed  theState do
	(
		addSweepCB.state = false

		addMatCB.enabled = false
		extSizeSP.enabled = true
	)
	

	
	on edgeToShapeOnModRLT open do
	(
		loadRolloutParams edgeToShapeOnModRLT Params
	)
	
	on edgeToShapeOnModRLT close do
	(
		writeRolloutParams edgeToShapeOnModRLT Params
	)
	
)
createDialog edgeToShapeOnModRLT

