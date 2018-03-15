--DEBUG

---- bloquer le ctr_free_elbow en y ou z
---- bloquer le ctr quand le coude est locké
---- rendre immobile le parent du ctr_free elbow
---- 
---- modifier le script pourqu'il fonctionne sur des point et non sur des bones (c'est pas les mêmes pistes)





-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- CREER UNE IK CHAIN

--à partir de trois bones
os = $ as array

-- verifier que l'array est dans le bon sens
--placer trois point a la place des os et construire l'ik sur ces points
--créer une ik
ik_chain = IKSys.ikChain os[1] os[3] "IKHISolver"

--création de trois points
points = for i = 1 to os.count collect point () 
for o in points do
(
points.Box = on
points.axistripod = off
)
--alignement des trois points sur les os 

for i = 1 to os.count do
(
	points[i].rotation =  os[i].rotation 
	points[i].pos = os[i].pos
)
--parente ik_chain avec un helper
os[1].parent = points[1] 
-- parente le premier os avec un helper
ik_chain.parent = points[3] 

--faire du point du milieu le controleur de la rotation de l'ik
ik_chain.transform.controller.VHTarget = points[2]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

-- CREER LE STRETCH

--A sur l'os du coude, preparation du controller de position en x
--1 créer une liste de controller de position en x 
--2 creer un bezier float pour memoriser la taille initiale de l'os
os2_pos = os[2].transform.controller.FK_Sub_Control.controller.Position.controller


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
os2_pos_x.stretch.controller.addconstant "biceps_fix" (os[2].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)
os2_pos_x.stretch.controller.script = "biceps_fix.value"

--B preparation du controller de position en x sur l'os du poignet
--1 créer une liste de controller de position en x 
--2 creer un bezier float pour memoriser la taille initiale de l'os
os3_pos = os[3].transform.controller.FK_Sub_Control.controller.Position.controller

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
os3_pos_x.stretch.controller.addconstant "av_bras_fix" (os[3].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)
os3_pos_x.stretch.controller.script = "av_bras_fix.value"

--C écrire le script du coude
-----variables : point du coude comme node, point de l'epaule et longueur de l'avant bras
os2_pos_x.stretch.controller.addconstant "poignet" (points[3])
os2_pos_x.stretch.controller.addconstant "epaule" (points[1])
os2_pos_x.stretch.controller.addconstant "av_bras_fix" (os[3].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)

aa = "(arm_size = distance epaule poignet) \n"
bb = "(arm_size_fix = biceps_fix.value + av_bras_fix.value) \n"
cc =" (coef = arm_size / arm_size_fix) \n"
dd = " (if arm_size > arm_size_fix then (biceps_fix.value*coef)  else (biceps_fix.value))"
os2_pos_x.stretch.controller.script = aa + bb +cc +dd 


--D écrire le script du poignet
-----variables : point du coude comme node, point de l'epaule et longueur du biceps
os3_pos_x.stretch.controller.addconstant "poignet" (points[3])
os3_pos_x.stretch.controller.addconstant "epaule" (points[1])
os3_pos_x.stretch.controller.addconstant "biceps_fix" (os[2].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.zero.controller)

aa = "arm_size = distance epaule poignet\n "
bb = "arm_size_fix = biceps_fix.value + av_bras_fix.value \n "
cc = "coef = arm_size/arm_size_fix \n "
dd = "if arm_size > arm_size_fix then (av_bras_fix.value*coef) else (av_bras_fix.value)"
os3_pos_x.stretch.controller.script = aa +bb +cc +dd

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

--CREER LE FREE ELBOW

--creer le dispositif:
---créer un helper de trois splines
cercle = for i= 1 to 3 collect circle ()


rotate cercle[1]  (angleaxis 90 [1,0,0])
rotate cercle[2]  (angleaxis 90 [0,1,0])
rotate cercle[3] (angleaxis 90 [0,0,1])

 for o in cercle do
	(
	select o
	modPanel.addModToSelection (Edit_Spline ()) ui:on
	maxOps.CollapseNodeTo o 1 off
	)

for i = 2 to cercle.count do
addandweld cercle[1] cercle[i] 10

	
test = stringstream ""
format "ctr_free_elbow_target%" (random 1 100) to: test
cercle[1].name = test as string

