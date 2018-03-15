--VARIABLES

-- bone002, os de l'avant bras, controle la taille du biceps
format "bone002 =$bone002 \n" 
-- bone003, os de la main, controle la taille de l'avant bras
format "bone003 = $bone003 \n" 
-- point001, controlle la taille du bras quand on uis demande 
format "point001 = $free_elbow_target \n" 

format "bn2 = bone002.pos.controller.x_position.controller \n" 
format "bn3 = bone003.pos.controller.x_position.controller \n" 

format "bn2_pos = 	$bone002.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.Bezier_Float.controller \n" 
format "bn3_pos =  $bone003.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.Bezier_Float.controller	\n" 

--ROLLOUT

format "rollout free_elbow \"free elbow!\" width:162 height:300 \n" 
format "( \n checkButton ckb1 \"liberer le coude!\"pos:[32,56] width:105 height:54" 
format "on ckb1 changed state do \n"			
-- etat du coude libéré
format "if state == on then \n"	  
format "(\n elbow_keys = bn2_pos.keys \n"
format "free_elbow_pos = $free_elbow_target.pos.track \n"
format "deletekeys free_elbow_pos #allkeys \n"

-- collecte des positions du coude au point clés
format "anim_free_elbow = for o in elbow_keys collect at time o.time in coordsys $Point007  bone002.pos \n\n"
--collage des positions du coude au point clés
format "animate on \n (for i = 1 to elbow_keys.count  do at time elbow_keys[i].time point001.pos.track.value = anim_free_elbow[i])\n\n"

----le free_elbow_controleur recupère la position du coude
format "animate on\n	point001.pos = bone002.pos"
----le coude suit le free_elbow_target
	
	--nettoyer les courbes de poids des os
bn2.weight[1] = 100
bn2.weight[2] = 0
bn2.weight[3] = 0
	
bn3.weight[1] = 100
bn3.weight[2] = 0
bn3.weight[3] = 0

	)

  else 
-- coude captif
(

	--nettoyer les courbes de poids des os
deletekeys bn2.weight #allkeys
deletekeys bn3.weight #allkeys
-- nettoyer les piste  de position x des os avant bras et biceps
deletekeys bn2_pos #allkeys
deletekeys bn3_pos #allkeys
-- transférer animation du controleur de position du free_elbow vers les controleur  de position en x des os.
---- récupérer les numéros de frame des points clés sur la piste de position du free_elbow_target
free_elbow_keys = point001.pos.track.position_xyz.track.keys
	
----  recuperer taille os avant bras : position en x de $bone 003 = distance entre $free elbow et $point003
---- taille os du biceps : position en x de $bone002 =  distance entre $free elbow et $point002
anim_bn_2 = for o in free_elbow_keys collect at time o.time distance point001 $point002 
anim_bn_3 = for o in free_elbow_keys collect at time o.time distance point001 $point003 
---- coller taille os
animate on
	(
	for i = 1 to free_elbow_keys.count  do at time free_elbow_keys[i].time bn2_pos.value = anim_bn_2[i]
	for i = 1 to free_elbow_keys.count  do at time free_elbow_keys[i].time bn3_pos.value = anim_bn_3[i]
	)
animate off

	
bn2.weight[1] = 0
bn2.weight[2] = 100
bn2.weight[3] = 0
	
bn3.weight[1] = 0
bn3.weight[2] = 100
bn3.weight[3] = 0
	
	)	
)

createdialog free_elbow