-- BONES TUNES

os = $selection as array

BakBonesFN (os)

-- creation des spy rot
wire_temp = color (random 0 255) (random 0 255) (random 0 255)

bn_spy_rot = for i = 1 to os.count collect
(
	point name: (uniquename "bn_spy_rot") rotation:os[i].rotation \
	pos:os[i].position  size: 1 box: false cross: false  axistripod: true wirecolor: wire_temp
)
for i = 1 to bn_spy_rot.count do bn_spy_rot[i].parent = os[i]

-- creation des hlpers de bones 
wire_temp = color (random 0 255) (random 0 255) (random 0 255)

bn_tune_hlps = for i = 1 to os.count collect 
(
	point name: (uniquename "bn_tune_hlp") rotation: os[i].rotation \
	pos: os[i].pos size: 5 box: false cross: true axistripod: false wirecolor: wire_temp
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



