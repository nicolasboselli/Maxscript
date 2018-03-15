-- à partir d'un os selectionné en faire trois de même taille
---- (on ne peu pa utiliser le scale, le ffd et avec l'edit poly c'est la chiotte)
---- recupérer les deux helpers de reference

-- bug: l'os du haut tourne trop lorsque le bras est étiré. changé la formule pour cet os: 
-- rot_xyz = in coordsys target_rot ref_rot.rotation as eulerangles
-- rot_xyz.x/180*pi*coef*-1


root = $.parent 
child_temp = for o in root.children where classof o == point collect o
child = child_temp[1]

---- calculer les quatre points necessaire au positionnement des bones
inter1 = root.pos + ((child.pos - root.pos)*0.33)
inter2 = root.pos + ((child.pos - root.pos)*0.66)

twist_bn_pos = #(root.pos, inter1, inter2, child.pos)

---- creer une nouvelle chaine de bones 
c = [1,0,0]

twist_bn = for i = 1 to (twist_bn_pos.count - 1 ) collect
(
	BoneSys.createBone twist_bn_pos[i] twist_bn_pos[i+1]  c 
)

---- linker chaque bone au helper de depart
for o in twist_bn do o.parent = root
	
delete $

------------------------------------------------------------------------------------------------
-- CREATION DU POS_SCRIT X
coef = 0

for i = 1 to (twist_bn.count) do
(
twist_bn[i].pos.controller.X_Position.controller = bezier_float  ()
twist_bn[i].pos.controller.X_Position.controller = float_script ()
	
-- declaration des variables
twist_bn[i].pos.controller.X_Position.controller.addnode "node1" (root)
twist_bn[i].pos.controller.X_Position.controller.addnode "node2" (child)
twist_bn[i].pos.controller.X_Position.controller.addconstant "coef" ( coef )

-- ecriture du script
pos_x = stringstream ""
format "dist_var = distance node1 node2
dist_var*coef" to: pos_x
close pos_x

twist_bn[i].pos.controller.X_Position.controller.script = pos_x as string
	
coef += 0.33
)
------------------------------------------------------------------------------------------------
-- CREATION DU SCALE_SCRIT X
---- recupérer les helpers de reference
for i = 1 to (twist_bn.count) do
(
------ recuperer la distance fixe entre deux helper 
dist_temp = distance root child

twist_bn[i].scale.controller = Bezier_Scale ()
twist_bn[i].scale.controller = scale_script ()
	
-- declaration des variables
twist_bn[i].scale.controller.addnode "node1" (root)
twist_bn[i].scale.controller.addnode "node2" (child)
twist_bn[i].scale.controller.addconstant "dist_fix" ( dist_temp )

-- ecriture du script
scale_x = stringstream ""
format "dist_var = distance node1 node2
coef = dist_var / dist_fix
[coef, 1, 1]" to: scale_x
close scale_x

twist_bn[i].scale.controller.script = scale_x as string
)

------------------------------------------------------------------------------------------------
-- CREATION DU ROT_SCRIT X


-- sur chaque bone compenser la rotation en x du bone pour créer le twist
-- recuperer le spy_rot comme target_rot
target_rot = for o in root.children where classof o == point collect o
target_rot = for o in target_rot where o.axistripod == true collect o
target_rot = target_rot[1]

-- recuperer le point_bn_ctr001 comme ref_rot
ref_rot = root.parent
--- creer un coefficient multiplicateur en fonction de la position du bone dans la chaine
multi  = 1

--bn_num = bn.count - 2
--pas = 1.0/bn_num

for i = 1 to (twist_bn.count) do

(
--- creer un controleur script en rotation x sur le bone
twist_bn[i].rotation.controller.x_rotation.controller = Bezier_Float ()
twist_bn[i].rotation.controller.x_rotation.controller = float_script ()

--- creer les variable
twist_bn[i].rotation.controller.x_rotation.controller.addnode "ref_rot" (ref_rot) 
twist_bn[i].rotation.controller.x_rotation.controller.addnode "target_rot" (target_rot) 
twist_bn[i].rotation.controller.x_rotation.controller.addconstant "coef" (multi) 

--- ecrire le script 
script_rot_x = stringstream ""
format "rot_xyz = in coordsys ref_rot target_rot.rotation as eulerangles
rot_xyz.x/180*pi*coef" to: script_rot_x
close script_rot_x

twist_bn[i].rotation.controller.x_rotation.controller.script = script_rot_x as string

-- reevaluation du coef
multi -= 0.5
)



---- recuperer les helpers de reference (mettre un spy_rot si nessecaire)
---- calculer un coef multiplicateur de la rotation
