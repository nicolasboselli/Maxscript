modPanel.addModToSelection (emptymodifier ()) ui:on

toto = attributes toto	
(
	parameters main rollout:pose
	(

	)
	
	rollout pose "test"
	(
	pickButton Ref_Select "Ref Selection" pos:[10,10] width:120 height:20
	button copy_pose "Copy Pose" pos:[10,50] width:120 height:20
	listBox lbx1 "poses" pos:[10,100] width:120 height:5 items: #()

    button select_ref "Select Ref" pos:[10,200] width:55 height:30
	button select_set "Select Set" pos:[70 ,200] width:55 height:30
	
	button delete_pose "Delete pose" pos:[10,250] width:50 height:30	
	button paste_pose "Paste Pose" pos:[10,310] width:120 height:30

		
	-- print test


	local s
	local s_rot
	local s_pos
	local ref
	local collection = #()
	local nb

		
	
	on copy_pose pressed  do
(
		if ref == undefined then print "select ref first!"	else 
		(
		if $ == undefined then print "select array first!" else
			(
			-- enregistrement du nom de la pose
			lbx1.items = append lbx1.items	("pose_"  + ((lbx1.items.count + 1) as string))
			-- collecte des valeurs de la pose
			if $selection.count == 1 then 
			(
			s = #($)
			--append s $
			)
			else s = $ as array
			s_rot = for o in s collect in coordsys ref o.rotation
			s_pos = for o in s collect in coordsys ref o.position
			-- enregistrement de la pose dans un array
			pose_temp = #(s,s_rot,s_pos)
			append collection pose_temp
			
			)
		)
)

	
	on paste_pose pressed  do
(
	if collection.count == 0 then print "copy pose first!" else
	(
		animate on
		(
		nb = lbx1.selection
		-- collection[i][1] = s
		-- collection[i][2] = s_rot
		-- collection[i][3] = s_pos
			
		for i=1 to collection[nb][1].count do in coordsys ref collection[nb][1][i].rotation = collection[nb][2][i]
		for i=1 to collection[nb][1].count do in coordsys ref collection[nb][1][i].position = collection[nb][3][i]
		)
	)
)


	on select_ref pressed do
(
	if ref == undefined then print "select ref first!"	else select ref
)

	on select_set pressed do
(
	if collection == 0 then print "copy first!"	else 
	(
	nb = lbx1.selection
	select collection[nb][1]
	)
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
	nb = lbx1.selection
	lbx1.items = deleteitem lbx1.items nb
	deleteitem collection nb
 )

)
)
--custAttributes.add $box001 toto

custAttributes.add $.modifiers[#'Attribute Holder'] toto
