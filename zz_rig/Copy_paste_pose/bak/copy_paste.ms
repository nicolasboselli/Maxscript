rollout Copy_Paste_Pose "Copy Paste" width:200 height:112
(
	button btn1 "Copy Pose" pos:[8,8] width:88 height:30
	button btn2 "Paste Pose" pos:[100,8] width:88 height:30
    button btn3 "Select Ref" pos:[8,56] width:88 height:30
	button btn4 "Select Array" pos:[100,56] width:88 height:30
	
	local s
	local s_rot
	local s_pos
	local ref = $robot_recorder
	

	on btn1 pressed  do
(
		s = $ as array
		ref = $robot_recorder
		s_rot = for o in s collect in coordsys ref o.rotation
		s_pos = for o in s collect in coordsys ref o.position
	)
	
	on btn2 pressed  do
(
		animate on

		(

		for i=1 to s_rot.count do in coordsys ref s[i].rotation = s_rot[i]
		for i=1 to s_rot.count do in coordsys ref s[i].position = s_pos[i]
		)
	)


	on btn3 pressed do
(
select ref
)

	on btn4 pressed do
(
select s
)

)
Createdialog Copy_Paste_Pose