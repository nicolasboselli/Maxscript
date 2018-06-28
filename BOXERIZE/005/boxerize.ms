/*
-- maj:
	-- proposer des options pour l'orientation du pivot
		x- UI
		/- fonction
			-- le pivot se place correctement mais le xform est décaler
	
-- rebuilt:
	-- ecrire une nouvelle fonction pivot on face qui propose l'orientation en X, Y,Z
	/- faire une fonction qui ne nécessite pas un reset xform avant d'être utilisé
*/



fn detachFaces2 s =
(
	local faceCount = polyop.getNumFaces s.baseobject
	local edges_list = s.baseobject.EditablePoly.getSelection #edge

	polyop.capHolesByEdge s edges_list
	
	local faceCountAft = polyop.getNumFaces s.baseobject

	local newFaces = for i = faceCount + 1 to faceCountAft collect i
		
-- 	polyop.setFaceSelection  s newFaces
	polyop.detachFaces s newFaces delete:true asNode:true name: (uniquename "fenetre") 
)

-- detachFaces2 $




fn detach_face_fenetre s =
(

	edges_list = s.baseobject.EditablePoly.getSelection #edge

	polyop.capHolesByEdge s edges_list
	s.ConvertSelection #edge #face

	s.baseobject.EditablePoly.ShrinkSelection selLevel: #face

	fenetres_list = s.baseobject.EditablePoly.getSelection #face

	polyop.detachFaces s fenetres_list delete:true asNode:true name: (uniquename "fenetre") 
)


fn explodeObject s =
(
	num = polyop.getNumFaces s
	numToDetach = #(num)
	detached = #()

	for n in numToDetach do
	(
		facesToDetach = polyop.getElementsUsingFace s #{num}
		fenetre_detach_name = uniquename "fenetre_detach_"
		polyop.detachFaces s facesToDetach delete:true asNode:true name:fenetre_detach_name
		append detached (getnodebyname fenetre_detach_name)
		
		num = polyop.getNumFaces s
		if num > 0 then append numToDetach num
	)
	delete s
	detached
)
-- explodeObject $

