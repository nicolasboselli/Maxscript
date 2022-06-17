/*

memo:

edge picker: selectionner une edge en calculant la distance entre le point piqué et l'edge la plus proche avec des math et pas avec un objet impacté


*/

-- check system presence
-- GetDialogPos planResizerRLT




try(destroydialog facePickerRLT)catch()
rollout facePickerRLT "face picker" width: 250
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
				if iskindof theNearestObj.baseobject editable_poly then
				(
/* 					
					meshModForMatID = edit_mesh name: "meshModForMatID "
					addmodifier theNearestObj meshModForMatID
					local impact = intersectRayEx theNearestObj myRay
					local thefaceMesh = impact[2]
					format "thefaceMesh:%\n" thefaceMesh
-- 					local verts = polyop.getFaceVerts theNearestObj.baseobject faceMesh
-- 					format "verts:%\n" verts
					
					deleteModifier theNearestObj meshModForMatID
					 */
					
					local impact = intersectRayEx theNearestObj.mesh myRay
					local thefaceMesh = impact[2]
					format "thefaceMesh:%\n" thefaceMesh
					
				)
				
				-- recuperation de la face editable_poly
				vv = getface theNearestObj.mesh thefaceMesh
				pp0 = #{1..theNearestObj.numfaces}
				
				for k=1 to 3 do
				(
					pp1 = #{}
					v = vv[k]
					for i=1 to theNearestObj.getVertexFaceCount v do append pp1 (theNearestObj.getVertexFace v i)
					pp0 *= pp1
				)
				
				format "pp0:%\n" pp0
				
				-- trouver toutes les faces contigueus avec la même normale et une tolerance

			)
		)
	)
	
-- 	UI

	-- pick blueprint resizer
			-- create resizer	

	checkbutton placeObjBT "pick face" --enabled: true across: 2


	
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
)


createdialog facePickerRLT --style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

-- planResizerRF.pos 


-- $.material[9]

