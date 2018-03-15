
		
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
-- Script Detach n Clean


	if selection.count != 0 then
	(
		local fenetres_array = #()
		local vertArList = #()
		
		case of
		(
		-- en cas de selection d'éléments
			(subobjectLevel == 5) :
			(
			s = $

			fenetres_array = detach_elements_selected s

				for o in fenetres_array do 
				(	
					select o
					-- en cas de selection d'objet fenetres bases
					if (o.EditablePoly.GetNumFaces ()) > 10 then 
					(
						clean_une_fenetre o
						FlipAllNormals o
					)
						
					vectors_by_matrix o
					redress_pivot o
					redress_pivot o

					--edgesVariables o
					/*
					VertexSorting o
					RecreateEdgeY o
					RecreateEdgeX o
					*/
					vertArList = VertexSorting o
					RecreateEdgeY o vertArList[1]
					RecreateEdgeX o vertArList[3]
				)
				
				select fenetres_array
				
				s_array = selection as array

				for s in s_array do
				(
					select s
					if (modPanel.getCurrentObject() == undefined) then  max modify mode
					FenetreOuvrable s
				)
			)
			
		-- en cas de selection au niveau objet
		
			(subobjectLevel == 0):
			(
				s_array = selection as array
				
				if (modPanel.getCurrentObject() == undefined) then  max modify mode
				
				for s in s_array do
				(
					-- selectionne toutes les faces de l'objet
					select s
					polyop.setFaceSelection s #all

					fenetres_array = detach_elements_selected s

					for o in fenetres_array do 
					(
						select o
						-- en cas de selection d'objet fenetres bases
						if (o.EditablePoly.GetNumFaces ()) > 10 then 
						(
							clean_une_fenetre o
							FlipAllNormals o
						)
							
						vectors_by_matrix o
						redress_pivot o
						redress_pivot o

						--edgesVariables o
						/*
						VertexSorting o
						RecreateEdgeY o
						RecreateEdgeX o
						*/
						vertArList = VertexSorting o
						RecreateEdgeY o vertArList[1]
						RecreateEdgeX o vertArList[3]
					)
					
					select fenetres_array
					
					s_array = selection as array

					for s in s_array do
					(
						select s
						if (modPanel.getCurrentObject() == undefined) then  max modify mode
						FenetreOuvrable s
					)
					
				)
			)
			
			-- dans tous les autres cas de selection
			default: print "selectionner des objets ou des elements d'objet"
			
		)
	)
	else print "selectionner des objets ou des elements d'objet"

	
