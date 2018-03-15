-- RECUPERATION D UN CERTAIN NOMBRE DE VARIABLES

-- Fonction definition des variables de base
-- vars
edgeBorder 
edgeBorderSorted
vertexDuo
EdgesVectors
MainVectors

-- fonction
fn initVars  sel =
(

	-- recuperation de la selection d'edge a partir de la face
	-- var
	edgeBorder = #()

	-- main
	sel.editablePoly.getselection #face
	sel.EditablePoly.ConvertSelectionToBorder #Face #Edge
	sel.EditablePoly.ConvertSelectionToBorder #Face #vertex
	edgeBorder = ((polyop.getEdgeSelection sel) as array)
	redrawviews ()

	-- recuperation de la selection d'edge classée dans la boucle
	-- vars
	edgeBorderSorted = #()

	-- Main
		-- recuperation de la premiere edge
	append edgeBorderSorted edgeBorder[1]
	deleteItem edgeBorder 1
	ref = edgeBorderSorted[edgeBorderSorted.count]

		-- recuperation de deux deuxième edge possible
	for o in edgeBorder do
	(
		if ((polyop.getVertsUsingEdge sel #{ref} * polyop.getVertsUsingEdge sel #{o}) as array).count == 1 then 
		(	
			append edgeBorderSorted o
		)
	)
		-- selection de la deuxieme edge
	deleteItem edgeBorderSorted edgeBorderSorted.count

		-- elimination de la deuxieme edge de l'array de depart
	elt2Del = findItem edgeBorder edgeBorderSorted[2]
	deleteItem edgeBorder elt2Del

	-- recuperation des edges suivantes
	while edgeBorder.count > 0 do
	(
		ref = edgeBorderSorted[edgeBorderSorted.count]
		for o in edgeBorder do
		(
			if ((polyop.getVertsUsingEdge sel #{ref} * polyop.getVertsUsingEdge sel #{o}) as array).count == 1 then 
			(	
				append edgeBorderSorted o
			)
		)
		elt2Del = findItem edgeBorder edgeBorderSorted[edgeBorderSorted.count]
		deleteItem edgeBorder elt2Del
	)

	/*
	 -- verif edgeBorder
	 pas = 1
	  
	 i = pas
	 polyop.setEdgeSelection $ #{edgeBorderSorted[i]}
	 redrawviews ()
	 pas += 1
	edgeBorderSorted.count
	*/

	-- recup des vecteurs des edges
		-- vars
	vertexDuo = #()
	EdgesVectors = #()

		-- main
	vertexDuo = for o in edgeBorderSorted collect ((polyop.getVertsUsingEdge sel #{o}) as array)
	vertexDuo.count
	EdgesVectors = for o in vertexDuo collect  
	(
	normalize (((sel.editablePoly.getvertex  o[1])*sel.transform) - ((sel.editablePoly.getvertex  o[2])*sel.transform))
	)
	EdgesVectors.count

	-- comparaison des vecteurs par angle, recuperation des premiers vecteurs de direction
		--Vars
	MainVectors = #()

		-- main
	for i = 1 to (vertexDuo.count - 1) do
	(
		if acos (dot EdgesVectors[i]  EdgesVectors[i+1]) > 1 then
		(
			if acos (dot EdgesVectors[i]  EdgesVectors[i+1]) < 179 then 
			(
				append MainVectors EdgesVectors[i] 
			)
		)
	)

	-- comparaison du premier et du dernier vecteur, recuperation du dernier vecteur de direction
	if acos (dot  EdgesVectors[EdgesVectors.count] EdgesVectors[1]) > 1 then
	(
		if acos (dot  EdgesVectors[EdgesVectors.count] EdgesVectors[1]) < 179 then 
		(
			append MainVectors  EdgesVectors[EdgesVectors.count] 
		)
	)
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FN Creation de la face clean
-- vars 
VertexCorner
NewVertexCorner
CleanFace

-- fonction

fn CleanFaceFN sel =
(
	-- recuperation des points aux angles de la selection
	sel.EditablePoly.setSelection #edge (edgeBorderSorted as bitarray)
	VertexCorner = #()
	for i = 1 to (edgeBorderSorted.count - 1) do
	(
		if acos (dot EdgesVectors[i]  EdgesVectors[i+1]) > 2 then
		(
			if acos (dot EdgesVectors[i]  EdgesVectors[i+1]) < 178 then 
			(
				append VertexCorner (((polyop.getVertsUsingEdge sel #{edgeBorderSorted[i]})*(polyop.getVertsUsingEdge sel #{edgeBorderSorted[i+1]})) as array)[1]
			)
		)
	)

	-- recuperation du dernier point
	if acos (dot EdgesVectors[edgeBorderSorted.count ]  EdgesVectors[1]) > 2 then
		(
			if acos (dot EdgesVectors[edgeBorderSorted.count ]  EdgesVectors[1]) < 178 then 
			(
				append VertexCorner (((polyop.getVertsUsingEdge sel #{edgeBorderSorted[edgeBorderSorted.count]})*(polyop.getVertsUsingEdge sel #{edgeBorderSorted[1]})) as array)[1]
			)
		)

	NewVertexCorner = for o in 	VertexCorner collect polyop.createVert sel (polyop.getvert sel o)
	polyop.createPolygon sel NewVertexCorner

	newface = polyop.getNumFaces sel
	polyop.setFaceSelection sel #{newface}
	redrawviews ()

	FaceNameTemp = uniquename "CleanFace_"
	polyop.detachFaces sel newface delete: true asNode: true name: FaceNameTemp
	CleanFace = getnodebyname FaceNameTemp
	CleanFace.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
)

---------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------
--FN CREATION DU GUIDE
-- vars
faceVectorZ
Vector_Z
vector_Y
vector_X
guide

-- fonction
fn GuideCreation sel =
(
	vector_Y_prov
	-- Vector_z
	faceVectorZ = sel.EditablePoly.getSelection #face as array
	Vector_Z = polyop.getFaceNormal sel faceVectorZ[1]


	-- recuperation du vector_y provisoire
		-- si un vecteur de direction est perpendiculaire au z de la scne [0, 0, 1] alors il est le vecteur y
	for i = 2 to MainVectors.count do
	(
		if
		(
			acos (dot MainVectors[i] [0,0,1]) < 91
		)	
		then
		(
			if 
			(
				acos (dot MainVectors[i] [0,0,1]) > 89
			)
			then  vector_Y_prov= MainVectors[i]
		)
	)

	-- vector_X-- recuperation du vector_x
	vector_X = normalize (cross vector_Y_prov Vector_Z)
	
-- 	 vector_X.z 
	if vector_X.z > 0 then vector_X = vector_X * -1
	-- recup du vecteur Y
	vector_Y = normalize (cross vector_X Vector_Z)
	
	
	-- position guide
	pos_guide = polyop.getFaceCenter CleanFace 1 
-- 	pos_guide = polyop.getFaceCenter  sel faceVectorZ[1]

	-- creation du guide

	guide = box ()

	guide.transform = matrix3 (Vector_X ) (vector_Y ) (Vector_Z ) pos_guide
)

-- Main
initVars $
FaceSelect = polyop.getFaceselection $
CleanFaceFN $
polyop.SetFaceselection $ FaceSelect
GuideCreation $
select CleanFace

-- comparer l'orientation de la nouvelle face avec le guide et flipper la face si necessaire

-- reset x form de la face clean et alignement avec l'univers
CleanFace.parent = guide
PosBack = guide.transform
guide.transform = matrix3 1

ResetXForm CleanFace
CenterPivot CleanFace
ResetXForm CleanFace
converttopoly CleanFace



	