fn pivotOnFAce s = 
(
	posCenter = s.center
	bakTM = s.transform
	
	theX = normalize ((polyop.getFaceNormal s.baseobject 1)*-1)
	theY = normalize (cross [0,0,1] theX )
	theZ= normalize (cross theX theY)
	
	localTM = matrix3   theX theY theZ posCenter

	s.transform = localTM
	
	addmodifier s (xform ())

-- 	s.modifiers[#xform].gizmo.rotation = in coordsys local localTM.rotation
	s.modifiers[#xform].gizmo.rotation = localTM.rotationpart - bakTM.rotationpart
	s.modifiers[#xform].gizmo.position = (in coordsys local s.center)* -1
)

fn pivotOnFAce3  s normal: 1 flipNormal: true upnode: 3 flipUpnode: false = 
(
	local theX, theY, theZ
	local invNormal, invUpnode
	local theOrder = #(0,0,0)
	
	local theRest = #{1,2,3} - #{normal, upnode}
	local theRestAr = theRest as array
	local Other = theRestAr[1]
	
	if flipNormal then invNormal = -1 else invNormal = 1
	if flipUpnode then invUpnode = -1 else invUpnode = 1
	
	local posCenter = s.center
	local bakTM = s.transform
	
	theNormal = normalize ( ( polyop.getFaceNormal s.baseobject 1) * invNormal )
	theOther = normalize ( cross   ( [0,0,1] * invUpnode ) theNormal)
	theUpnode= normalize ( cross theNormal theOther )
	
	theOrder[normal] = theNormal
	theOrder[Other] = theOther
	theOrder[upnode] = theUpnode
	
	local localTM = matrix3   theOrder[1] theOrder[2] theOrder[3] posCenter
	
	s.transform = localTM
	
	addmodifier s (xform ())
	s.modifiers[#xform].gizmo.transform = bakTM * inverse(localTM)
)

-- boxerizeRLT.upnodeRB.enabled = true

try(destroydialog boxerizeRLT)catch()
rollout boxerizeRLT "Boxerize"
(
	local wireAr = #(green, red, blue, orange, yellow, brown)
	local params = #("pos", "boxOutlineSP", "boxSizeSP", "boxSizeOutSP")
	local RLTvers = getScriptVersion (getThisScriptFilename())
	
	group "faces:"
	(
		button createFacesBT "create faces"
		button resetpivotBT "reset Pivot"
	)
	
	group "explode:"
	(
		button explodeBT "explode element"
	)
	
	group "pivot settings:"
	(
		radiobuttons normalRB "normal:" labels: #("x", "y", "z")  across: 2 default: 1
		checkbox flipNormalBT "flip nomal" checked: true
		radiobuttons upnodeRB "upnode:" labels: #("x", "y", "z")  across: 2  default: 3
		checkbox flipUpnodeBT "flip upnode" 
		
		button testBT "Pivot on face"
	)
		
	group "boxerize:"
	(
		spinner boxOutlineSP "Outline Size:" type: #worldunits range:[0,1000,2] -- enabled: false
		spinner boxSizeSP "Shell Inner:" type: #worldunits range:[0,1000,28]
		spinner boxSizeOutSP "Shell Outer:" type: #worldunits range:[0,1000,0]
		
-- 		button boxBT "Create Box"
		button addBoxBT "make box"
		
	)
	button boxBT2 "BOXERIZE"
	
	-- Actions
	fn refreshUI =
	(
-- 		local getScriptVersion (getThisScriptFilename()) = getScriptVersion (getThisScriptFilename())
		if RLTvers != undefined then boxerizeRLT.title = boxerizeRLT.title + " v." + (RLTvers as string)
	)
	
	on boxerizeRLT open do
	(
		loadRolloutParams boxerizeRLT Params
		refreshUI ()
	)
	
	on boxerizeRLT close do
	(
		writeRolloutParams boxerizeRLT Params
	)
	
	on createFacesBT pressed do 
	(
		if selection == undefined then "selectionne un objet ou des ouvertures"
		else
		(
			if (modPanel.getCurrentObject() == undefined) then  max modify mode
			
			case of
			(
				(subobjectLevel == 0):
				(
					s_array = selection as array
					for s in s_array do 
					(
						select s
						s.baseobject.EditablePoly.SetSelection #Edge ((polyOp.getOpenEdges s.baseobject) as bitarray)
						detachFaces2 s
					)
				)
					
				(subobjectLevel == 3):
				(
					s = $
					detachFaces2 s
				)
				
				default: print "selectionner des objets ou des ouvertures"
			)
		)
	)
	
	on resetpivotBT pressed do
	(
		for s in selection do resetpivot s
	)
	
	-- explosion
	on explodeBT pressed do
	(
		local sel = selection as array
		for s in sel do explodeObject s
	)
	
	-- pivot on surface
	on normalRB changed val do
	(
		if upnodeRB.state == val then  upnodeRB.state = 0
	)
	
	on upnodeRB changed val do
	(
		if normalRB.state == val then  normalRB.state = 0
	)
		
	on testBT pressed do
	(
		local sel = selection as array
		for s in sel do pivotOnFAce3  s normal:  normalRB.state flipNormal: flipNormalBT.state upnode: upnodeRB.state flipUpnode: flipUpnodeBT.state
	)
	
	on addBoxBT pressed do
	(
		local sel = selection as array
		undo on
		(
			for s in sel do
			(
				select s
				s.outlineAmount = boxOutlineSP.value
				s.baseobject.EditablePoly.Outline ()
			
				myShell = Shell innerAmount:boxSizeOutSP.value outerAmount:boxSizeSP.value
				addmodifier s myShell
				s.pivot = s.center
				
				id = random 1 wireAr.count
				s.material = undefined
				s.wirecolor = wireAr[id]
			)
		)
	)
	
-- 	on boxBT pressed do
-- 	(
-- 		local sel = selection as array
-- 		if sel.count == 1 do boxerize2 sel amount: boxSizeSP.value		
-- 	)
	
	on boxBT2 pressed do
	(
		local sel = selection as array
			
		undo on 
		(
			for s in sel do
			(
				select s
				polyop.setFaceSelection s.baseobject #all
				
				s.outlineAmount = boxOutlineSP.value
				s.baseobject.EditablePoly.Outline ()
				
				-- detacher chaque element
				local selArr = explodeObject s

				for o in selArr do
				(
					if (polyop.getNumFaces o.baseobject)>0 do
					(
						-- reset in place
						pivotOnFAce3  o normal:  normalRB.state flipNormal: flipNormalBT.state upnode: upnodeRB.state flipUpnode: flipUpnodeBT.state
						
						-- add shell on object
						myShell = Shell innerAmount:boxSizeOutSP.value outerAmount:boxSizeSP.value
						addmodifier o myShell
						o.pivot = o.center
						
						converttopoly o
					
						o.material = undefined	
						
						id = random 1 wireAr.count
						o.wirecolor = wireAr[id]
					)
				)
			)
		)
	)
)
createdialog boxerizeRLT
-- polyop.setFaceSelection $ #all

