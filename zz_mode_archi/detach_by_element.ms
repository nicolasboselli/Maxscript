
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


	if subobjectLevel == 5 then 
	(
		s= $
		detach_elements_selected s
	)
	else "selectionner un element"