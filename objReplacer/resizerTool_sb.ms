/*
maj:
- rendre la selection des points interactive 

*/


try(destroydialog resizerToolRLT )catch()
rollout resizerToolRLT "Resizer Tool"
(
	local head
	local copyHead
	
	group "object to resize:"
	(
		button selObjBT "sel"
		edittext objNameET "" readonly: true
	)
	
	group "range:"
	(
		spinner zMaxRangeSP "zMaxRange:" range: [ -100, 100, -30 ] type: #worldunits
		spinner zMinRangeSP "zMinRange:" range: [ -100, 100, 18 ] type: #worldunits
		spinner yMaxRangeSP "yMaxRange:" range: [ -100, 100, -15 ] type: #worldunits
		spinner yMinRangeSP "yMinRange:" range: [ -100, 100, 15 ] type: #worldunits
		spinner xMaxRangeSP "xMaxRange:" range: [ -100, 100, -15 ] type: #worldunits
		spinner xMinRangeSP "xMinRange:" range: [ -100, 100, 5 ] type: #worldunits
	)
	
	button ResizeBT "Resize"
	
	fn refreshUI =
	(
		if isvalidnode head then objNameET.text = head.name else objNameET.text = "[NONE]"
	)
	
	on resizerToolRLT open do
	(
		refreshUI ()
	)
	
	on selObjBT pressed do
	(
		sel = selection as array
-- 		head = findHeadsOfHierarchy2 sel
		
		for s in sel where isgrouphead s do 
		(
			head = s
			format "head: %\n" head.name
			exit
		)
		
		refreshUI ()
	)
	
	on ResizeBT pressed do
	(
		if not isvalidnode head then(format "selectionnez un objet à resizer.\n")
		else
		(
			sel = selection as array
			if sel.count == 0 then (format "selectionnez des gabarits sur lequel redimensionner.\n")
			else
			(
				for s in sel do
				(
					
					local res = #()
					local copyRef
					
					-- copy ref 
					maxOps.cloneNodes head cloneType: #copy newNodes:&copyRef

					-- placement sur layer
					for c in copyRef do s.layer.addnode c
					
					-- unhide de la copy
					for o in copyRef do o.ishidden = false
					
					-- convertoPoly
					for o in copyRef do converttopoly o
						
					-- trouver la tete de copy
					for c in copyRef where isgrouphead c do 
					(
						copyHead = c
						format "copyhead: %\n" copyHead.name
						exit
					)
					
					-- resize
					if not isvalidnode copyHead then (format "abort\n")
					else
					(
						copyHead.rotation = s.rotation
						copyHead.center = s.center
				
						-- relever la taille du gabarit
						local bb = nodeGetBoundingBox  s s.transform
						local gabaritSize = point3 (distance (point3 bb[1].x 0 0) (point3 bb[2].x 0 0 )) (distance (point3 0 bb[1].y 0) (point3 0 bb[2].y 0 )) (distance (point3 0 0 bb[1].z) (point3 0 0 bb[2].z))
						
						-- determiner les valeurs maximales et minimales en z et y des  vertex par rapport au ref
						xmax = -1000
						xmin = 1000
						ymax = -1000
						ymin = 1000
						zmax = -1000
						zmin = 1000	
						
						for o in copyRef do
						(
							onebb = (nodeGetBoundingBox o copyHead.transform)
							if onebb[1].x > xmax then xmax =  onebb[1].x
							if onebb[2].x > xmax then xmax =  onebb[2].x
							if onebb[1].x < xmin then xmin =  onebb[1].x
							if onebb[2].x < xmin then xmin =  onebb[2].x
							
							if onebb[1].y > ymax then ymax =  onebb[1].y
							if onebb[2].y > ymax then ymax =  onebb[2].y
							if onebb[1].y < ymin then ymin =  onebb[1].y
							if onebb[2].y < ymin then ymin =  onebb[2].y
								
							if onebb[1].z > zmax then zmax =  onebb[1].z
							if onebb[2].z > zmax then zmax =  onebb[2].z
							if onebb[1].z < zmin then zmin =  onebb[1].z
							if onebb[2].z < zmin then zmin =  onebb[2].z
						)	
						
						-- relever la taille de la fentres
						fenetreSize = point3 (distance (point3 xmin 0 0) (point3 xmax 0 0 )) (distance (point3 0 ymin 0) (point3 0 ymax 0 )) (distance (point3 0 0 zmin) (point3 0 0 zmax))

						-- calculer le decalage entre la fenetre et le gabarit
						theShift =  gabaritSize - fenetreSize
						
						format "theShift: %\n" theShift
						-- valeur de decalage arbitraire
						zMaxMove = theShift.z * 0.5
						zMinMove = theShift.z * -0.5
						yMaxMove = theShift.y  * 0.5
						yMinMove = theShift.y * -0.5
						xMaxMove = theShift.x  * 0.5
						xMinMove = theShift.x * -0.5
							

						-- plage de selection des vertex
						zMaxRange = zMaxRangeSP.value
						zMinRange = zMinRangeSP.value
						yMaxRange = yMaxRangeSP.value
						yMinRange = yMinRangeSP.value
						xMaxRange = xMaxRangeSP.value
						xMinRange = xMinRangeSP.value
							
												
						-- deplacement des vertex et des pivots
-- 								for s in fenSelAr do
						for o in copyRef where not iskindof o dummy do
						(
							format "========= %\n" o.name
							
							numVert = o.GetNumVertices () 
							wireTmp = color (random 1 255) (random 1 255) (random 1 255)
							
				-- 			test et décalage du pivot si necessaire
							pvtPos = in coordsys copyHead o.pivot
							pvtPosXShift = 0
							pvtPosYShift = 0
							pvtPosZShift = 0
							movePivot = false
								
							if pvtPos.x >= xmax + xMaxRange then
							(
								format "yMaxMove: %\n" pvtPos
								movePivot = true
								pvtPosXShift = xMaxMove
							)
							else if pvtPos.x <= xmin + xMinRange then
							(
								format "yMinMove: %\n" pvtPos
								movePivot = true
								pvtPosXShift = xMinMove
							)
							else() 
							
							if pvtPos.y >= ymax + yMaxRange then
							(
								format "yMaxMove: %\n" pvtPos
								movePivot = true
								pvtPosYShift = yMaxMove
							)
							else if pvtPos.y <= ymin + yMinRange then
							(
								format "yMinMove: %\n" pvtPos
								movePivot = true
								pvtPosYShift = yMinMove
							)
							else()
							
							if pvtPos.z >= zmax + zMaxRange then
							(
								format "zMaxMove: %\n" pvtPos
							)
							else if pvtPos.z <= zmin + zMinRange then
							(
								format "zMinMove: %\n" pvtPos
							)
							else()
							
							if movePivot then o.pivot = ( transMatrix(point3 pvtPosXShift pvtPosYShift pvtPosZShift) * o.transform).translation
							
										
							-- test et deplacement de chaque vertex
							for i = 1 to numVert do
							(
								vPos = ((polyop.getvert o  i) * inverse copyHead.transform)
								vPosXShift = 0
								vPosYShift = 0
								vPosZShift = 0
								moveVertex = false
								
								-- determiner s'il doit y avoir un saut du vertex sur l'axe z
								if vPos.z >= zmax + zMaxRange then
								(
									moveVertex = true
									vPosZShift = zMaxMove
								)
								else if  vPos.z <= zmin + zMinRange then
								(
									moveVertex = true
									vPosZShift = zMinMove
								)
								else()
								
								-- determiner s'il doit y avoir un saut du vertex sur l'axe y
								if vPos.y >= ymax + yMaxRange then
								(
									moveVertex = true
									vPosYShift = yMaxMove
								)
								else if  vPos.y <= ymin + yMinRange then
								(
									moveVertex = true
									vPosYShift = yMinMove
								)
								else()
								
								-- determiner s'il doit y avoir un saut du vertex sur l'axe x
								if vPos.x >= xmax + xMaxRange then
								(
									moveVertex = true
									vPosXShift = xMaxMove
								)
								else if  vPos.x <= xmin + xMinRange then
								(
									moveVertex = true
									vPosXShift = xMinMove
								)
								else()
								
								-- deplacement du vertex si nécessaire
								if moveVertex then polyop.setvert o #{i} ((vPos + [vPosXShift, vPosYShift, vPosZShift])*copyHead.transform)
							)
						)		
					)
				)
			)
		)
		
	)
)
createdialog resizerToolRLT