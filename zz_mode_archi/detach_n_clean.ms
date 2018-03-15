-- fonction : detach_elements_selected, resultante : fenetres_array

fn detach_elements_selected s =
(

-- selection de plusieurs elements 


selection_globale = s.getselection #face

selection_globale_array = selection_globale as array

une_selection = polyop.getElementsUsingFace s #{selection_globale_array[1]} as array

max_value = selection_globale_array.count
pas = 0
tour = 0
-- print "max_value : " + (max_value as string)


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

/*
delete fenetres_array
*/
)

-- fonction clean_une_fenetre

fn clean_une_fenetre s =
(

-- detache la selection
s.EditablePoly.GetNumFaces ()
/*
face_fenetres = s.editablePoly.getSelection #face

detach_name = uniquename "fenetre_seule"
polyop.detachFaces s face_fenetres delete:true asNode:true name: detach_name
fenetre_seule = getnodebyname detach_name
select fenetre_seule
*/
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

-- recup faces a flipper
num_face_restantes = s.EditablePoly.GetNumFaces ()
face_restantes = #()
for i = 1 to num_face_restantes do append face_restantes i
face_to_flip = face_restantes as bitarray

select s
-- flippage des faces
subobjectLevel = 4
s.setselection #face  face_to_flip
polyop.flipNormals s face_to_flip
subobjectLevel = 0
)

if $selection.count != 0 then
(

	-- appliquer à des elements selectionnés

	if 	subobjectLevel == 5 then
		
	(
	s = $

	detach_elements_selected s

	print fenetre_array

	for o in fenetres_array do clean_une_fenetre o
	)

	else 
	(
		if subobjectLevel == 0 then
			(

				s_array = $selection as array

				for s in s_array do
					(
					faces_num = s.EditablePoly.GetNumFaces ()
					faces_array = for i = 1 to faces_num collect i
					faces_bitarray = faces_array as bitarray
					s.editablePoly.setSelection #face faces_bitarray

					detach_elements_selected s

					print fenetre_array

					for o in fenetres_array do clean_une_fenetre o
					)
			)
		else print "selectionner des objets ou des elements d'objet"
	)
)
else print "selectionner des objets ou des elements d'objet"
