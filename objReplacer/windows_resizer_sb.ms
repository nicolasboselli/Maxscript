
/*
memo:
	le getvert de l'edit poly est relatif au toolmode.coordsys: toolMode.coordsys #local

*/
-- créer un script qui déplace les points des fenetres en haut et en bas et sur les côtés pour les caler à un gabarit

-- attraper le modifier edit poly
-- for s in (selection as array) do format "% %\n" s.name s.modifiers

-- collecte de la position de chaque objet par rapport au parent
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
		append sel s
	)
)	

-- créer un modifier edit_poly sur la selection
ep = edit_poly name: "resizer_ep"
for s in selection where not iskindof s dummy do addModifier s ep

-- collecter les coordonnée de chaque vertex 
for s in sel do
(
	format "========= %\n" s.name
	
-- 	sToParentTM = s.transform * inverse ref.transform
-- 	format "sToParentTM: %\n" sToParentTM
	
-- 	format "s: % numVertices: %\n" s.name (s.resizer_ep.GetNumVertices node: s)
-- 	numVert = s.resizer_ep.GetNumVertices node: s
	numVert = s.GetNumVertices ()
	
	for i = 1 to numVert do
	(
-- 		VertToSTM = transMatrix(s.resizer_ep.GetVertex i node: s)
-- 		VertToSTM = transMatrix(s.GetVertex i )
		
-- 		VertToParentTM = sToParentTM*VertToSTM
		
	-- 	format "parentVertPos: % vert1pos: %\n" parentVertPos  VertPos
		
		point name: (s.name + "_" +(i as string)) transform: (transMatrix((polyop.getvert s  i) * inverse ref.transform))
	)
)


-- selectionner tous les vertex qui se trouve dans la zone de selection
-- calculer le decalage entre le gabarit et la position maximale du vertex
-- deplacer les vertex




$driven.transform = xformMat  $localSpace.transform $driver.transform

select $driven

xformMat $.transform (transMatrix [50,50,50])
select $point003
point transform: (($.transform)*inverse(transMatrix [50,50,50]))


xformMat (transMatrix [50,50,50]) (transMatrix [50,50,50])

$.position

in coordsys $Point004 $.position

-- point transform: (inverse($.transform))

-- inverse($.transform)

-- n = o.edit_poly.GetPrimaryNode ()