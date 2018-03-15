macroScript SupaSlice
	category:"ArmadasScripts"
	toolTip:"Supa Slice"
-- v1	

(
	local isExecuting = false
	
	tool supaSlice
	(
		local snapgrid
		local faceNormal = [0,1,0]
		local firstPoint = [0,0,0]
		local secondPoint = [0,0,0]
		local thirdPoint = [0,0,0]
		local splineGuide
		
		local isMesh = false	
		local meshModifier
		local backGrid
		local backSnapActive
		local backSnapPreviewRadius
		local backSnapRadius
		local backSnapDisplayRubberBand
		local backSnapDisplay
		local backSnapType
		local backSnapOptions

		fn goBackdraftTemp = 
		(
			if(snapgrid != undefined AND (isDeleted snapgrid) == false) then
			(
				--save values
					activegrid = backGrid
					delete snapgrid
					snapMode.active = backSnapActive
					snapMode.snapPreviewRadius = backSnapPreviewRadius
					snapMode.snapRadius = backSnapRadius
					snapMode.displayRubberBand = backSnapDisplayRubberBand
					snapMode.display = backSnapDisplay
					if(backSnapType != undefined) then
					(
						snapMode.type = backSnapType
					)
					else
					(
						snapMode.type = #3D
					)
					for i = 1 to snapmode.numOSnaps do
					( 
						for j = 1 to (snapmode.getOSnapNumItems i) do
						(
							snapmode.setOSnapItemActive i j backSnapOptions[i][j]
						)
					)
			)
			--remove spline
			if(splineGuide != undefined AND (isDeleted splineGuide) == false) then
			(
				delete splineGuide
			)
			if(isMesh == true) then
			(
				--remove edit mesh
				deleteModifier $ meshModifier
			)
			max undo
		)
		
		--function to end the tool
		fn goBackdraft =
		(
			goBackdraftTemp()
			isExecuting = false
			#stop
		)
		
		--function to draw line to see what you do
		fn drawLineBetweenTwoPoints pointA pointB =
		(
			ss = SplineShape pos:pointA
			addNewSpline ss
			addKnot ss 1 #corner #line PointA
			addKnot ss 1 #corner #line PointB
			ss.wirecolor = color 255 255 0
			updateShape ss
			ss
		)
		
		--click (clickno=nombre de click), release est un click (d'ou le stop)
		on mousePoint clickno do
		(
			if $ != undefined then
			(
				--if (classof ($) == Editable_Poly) then
				if(LayerManager.current.isHidden == false) then
				(
					selected = false
					nbFaces = polyop.getFaceSelection $.baseObject
					for i = 1 to nbFaces.count do
					( 
						if nbFaces[i] == true then
						(
							selected = true
						)
					)
					if(selected == true) then
					(
						--on first click
						if mod clickno 2 == 0 then
						(
							--save values
							backGrid = activegrid
							backSnapActive = snapMode.active
							backSnapPreviewRadius = snapMode.snapPreviewRadius
							backSnapRadius = snapMode.snapRadius
							backSnapDisplayRubberBand = snapMode.displayRubberBand
							backSnapDisplay = snapMode.display
							backSnapType = snapMode.type
							backSnapOptions = #()
							for i = 1 to snapmode.numOSnaps do
							( 
								backSnapOptions[i] = #()
								for j = 1 to (snapmode.getOSnapNumItems i) do
								(
									backSnapOptions[i][j] = snapmode.getOSnapItemActive i j
								)
							)
							
							--convert poly to mesh
							isMesh = true
							meshModifier = Edit_Mesh ()
							modPanel.addModToSelection (meshModifier) ui:off
							--Ray form clicked point to far away in the view
							myRay = mapScreenToWorldRay viewPoint
							arr = intersectRayEx $ myRay
							if(arr != undefined) then
							(
								firstPoint = arr[1].pos
								worldPoint = firstPoint
								clickedFace = arr[2]
													
								--calculer la matrice de la grille en fonction normale de la face cliquée
								faceNormal = getFaceNormal $ clickedFace
								matrice = MatrixFromNormal (faceNormal)
								--remove edit mesh
								deleteModifier $ meshModifier
								isMesh = false
								snapgrid = grid length:1000 width:1000 grid:50 position:firstPoint transform:matrice
								activegrid = snapgrid
								--activer le snap
								snapMode.active = true
								snapMode.snapPreviewRadius = 250
								snapMode.snapRadius = 225
								snapMode.displayRubberBand = false
								snapMode.display = false
								snapMode.type = #3D
								--enlever toutes les options
								for i = 1 to snapmode.numOSnaps do
								( 
									for j = 1 to (snapmode.getOSnapNumItems i) do
										snapmode.setOSnapItemActive i j false
								)
								--activer le snap aux points de la grille
								snapMode.setOSnapItemActive 3 1 true
								$.EditablePoly.resetSlicePlane ()
							)
							else
							(
								MessageBox "Clique pas a coté de l'objet..."
								goBackdraft()
							)
						)
						else
						(
							if clickno != 1 then
							(
								if firstPoint != secondPoint then
								(
									--cut
									rayPlane = polyop.getSlicePlane $.baseObject
									polyOp.slice $.baseObject (polyop.getFaceSelection $.baseObject) rayPlane 
								)
								else
								(
									MessageBox "T'a pas bougé assez le curseur, flemmard"
								)
							)	
							goBackdraftTemp()
						)
					)
					else
					(
						MessageBox "Pas de faces sélectionnées, tu vas pas couper grand chose :/"
						goBackdraft()
					)
				)
				else
				(
					MessageBox "Le calque actif est masqué"
					goBackdraft()
				)
			)
			else
			(
				MessageBox "Selectionne un objet d'abord, sinon, ça ne risque pas de marcher, hippie..."
				goBackdraft()
			)
		)
		
		on mouseMove clickno do
		(
			if mod clickno 2 != 0 AND clickno != 1 then
			(
				if(splineGuide != undefined AND (isDeleted splineGuide) == false) then
				(
					delete splineGuide
				)
				local center
				local normal
				thirdPoint = firstPoint+faceNormal
				gridPointRelative = gridPoint*snapGrid.transform
				secondPoint = gridPointRelative
				
						
				normal = normalize ( cross (firstPoint-secondPoint) (firstPoint-thirdPoint))
				center = firstPoint
				rayPlane = ray center normal
				polyop.setSlicePlane $ rayPlane 20
					
				splineGuide = drawLineBetweenTwoPoints firstPoint secondPoint
				)
		)
		
		on mouseAbort clickno do
		(
			if(mButton == true) then
			(
				goBackdraftTemp()
				return true
			)
			else
			(
				goBackdraft()
			)
		)
		
		on abort do
		(
			print "abort"
			goBackdraft()
		)
	)
	on execute do
	(
		isExecuting = true
		continueTool = true
		while continueTool == true do
		(
			print continueTool
			continueTool = starttool supaSlice
		)
	)
	
	on isChecked return (isExecuting == true)
)