---- deux points, un entre epaule et poigent, orienté vers le helper de "twist ik", l'autre enfant de celui là
--free_elbow_target = point ()
free_elbow_target = cercle[1]
free_elbow_target.pos = os[2].pos
free_elbow_target.pos.controller = Position_XYZ ()
free_elbow_target.pos.controller = position_list ()
free_elbow_target.pos.controller.Available.controller = position_script ()
free_elbow_target.pos.controller.setname 1  "free"
free_elbow_target.pos.controller.setname 2  "lock"


free_elbow_target_hlp = point ()
free_elbow_target_hlp.pos.controller = Position_Constraint ()
free_elbow_target_hlp.pos.controller.constraints.appendTarget points[1] 50
free_elbow_target_hlp.pos.controller.constraints.appendTarget points[3] 50

free_elbow_target_hlp.rotation.controller = LookAt_Constraint ()
free_elbow_target_hlp.rotation.controller.constraints.appendTarget points[1] 100
free_elbow_target_hlp.rotation.controller.upnode_world = off
free_elbow_target_hlp.rotation.controller.pickUpNode = points[2]
free_elbow_target_hlp.rotation.controller.upnode_ctrl = 0

--cercle[1].parent = free_elbow_target_hlp
--free_elbow_target.parent = cercle[1]
free_elbow_target.parent = free_elbow_target_hlp
--free_elbow_target.pos = free_elbow_target_hlp.pos
free_elbow_target.pos = os[2].pos

AlignToParent free_elbow_target

------mettre en place les controleur de position sur les os, deux controllers, un pour suivre le free_elbow_target, un pour récupérer la position du free_elbow_target
----génération controller free_elbow os2
-----génération controller de position
os2_pos_x.available.controller = float_script ()
os2_pos_x.available.controller = bezier_float ()
os2_pos_x.setname 3 "lock"
os2_pos_x.setname 4 "backup"

------génération  les controller de poids
os2_pos_x.weight[3].controller = bezier_float ()
os2_pos_x.weight[4].controller = bezier_float ()
os2_pos_x.weight[3].controller.value = 0
os2_pos_x.weight[4].controller.value = 0

-------- déclaration des variables
os2_pos_x.lock.controller.addconstant "poignet" (points[3])
os2_pos_x.lock.controller.addconstant "epaule" (points[1])
os2_pos_x.lock.controller.addconstant "free_elbow_target" (free_elbow_target)
-------- écriture du script lock
os2_pos_x.lock.controller.script = "distance free_elbow_target epaule"
-------- modification du stretch



----génération controller free_elbow os3
-----génération controller de position
os3_pos_x.available.controller = float_script ()
os3_pos_x.available.controller = bezier_float ()
os3_pos_x.setname 3 "lock"
os3_pos_x.setname 4 "backup"
------génération  les controller de poids
os3_pos_x.weight[3].controller = bezier_float ()
os3_pos_x.weight[4].controller = bezier_float ()
os3_pos_x.weight[3].controller.value = 0
os3_pos_x.weight[4].controller.value = 0

-------- déclaration des variables
os3_pos_x.lock.controller.addconstant "poignet" (points[3])
os3_pos_x.lock.controller.addconstant "epaule" (points[1])
os3_pos_x.lock.controller.addconstant "free_elbow_target" (free_elbow_target)

-------- écriture du script lock
os3_pos_x.lock.controller.script = "distance free_elbow_target poignet"

------- modification des stretch
os2_pos_x.backup.controller.value = os2_pos_x.zero.controller.value
os2_pos_x.stretch.controller.addconstant "biceps_fix" 	(os[2].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.backup.controller)
os2_pos_x.stretch.controller.addconstant "av_bras_fix" 	(os[3].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.backup.controller)

os3_pos_x.backup.controller.value = os3_pos_x.zero.controller.value
os3_pos_x.stretch.controller.addconstant "biceps_fix" 	(os[2].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.backup.controller)
os3_pos_x.stretch.controller.addconstant "av_bras_fix" 	(os[3].transform.controller.FK_Sub_Control.controller.Position.controller.x_position.controller.backup.controller)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--GENERER LE SCRIPT DE LIBERATION DU COUDE

