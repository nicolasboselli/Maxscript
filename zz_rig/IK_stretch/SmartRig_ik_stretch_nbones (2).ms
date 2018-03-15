-- AMELIORATION
-- aligner les controller spline sur les helpers
-- deplacer le controller d'orientation de l'ik vers l'avant dans la bonne direction
-- attacher les controlleur d'orientation des twist bones au helper du poignet plutot qu'au controlleur spline
-- sur le controlleur de ik placer un custom_attribute qui permette de selectionner des controlleur de rotation et position à la volée
-------------------------------------------------------------------------------------------------------------------------
--DEBUG

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- CREER UNE IK CHAIN

--à partir de trois bones
os = $ as array

-- verifier que l'array est dans le bon sens
-- creation de trois point pour l'ikchain

points_bn = for i = 1 to os.count collect 
(
point name: (uniquename "point_bn") rotation: os[i].rotation pos:os[i].pos size: 3 boneEnable: true boneFreezeLength:false 
)
wire_temp = color (random 0 255) (random 0 255) (random 0 255)
for o in points_bn do o.wirecolor = wire_temp
	

for i = 2 to points_bn.count do
points_bn[i].parent = points_bn[i-1]

-- creation de trois point espion de rotation
bn_spy_rot = for i = 1 to os.count collect
(
point name: (uniquename "bn_spy_rot") rotation: os[i].rotation pos:os[i].pos size: 5 box:false cross: false axistripod:true
)
wire_temp = color (random 0 255) (random 0 255) (random 0 255)
for o in bn_spy_rot do o.wirecolor = wire_temp


for i = 1 to bn_spy_rot.count do bn_spy_rot[i].parent = points_bn[i]

--créer une ik

ik_chain = IKSys.ikChain points_bn[1] points_bn[points_bn.count] "IKHISolver"
----------------------------------------------------------------------------------------------------------------------------------------------
-- PARENTE DES BONES AU HELPERS de BONES

for i= 1 to os.count do
(
os[i].parent = points_bn[i]
)

----------------------------------------------------------------------------------------------------------------------------------------------
--création de trois points pour controle des points bones

point_start = point name: (uniquename "point_bn_ctr") rotation:bn_spy_rot[1].rotation pos: points_bn[1].pos box: on axistripod: off size: 7
point_mid = point name: (uniquename "point_bn_ctr") rotation:bn_spy_rot[2].rotation pos: points_bn[2].pos box: on axistripod: off size: 7
point_end = point name: (uniquename "point_bn_ctr") rotation:bn_spy_rot[points_bn.count].rotation pos: points_bn[points_bn.count].pos box: on axistripod: off size: 7

points = #(point_start, point_mid, point_end)

wire_temp = color (random 0 255) (random 0 255) (random 0 255)
for o in points do o.wirecolor = wire_temp

--faire du point du milieu le controleur de la rotation de l'ik
ik_chain.transform.controller.VHTarget = points[2]

points_bn[2].transform.controller.PrefYAngle = 0
points_bn[2].transform.controller.PrefXAngle = 0

-- parente le premier os avec un helper
points_bn[1].parent = points[1] 
--parente ik_chain avec un helper
ik_chain.parent = points[3] 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--CREATION DU STRETCH

--A sur l'os du coude, preparation du controller de position en x
--1 créer une liste de controller de position en x 
--2 creer un bezier float pour memoriser la taille initiale de l'os
for i = 2 to points_bn.count do
(

os2_pos = points_bn[i].transform.controller.FK_Sub_Control.controller.Position.controller


os2_pos.x_position.controller = bezier_float ()
os2_pos.x_position.controller = float_list ()

os2_pos_x = os2_pos.x_position.controller
--3 créer un script float pour délarer le script
os2_pos_x.available.controller = float_script ()
os2_pos_x.setname 1 "zero"
os2_pos_x.setname 2 "stretch"
--4 activer le position script
os2_pos_x.setactive 2
os2_pos_x.weight[1].controller = bezier_float ()
os2_pos_x.weight[2].controller = bezier_float ()
os2_pos_x.weight[1].controller.value = 0
--5 variable: longueur du biceps fixe : biceps_fix = position en x de os[2]

constant  = stringstream ""
format "points_bn[%].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.stretch.controller.addconstant \"bone_%_size_fix\" (points_bn[%].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)" i i i to: constant
close constant
execute (constant as string)

size_fix = stringstream ""
format "os2_pos_x.stretch.controller.script = \"bone_%_size_fix.value\"" i to: size_fix
close size_fix
execute (size_fix as string)

)
-- placement de la taille des autres os en variables
for i = 2 to points_bn.count do
(
 
	for a = 2 to points_bn.count do
	(
	constant  = stringstream ""
	format "points_bn[%].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.stretch.controller.addconstant \"bone_%_size_fix\" (points_bn[%].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)" i a a to: constant
	close constant
	execute (constant as string)
	)
)

-----variables : point du coude comme node, point de l'epaule et longueur de l'avant bras
for i = 2 to points_bn.count do
(
points_bn[i].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.stretch.controller.addconstant "poignet" (points[3])
points_bn[i].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.stretch.controller.addconstant "epaule" (points[1])
)

--- formule de la taille du bras fixe
addition = stringstream ""
format "bone_2_size_fix.value" to: addition
for i = 3 to points_bn.count do
(
format " + bone_%_size_fix.value" i to: addition
)
close addition

