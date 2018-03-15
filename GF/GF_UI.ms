filein "FN_gestion_fenetres.ms"

rollout fenetresRLT "fenetres"

	(
		
		local cadreSize = (units.decodeValue "4cm")
		local dormantSize = (units.decodeValue "4cm")
		local battantSize = (units.decodeValue "4cm")

-- 		UI
		button btn_create_faces "Create face"
		group "fake windows:"
		(
			spinner cadreSizeSP "cadre size:" type: #worldunits range:[0,1000,cadreSize]
			spinner dormantSizeSP "dormant size:" type: #worldunits range:[0,1000,dormantSize]
			spinner battantSizeSP "battant size :" type: #worldunits range:[0,1000,battantSize]
			button btn_fenetre_fixes "Create fake windows"
		)
		button btn_clean_base "Return to Faces"
		button btn_super_fenetre "Create Fenetre Ouvrables"
		
-- 		actions
		on cadreSizeSP changed val do cadreSize = val
		on dormantSizeSP changed val do dormantSize = val
		on battantSizeSP changed val do battantSize = val

		on btn_create_faces pressed do 
		(
			if selection == undefined then "selectionne un objet ou des ouvertures"
			else
			(
				if (modPanel.getCurrentObject() == undefined) then  max modify mode
				
				case of
				(
					(subobjectLevel == 0):
					(
						s_array = selection as array
						for s in s_array do 
						(
							select s
							s.EditablePoly.SetSelection #Edge ((polyOp.getOpenEdges s) as bitarray)
							detach_face_fenetre s
						)
					)
						
					(subobjectLevel == 3):
					(
						s = $
						detach_face_fenetre s
					)
					
					default: print "selectionner des objets ou des ouvertures"
				)
			)
		)
		
		on btn_fenetre_fixes pressed do
		(
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
							undo on
							(
								fenetres_base s cadreSize: cadreSize  dormantSize: dormantSize battantSize: battantSize
							)
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
						
						undo on
						(
							fenetres_base s2 cadreSize: cadreSize  dormantSize: dormantSize battantSize: battantSize
						)
						
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
						
						undo on
						(
							fenetres_base s2 cadreSize: cadreSize  dormantSize: dormantSize battantSize: battantSize
						)
						
						s2.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
					)
					
					default: print "selectionner des objets des faces ou des elements"
				)
			)
		)
		
		on btn_clean_base pressed do 
		(
			filein "GF_return2faces_v2.ms"
		)
		
		on btn_super_fenetre pressed do 
		(
			filein "GF_super_fenetre_v2.ms"
		)
		


	)
CreateDialog fenetresRLT
	
