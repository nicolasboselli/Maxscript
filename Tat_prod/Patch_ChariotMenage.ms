

sel = selection as array
for s in sel do
(
	ctrl = point name: (substitutestring s.name "_RIG" "_CTRL") \
	box: true axistripod: false cross: false wirecolor: (color 224 86 86)  size: 15 

	ctrl.parent = s
	in coordsys parent ctrl.rotation = (quat 0 0 0 1)
	in coordsys parent ctrl.position = [0,0,0]
)

-- ajout de rig arriere
sel = selection as array
for s in sel do
(
	if matchpattern s.name pattern: "*_01_RIG" then
	(
		newName = (substitutestring s.name "_RIG" "_ar_RIG")
		s.name = substitutestring s.name "_RIG" "_arSkin_RIG"
	)
	else if matchpattern s.name pattern: "*_02_RIG" then
	(
		newName = (substitutestring s.name "_RIG" "_av_RIG")
		s.name = substitutestring s.name "_RIG" "_avSkin_RIG"
	)else(print "fail")

	arRig = point name: newName box: true axistripod: false cross: false wirecolor: green  size: 10 

	arRig.parent = s
	in coordsys parent arRig.rotation = (quat 0 0 0 1)
	in coordsys parent arRig.position = [0,0,0]
	arRig.parent = undefined 

	s.position.controller = position_xyz ()
	s.position.controller = position_list ()
	s.position.controller.available.controller = position_constraint () 
	s.position.controller.position_constraint.controller.appendTarget arRig 50

	s.rotation.controller = euler_xyz ()
	s.rotation.controller = rotation_list ()
	s.rotation.controller.available.controller = orientation_constraint () 
	s.rotation.controller.orientation_constraint.controller.appendTarget arRig 50
)


-- 
for s in selection do s.name = substitutestring s.name "_CTRL" "_RIG"