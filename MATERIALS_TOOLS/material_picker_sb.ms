-- viewTM = (inverse(getViewTM())).translationpart
-- myRay = mapScreenToWorldRay pickedPt
-- res = intersectRayScene myRay
 
 
--  pickedPt = pickPoint prompt:"Sélectionnez une face" 



try(destroydialog pickMaterialRLT)catch()
rollout pickMaterialRLT "Pick Material"
(
-- 	button pickMat1CB "pick material 1"
	checkbutton pickMat2CB "pick material 2"  
	
	tool pickMaterialTool numPoints: 2
	(	
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
					
					format "theNearestObj: % impact: %\n" theNearestObj.name impact
					
					local pickedId = (getFaceMatID theNearestObj impact[2])
					format "matID: %\n" pickedId
	-- 				select theNearestObj
					
					if iskindof  theNearestObj.material MultiMaterial then
					(
						format "mat: %\n" theNearestObj.material[pickedId]
						pickedMat = theNearestObj.material[pickedId]
						format "pickedMat: %\n" ( pickedMat)
-- 						materialListMLB.selection = (finditem matArToDisp pickedMat)
						
						(sme.getview 1).CreateNode pickedMat [0,0]
					)
					else
					(
						format "mat: %\n" theNearestObj.material
						pickedMat = theNearestObj.material
-- 						format "%\n" (finditem matArToDisp pickedMat)
-- 						materialListMLB.selection = (finditem matArToDisp pickedMat)
						(sme.getview 1).CreateNode pickedMat [0,0]
						
					) 
					
					deleteModifier theNearestObj meshModForMatID
				)
				
	-- 			format "res:%\n" res
			)
		) 
	)
	
	on pickMat1CB pressed do
	(
		pickedPt = pickPoint prompt:"Sélectionnez une face\n" 
		format "pickedPt: %\n" pickedPt
	)
	
	on pickMat2CB changed state do
	(
		starttool pickMaterialTool
		
		pickMat2CB.state = false
		
-- 		stoptool pickMaterialTool
-- 		pickMat2CB.state = false
		
/* 		if state == true do
		( 
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool pickMaterialTool
			)
			pickMat2CB.state = false
		)  */
	)
)
createdialog pickMaterialRLT