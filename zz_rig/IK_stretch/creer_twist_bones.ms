-- CREATE TWIST BONES
os = $ as array

bn_tune_hlps = for i = 1 to os.count collect 
(
point name: (uniquename "bn_tune_hlp") rotation: os[i].rotation pos: os[i].pos size: 5 box: false cross: false axistripod: true
)



-- contrainte des bones aux helpers
-- position
for i= 1 to os.count do
(
os[i].pos.controller = Position_Constraint ()
os[i].pos.controller.constraints.appendTarget bn_tune_hlps[i] 100
)
-- rotation
for i= 1 to os.count-1 do
(
os[i].rotation.controller = LookAt_Constraint ()
os[i].rotation.controller.constraints.appendTarget bn_tune_hlps[i+1] 100
os[i].rotation.controller.upnode_world = off
os[i].rotation.controller.pickUpNode = bn_tune_hlps[i]
os[i].rotation.controller.upnode_ctrl = 1
os[i].rotation.controller.viewline_length_abs = off
)

-- POSITIONNEMENT DES HELPERS
-- contrainte de position des hlpers intermediares

bn_max = bn_tune_hlps.count

for i = 2 to (bn_max - 1 ) do
(
bn_tune_hlps[i].position.controller = position_xyz ()
bn_tune_hlps[i].position.controller = position_constraint ()
bn_tune_hlps[i].position.controller.constraints.appendTarget bn_tune_hlps[1] (100 - ((100 / (bn_max - 1)) * (i - 1)))
bn_tune_hlps[i].position.controller.constraints.appendTarget bn_tune_hlps[bn_max] ((100 / (bn_max - 1)) * (i - 1))
)


-- POSITIONNEMENT DES HELPERS DOWN
---- creation des helpers
bn_hlp_up = for o in bn_tune_hlps collect copy o
for o in bn_hlp_up do o.name =  uniquename "bn_hlp_up"
----contrainte rotation
for i= 2 to (bn_hlp_up.count) do
(
bn_hlp_up[i].rotation.controller = euler_xyz()
bn_hlp_up[i].rotation.controller = LookAt_Constraint ()
bn_hlp_up[i].rotation.controller.constraints.appendTarget bn_tune_hlps[1] 100
bn_hlp_up[i].rotation.controller.target_axisFlip = on
bn_hlp_up[i].rotation.controller.upnode_world = off
bn_hlp_up[i].rotation.controller.pickUpNode = bn_hlp_up[1]
bn_hlp_up[i].rotation.controller.upnode_ctrl = 1
bn_hlp_up[i].rotation.controller.viewline_length_abs = off
)

select bn_hlp_up
-- POSITIONNEMENT DES HELPERS UP
---- creation des helpers
bn_hlp_dw = for o in bn_tune_hlps collect copy o
for o in bn_hlp_dw do o.name =  uniquename "bn_hlp_dw"
----contrainte rotation
for i= 2 to (bn_hlp_dw.count-1) do
(
bn_hlp_dw[i].rotation.controller = euler_xyz()
bn_hlp_dw[i].rotation.controller = LookAt_Constraint ()
bn_hlp_dw[i].rotation.controller.constraints.appendTarget bn_tune_hlps[bn_max] 100
bn_hlp_dw[i].rotation.controller.upnode_world = off
bn_hlp_dw[i].rotation.controller.pickUpNode = bn_hlp_dw[bn_hlp_dw.count]
bn_hlp_dw[i].rotation.controller.upnode_ctrl = 1
bn_hlp_dw[i].rotation.controller.viewline_length_abs = off
)


-- CONTRAINTES DE ROTATION DES HELPERS AU HELPERS DOWN ET UP
for i = 1 to bn_tune_hlps.count do
(
bn_tune_hlps[i].rotation.controller = euler_xyz()
bn_tune_hlps[i].rotation.controller = orientation_constraint ()
bn_tune_hlps[i].rotation.controller.constraints.appendTarget bn_hlp_up[i] (100 - (100 / (bn_max - 2)) * (i - 1))
bn_tune_hlps[i].rotation.controller.constraints.appendTarget bn_hlp_dw[i] ((100 / (bn_max - 2)) * (i - 1))
)	

-- retaillage des helpers
bn_hlp_dw[bn_max].size = 10
bn_hlp_up[1].size = 10

-- contrainte au helper down
bn_tune_hlps[bn_max].controller.position.controller = position_xyz ()
bn_tune_hlps[bn_max].controller.position.controller = position_constraint ()
bn_tune_hlps[bn_max].controller.position.controller.constraints.appendTarget bn_hlp_dw[bn_max] 100

bn_hlp_up[bn_max].controller.position.controller = position_xyz ()
bn_hlp_up[bn_max].controller.position.controller = position_constraint ()
bn_hlp_up[bn_max].controller.position.controller.constraints.appendTarget bn_hlp_dw[bn_max] 100
-- contrainte au helper up
bn_tune_hlps[1].controller.position.controller = position_xyz ()
bn_tune_hlps[1].controller.position.controller = position_constraint ()
bn_tune_hlps[1].controller.position.controller.constraints.appendTarget bn_hlp_up[1] 100

bn_hlp_dw[1].controller.position.controller = position_xyz ()
bn_hlp_dw[1].controller.position.controller = position_constraint ()
bn_hlp_dw[1].controller.position.controller.constraints.appendTarget bn_hlp_up[1] 100
