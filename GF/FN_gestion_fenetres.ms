
-- function to create and detach face 
fn detach_face_fenetre s =
(

	edges_list = s.EditablePoly.getSelection #edge

	polyop.capHolesByEdge s edges_list
	s.ConvertSelection #edge #face

	s.EditablePoly.ShrinkSelection selLevel: #face

	fenetres_list = s.EditablePoly.getSelection #face

	polyop.detachFaces s fenetres_list delete:true asNode:true name: (uniquename "fenetre") 
)


-- classement array
fn ySort v1 v2 =
(
	local dd
	if(v1.y < v2.y) then
		dd=-1
	else
		dd=1
	
--compare les numeros entre eux et les classe	
	case of
	(
		(dd < 0.):1
		(dd > 0.):-1
		default: 0
	)
)
	
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
	

	-- detache elements d'un objet un par un
fn detach_elements_selected s =
(
	-- selection de plusieurs elements 
	local selection_globale = s.getselection #face
	local selection_globale_array = selection_globale as array
	local une_selection = polyop.getElementsUsingFace s #{selection_globale_array[1]} as array

	local max_value = selection_globale_array.count
	local pas = 0
	local tour = 0

	-- trouver le nombre d'elements à détacher
	-- compteur d'éléments

		while (selection_globale as array).count != (une_selection as array).count do
		(
			max_value_bak = max_value
			pas = une_selection.count
			(max_value -= pas)
			tour += 1
			
			selection_globale = selection_globale - (une_selection as bitarray)
			selection_globale_array = selection_globale as array
			une_selection = (polyop.getElementsUsingFace s #{selection_globale_array[1]}) as array
			-- print "max_value avant soustraction : " + (max_value_bak as string) + " ; selection:" + (pas as string) + " ; max_value apres soustraction:" + ((max_value) as string) + " ; verif :" + ((max_value + pas) as string)
		)	

	elts_num = tour + 1
	-- print elts_num

	selection_globale = s.getselection #face
	selection_globale_bak = s.getselection #face

	fenetres_array = #()

	-- detachement des elements
	for i = 1 to elts_num do
	(

		selection_globale_array = selection_globale as array
		
		detach1 = polyop.getElementsUsingFace s #{selection_globale_array[1]}
		s.EditablePoly.setSelection #face detach1
		
		fenetre_detach_name = uniquename "fenetre_detach_"
		polyop.detachFaces s detach1 delete:false asNode:true name: fenetre_detach_name
			
		selection_globale = selection_globale - detach1
		
		fenetre_detach = getnodebyname fenetre_detach_name
		fenetre_detach.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
		append fenetres_array fenetre_detach
		
	)

	s.EditablePoly.setSelection #face selection_globale_bak

	polyop.deleteFaces s selection_globale_bak
	return fenetres_array
)

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	

	-- fonction clean_une_fenetre
fn clean_une_fenetre s =
(

-- detache la selection
s.EditablePoly.GetNumFaces ()

-- fermeture des face ouvertes
s.EditablePoly.SetSelection #Edge ((polyOp.getOpenEdges s) as bitarray)
edges_list = (polyOp.getOpenEdges s)
polyop.capHolesByEdge s edges_list
s.ConvertSelection #edge #face

-- recup selection faces à garder
--select s
--subobjectLevel = 4
s.EditablePoly.ShrinkSelection selLevel: #face
face_survive = s.getselection #face
--subobjectLevel = 0

-- recup selection faces à supprimer
face_fenetre_seule_count = s.EditablePoly.GetNumFaces ()
face_fenetre_seule = #{} 
for i = 1 to face_fenetre_seule_count do append face_fenetre_seule i
face_to_delete = face_fenetre_seule - face_survive

-- suppression  des faces inutiles
s.EditablePoly.setSelection #face face_to_delete
s.delete #face

)

--------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------		

-- fonction pour récupérer les vecteurs des edges d'une face
fn vectors_by_matrix v = 
(
	v.EditablePoly.setSelection #face #{1}
	v.ConvertSelection #face #edge
	edge_col = v.getselection #edge
	edge_array = edge_col as array
	v.EditablePoly.setSelection #face #{}

		for o in edge_array collect
		(
		v.EditablePoly.setSelection #edge #{o}
		v.ConvertSelection #edge #vertex
		vertex_duo = v.getselection #vertex
		vertex_duo_int = vertex_duo as array
		vertex_coord = for o in vertex_duo_int collect v.GetVertex  o
		normalize (vertex_coord[1]*(v.transform) - vertex_coord[2]*(v.transform))
		)
 )

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	

	-- fonction classer array en fonction de l'orientation en z
	  fn sort_by_z v1 v2 =
	(
		local dd
		if(abs v1.z < abs v2.z) then
			dd=-1
		else
			dd=1
		
	--compare les numeros entre eux et les classe	
		case of
		(
			(dd < 0.):1
			(dd > 0.):-1
			default: 0
		)
	)
	
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------	

	fn redress_pivot s =
	(
			centerpivot s
					
			s_pos = s.pos
				
			-- orientation axe z
			vector_z = polyop.getFaceNormal s 1

			-- orientation axe y

			vectors = vectors_by_matrix s

			qsort vectors sort_by_z

			vector_y = vectors[1]

			-- vector x
			vector_x = cross vector_z vector_y

			--  creation et orientation du tutor
			tutor = box length: 2 width: 2 height: 2 name: (uniquename "tutor") wirecolor: (color 255 0 255)
			tutor.transform = (matrix3  vector_x vector_y vector_z s_pos)

			s.parent = tutor
			--------------------------------------------------------------------
			-- RESET DU DRIVER

			Tutor_matrix_bak = tutor.transform
			tutor.transform = matrix3 1
			s.parent = undefined

			ResetXForm s
			-- faire une condition en fonction de l'oraientation de la normale pour flipper les faces
			maxOps.CollapseNode s off
			s.transform = Tutor_matrix_bak

			delete tutor

			s.scale = [1,1,1]

	)

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------		

	fn FlipAllNormals s =
	(	
		if (modPanel.getCurrentObject() == undefined) then max modify mode
		select s
		setSelectionLevel  s #face
		polyop.flipNormals s #all
		redrawViews()
		setSelectionLevel  s #object
	)	

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------		

	fn VertexSorting s =
	(
		num_vertex = s.EditablePoly.GetNumVertices ()
		global vertex_array = for i = 1 to num_vertex collect i
		vertex_bitarray = vertex_array as bitarray
		vertex_pos = for i = 1 to num_vertex collect s.getvertex i
		print (vertex_pos as string)
		
		
		
		max_y = -1000

		for o in vertex_pos do
		(
			if (o.y > max_y)  then  
				max_y = o.y
		)
		max_y

		vertex_y_max = #()
		for i = 1 to vertex_pos.count do
		(
			if (vertex_pos[i].y > max_y - 2)  then  
				append vertex_y_max i
		)
		vertex_up_array = vertex_y_max

		-- recup vertex en y min
		min_y = 1000

		for o in vertex_pos do
		(
			if (o.y < min_y)  then  
				min_y = o.y
		)
		min_y

		vertex_y_min = #()
		for i = 1 to vertex_pos.count do
		(
			if (vertex_pos[i].y < min_y + 2)  then  
				append vertex_y_min i
		)

		vertex_down_array = vertex_y_min


		-- recup vertex en x max

		max_x = -1000

		for o in vertex_pos do
		(
			if (o.x > max_x)  then  
				max_x = o.x
		)
		max_x

		vertex_x_max = #()
		for i = 1 to vertex_pos.count do
		(
			if (vertex_pos[i].x > max_x - 2)  then  
				append vertex_x_max i
		)

		vertex_left_array = vertex_x_max


		-- recup vertex en x min
		min_x = 1000

		for o in vertex_pos do
		(
			if (o.x < min_x)  then  
				min_x = o.x
		)
		min_x

		vertex_x_min = #()
		for i = 1 to vertex_pos.count do
		(
			if (vertex_pos[i].x < min_x + 2)  then  
				append vertex_x_min i
		)

		vertex_right_array = vertex_x_min

-- 		"vertex_up_array : " + (vertex_up_array as string) + "; vertex_down_array :"  + (vertex_down_array as string) + "; vertex_left_array :" + (vertex_left_array as string)  + "; vertex_right_array :"  + ( vertex_right_array as string )
		return #(vertex_up_array,vertex_down_array, vertex_left_array, vertex_right_array)
	)

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------		

	-- recréation des edge en Y
	fn RecreateEdgeY s vertex_up_array =
	(
		local asset_array = #()

		for a = 1 to vertex_up_array.count do
		(
			asset = #()
			for b = 1 to vertex_array.count do
			(
				
				if ((s.getvertex vertex_array[b]).x < ((s.getvertex  vertex_up_array[a]).x + 0.1)) then
				(
					if ((s.getvertex vertex_array[b]).x > ((s.getvertex  vertex_up_array[a]).x - 0.1)) then
					(
						append asset vertex_array[b] 
					)
				)
			)
			append asset_array asset
		)

		-- creation des edges si on a des couple de point
		for i = 1 to asset_array.count do
		(
			if asset_array[i].count == 2 do
			(
			duo_vertex = asset_array[i] as bitarray

			s.EditablePoly.SetSelection #Vertex duo_vertex
			s.EditablePoly.ConnectVertices vertexFlag: 1
			)
		)
	)

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------		

	-- recréation des edge en X
	fn RecreateEdgeX s vertex_left_array =
	(

		asset_array_x = #()

		for a = 1 to vertex_left_array.count do
		(
			asset = #()
			for b = 1 to vertex_array.count do
			(
				
				if ((s.getvertex vertex_array[b]).y < ((s.getvertex  vertex_left_array[a]).y + 0.1)) then
				(
					if ((s.getvertex vertex_array[b]).y > ((s.getvertex  vertex_left_array[a]).y - 0.1)) then
					(
						append asset vertex_array[b] 
					)
				)
			)
			append asset_array_x asset
		)
		asset_array_x

		
		duo_array = #()
		for i = 1 to asset_array_x.count  do
		(	if asset_array_x[i].count == 2 then 
			(
				append duo_array asset_array_x[i]
			)
		)
		duo_array

		for i = 1 to duo_array.count do
		(
			duo_vertex = duo_array[i] as bitarray
			
			--s.EditablePoly.SetSelection #Vertex duo_vertex
			--s.EditablePoly.ConnectVertices vertexFlag: 1
			--s.EditablePoly.cutVertices duo_array[i][1] (s.getvertex duo_array[i][2]) [0,1,0]
			s.EditablePoly.slice ( cross (normalize ((s.getvertex duo_array[i][1]) - (s.getvertex duo_array[i][2]))) [0,0,1]) (s.getvertex duo_array[i][2]) 
		)

	)


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Vars pour GF_fenetres_v3.ms
/*
s
face_count
face_fenetre

-- FONCTIONS pour GF_fenetres_v3.ms

FenetresMaterial
fenetres_base
	*/


-- DEF des materiaux vitre
	fn FenetresMaterial =
	(
				-- creation des materiaux
		if sceneMaterials ["fenetre_vitre"] == undefined then
		(
			sceneMaterials ["fenetre_vitre"] = standard ()
			sceneMaterials ["fenetre_vitre"].diffuse = color 117 188 255
		)

		if sceneMaterials ["fenetre_huisserie"] == undefined then
		(
			sceneMaterials ["fenetre_huisserie"] = standard ()
			sceneMaterials ["fenetre_huisserie"].diffuse = color 255 255 255
		)
		
		if  sceneMaterials ["fenetre"] == undefined then
		(
			sceneMaterials ["fenetre"] = Multimaterial numsubs:2
			sceneMaterials ["fenetre"].materialList[1] = sceneMaterials ["fenetre_huisserie"]
			sceneMaterials ["fenetre"].materialList[2] = sceneMaterials ["fenetre_vitre"]
		)
	)
FenetresMaterial()
-- declaration de la modelisation de fenetre de base
	fn fenetres_base s cadreSize: 4 dormantSize: 4 battantSize: 4 =
	(
	-- application des opérations
		/*
	if cadreSize == unsupplied then cadreSize = 4
	if cadreSize == unsupplied then cadreSize = 4
	if cadreSize == unsupplied then cadreSize = 4
		*/
	subobjectLevel = 0
	
	s.material = sceneMaterials ["fenetre"]
	
	subobjectLevel = 4
	
	s.EditablePoly.setMaterialIndex 1 1
	-- cadre creation
	s.insetAmount = cadreSize
	s.insetType = 0
	s.EditablePoly.buttonOp #Inset
		
	-- dormant creation
	s.extrusionType = 0
	s.faceExtrudeHeight = dormantSize*-1
	s.EditablePoly.buttonOp #Extrude

	s.insetAmount = 0.3
	s.insetType = 1
	s.EditablePoly.buttonOp #Inset

	s.faceExtrudeHeight = 2.5
	s.faceExtrudeHeight = 3
	s.EditablePoly.buttonOp #Extrude
	
	-- battant creation
	s.insetAmount = battantSize
	s.insetType = 1
	s.EditablePoly.buttonOp #Inset

	s.faceExtrudeHeight = -2
	s.EditablePoly.buttonOp #Extrude

	s.outlineAmount = -2
	s.EditablePoly.buttonOp #Outline
	
	s.EditablePoly.setMaterialIndex 2 1

	subobjectLevel = 0
	
	-- appliquer les couleurs
	)
	

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- FONCTIONS pour GF_fenetres_ouvrables.ms et GF_super_fenetre.ms




	fn FenetreOuvrable s = 
	(
		-- Creation materiaux
		/*
		if sceneMaterials ["fenetre_vitre"] == undefined then
		(
			sceneMaterials ["fenetre_vitre"] = standard ()
			sceneMaterials ["fenetre_vitre"].diffuse = color 117 188 255
		)

		if sceneMaterials ["fenetre_huisserie"] == undefined then
		(
			sceneMaterials ["fenetre_huisserie"] = standard ()
			sceneMaterials ["fenetre_huisserie"].diffuse = color 255 255 255
		)
		*/

		-- CREATION DU CADRE

		-- selectionner plusieurs faces (cadre):
		FenetresMaterial ()
		
		face_count = s.EditablePoly.GetNumFaces ()
		face_array = #{}
		for i = 1 to face_count do append face_array i

		subobjectLevel = 4
		s.EditablePoly.setSelection #face face_array

		-- faire un inset
		s.insetType = 0
		s.insetAmount = 4
		s.EditablePoly.buttonOp #Inset

		-- recuperer selection des faces
		face_battants = s.EditablePoly.GetSelection #face 
		-- nettoyage de la selection
		s.EditablePoly.setSelection #face #{}
		subobjectLevel = 0

		-- detacher les face dans un nouvel objet
		detach_name = uniquename "detach" 
		polyop.detachFaces s face_battants delete:true asNode:true name:detach_name as string
		s2 = getNodeByName (detach_name as string)

		-- appliquer un shell sur lobjet restant
		select s
		modPanel.addModToSelection (Shell ()) ui:on
		s.modifiers[#Shell].innerAmount = 8
		s.modifiers[#Shell].outerAmount = 0
			
		s.name =(uniquename "cadre")

		cadre = s
		cadre.material = 	sceneMaterials ["fenetre_huisserie"]



		------------------------------------------------------------------------------------------------------------------
		-- CREATION DES BATTANT

		-- sur le nouvel objet: 
		select s2
			
		--  detacher les faces une par une (battant)

		face_count3 = s2.EditablePoly.GetNumFaces ()

		battants = #()
		for i = 1 to face_count3 collect
		(
			battant_name =(uniquename "toto")
			polyop.detachFaces s2 1 delete:true asNode:true name: battant_name as string
			battant_temp = getNodeByName battant_name
			append battants battant_temp
		)

		select battants
			
		vitres = #()
		--$.EditablePoly.GetSelection #Face 
			
		-- operation sur chaque battant
		for o in battants do
		(
			-- CREATION DU BATTANT
			in coordsys local move o [0,0, 1]
			o.material = sceneMaterials ["fenetre_huisserie"]
			select o 

			--CenterPivot o
			subobjectLevel = 4
			o.EditablePoly.SetSelection #Face #{1}
			-- faire un outline
			$.outlineAmount = -0.2
			$.EditablePoly.Outline ()
			-- faire un inset
			$.EditablePoly.buttonOp #Inset
			$.insetAmount = 4
			-- faire extrude
			$.faceExtrudeHeight = -1
			$.EditablePoly.buttonOp #Extrude
			-- faire outline
			$.outlineAmount = -2
			$.EditablePoly.Outline ()

			-- CREATION DE LA VITRE
			-- detachement de la face
			vitre_select = $.EditablePoly.GetSelection #Face 
			vitre_name = uniquename "vitre"
			polyop.detachFaces o vitre_select delete:true asNode:true name:vitre_name as string

			-- recupérer la selection de vitre
			vitre = getNodeByName vitre_name
			append vitres vitre

			subobjectLevel = 0
		)



		-- creation des battants
		for o in battants do
		(
			select o
			-- extruder les border en z
			o.EditablePoly.SetSelection #Edge ((polyOp.getOpenEdges $) as bitarray)
			o.parent = s

			subobjectLevel = 2
			o.edgeExtrudeHeight = -10
			o.edgeExtrudeWidth = 0
			o.EditablePoly.buttonOp #Extrude
			subobjectLevel = 0

			-- faire la symétrie sur le battant
			modPanel.addModToSelection (symmetry ()) ui:on
			o.modifiers[#Symmetry].axis = 2
			o.modifiers[#Symmetry].flip = on
			o.modifiers[#Symmetry].weld = 1
			o.modifiers[#Symmetry].mirror.position = [0,0,2.5]
				
			maxOps.CollapseNode o off
		)


		-- sur chaque vitre appliquer un shell
		for i = 1 to vitres.count do
		(
			Vitres[i].material =  sceneMaterials ["fenetre_vitre"]

			vitres[i].parent = battants[i]
			select vitres[i]
			modPanel.addModToSelection (Shell ()) ui:on
			vitres[i].modifiers[#Shell].innerAmount = 0.5
			vitres[i].modifiers[#Shell].outerAmount = 0
		)

		-- placer des controleur pour chaque battant
			

		for s in battants do
		(
				
			-- recup coordonnées des vertex
			select s

			verts_num = s.EditablePoly.GetNumVertices ()
			vertex_pos = for i = 1 to verts_num collect (execute ((s.GetVertex i) as string ))
			for o in vertex_pos do print o
			vertex_pos.count

			-- recup des coordonnées a -5 en z
			vertex_array = #()

			maxValue = -1000

			for o in vertex_pos do
			(
				if (o.z > maxValue)  then maxValue = o.z
			)

			for o in vertex_pos do
			(
				if (o.z > maxValue - .1)  then append vertex_array o
			)
			print vertex_array

			-- classement des coordonnées de la plus grnade à la plus petite en y
			qsort vertex_array ySort

			--placement des points
			battants_ctr = for i = 1 to 2 collect
			(
				battants_hlp = point name: (uniquename (s.name + "_hlp")) box: on size: 40
				--in coordsys s battants_hlp.pos = vertex_array[i]
				battants_hlp.rotation = s.rotation
				battants_hlp.pos = vertex_array[i]*s.transform
				battants_hlp
			)

			-- lien de parenté
			s.parent = battants_ctr[2]
			battants_ctr[2].parent = battants_ctr[1]
			battants_ctr[1].parent = cadre
		)
	)		

	
print "all windows functions loaded"
	
-- Vars pour GF_return2faces.ms et GF_super_fenetre.ms
/*
vector_z
vectors
Tutor_matrix_bak
num_vertex
s_pos
faces_num
s_array
fenetres_array
faces_bitarray
vertex_up_array
vertex_array
duo_array
vertex_left_array
max_value_bak
pas
max_value
tour
selection_globale_bak
selection_globale_array
elts_num
une_selection
selection_globale
tutor
vector_x
vector_y
*/

-- FONCTIONS pour GF_return2faces.ms et GF_super_fenetre.ms
/*
ySort
detach_elements_selected
clean_une_fenetre
vectors_by_matrix
sort_by_z
redress_pivot
FlipAllNormals
VertexSorting
RecreateEdgeY
RecreateEdgeX
*/