------------------------------------------
bof = createfile "bof"

format "def = attributes boton

(
	parameters main rollout:free_elbow (
	)
	
	 rollout free_elbow \"free elbow!\" width:162 height:300 
	( 
		checkButton ckb1 \"liberer le coude!\"pos:[32,56] width:105 height:54
		 
		on ckb1 changed state do 

			if state == on then 
			(\n" to: bof
				format "bone002 = $%\n" 	os[2].name to: bof
format "bone003 = $%\n" 	os[3].name to: bof
format "point001 = $%\n" 	cercle[1].name to: bof
format "point7 = $%\n" 	free_elbow_target_hlp.name to: bof
format "epaule =$%\n" 		points[1].name to: bof
format "poignet =$%\n" 	points[3].name to: bof
				format "execute yo

				bn2 = bone002.pos.controller.x_position.controller 
bn3 = bone003.pos.controller.x_position.controller 
 
bn2_pos = 		bone002.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.backup.controller 
bn3_pos =  	bone003.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.backup.controller	

		 elbow_keys = bn2_pos.keys 
		 free_elbow_pos = point001.pos.track 
		 deletekeys free_elbow_pos #allkeys 

anim_free_elbow = for o in elbow_keys collect at time o.time in coordsys Point7  bone002.pos 

animate on 
 (for i = 1 to elbow_keys.count  do at time elbow_keys[i].time point001.pos.track.value = anim_free_elbow[i])

animate on
(
point001.pos = bone002.pos

)
bn2.weight[1] = 0
 bn2.weight[2] = 0
 bn2.weight[3] = 100
 bn2.weight[4] = 0

bn3.weight[1] = 0
 bn3.weight[2] = 0
 bn3.weight[3] = 100 
 bn3.weight[4] = 0

			)
			
			else
			(\n" rd_name to: bof
				format "bone002 = $%\n" 	os[2].name to: bof
format "bone003 = $%\n" 	os[3].name to: bof
format "point001 = $%\n" 	cercle[1].name to: bof
format "point7 = $%\n" 	free_elbow_target_hlp.name to: bof
format "epaule =$%\n" 		points[1].name to: bof
format "poignet =$%\n" 	points[3].name to: bof
				format "execute yo 
	
				bn2 = bone002.pos.controller.x_position.controller 
bn3 = bone003.pos.controller.x_position.controller 
 
bn2_pos = 	bone002.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.backup.controller 
bn3_pos =  bone003.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.backup.controller	


deletekeys bn2.weight #allkeys
deletekeys bn3.weight #allkeys
deletekeys bn2_pos #allkeys
deletekeys bn3_pos #allkeys

free_elbow_keys = point001.pos.controller.free.controller.keys

anim_bn_2 = for o in free_elbow_keys collect at time o.time distance point001 epaule 
anim_bn_3 = for o in free_elbow_keys collect at time o.time distance point001 poignet 

animate on
	(
	for i = 1 to free_elbow_keys.count  do at time free_elbow_keys[i].time bn2_pos.value = anim_bn_2[i]
	for i = 1 to free_elbow_keys.count  do at time free_elbow_keys[i].time bn3_pos.value = anim_bn_3[i]
)
animate off
bn2.weight[1] = 0
 bn2.weight[2] = 100
 bn2.weight[3] = 0
 bn2.weight[4] = 0

bn3.weight[1] = 0
 bn3.weight[2] = 100
 bn3.weight[3] = 0 
 bn3.weight[4] = 0
			)	
	)
)
select cercle[1]
modPanel.addModToSelection (emptymodifier ()) ui:on
custAttributes.add $.modifiers[#'Attribute Holder'] def\n" rd_name to: bof
	
close bof
edit "bof"
assaut = openfile "bof"
execute assaut


--yo = openfile "toto3.ms"
--execute yo
--close yo



-- enregistrer le script quelque part
-- créer un bouton sur le free_elbow_target pour charger le rollout
----créer un modifier
----placer le modifier sur le free_elbow_target


--CREER LES TWIST BONES

--CREER UN STRETCH ANIMABLE

--CREER LE PASSAGE FK/IK

--suppression des points

--delete points
















