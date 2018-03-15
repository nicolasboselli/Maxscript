$point006.pos.controller.pos1.controller = point3_script ()

$point006.position.controller.position_script.controller.value

pt6_p1 = $point006.pos.controller.pos1.controller
pt6_p2 = $point006.pos.controller.pos2.controller

pt6_p1 = point3_script ()

pt6_p1.value
pt6_p2.value

pt6_pw1 = $point006.pos.controller.weight[1].controller
pt6_pw2 = $point006.pos.controller.weight[2].controller

pt6_pw1.value
pt6_pw2.value

sujet = $
sujet.position.controller = position_xyz ()
sujet.position.controller = position_list ()
sujet.position.controller.available.controller = position_xyz ()
sujet.position.controller.setname 1 "tata"
sujet.position.controller.setname 2 "toto"
sujet.position.controller.tata.controller = position_script 
( 
	dependson $point005
	a = 4
	if a>5 then
		[ 915.013, 201.821, 0 ]
	else
	[ 915.013, 201.821, 0 ]
	)
sujet.position.controller.setactive 2



