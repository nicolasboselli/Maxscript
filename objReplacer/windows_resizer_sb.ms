
/*
memo:
	le getvert de l'edit poly est relatif au toolmode.coordsys: toolMode.coordsys #local

*/
-- créer un script qui déplace les points des fenetres en haut et en bas et sur les côtés pour les caler à un gabarit

-- attraper le modifier edit poly
-- for s in (selection as array) do format "% %\n" s.name s.modifiers

-- collecte de la position de chaque objet par rapport au parent

fn memo=
(
	for s in sel do
	(
		format "s: % pos:%\n" s.name (in coordsys parent s.position)
		format "s: % pos2:%\n" s.name (s.transform * inverse s.parent.transform).position
	)

	-- transforme la position absolu du vertex en position relative par rapport au transform
	point transform: transMatrix((polyop.getvert $  1) * inverse $.transform) --node: $

	-- transform la position relative du vertex par rapport au transform en matrix absolu
	point transform:(transMatrix($.GetVertex 1) * $.transform)--node: $

	-- pour travailler dans le bon systeme de coordonné avec un edit poly il faut le changer avant le in ccordsys ne fonctionne pas
	bakMode = getRefCoordSys()
	toolMode.coordsys #local
	$.edit_poly.GetVertex 1 node: $
	toolMode.coordSys bakMode

	-- selon l'ordre dans la multiplication des matrice le resultat n'est pas le même
	$b3.transform = $b1.transform*$b2.transform

	-- créer un modifier edit_poly sur la selection
	ep = edit_poly name: "resizer_ep"
	for s in selection where not iskindof s dummy do addModifier s ep
)

try(destroydialog adjustToGabaritRLT)catch()
rollout adjustToGabaritRLT "adjust to gabarit"
(
	local sel = #()
	local gabarit
	local fenSelAr = #()
	
	button selFenBT "select fenetre"
	edittext fenET "fenetre:" readonly: true
-- 	button selRefBT "select ref"
-- 	edittext refET "ref:" readonly: true
	button adjustBT "adjust"
	
	
	on selFenBT pressed do
	(
		
		fenSelAr = #()
		sel = selection as array
		
		for s in sel do
		(
			if isvalidnode s then
			(
-- 				append sel s
				if not isGroupMember s or isGroupHead s then
				(
					ref = s
				)
				
				if not iskindof s dummy then append fenSelAr s
			)
		)
		
		fenET.text =ref.name
	)
		
	on adjustBT pressed do
	(
		for s in fenSelAr where not iskindof s editable_poly do 
		(
			format "converttopoly: %\n" s.name
			converttopoly s
		)
		-- relever la taille du gabarit
		gabarits = selection as array
		if gabarits.count != 1 then exit
		bb = nodeGetBoundingBox  gabarits[1] gabarits[1].transform
		gabaritSize = point3 (distance (point3 bb[1].x 0 0) (point3 bb[2].x 0 0 )) (distance (point3 0 bb[1].y 0) (point3 0 bb[2].y 0 )) (distance (point3 0 0 bb[1].z) (point3 0 0 bb[2].z))
		format "gabaritSize: %\n" gabaritSize
			
		ref.rotation = gabarits[1].rotation
		ref.center = gabarits[1].center
			
		-- determiner les valeurs maximales et minimales en z et y des  vertex par rapport au ref
		xmax = -1000
		xmin = 1000
		ymax = -1000
		ymin = 1000
		zmax = -1000
		zmin = 1000

		for s in fenSelAr do
		(
-- 			format "%\n" (nodeGetBoundingBox s ref.transform)
			onebb = (nodeGetBoundingBox s ref.transform)
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
		format "fenetreSize: %\n" fenetreSize


		-- calculer le decalage entre la fenetre et le gabarit
		theShift =  gabaritSize - fenetreSize

		-- valeur de decalage arbitraire
		zMaxMove = theShift.z * 0.5
		zMinMove = theShift.z * -0.5
		yMaxMove = theShift.y  * 0.5
		yMinMove = theShift.y * -0.5		

		-- plage de selection des vertex
		zMaxRange = -15
		zMinRange = 15
		yMaxRange = -15
		yMinRange = 15

		-- collecter les coordonnée de chaque vertex 
		for s in fenSelAr do
		(
			format "========= %\n" s.name
			
			numVert = s.GetNumVertices () 
			wireTmp = color (random 1 255) (random 1 255) (random 1 255)
			
-- 			test et décalage du pivot si necessaire
			pvtPos = in coordsys ref s.pivot
			pvtPosXShift = 0
			pvtPosYShift = 0
			pvtPosZShift = 0
			movePivot = false
				
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
			
			if movePivot then s.pivot = (transMatrix([pvtPosXShift,pvtPosYShift,pvtPosZShift]) * s.transform).translation
			
						
			-- test et deplacement de chaque vertex
			for i = 1 to numVert do
			(
				vPos = ((polyop.getvert s  i) * inverse ref.transform)
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
				
				-- deplacement du vertex si nécessaire
				if moveVertex then polyop.setvert s #{i} ((vPos + [vPosXShift, vPosYShift, vPosZShift])*ref.transform)
			)
		)		
	)
)
createdialog adjustToGabaritRLT width: 300

-- calculer la position globale d'un vertex déplacer en z dans son referenteil local

-- selectionner tous les vertex qui se trouve dans la zone de selection
-- calculer le decalage entre le gabarit et la position maximale du vertex
-- deplacer les vertex-- point transform: (inverse($.transform))

/*
$.getvertex  1
$.setvertex 1 ([50,50,50])

(polyop.getvert $ 3) * ( inverse $.transform)
polyop.moveVert $ #{1} ([0,0,50])
polyop.setvert $ #{1} ([50,50,50])	
*/