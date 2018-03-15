-- bone002, os de l'avant bras, controle la taille du biceps
bone002 =$bone002
-- bone003, os de la main, controle la taille de l'avant bras
bone003 = $bone003
-- point001, controlle la taille du bras quand on uis demande 
point001 = $free_elbow_target

elbow_tgt = $elbow_target

elbow_tgt_lok = $point015

bn2 = bone002.pos.controller.x_position.controller
bn3 = bone003.pos.controller.x_position.controller

rollout tracker "tracker" width:162 height:300
(
	checkButton ckb1 "lier position" pos:[32,56] width:105 height:54
		on ckb1 changed state do
			
-- etat du coude libéré
  if state == on then 
	  
(
-- le free_elbow_controleur recupère la position du coude
point001.pos = bone002.pos
-- le coude suit le free_elbow_target
bn2.weight[1] = 100
bn2.weight[2] = 0
	
bn3.weight[1] = 100
bn3.weight[2] = 0

-- le elbow target locke
elbow_tgt_lok.pos = elbow_tgt.pos
	
elbow_tgt.pos.controller.weight[1].controller.value = 100
elbow_tgt.pos.controller.weight[2].controller.value = 0
	
-- le elbow target suit le free elbow target
	)

  else 

(
bn2.weight[1] = 0
bn2.weight[2] = 100
	
bn3.weight[1] = 0
bn3.weight[2] = 100

elbow_tgt.pos.controller.weight[1].controller.value = 0
elbow_tgt.pos.controller.weight[2].controller.value = 100

	)
	
		button btn1 "enregistrer position" pos:[28,166] width:110 height:51
	on btn1 pressed do
	(
	
		fram = slidertime
		
		animate on 
			(at time fram 
				(bn2.bezier_float.controller.value = bn2.float_script1.controller.value
					bn3.bezier_float.controller.value = bn3.float_script1.controller.value)
				))
	
)

createdialog tracker

--rajouter un bouton pour positionner le coude sur le helper