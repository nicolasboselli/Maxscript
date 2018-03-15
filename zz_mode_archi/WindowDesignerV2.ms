macroScript WindowDesignerV2
	category:"mode_archi"
	toolTip:"WD2"
(
	local isExecuting = false
	
	tool windowDesignerV2
	(
		local clickedFace
		local normalMatrix
		local Point_1
		local Point_2
		local Point_3
		local Point_4
		local snapgrid
		local faceNormal
		local vector1_3
		local edgeDirection
		local localTransform
		
		local isMesh = false
		local backGrid
		local backSnapActive
		local backSnapPreviewRadius
		local backSnapRadius
		local backSnapType = #3D
		local backSnapOptions

		fn removeGrid = 
		(
			if(snapgrid != undefined AND (isDeleted snapgrid) == false) then
			(
				--save values		
				activegrid = backGrid
				delete snapgrid
				snapMode.active = backSnapActive
				snapMode.snapPreviewRadius = backSnapPreviewRadius
				snapMode.snapRadius = backSnapRadius
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
		)
		
		fn addGrid gridPosition gridMatrix =
		(
			snapgrid = grid length:1000 width:1000 grid:50 position:gridPosition transform:gridMatrix
			activegrid = snapgrid
			--activer le snap
			snapMode.active = true
			snapMode.snapPreviewRadius = 5
			snapMode.snapRadius = 5
			snapMode.type = #3D
			--enlever toutes les options
			for i = 1 to snapmode.numOSnaps do
			( 
				for j = 1 to (snapmode.getOSnapNumItems i) do
					snapmode.setOSnapItemActive i j false
			)
			--activer le snap aux points de la grille
			snapMode.setOSnapItemActive 3 2 true
		)
		
		fn goBackdraftTemp = 
		(
			if(isMesh == true) then
			(
				--remove edit mesh
				deleteModifier $ meshModifier
			)
			removeGrid()
			max undo
		)
		
		--function to end the tool
		fn goBackdraft =
		(
			goBackdraftTemp()
			isExecuting = false
			#stop
		)
		
		fn resetTool =
		(
			baseSelectedFaces = polyop.getFaceSelection $
			for i = 1 to baseSelectedFaces.count do
			(
				baseSelectedFaces[i] = false
			)
			polyop.setFaceSelection $ baseSelectedFaces
			clickedFace = undefined
			normalMatrix = undefined
			Point_1 = undefined
			Point_3 = undefined
			yAsset = 0
			zAsset = 0
			
		)
		
		fn meshFaceToPoly poly mesh_face =
		(
			face_verts = meshop.getVertsUsingFace poly.mesh mesh_face
			vert_faces = for item in face_verts collect (polyOp.getFacesUsingVert poly item)
			result = (vert_faces[1] * vert_faces[2] * vert_faces[3]) as array
			result[1]
		)
				
		fn drawWindows = 
		(
			local oldPoint1 = 0
			local oldPoint2 = 0
			local oldPoint3 = 0
			local oldPoint4 = 0
			
			normalMatrix = MatrixFromNormal (faceNormal)
			
			local edgeList = polyop.getFaceEdges $ clickedFace
			local maxZ = -9999
			local topEdge
			for i = 1 to (edgeList as array).count do
				(
					tabVert = polyop.getEdgeVerts $ (edgeList as array)[i]
					if((polyop.getVert $ (tabVert as array)[2]).z < (polyop.getVert $ (tabVert as array)[1]).z) then
					(
						vertSel = (polyop.getVert $ (tabVert as array)[2]).z
					)
					else
					(
						vertSel = (polyop.getVert $ (tabVert as array)[1]).z
					)
					if(vertSel > maxZ) then
					(
						maxZ = vertSel
						topEdge = (edgeList as array)[i]
					)
				)
				--topEdgeArray = #()
				--topEdgeArray[1] = (topEdge)
				--polyop.setEdgeSelection $ (topEdgeArray)
				
			tabVert = polyop.getEdgeVerts $ topEdge
			if((polyop.getVert $ (tabVert as array)[2]).x < (polyop.getVert $ (tabVert as array)[1]).x) then
			(
				edgeDirection = (polyop.getVert $ (tabVert as array)[2]) - (polyop.getVert $ (tabVert as array)[1])
			)
			else
			(
				edgeDirection = (polyop.getVert $ (tabVert as array)[1]) - (polyop.getVert $ (tabVert as array)[2])
			)
			vector1_3 = Point_3-Point_1
			
			--worldPoint2 = in coordsys $ Point_1+[1,0,0]
			--worldPoint4 = in coordsys $ Point_1+[0,0,-1]
			
			worldPoint1 = Point_1
			worldPoint3 = Point_3
			distance1_2 = (dot vector1_3 (normalize edgeDirection)) 
			worldPoint2 = Point_1 + (normalize edgeDirection)*distance1_2
			worldPoint4 = Point_3 + (normalize edgeDirection)*-distance1_2
			polyop.createVert $ worldPoint1
			polyop.createVert $ worldPoint2
			polyop.createVert $ worldPoint3
			polyop.createVert $ worldPoint4
			local oldPoint1 = 0
			local oldPoint2 = 0
			local oldPoint3 = 0
			local oldPoint4 = 0
				
			local vertexList = polyop.getVertsUsingFace $ clickedFace
			--new Top Left point
			newPoint1 = polyop.createVert $ worldPoint1
			--old Top Left point
			minDistance = 15000
			for i = 1 to (vertexList as array).count do
			(
				print ((vertexList as array)[i])
				if (distance (polyop.getVert $ newPoint1) (polyop.getVert $ (vertexList as array)[i])< minDistance) then
				(
					minDistance = distance (polyop.getVert $ newPoint1) (polyop.getVert $ (vertexList as array)[i])
					oldPoint1 = (vertexList as array)[i]
				)
			)
			vertexList = deleteItem vertexList oldPoint1
			--new Top Right point
			newPoint2 = polyop.createVert $ worldPoint2
			--old Top Right point
			minDistance = 15000
			print "-----"
			for i = 1 to (vertexList as array).count do
			(
				print ((vertexList as array)[i])
				if (distance (polyop.getVert $ newPoint2) (polyop.getVert $ (vertexList as array)[i])< minDistance) then
				(
					minDistance = distance (polyop.getVert $ newPoint2) (polyop.getVert $ (vertexList as array)[i])
					oldPoint2 = (vertexList as array)[i]
				)
			)
			vertexList = deleteItem vertexList oldPoint2
			--new Bottom Right point
			newPoint3 = polyop.createVert $ worldPoint3
			--old Bottom Right point
			minDistance = 15000
			for i = 1 to (vertexList as array).count do
			(
				if (distance (polyop.getVert $ newPoint3) (polyop.getVert $ (vertexList as array)[i])< minDistance) then
				(
					minDistance = distance (polyop.getVert $ newPoint3) (polyop.getVert $ (vertexList as array)[i])
					oldPoint3 = (vertexList as array)[i]
				)
			)
			vertexList = deleteItem vertexList oldPoint3
			--new Bottom Left point
			newPoint4 = polyop.createVert $ worldPoint4
			--old Bottom Left point
			minDistance = 15000
			for i = 1 to (vertexList as array).count do
			(
				if (distance (polyop.getVert $ newPoint4) (polyop.getVert $ (vertexList as array)[i])< minDistance) then
				(
					minDistance = distance (polyop.getVert $ newPoint4) (polyop.getVert $ (vertexList as array)[i])
					oldPoint4 = (vertexList as array)[i]
				)
			)
			vertexList = deleteItem vertexList oldPoint4
			
			--delete the face				
			oldMaterialId = polyop.getFaceMatID $ clickedFace
			polyop.deleteFaces $ clickedFace delIsoVerts:false
			
			--create geometry
			newFace = polyop.createPolygon $ (#(oldPoint1,newPoint1,newPoint4,oldPoint4))
			polyop.setFaceMatID $ (#(newFace)) oldMaterialId
			newFace = polyop.createPolygon $ (#(oldPoint1,oldPoint2,newPoint2,newPoint1))
			polyop.setFaceMatID $ (#(newFace)) oldMaterialId
			newFace = polyop.createPolygon $ (#(oldPoint2,oldPoint3,newPoint3,newPoint2))
			polyop.setFaceMatID $ (#(newFace)) oldMaterialId
			newFace = polyop.createPolygon $ (#(oldPoint3,oldPoint4,newPoint4,newPoint3))
			polyop.setFaceMatID $ (#(newFace)) oldMaterialId
			newFace = polyop.createPolygon $ (#(newPoint1,newPoint2,newPoint3,newPoint4))
			polyop.setFaceMatID $ (#(newFace)) oldMaterialId
			polyop.extrudeFaces $ (#(newFace)) -25
			polyop.deleteFaces $ #(newFace) delIsoVerts:false
				
			print "ok"
		)
		
		--click (clickno=nombre de click), release est un click (d'ou le stop)
		on mousePoint clickno do
		(
			if $ != undefined then
			(
				--on click
				if clickno >1 then
				(	
					--convert poly to mesh
					isMesh = true
					meshModifier = Edit_Mesh ()
					modPanel.addModToSelection (meshModifier) ui:off
					--Ray form clicked point to far away in the view
					myRay = mapScreenToWorldRay viewPoint
					arr = intersectRayEx $ myRay
					--if a face is clicked
					if(arr != undefined) then
					(
						--get poly face
						if(snapgrid != undefined AND isDeleted snapgrid == false) then
						(
							clickedPoint = gridPoint*snapGrid.transform
						)
						else
						(
							clickedPoint = arr[1].pos
						)
						clickedFaceTri = arr[2]
						faceNormal = getFaceNormal $ clickedFaceTri
						
						--remove edit mesh
						deleteModifier $ meshModifier
						isMesh = false
						
						--get the poly from the mesh face
						polySelected = meshFaceToPoly $ clickedFaceTri
													
						--if this is the first point on this face show error
						if polySelected != clickedFace then
						(	
							if clickedFace != undefined then
							(
								MessageBox "Clique dans la meme face, pour finir la fenetre"
							)
							else
							(
								Point_1 = clickedPoint
								clickedFace = polySelected
								removeGrid()
								addGrid clickedPoint (MatrixFromNormal (faceNormal))
							)
						)
						--if this is not the first point, draw all windows
						else
						(
							--get the twice clicked face
							removeGrid()
							
							Point_3 = clickedPoint
							drawWindows()
							goBackdraftTemp()
							resetTool()
						)
					)
					else
					(
						MessageBox "Clique dans une face, c'est mieux..."
						--remove edit mesh
						deleteModifier $ 1
						isMesh = false
						
					)
				)
				else
				(
					--init
					baseSelectedFaces = polyop.getFaceSelection $
					for i = 1 to baseSelectedFaces.count do
					(
						baseSelectedFaces[i] = false
					)
					polyop.setFaceSelection $ baseSelectedFaces
					--save old settings values
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
				)
			)
			else
			(
				MessageBox "Selectionne un objet d'abord, sinon, ça ne risque pas de marcher, hippie..."
				goBackdraft()
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
			continueTool = starttool windowDesignerV2
		)
	)
	
	on isChecked return (isExecuting == true)
)
