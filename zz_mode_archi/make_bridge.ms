-- createur de pont

-- à partir du'une selection de deux edges sur le même plan
s = $
edgeSel  = polyop.getEdgeSelection s -- ) as array


-- trouver les vertex selectionnés
firstVx = #()
for i in edgeSel do 
(
	tmpVx = polyop.getEdgeVerts s i
	firstVx += tmpVx
)

-- trouver les faces concernées
faces = #()
for i in edgeSel do 
(
-- 	print i
	tmpfaces = polyop.getEdgeFaces  s i
	format "faces:%\n" faces
	faces += tmpFaces
)
polyop.setfaceselection s  faces
redrawviews ()

 
-- trouver les vertex des faces concernées
verts = #()
for i in faces do
(
	tmpVerts = polyop.getFaceVerts  s  i
	for i in tmpVerts do appendifunique verts i
)

-- supprimer les vertex selectionner initialement de la selection finale.
restVxBit = verts as bitarray - firstVx as bitarray

-- pour chaque vertex restant, recuperer les edges correspondante
restVx = restVxBit as array
t = 0
for i = 1 to restVx.count do 
(
	for j = i + 1 to restVx.count do
	(
		totalEdge = #()
		
		polyop.setVertSelection s restVx[i]
		s.editablePoly.ConvertSelection #vertex #edge
		edgeSel1  = (polyop.getEdgeSelection s) as array
		
		polyop.setVertSelection s restVx[j]
		s.editablePoly.ConvertSelection #vertex #edge
		edgeSel2  = (polyop.getEdgeSelection s ) as array
		
		for ed in edgeSel1 do appendifunique  totalEdge ed
		for ed in edgeSel2 do appendifunique  totalEdge ed
		
		format "################ turn: %\n" (t +=1)
		format "vert1: %, edge: %, count:%\n" restVx[i] edgeSel1  edgeSel1.count-- ) as array
		format "vert2: %, edge: %,  count:%\n" restVx[j] edgeSel2 edgeSel2.count-- ) as array
		format "total1: %, total2: %\n" (edgeSel1.count + edgeSel2.count) totalEdge.count -- ) as array
	)
)

-- autre piste
	-- supprimer les edges selectionnées
	-- recuperer le numero de la face apres la suppression des edges
	-- retourner la liste de vertex de la face
edgeSel  = polyop.getFaceVerts $ 11
	-- prendre les vertex  dans l'ordre en partant d'un premier et d'un deuxieme vertex d'edge supprimer pour connecter le troisieme vertex avec le huitieme et le quatrieme avec le septieme
