/*
maj:
- tester la creation d'un objet correctement orienté en z au point d'impact
- la selection de sous objet au point d'impact(face, edge, spline...)
- prendre en charge les categories objets caché par raccourcis(geometry, spline, lights)
- prendre en charge les spline

snapMode.hitPoint 
snapMode.node 

debug: les parametres du snaps ne sont pas setter


*/
-- $.getVertexFace 1 1

-- polyop.getFaceDeg $ 1

try(destroydialog testPickerRLT)catch()
rollout testPickerRLT "Test Picker"
(
	local goodRes
	checkbutton pickCB "pick"
	
	tool testTool
	(
		on mousePoint clickno do
		(
			format "########## start click\n"
			
			local myRay = mapScreenToWorldRay viewPoint
			format "clickno:%\n" clickno
			format "viewPoint: %\n" viewPoint
			format "node: %\n" snapMode.node.name
			
			-- si l'objet est un editable poly
			if iskindof snapMode.node.baseobject editable_poly then
			(
							
				-- Selectionner une face
				selVx = #()
				polyFaceAr = #()
				
				-- ajouter un editmesh sur l'objet
				em = (Edit_Mesh ())
				addmodifier snapMode.node  em
				
				-- retourner la face de l'edit mesh selectionné
				if isvalidnode snapMode.node then
				(
					tmpHit = intersectRayEx snapMode.node myRay
					if tmpHit != undefined then
					(
	-- 					format "face id: %\n" tmpHit[2]
						-- recuperer les trois vertex de la face
						selVx = meshop.getVertsUsingFace snapMode.node tmpHit[2]
	-- 					format "vx: %\n" selVx
					)
				)
				deletemodifier snapMode.node  em
				
				-- dans le poly retourner les faces avec les trois vertex
				for id in selVx do
				(
					polyFace = polyop.getFacesUsingVert snapMode.node # {id}
	-- 				format "polyFace: %\n" polyFace
					append polyFaceAr polyFace
				)
				
				-- recouper les bitarray			
				for  p in polyFaceAr do polyFaceAr[1] *= p
				faceSel = (polyFaceAr[1] as array)[1]
				format "faceSel: %\n" faceSel
			)
			-- si l'objet est une line avec un sweep
			else if iskindof snapMode.node.baseobject line then
			(
				tmpHit = intersectRayEx snapMode.node myRay
				format "tmpHit:%\n" tmpHit
				
				-- à partir de la face selectionné retrouver l'id de la section correspondante
			)
			-- si l'objet est un mesh
			-- si l'objet est un edit poly avec un shell
		)
		
		on mouseMove clickno do(/*format "######## move #######\n"*/)
		
		on stop do 
		(
			format "######## stop #######\n"
		)
	)
	
	on pickCB changed state do
	(
		if state do
		(
			snapMode.display = false
			snapMode.active = true

			-- active vertex, edge et face
			snapMode.setOSnapItemActive 7 5 true
			max drawingaids; max drawingaids 
			
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool testTool
			)
			pickCB.state = false
		)
	)
)
createdialog testPickerRLT