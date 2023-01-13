/*
maj:
faire varier un gabarit (box filaire) avant de faire un resize sur le gabarit pour accéléere le script (pas necessaire)
-- créer une box filire pour materialiser le range de selection des points

debug:
retrancher la valeur précédente du spinner
*/


fn resetOuvrantPivot =
(
	sel = selection as array
	for s in sel do
	(
		try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
		if iskindof res booleanClass then
		(
			
			if res then
			(
				bbVal = nodeGetBoundingBox s s.transform
				s.pivot = ( transMatrix(point3 (bbVal[2].x) (bbVal[2].y) 0) * s.transform).translation
			)
			else if not res then
			(
				bbVal = nodeGetBoundingBox s s.transform
				s.pivot = ( transMatrix(point3 (bbVal[2].x) (bbVal[1].y) 0) * s.transform).translation
			)
		)
	)
	format "Pivots des ouvrants recalés\n"
)

-- resetWindowsPivot()

try(destroydialog windowsResizerRLT)catch()
rollout windowsResizerRLT "windows resizer live"
(
	local bakVal
	local val
	local sel
	local grouphead
	local oneVertBit
	local verBitAr
	local vmax
	local xMaxRange
	local xmax, xmin, ymax, ymin, zmax, zmin 	
	
	local head
	local copyHead
	
	group "vertices selection range:"
	(
		spinner xMaxRangeSP "xMaxRange:" range: [ -100, 100, -15 ] type: #worldunits across: 2
		spinner xMinRangeSP "xMinRange:" range: [ -100, 100, 5 ] type: #worldunits
		spinner yMaxRangeSP "yMaxRange:" range: [ -100, 100, -15 ] type: #worldunits across: 2
		spinner yMinRangeSP "yMinRange:" range: [ -100, 100, 15 ] type: #worldunits
		spinner zMaxRangeSP "zMaxRange:" range: [ -100, 100, -30 ] type: #worldunits across: 2
		spinner zMinRangeSP "zMinRange:" range: [ -100, 100, 18 ] type: #worldunits
	)
	
	group "live resizing:"
	(
		spinner moreXSP "+X" range:[-20,20,0] 	type: #worldunits across: 2
		spinner lessXSP "-X" range:[-20,20,0] 	type: #worldunits
		spinner moreYSP "+Y" range:[-20,20,0] 	type: #worldunits across: 2
		spinner lessYSP "-Y" range:[-20,20,0]	type: #worldunits
		spinner moreZSP "+Z" range:[-20,20,0] 	type: #worldunits across: 2
		spinner lessZSP "-Z" range:[-20,20,0]	type: #worldunits
	)
	
	group "resizing on gabaring:"
	(
		button selObjBT "sel"
		edittext objNameET "" readonly: true
		button ResizeBT "Resizing"
	)
	
	
	
	-- UI dependent function
	fn findGroupHead sel = 
	(
		for i = sel.count to 1 by -1 do
		(
			if isgrouphead sel[i]  then
			(
				grouphead = sel[i]
				head = sel[i]
				deleteItem sel i
				exit
			)
			else()
		)	
		if not isvalidNode grouphead then return (format "no groupHead\n")
	)
	
	fn findVerBitArMax p3val vMaxRange =
	(
-- 		p3val = 2
		vmax = -1000
		for s in sel do
		(
			onebb = (nodeGetBoundingBox s grouphead.transform)
			if onebb[1][p3val] > vmax then vmax =  onebb[1][p3val]
			if onebb[2][p3val] > vmax then vmax =  onebb[2][p3val]
		)
		vmax		

		verBitAr = #()
		
		for s in sel where not iskindof s dummy do
		(
			-- 
			numVert = s.GetNumVertices()
			oneVertBit = #{}
			
			-- test et deplacement de chaque vertex
			for i = 1 to numVert do
			(
				-- calcul de la position d'un vertex
				vPos = ((polyop.getvert s  i) * inverse groupHead.transform)
				
				-- determiner s'il doit y avoir un saut du vertex sur l'axe y
				if (vPos[p3val] >= vmax + vMaxRange) then append oneVertBit i
				else()
			)
			append verBitAr oneVertBit
		)
		format "format vmax: % verBitAr: %\n" vmax verBitAr
		verBitAr
	)
	
	fn findVerBitArMin p3val vMinRange =
	(
-- 		p3val = 2
		vmin = 1000
		for s in sel do
		(
			onebb = (nodeGetBoundingBox s grouphead.transform)
			if onebb[1][p3val] < vmin then vmin =  onebb[1][p3val]
			if onebb[2][p3val] < vmin then vmin =  onebb[2][p3val]
		)
		vmin		

		verBitAr = #()
		
		for s in sel where not iskindof s dummy do
		(
			-- 
			numVert = s.GetNumVertices()
			oneVertBit = #{}
			
			-- test et deplacement de chaque vertex
			for i = 1 to numVert do
			(
				-- calcul de la position d'un vertex
				vPos = ((polyop.getvert s  i) * inverse groupHead.transform)
				
				-- determiner s'il doit y avoir un saut du vertex sur l'axe y
				if (vPos[p3val] <= vmin + vMinRange) then append oneVertBit i
				else()
			)
			append verBitAr oneVertBit
		)
		format "vmin: % verBitAr: %\n"  vmin verBitAr
		verBitAr
	)
	
	fn moveVertAr p3val val =
	(
		for i = 1 to sel.count do
		(
			vertPosList = #()

			for vxid in verBitAr[i] do 
			(
				vPos = ((polyop.getvert sel[i] vxid) * inverse groupHead.transform)
				vPosShift = point3 0 0 0
				vPosShift[p3val] = val-bakval
				append vertPosList ((vPos + vPosShift)*grouphead.transform)
			)
			polyop.setvert sel[i] verBitAr[i] vertPosList
		)
	)
	
		
	fn refreshUI =
	(
		if isvalidnode head then objNameET.text = head.name else objNameET.text = "[NONE]"
	)
	
	-- ACTIONS	
	on windowsResizerRLT open do
	(
		refreshUI()
	)
	

	
	/* +X */
	on moreXSP buttondown do
	(
		bakval = 0

		-- trouver grouphead
		sel = selection as array
		findGroupHead sel
		
		findVerBitArMax 1 xMaxRangeSP.value
	)
	
	on moreXSP changed val do
	(
		moveVertAr 1 val 
		
		redrawViews()
		bakval = val
		
	)
	
	on moreXSP buttonup do
	(
		moreXSP.value = 0.0
		resetOuvrantPivot ()
	) 
	
	/* -X */
	on lessXSP buttondown do
	(
		bakval = 0

		-- trouver grouphead
		sel = selection as array
		findGroupHead sel
		
		findVerBitArMin 1 xMinRangeSP.value
	)
	
	on lessXSP changed val do
	(
		moveVertAr 1 val 
		
		redrawViews()
		bakval = val
	)
	
	on lessXSP buttonup do
	(
		lessXSP.value = 0.0
		resetOuvrantPivot ()
	)
	
	/* +Y */
	on moreYSP buttondown do
	(
		bakval = 0

		-- trouver grouphead
		sel = selection as array
		findGroupHead sel
		
		findVerBitArMax 2 yMaxRangeSP.value
	)
	
	on moreYSP changed val do
	(	
		moveVertAr 2 val 
		redrawViews()
		bakval = val
	)
	
	on moreYSP buttonup do
	(
		
		moreYSP.value = 0
		resetOuvrantPivot ()
	)
	
	/* -Y */
	on lessYSP buttondown do
	(
		bakval = 0

		-- trouver grouphead
		sel = selection as array
		findGroupHead sel
		
		findVerBitArMin 2 yMinRangeSP.value
	)
	
	on lessYSP changed val do
	(
		moveVertAr 2 val 
		
		redrawViews()
		bakval = val
	)
	
	on lessYSP buttonup do
	(
		lessYSP.value = 0
		resetOuvrantPivot ()
	)
	
	/* +Z */
	on moreZSP buttondown do
	(
		bakval = 0

		-- trouver grouphead
		sel = selection as array
		findGroupHead sel
		
		findVerBitArMax 3 zMaxRangeSP.value
	)
	
	on moreZSP changed val do
	(
		moveVertAr 3 val 
		
		redrawViews()
		bakval = val
	)
	
	on moreZSP buttonup do
	(
		moreZSP.value = 0
		resetOuvrantPivot ()
	)
	
	/* -Z */
	on lessZSP buttondown do
	(
		bakval = 0

		-- trouver grouphead
		sel = selection as array
		findGroupHead sel
		
		findVerBitArMin 3 zMinRangeSP.value
	)
	
	on lessZSP changed val do
	(
		undo on
		(
			moveVertAr 3 val 
					
			bakval = val
		)
		redrawViews()
	)
	
	on lessZSP buttonup do
	(
		lessZSP.value = 0
		resetOuvrantPivot ()
		
	)
	
	-- resize on gabarits
	on selObjBT pressed do
	(
		sel = selection as array
		findGroupHead sel
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
CreateDialog windowsResizerRLT width: 300


