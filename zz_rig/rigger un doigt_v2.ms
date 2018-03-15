-- BONES TUNES

os = $selection as array

BakBonesFN (os)

-- creation des spy rot

bn_spy_rot = for i = 1 to os.count collect
(
	point name: (uniquename "bn_spy_rot") rotation:os[i].rotation \
	pos:os[i].position  size:  (units.decodeValue "2cm")  box: false cross: false    axistripod: true wirecolor: orange 
)
for i = 1 to bn_spy_rot.count do bn_spy_rot[i].parent = os[i]

-- creation des hlpers de bones 

bn_tune_hlps = for i = 1 to os.count collect 
(
	point name: (uniquename "bn_tune_hlp") rotation: os[i].rotation \
	pos: os[i].pos size:  (units.decodeValue "2cm")  box: false cross: true axistripod: false wirecolor: green
)

-- contrainte des bones aux helpers
for i= 1 to os.count do
(
	os[i].pos.controller = Position_Constraint ()
	os[i].pos.controller.constraints.appendTarget bn_tune_hlps[i] 100
)

for i= 1 to os.count-1 do
(
	os[i].rotation.controller = LookAt_Constraint ()
	os[i].rotation.controller.constraints.appendTarget bn_tune_hlps[i+1] 100
	os[i].rotation.controller.upnode_world = off
	os[i].rotation.controller.pickUpNode = bn_tune_hlps[i]
	os[i].rotation.controller.upnode_ctrl = 1
	os[i].rotation.controller.viewline_length_abs = off
)

for i = bn_tune_hlps.count to 2 by -1 do
(
	bn_tune_hlps[i].parent = bn_tune_hlps[i - 1]
)

-- création controller spline

ctrCircleAr = for i = 1 to bn_tune_hlps.count collect
(
	circleTemp = circle name: (uniquename "ctr_doigt_") rotation: bn_tune_hlps[i].rotation  \
	pos: bn_tune_hlps[i].pos radius: (units.decodeValue "5cm") wirecolor: blue
	
	bn_tune_hlps[i].parent = circleTemp
	
	circleTemp
)

for i = ctrCircleAr.count to 2 by -1 do
(
	ctrCircleAr[i].parent = ctrCircleAr[i - 1]
)

for i = 2 to ctrCircleAr.count do
(
	ctrCircleAr[i].position.controller.y_position.controller = float_script ()
	ctrCircleAr[i].position.controller.z_position.controller = float_script ()
	
	ctrCircleAr[i].rotation.controller.x_rotation.controller = float_script ()
	ctrCircleAr[i].rotation.controller.y_rotation.controller = float_script ()
)

delete bn_spy_rot