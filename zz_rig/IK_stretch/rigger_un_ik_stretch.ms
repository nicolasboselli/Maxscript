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

for i = 2 to points_bn.count do
points_bn[i].parent = points_bn[i-1]

-- creation de trois point espion de rotation
bn_spy_rot = for i = 1 to os.count collect
(
point name: (uniquename "bn_spy_rot") rotation: os[i].rotation pos:os[i].pos size: 5 box:false cross: false axistripod:true
)

for i = 1 to bn_spy_rot.count do bn_spy_rot[i].parent = os[i].parent

--créer une ik
ik_chain = IKSys.ikChain points_bn[1] points_bn[3] "IKHISolver"

-- CREER LES BONES TUNES

for i= 1 to os.count do
(
os[i].pos.controller = Position_Constraint ()
os[i].pos.controller.constraints.appendTarget points_bn[i] 100
)

for i= 1 to os.count-1 do
(
os[i].rotation.controller = LookAt_Constraint ()
os[i].rotation.controller.constraints.appendTarget points_bn[i+1] 100
os[i].rotation.controller.upnode_world = off
os[i].rotation.controller.pickUpNode = points_bn[i]
os[i].rotation.controller.upnode_ctrl = 1
os[i].rotation.controller.viewline_length_abs = off
)

--création de trois points pour controle des points bones
points = for i = 1 to os.count collect point name: (uniquename "point_bn_ctr") rotation:bn_spy_rot[i].rotation pos: points_bn[i].pos box: on axistripod: off size: 7


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

-- CREATION DU STRETCH

--A sur l'os du coude, preparation du controller de position en x
--1 créer une liste de controller de position en x 
--2 creer un bezier float pour memoriser la taille initiale de l'os
os2_pos = points_bn[2].transform.controller.FK_Sub_Control.controller.Position.controller


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
os2_pos_x.stretch.controller.addconstant "biceps_fix" (points_bn[2].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)
os2_pos_x.stretch.controller.script = "biceps_fix.value"

--B preparation du controller de position en x sur l'os du poignet
--1 créer une liste de controller de position en x 
--2 creer un bezier float pour memoriser la taille initiale de l'os
os3_pos = points_bn[3].transform.controller.FK_Sub_Control.controller.Position.controller

os3_pos.x_position.controller   = bezier_float ()
os3_pos.x_position.controller = float_list ()

os3_pos_x = os3_pos.x_position.controller

--3 créer un script float pour délarer le script
os3_pos_x.available.controller = float_script ()
os3_pos_x.setname 1 "zero"
os3_pos_x.setname 2 "stretch"
--4 activer le position script
os3_pos_x.setactive 2
os3_pos_x.weight[1].controller = bezier_float ()
os3_pos_x.weight[2].controller = bezier_float ()
os3_pos_x.weight[1].controller.value = 0
--5 variable longueur de l'avant bras fixe : av_bras_fix = position en x de os[3]
os3_pos_x.stretch.controller.addconstant "av_bras_fix" (points_bn[3].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)
os3_pos_x.stretch.controller.script = "av_bras_fix.value"

--C écrire le script du coude
-----variables : point du coude comme node, point de l'epaule et longueur de l'avant bras
os2_pos_x.stretch.controller.addconstant "poignet" (points[3])
os2_pos_x.stretch.controller.addconstant "epaule" (points[1])
os2_pos_x.stretch.controller.addconstant "av_bras_fix" (points_bn[3].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)

os2_pos_x_str = stringstream  ""
format "arm_size = distance epaule poignet
arm_size_fix = biceps_fix.value + av_bras_fix.value
coef = arm_size / arm_size_fix
if arm_size > arm_size_fix then (biceps_fix.value*coef)  else (biceps_fix.value)" to: os2_pos_x_str
os2_pos_x.stretch.controller.script = os2_pos_x_str as string

--D écrire le script du poignet
-----variables : point du coude comme node, point de l'epaule et longueur du biceps
os3_pos_x.stretch.controller.addconstant "poignet" (points[3])
os3_pos_x.stretch.controller.addconstant "epaule" (points[1])
os3_pos_x.stretch.controller.addconstant "biceps_fix" (points_bn[2].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)

os3_pos_x_str = stringstream  ""
format "arm_size = distance epaule poignet
arm_size_fix = biceps_fix.value + av_bras_fix.value 
coef = arm_size/arm_size_fix 
if arm_size > arm_size_fix then (av_bras_fix.value*coef) else (av_bras_fix.value)" to: os3_pos_x_str
os3_pos_x.stretch.controller.script = os3_pos_x_str as string

-- CREATION DES CONTROLEURS SPLINE

crt_point_bns = for i = 1 to points.count collect 
(
circle name: (uniquename "ctr_point_bn") rotation: points[i].rotation pos: points[i].pos radius: 10
)

for i = 1 to points.count do 
(
points[i].pos.controller = Position_Constraint ()
points[i].pos.controller.constraints.appendTarget crt_point_bns[i] 100
)

delete bn_spy_rot