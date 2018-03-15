-- CREATION DES BATTANT
-- prepa scene
/*
s = box name: "cadre" pos:[220,0,0]
s2 = plane length:40 width:40 pos:[0,0,0] lengthsegs: 2 widthsegs: 2
converttopoly s2
s.name = "cadre"

-- sur le nouvel objet: 
select s2
*/
s2 = $
converttopoly s2
--  detacher les faces une par une (battant)
	-- compter le nombre de face
	face_count3 = s2.EditablePoly.GetNumFaces ()
	face_total = #{}
	for i = 1 to face_count3 do append face_total i
	
	-- creer autant de copie d'objet qu'il n y a de face
	battants_array = #()
	battants_array = for i = 1 to (face_count3 - 1) collect copy s2
	append battants_array s2
	
	pas = 0
	for o in battants_array do 
	(	
	--o.pos.x = pas
	o.name = (uniquename (s.name + "_battant") )
	--pas += 50
	)
	
	-- sur chaque copie:
		for i = 1 to face_count3 do 
		(
		face_safe = #{}
		append face_safe i
		face_sup = face_total - face_safe
		battants_array[i].EditablePoly.setSelection #face face_sup
		battants_array[i].EditablePoly.delete #Face 
		)
		-- supprimer les faces de l'objet inutile
			-- calculer la selection des faces inutile
			-- 
		-- centrer le pivot

		