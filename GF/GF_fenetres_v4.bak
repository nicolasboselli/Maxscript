if selection == undefined then  "selectionner des objets des faces ou des elements"
else
(
	if (modPanel.getCurrentObject() == undefined) then  max modify mode
	
	FenetresMaterial ()
	-- creation des fenetres
	case of
	(
		(subobjectLevel == 0):
		(
			s_array = selection as array
			for s in s_array do 
			(
				select s
				polyop.setFaceSelection s #all
				fenetres_base s
			)
		)
			
		(subobjectLevel == 4):
		(
			s = $
			s2_name = uniquename "fenetres_base_"
			polyop.detachFaces s  #selection delete: true asNode:true name: s2_name
			s2 = getnodebyname s2_name
			select s2
			polyop.SetFaceselection s2 #all
			redrawviews ()
			
			fenetres_base s2
			
			s2.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
		)
		
		(subobjectLevel == 5):
		(
			s = $
			s2_name = uniquename "fenetres_base_"
			polyop.detachFaces s  #selection delete: true asNode:true name: s2_name
			s2 = getnodebyname s2_name
			select s2
			polyop.SetFaceselection s2 #all
			redrawviews ()
			
			fenetres_base s2
			
			s2.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
		)
		
		default: print "selectionner des objets des faces ou des elements"
	)
)
	

	