-- ecriture du script de stretch
for i = 2 to points_bn.count do
(
os2_pos_x_str = stringstream  ""
format "arm_size = distance epaule poignet
arm_size_fix = %
coef = arm_size / arm_size_fix
if arm_size > arm_size_fix then (bone_%_size_fix.value*coef)  else (bone_%_size_fix.value)" (addition as string) i i to: os2_pos_x_str
close os2_pos_x_str
	
points_bn[i].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.stretch.controller.script = os2_pos_x_str as string
)

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- CREATION DU SCALE SUR LES BONES

---- creation de la contrainte scale en x
for i = 1 to (os.count - 1) do
(
------ recuperer la distance fixe entre deux helper 
dist_temp = distance points_bn[i] points_bn[i+1]

os[i].scale.controller = Bezier_Scale ()
os[i].scale.controller = scale_script ()
	
-- declaration des variables
os[i].scale.controller.addnode "node1" (points_bn[i])
os[i].scale.controller.addnode "node2" (points_bn[i+1])
os[i].scale.controller.addconstant "dist_fix" ( dist_temp )

-- ecriture du script
scale_x = stringstream ""
format "dist_var = distance node1 node2
coef = dist_var / dist_fix
[coef, 1, 1]" to: scale_x
close scale_x

os[i].scale.controller.script = scale_x as string
)

----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
-- COMPENSATION DE LA ROTATION EN X
select os

for o in os do
(
	o.rotation.controller.x_rotation.controller = bezier_float ()
	o.rotation.controller.X_Rotation.controller= float_script ()
	o.rotation.controller.x_rotation.controller = float_list ()
	o.rotation.controller.X_Rotation.controller.Available.controller = float_script ()
	o.rotation.controller.x_rotation.controller.setname 1 "rot_up"
	o.rotation.controller.x_rotation.controller.setname 2 "rot_dw"
)

-- collecter ref_rot_up, ref_rot_dw, target_rot_up, target_rot_dw et régler les poids des controllers
-- collecte target_rot_up
root = os[1].parent
target_rot = for o in root.children where classof o == point collect o
target_rot = for o in target_rot where o.axistripod == true collect o
target_rot_up = target_rot[1]

-- collecte ref_rot_up
root = os[1].parent
ref_rot_up = root.parent

-- creation des variables de rotation up
for o in os do
(
o.rotation.controller.x_rotation.controller.rot_up.controller.addnode "ref_rot_up" (ref_rot_up)
o.rotation.controller.x_rotation.controller.rot_up.controller.addnode "target_rot_up" (target_rot_up)
)

-- ecriture du script de rotation up
script_rot_x_up = stringstream ""
format "rot_xyz = in coordsys ref_rot_up target_rot_up.rotation as eulerangles
rot_xyz.x/180*pi" to: script_rot_x_up
close script_rot_x_up

for o in os do o.rotation.controller.x_rotation.controller.rot_up.controller.script = script_rot_x_up as string

-- collecte target_rot_dw

leaf = os[os.count].parent
target_rot = for o in leaf.children where classof o == point collect o
target_rot = for o in target_rot where o.axistripod == true collect o
target_rot_dw = target_rot[1]

-- collect ref_rot_dw
/*
ik_chain = getnodebyname "IK Chain001"
select ik_chain
*/
ref_rot_dw = ik_chain.parent

-- creation des variables de rotation down
for o in os do
(
o.rotation.controller.x_rotation.controller.rot_dw.controller.addnode "ref_rot_dw" (ref_rot_dw)
o.rotation.controller.x_rotation.controller.rot_dw.controller.addnode "target_rot_dw" (target_rot_dw)
)
-- ecriture du script de rotation down
script_rot_x_dw = stringstream ""
format "rot_xyz = in coordsys ref_rot_dw target_rot_dw.rotation as eulerangles
rot_xyz.x/180*pi" to: script_rot_x_dw
close script_rot_x_dw

for o in os do o.rotation.controller.x_rotation.controller.rot_dw.controller.script = script_rot_x_dw as string


-- réglage des poids de controllers
---- preparation des controller
for o in os do
(
o.rotation.controller.x_rotation.controller.weight[1].controller = bezier_float ()
o.rotation.controller.x_rotation.controller.weight[2].controller = bezier_float ()
)

---- reglage du poids de la rotation up
pas = 100.0/(os.count - 2)
coef = 100
for o in os do 
(
o.rotation.controller.x_rotation.controller.weight[1].controller.value = coef
coef -= pas
)

---- reglage du poids de la rotation dw
pas = 100.0/(os.count - 2)
coef = 0
for o in os do 
(
o.rotation.controller.x_rotation.controller.weight[2].controller.value = coef
coef += pas
)


----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
-- CREATION DES CONTROLEURS SPLINE

crt_point_bns = for i = 1 to points.count collect 
(
circle name: (uniquename "ctr_point_bn") rotation: points[i].rotation pos: points[i].pos radius: 10
)
wire_temp = color (random 0 255) (random 0 255) (random 0 255)
for o in crt_point_bns do o.wirecolor = wire_temp

for i = 1 to points.count do 
(
points[i].parent = crt_point_bns[i]
)

--delete bn_spy_rot
