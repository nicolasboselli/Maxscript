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

	rep = box transform: theTM
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


try(destroyDialog edgeToShapeRLT)catch()

rollout edgeToShapeRLT "edge to shape"
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
		
		undo on
		(
			for s in sel do
			(
				-- create box orient
				if createBoxOrientCB.state == true and subobjectLevel == 4 and (polyop.getfaceselection s).count > 0 then
				(
					boxorient = createBoxOrient2 s
				)else  (print "select faces")
					
				
				-- convert selection if necessary
				if subObjectLevel == 4 then
				(
					s.ConvertSelectionToBorder #Face #Edge
					selLev = 4
				)else (selLev = 2)
				
				-- create shape
				newName = uniqueName (s.name + "_shape")
				s.createShape  newName  false s
				
				newShape = getnodebyname newName
				updateshape newShape
				
				-- reset xform 
				if boxOrient != undefined and xformOnBoxCB.state == true then 
				(
					-- on box orient
					resetInPlace2 newShape boxOrient
					if collapseXformCB2.state == true do
					(
						converttosplineshape  newShape
						updateshape newShape
					)
				)
				else if resetXformCB.state then
				(
					-- on world
					resetxform newShape 
					if collapseXformCB.state == true do
					(
						converttosplineshape  newShape
						updateshape newShape
					)
				)else()
				
				
				if delBoxOrientCB.state and  isvalidnode boxorient then delete boxorient
				
				-- option: remove edge
				if removeEdgeCB.state == True do removeEdgeAndVerticesFN s
				
				if addExtrusionCB.state == true do
				(
					myExtrusion = Extrude amount: extSize capStart: off capEnd: off
					addmodifier newShape myExtrusion
				)
				
				-- option: add sweep
				if addSweepCB.state == true do
				(
					
					mySweep = Sweep CurrentBuiltInShape: 2 PivotAlignment:8 SmoothPath: false
					mySmooth = Smooth name: "my_Smooth" autosmooth: on
					
					addmodifier newShape mySweep

					redrawViews()
					
					newSweep = getnodebyname newShape.name

					newSweep.modifiers[#Sweep][4].length = 20
					newSweep.modifiers[#Sweep][4].width = 20
				)
				
				-- option keep selection
				if keepSelCB.state == true then
				(
					select s
					modPanel.setCurrentObject s
					subobjectLevel = selLev

				)
				else
				(
					subobjectLevel = 0		
					select newShape
				)
			)
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
	

	
	on edgeToShapeRLT open do
	(
		loadRolloutParams edgeToShapeRLT Params
	)
	
	on edgeToShapeRLT close do
	(
		writeRolloutParams edgeToShapeRLT Params
	)
	
)
createDialog edgeToShapeRLT 

