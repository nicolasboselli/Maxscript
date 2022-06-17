/*

*/

-- check system presence


-- GetDialogPos planResizerRLT




try(destroydialog matPickerRLT)catch()
rollout matPickerRLT "material picker" width: 250
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
				local theShortestDist = 10000000
				
				local viewTM = (inverse(getViewTM())).translationpart
				local myRay = mapScreenToWorldRay viewPoint
				local res = intersectRayScene myRay
					
				for o in res where not o[1].ishidden do
				(
	-- 				format "ishidden: %\n" o[1].ishidden
					if (distance o[2].pos viewTM) < theShortestDist do
					(
						theNearestObj = o[1]
						theShortestDist = distance o[2].pos viewTM
					)
				)
				
				if isvalidnode theNearestObj then
				(
					meshModForMatID = edit_mesh name: "meshModForMatID "
					addmodifier theNearestObj meshModForMatID
					local impact = intersectRayEx theNearestObj myRay
					
-- 					format "theNearestObj: % impact: %\n" theNearestObj.name impact
					
					local pickedId = (getFaceMatID theNearestObj impact[2])
-- 					format "matID: %\n" pickedId
	-- 				select theNearestObj
					
					if iskindof  theNearestObj.material MultiMaterial then
					(
						format "mat: %\n" theNearestObj.material[pickedId]
					)
					else
					(
						format "mat: %\n" theNearestObj.material
					)
					
					deleteModifier theNearestObj meshModForMatID
				)
				
	-- 			format "res:%\n" res
			)

		)
	)
	
-- 	UI

	-- pick blueprint resizer
			-- create resizer	
	group "Scaler:"
	(
		checkbutton placeObjBT "pick material" --enabled: true across: 2
	)

	
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


createdialog matPickerRLT --style: #(#style_resizing,#style_titlebar, #style_border, #style_sysmenu,#style_minimizebox, #style_maximizebox )

-- planResizerRF.pos 


-- $.material[9]

