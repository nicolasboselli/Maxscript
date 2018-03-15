-- AMELIORATION

-- orienter les controller dans le sens des bones

bn_finger = $ as array
--bn_finger_rot = for o in bn_finger collect o.rotation

-- collecter des spy rot
bn_finger_spy_rot_temp = #()
bn_finger_spy_rot_temp = for o in bn_finger collect o.children
bn_finger_spy_rot = #()
for i = 1 to bn_finger_spy_rot_temp.count do
(
n = bn_finger_spy_rot_temp[i].count 
append bn_finger_spy_rot bn_finger_spy_rot_temp[i][n] 
)

-- collecter des rotations de spy rot
bn_finger_spy_rot_rot = for o in bn_finger_spy_rot collect o.rotation


-- collecte des hlp_bn_finger
hlp_bn_finger = for o in bn_finger collect o.controller.position.controller.getnode 1

-- collecter des positions hlp_bn_finger_pos
hlp_bn_finger_pos = for o in hlp_bn_finger collect o.position

-- alignement des controller de bones
for i = 1 to hlp_bn_finger.count do 
(
hlp_bn_finger[i].rotation = bn_finger_spy_rot_rot[i]
hlp_bn_finger[i].position = hlp_bn_finger_pos[i]
)

delete bn_finger_spy_rot

-- creer un custom attribute general par doigt pour les phalanges

-----------------------------------------------------------------
-----------------------------------------------------------------
--RIG finger

-- creation des controller spline
ctr_finger = for i = 1 to hlp_bn_finger.count collect
(
circle name: (uniquename "ctr_finger") radius: 2 rotation:  hlp_bn_finger[i].rotation pos: hlp_bn_finger[i].pos
)
wire_temp = color (random 0 255) (random 0 255) (random 0 255)
for o in ctr_finger do o.wirecolor = wire_temp
--(((eulerangles 90 0 0 )as quat) +)

-- contraintes des hlp_bn_finger en position
for i = 1 to ctr_finger.count do
(
hlp_bn_finger[i].controller.pos.controller = position_constraint ()
hlp_bn_finger[i].controller.pos.controller.constraints.appendtarget  ctr_finger[i] 50
)

-- contraintes des hlp_bn_finger en rotation
for i = 1 to ctr_finger.count do
(
hlp_bn_finger[i].controller.rotation.controller = orientation_constraint ()
hlp_bn_finger[i].controller.rotation.controller.constraints.appendtarget  ctr_finger[i] 50
)

-- parenté des controller
for i = 1 to (ctr_finger.count - 1) do
(
ctr_finger[(i + 1)].parent = ctr_finger[i]
)


-------------------------------------------------------------



