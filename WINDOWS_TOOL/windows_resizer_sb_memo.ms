(
	local res = #()
	local copyRef
	
	-- copy ref 
	maxOps.cloneNodes refSelAr[j] cloneType: #copy newNodes:&copyRef

	-- placement sur layer
	if layerRB.state == 1 then()
	else if layerRB.state == 2 then for c in copyRef do s.layer.addnode c
	else()
	
	-- unhide de la copy
	if copyRef == undefined then()
	else if copyRef.count > 0 then for o in copyRef do o.ishidden = false
	else()
	
	-- convertoPoly
	for o in copyRef where not iskindof s editable_poly do converttopoly o

	-- trouver la tete de hierarcchie de la copy
	local copyHead = findHeadsOfHierarchy2 copyRef
		
	-- resize
	if copyHead.count == 1 then 
	(			
		
		copyHead[1].rotation = s.rotation
		copyHead[1].center = s.center
		
		-- relever la taille du gabarit
		local bb = nodeGetBoundingBox  s s.transform
		local gabaritSize = point3 (distance (point3 bb[1].x 0 0) (point3 bb[2].x 0 0 )) (distance (point3 0 bb[1].y 0) (point3 0 bb[2].y 0 )) (distance (point3 0 0 bb[1].z) (point3 0 0 bb[2].z))
		
		-- determiner les valeurs maximales et minimales en x,y,z des  vertex par rapport au ref
		xmax = -1000
		xmin = 1000
		ymax = -1000
		ymin = 1000
		zmax = -1000
		zmin = 1000	
		
		for o in copyRef do
		(
			onebb = (nodeGetBoundingBox o copyHead[1].transform)
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
		zMaxRange = -15
		zMinRange = 18
		yMaxRange = -15
		yMinRange = 15
		xMaxRange = -15
		xMinRange = 5
			
								
		-- deplacement des vertex et des pivots
-- 								for s in fenSelAr do
		for o in copyRef where not iskindof o dummy do
		(
			format "========= %\n" o.name
			
			numVert = o.GetNumVertices () 
			wireTmp = color (random 1 255) (random 1 255) (random 1 255)
			
-- 			test et décalage du pivot si necessaire
			pvtPos = in coordsys copyHead[1] o.pivot
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
			
			if movePivot then o.pivot = (transMatrix([pvtPosXShift,pvtPosYShift,pvtPosZShift]) * o.transform).translation
			
						
			-- test et deplacement de chaque vertex
			for i = 1 to numVert do
			(
				vPos = ((polyop.getvert o  i) * inverse copyHead[1].transform)
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
				if moveVertex then polyop.setvert o #{i} ((vPos + [vPosXShift, vPosYShift, vPosZShift])*copyHead[1].transform)
			)
		)		
	)							
)