--AMELIORATION:
-- creer une fonction rename pour les pose
-- creer un bouton de selection de la ref en cours pour les copies

-- creer des alertes pour eviter les crash:
-- 1 demander de selectionner une ref
-- 2 demande de selectionner un set d'objet

-- enregistrement de poses:

CPP = 0
rollout alert "alert"
(
	)
/*
rollout rename_pose "rename pose" width: 300
(
	edittext new_name "new pose name" 
		
	on new_name entered txt do 
	(
	print txt
	print CPP.pose_list.selection
	nb = CPP.pose_list.selection
	CPP.stack_pose_name_tab[nb] = txt
	print CPP.stack_pose_name_tab[nb]
	CPP.pose_list.items = for i = 1 to CPP.stack_pose_name_tab.count collect CPP.stack_pose_name_tab[i]
	destroydialog rename_pose
	
	)
	
)
*/

/*
	 s
	 ref
	 nb
	 pose_stacker = $
	555
	 stack_number_tab = pose_stacker.pose_stacker_tracks.stack_number 
	 stack_ref_tab = pose_stacker.pose_stacker_tracks.stack_ref 
	 stack_rotation_tab = pose_stacker.pose_stacker_tracks.stack_rotation 
	 stack_position_tab = pose_stacker.pose_stacker_tracks.stack_position
	 stack_selection_tab = pose_stacker.pose_stacker_tracks.stack_selection
	 stack_pose_name_tab = pose_stacker.pose_stacker_tracks.stack_pose_name
*/
rollout CPP  ($.name as string)
	(
	group "config copy"
	(
	pickButton Ref_Select "Ref Selection" 
	button select_current_ref "select current ref" 
 
	)
	
	group "copy pose"
	(
	button copy_pose "Copy Pose"
	)
	
	group "list poses"
	(
	button refresh "refresh"
	listBox pose_list "poses"  height:5 items: #()
	button select_ref "Select Ref" 
	button select_set "Select Set" 
	button delete_pose "Delete pose" 
	button rename "rename pose"
	)
	group "paste pose"
	(
	button paste_pose "Paste Pose" 
	)

	local s
	local ref
	local nb
	local pose_stacker = $
	
	local stack_number_tab = pose_stacker.pose_stacker_tracks.stack_number 
	local stack_ref_tab = pose_stacker.pose_stacker_tracks.stack_ref 
	local stack_rotation_tab = pose_stacker.pose_stacker_tracks.stack_rotation 
	local stack_position_tab = pose_stacker.pose_stacker_tracks.stack_position
	local stack_selection_tab = pose_stacker.pose_stacker_tracks.stack_selection
	local stack_pose_name_tab = pose_stacker.pose_stacker_tracks.stack_pose_name

	/*
	fn print_stack =
(
	print stack_number_tab 
	print stack_ref_tab 	
	print stack_pose_name_tab 
	
	print stack_rotation_tab 
	print stack_rotation_tab.count
	print stack_position_tab 
	print stack_position_tab.count
	print stack_selection_tab 
	print stack_selection_tab.count
)
	*/
	on copy_pose pressed  do
(
if $selection.count == 1 then s = #($) else s = $ as array
			
			(
				-- ajout du renge à l'array
				append stack_number_tab s.count
				-- ajout de la réference  selectionnée à l'array
				append stack_ref_tab ref
				-- pour chaque objet de la selection
				for o in s do
					(
						-- ajout de l'objet selectionner à l'array
						append stack_selection_tab o
						
						-- conversion de la rotation de l'objet selectionner en point4
						x = in coordsys ref o.rotation.x
						y = in coordsys ref o.rotation.y
						z = in coordsys ref o.rotation.z
						w =  in coordsys ref o.rotation.w
						point4_rotation = [x,y,z,w]
						-- ajout de la rotation de l'objet selectionner à l'array
						append stack_rotation_tab point4_rotation
						
						-- ajout de la position de l'objet selectionner à l'array
						append stack_position_tab (in coordsys ref o.position)
						
					)

				-- ajout de la pose à la liste
				append stack_pose_name_tab  ("pose_"  + ((stack_pose_name_tab.count + 1) as string))
				-- rafraichissement de la liste
				pose_list.items = for i = 1 to stack_pose_name_tab.count collect stack_pose_name_tab[i]
				
			
				)

			
)

	on select_current_ref pressed do select ref
	
	on paste_pose pressed  do
(
	if pose_list.items.count  > 0 do
	(
		
		-- target
			nb = pose_list.selection
			-- definition du debut de la collecte
			start =0
			for i = 1 to (nb-1) do
			(start += stack_number_tab[i])
			start = start+1
			
			-- definition de la fin de la collecte
			end = 0
			for i = 1 to (nb) do
			(end += stack_number_tab[i])
			end = end
		--recuperation de la ref	
			ref = stack_ref_tab[nb]
		-- recuperation du set de selection
			selection_set = for i = start to end collect stack_selection_tab[i]
					
		animate on
		(
			for o in selection_set do
			(-- manque pour chaque objet de la collection
				for i = start to end do
				(
					-- conversion de la rotation en quaternion
					rot_point4 = stack_rotation_tab[i]
					x = rot_point4[1]
					y = rot_point4[2]
					z = rot_point4[3]
					w = rot_point4[4]
					rot_quat = (quat x y z w )
					-- application de la rotation
					in coordsys ref stack_selection_tab[i].rotation =  rot_quat
					-- application de la position
					in coordsys ref stack_selection_tab[i].position =  stack_position_tab[i]
				)
			)
		)
	)
)

	on rename pressed do 
	(
		rollout rename_pose "rename pose" width: 300
		(
			edittext new_name "new pose name" 
				
			on new_name entered txt do 
			(
				print txt
				print pose_list.selection
				nb = pose_list.selection
				stack_pose_name_tab[nb] = txt
				print stack_pose_name_tab[nb]
				pose_list.items = for i = 1 to stack_pose_name_tab.count collect stack_pose_name_tab[i]
				destroydialog rename_pose
			)
		)
		createdialog rename_pose
	)

	on select_ref pressed do
(
	nb = pose_list.selection
	select stack_ref_tab[nb]
)

	on select_set pressed do
(
		nb = pose_list.selection
		-- definition du debut de la collecte
		start =0
		for i = 1 to (nb-1) do
		(start += stack_number_tab[i])
		start = start+1
			
			-- definition de la fin de la collecte
		end = 0
		for i = 1 to (nb) do
		(end += stack_number_tab[i])
		end = end
		
		selection_set = for i = start to end collect stack_selection_tab[i]
		select selection_set
		print selection_set
)

	on Ref_Select picked obj do
(
	if obj != undefined do
(
ref = obj
Ref_Select.text = obj.name
	)
)

 
  on delete_pose pressed do
 (
	 -- selection de l'index
	nb = pose_list.selection
	
		-- definition du debut de la collecte
		start =0
		for i = 1 to (nb-1) do
		(start += stack_number_tab[i])
		start = start+1
		print start
	 
		-- definition de la fin de la collecte
		end = 0
		for i = 1 to (nb) do
		(end += stack_number_tab[i])
		end = end
		print end
	 
	 for i = start to end do
	(
	-- delete le set de selection d'objet correspondant
	deleteitem  stack_selection_tab start
	-- delete le set de rotation correpondant
	deleteitem stack_rotation_tab start
	-- delete le set de position correpondant
	deleteitem stack_position_tab start
	)
	 
	 
	-- delete le nom correspondant
	deleteitem  stack_pose_name_tab nb
	
	-- delete la ref correpondante
	deleteitem stack_ref_tab nb
	 
	-- delete du range correpondant
	deleteitem stack_number_tab nb




	  
	  

	 
	-- rafraichaissement de la liste
	pose_list.items = for i = 1 to stack_pose_name_tab.count collect stack_pose_name_tab[i]

 )

 on refresh pressed do
 (	
	pose_list.items = for i = 1 to stack_pose_name_tab.count collect stack_pose_name_tab[i]

)
 
)

Createdialog CPP

/*
if $ != undefined then
(
	if custAttributes.count $ != 0 then
		(
			Createdialog CPP
		)
	else Createdialog alert
)
else Createdialog alert
*/
/*
destroydialog CPP
*/

/*
-- netoyage des tracks
pose_stacker.pose_stacker_tracks.stack_number = #(2,3,4)
pose_stacker.pose_stacker_tracks.stack_ref = #()
pose_stacker.pose_stacker_tracks.stack_rotation =#()
pose_stacker.pose_stacker_tracks.stack_position =#()
pose_stacker.pose_stacker_tracks.stack_selection =#()
*/
-- declaration des tackes comme variable
