
/*
memo:
	le getvert de l'edit poly est relatif au toolmode.coordsys: toolMode.coordsys #local

*/
-- créer un script qui déplace les points des fenetres en haut et en bas et sur les côtés pour les caler à un gabarit

-- attraper le modifier edit poly
-- for s in (selection as array) do format "% %\n" s.name s.modifiers

-- collecte de la position de chaque objet par rapport au parent

fn ignore=
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

-- collecte des elements d'une fenetre en excluant le dummy du groupe
sel = #()
ref
for s in selection do
(
	if iskindof s dummy then
	(
		ref = s
	)
	else
	(
		converttopoly s
		append sel s
	)
)	


-- determiner les valeurs maximales et minimales en z et y des des vertex par rapport au ref
xmax = -1000
xmin = 1000
ymax = -1000
ymin = 1000
zmax = -1000
zmin = 1000

for s in sel do
(
	format "%\n" (nodeGetBoundingBox s ref.transform)
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

xmax 
xmin
ymax 
ymin 
zmax 
zmin 

-- plage de selection des vertex
zMaxRange = -15
zMinRange = 15
yMaxRange = -15
yMinRange = 15


-- calculer le decalage avec le gabarit
-- comparer les dimension de la bounding box de l'objet selectionné et du gabarit et diviser par deux
zMaxMove = -150
zMinMove = -20
yMaxMove = 50
yMinMove = -20

-- collecter les coordonnée de chaque vertex 
for s in sel do
(
	format "========= %\n" s.name
	
-- 	sToParentTM = s.transform * inverse ref.transform
-- 	format "sToParentTM: %\n" sToParentTM
	
-- 	format "s: % numVertices: %\n" s.name (s.resizer_ep.GetNumVertices node: s)
-- 	numVert = s.resizer_ep.GetNumVertices node: s
	numVert = s.GetNumVertices () 
	wireTmp = color (random 1 255) (random 1 255) (random 1 255)
		
	for i = 1 to numVert do
	(
-- 		VertToSTM = transMatrix(s.resizer_ep.GetVertex i node: s)
-- 		VertToSTM = transMatrix(s.GetVertex i )
		
-- 		VertToParentTM = sToParentTM*VertToSTM
		
	-- 	format "parentVertPos: % vert1pos: %\n" parentVertPos  VertPos
		
-- 		point name: (s.name + "_" +(i as string)) transform: (transMatrix((polyop.getvert s  i) * inverse ref.transform)) wirecolor: wireTmp
-- 		format "s: % vert: % transform: %\n" s.name i ((polyop.getvert s  i) * inverse ref.transform)
		vPos = ((polyop.getvert s  i) * inverse ref.transform)
		
		-- selectionne le vertex qui se trouve dans la zone de selection
		if vPos.z >= zmax + zMaxRange then
		(
-- 			point name: (s.name + "_" +(i as string)) transform: (transMatrix((polyop.getvert s  i) * inverse ref.transform)) wirecolor: blue
			format "zMaxMove: % s.name: % vert: % vPos: %\n" zMaxMove s.name i vPos 
			format "\tpolyop.setVert % #{%} %\n" s i ((vPos + [0,0,zMaxMove])*ref.transform)
			polyop.setvert s #{i} ((vPos + [0,0,zMaxMove])*ref.transform)
-- 			polyop.moveVert  s #{i} ([0,0,zMaxMove])
		)
		else if  vPos.z <= zmin + zMinRange then
		(
-- 			point name: (s.name + "_" +(i as string)) transform: (transMatrix((polyop.getvert s  i) * inverse ref.transform)) wirecolor: red
			format "zMinMove: % s.name: % vert: % vPos: % \n" zMinMove s.name i vPos 
			format "\tpolyop.setVert % #{%} %\n" s i ((vPos + [0,0,zMinMove])*ref.transform)
			polyop.setvert s #{i} ((vPos + [0,0,zMinMove])*ref.transform)
-- 			polyop.moveVert s #{i} ([0,0,zMinMove])
		)
-- 		else(format "\tignore s.name: % vert: % vPos: % \n" s.name i vPos)
		
		if vPos.y >= ymax + yMaxRange then
		(
-- 			point name: (s.name + "_" +(i as string)) transform: (transMatrix((polyop.getvert s  i) * inverse ref.transform)) wirecolor: blue
			format "zMaxMove: % s.name: % vert: % vPos: %\n" yMaxMove s.name i vPos 
			format "\tpolyop.setVert % #{%} %\n" s i ((vPos + [0,yMaxMove,0])*ref.transform)
			polyop.setvert s #{i} ((vPos + [0,yMaxMove,0])*ref.transform)
-- 			polyop.moveVert  s #{i} ([0,0,zMaxMove])
		)
		else if  vPos.y <= ymin + yMinRange then
		(
-- 			point name: (s.name + "_" +(i as string)) transform: (transMatrix((polyop.getvert s  i) * inverse ref.transform)) wirecolor: red
			format "zMinMove: % s.name: % vert: % vPos: % \n" yMinMove s.name i vPos 
			format "\tpolyop.setVert % #{%} %\n" s i ((vPos + [0,yMinMove,0])*ref.transform)
			polyop.setvert s #{i} ((vPos + [0,yMinMove,0])*ref.transform)
-- 			polyop.moveVert s #{i} ([0,0,zMinMove])
		)
		

	)
)



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