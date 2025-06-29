/*

memo:

edge picker: selectionner une edge en calculant la distance entre le point piqué et l'edge la plus proche avec des math et pas avec un objet impacté


*/

-- check system presence
-- GetDialogPos planResizerRLT




try(destroydialog facePickerRLT)catch()
rollout facePickerRLT "Faces Extractor" width: 250
(

	
-- 	fonctions

	
-- 	tools
	
	tool pickMaterialTool
	(
		
		local snapNode
		
		on mousePoint clickno do
		(
			if clickno > 1 then
			(
-- 				format "clickno: %\n"clickno
				local theNearestObj
				local theNearestImpact
				local theShortestDist = 10000000
				
				
				local viewTM = (inverse(getViewTM())).translationpart
				local myRay = mapScreenToWorldRay viewPoint
				local res = intersectRayScene myRay
				
				
					
				for o in res where not o[1].ishidden do
				(
	-- 				format "ishidden: %\n" o[1].ishidden
					if (distance o[2].pos viewTM) < theShortestDist do
					(
						theNearestImpact = o
						theNearestObj = o[1]
						theShortestDist = distance o[2].pos viewTM
					)
				)
				format "theNearestImpact: %\n" theNearestImpact

				-- recuperation de la face edit_mesh
				newMesh = snapshot theNearestObj
				
				local impact = intersectRayEx newMesh myRay
-- 				local thefaceMesh = impact[2]
						
				local testFaces = meshop.getPolysUsingFace newMesh #{impact[2]} ignoreVisEdges: true threshhold: 1.0
				
				local totalFaces = for i = 1 to (getnumfaces newMesh) collect i
				totalFaces = totalFaces as BitArray
				
				
				local facesToDel = totalFaces - testFaces
				
				
				meshop.deleteFaces newMesh facesToDel
				
				format "newMesh: % testFaces: % totalFaces: % facetodel: %\n" newMesh testFaces totalFaces facesToDel
				
				newMesh.pivot = newMesh.center
-- 				newMesh.outlineAmount = 2
				convertToPoly newMesh
				addmodifier newMesh (shell())

				select newMesh
				
				
			
			)
		)
	)
	
	tool pickSplineTool
	(
		
		local snapNode
		
		on mousePoint clickno do
		(
			if clickno > 1 then
			(
-- 				format "clickno: %\n"clickno
				local theNearestObj
				local theNearestImpact
				local theShortestDist = 10000000
				
				local viewTM = (inverse(getViewTM())).translationpart
				local myRay = mapScreenToWorldRay viewPoint
				/*	
				local res = intersectRayScene myRay
					
				for o in res where not o[1].ishidden do
				(
	-- 				format "ishidden: %\n" o[1].ishidden
					if (distance o[2].pos viewTM) < theShortestDist do
					(
						theNearestImpact = o
						theNearestObj = o[1]
						theShortestDist = distance o[2].pos viewTM
					)
				)
				format "theNearestImpact: %\n" theNearestImpact
*/
				theNearestObj = (selection as array)[1]
					
				-- recuperation de la face edit_mesh
				meshModForMatID = edit_mesh name: "meshModForMatID"
				addmodifier theNearestObj meshModForMatID
				
				local impact = intersectRayEx theNearestObj myRay
-- 				local thefaceMesh = impact[2]
				
				-- collecter les faces coplanaire selectionnées
				local testFaces = meshop.getPolysUsingFace theNearestObj #{impact[2]} ignoreVisEdges: true threshhold: 10
				
				-- appliquer la selection dzans l'editmesh
				setFaceSelection theNearestObj meshModForMatID testFaces
				
				-- faire un clone de l'objet
				theNearestObjCopy = copy  theNearestObj
				
				-- convertir la selection en edge
				converttopoly theNearestObjCopy
				
				-- recupérer la selection d'edges
				local facesSel = polyop.getFaceSelection theNearestObjCopy
				local vertSel = polyop.getVertsUsedOnlyByFaces theNearestObjCopy facesSel

				local edgeSel1 = polyop.getEdgesUsingVert theNearestObjCopy vertSel
				local edgeSel2 = polyop.getEdgesUsingFace theNearestObjCopy facesSel
				
				edgeSel3 = edgeSel2 - edgeSel1
				
				polyop.createShape theNearestObjCopy edgeSel3 smmoth: false name: "shape" node: theNearestObjCopy
				delete theNearestObjCopy
								
				deleteModifier theNearestObj meshModForMatID
			)
		)
	)
	
	tool pickEdgeLoopTool
	(
		
		local snapNode
		
		on mousePoint clickno do
		(
			if clickno > 1 then
			(
-- 				format "clickno: %\n"clickno
				local theNearestObj
				local theNearestImpact
				local theShortestDist = 10000000
				
				local viewTM = (inverse(getViewTM())).translationpart
				local myRay = mapScreenToWorldRay viewPoint
				local res = intersectRayScene myRay
					
				for o in res where not o[1].ishidden do
				(
	-- 				format "ishidden: %\n" o[1].ishidden
					if (distance o[2].pos viewTM) < theShortestDist do
					(
						theNearestImpact = o
						theNearestObj = o[1]
						theShortestDist = distance o[2].pos viewTM
					)
				)
				format "theNearestImpact: %\n" theNearestImpact

				-- recuperation de la face edit_mesh
				meshModForMatID = edit_mesh name: "meshModForMatID"
				addmodifier theNearestObj meshModForMatID
				
				local impact = intersectRayEx theNearestObj myRay
-- 				local thefaceMesh = impact[2]
				
				-- collecter les faces coplanaire selectionnées
				local testFaces = meshop.getPolysUsingFace theNearestObj #{impact[2]} ignoreVisEdges: true threshhold: 1.0
				
				-- appliquer la selection dzans l'editmesh
				setFaceSelection theNearestObj meshModForMatID testFaces
				
				-- faire un clone de l'objet
				theNearestObjCopy = copy  theNearestObj
				
				-- convertir la selection en edge
				converttopoly theNearestObjCopy
				
				-- recupérer la selection d'edges
				local facesSel = polyop.getFaceSelection theNearestObjCopy
				local vertSel = polyop.getVertsUsedOnlyByFaces theNearestObjCopy facesSel

				local edgeSel1 = polyop.getEdgesUsingVert theNearestObjCopy vertSel
				local edgeSel2 = polyop.getEdgesUsingFace theNearestObjCopy facesSel
				
				edgeSel3 = edgeSel2 - edgeSel1
				
				polyop.createShape theNearestObjCopy edgeSel3 smmoth: false name: "shape" node: theNearestObjCopy
				delete theNearestObjCopy
								
				deleteModifier theNearestObj meshModForMatID
			)
		)
	)
	
-- 	UI

	-- pick blueprint resizer
			-- create resizer	

	checkbutton placeObjBT "Extract face" --enabled: true across: 2
	group "Extract spline by faces"
	(
		spinner tresholdSP "Treshold: "
		checkbutton extractSplineCB "Extract spline" --enabled: true across: 2
		 
	)
	checkbutton extractSplineCB2 "Extract spline by EdgeLoop"
	
	-- rescale points	
	on placeObjBT changed state do
	(
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool pickMaterialTool
			)
			placeObjBT.state = false
		)
	)
	
	on extractSplineCB changed state do 
	(
		sel = selection as Array
		if sel.count == 1 then
		(
			if state == true do
			(
				continueTool = true
				while continueTool == true do
				(
					continueTool = starttool pickSplineTool
				)
				extractSplineCB.state = false
			)
		)
		else
		(
			extractSplineCB.state = false
			format "Selectionner un seul objet.\n"
		)
	)
	
	on extractSplineBT pressed do
	(
		meshOps.createShapeFromEdges $
	)
)
createdialog facePickerRLT --style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )



-- $.GetSelection #Edge

-- $.GetSelection #face
-- planResizerRF.pos 


-- $.material[9]

