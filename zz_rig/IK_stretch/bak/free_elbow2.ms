-- bone002, os de l'avant bras, controle la taille du biceps
bone002 =$bone002
-- bone003, os de la main, controle la taille de l'avant bras
bone003 = $bone003
-- point001, controlle la taille du bras quand on uis demande 
point001 = $free_elbow_target

elbow_tgt = $elbow_target

elbow_tgt_lok = $point015

a_cacher =#($free_elbow_target , $Point015 , $Point008 , $Point007 )

fn free_elbow_target_selected =
(
bn2 = bone002.pos.controller.x_position.controller
bn3 = bone003.pos.controller.x_position.controller

-- if free_elbow_target selected
----le free_elbow_controleur recupère la position du coude
point001.pos = bone002.pos
----le coude suit le free_elbow_target
bn2.weight[1] = 100
bn2.weight[2] = 0
	
bn3.weight[1] = 100
bn3.weight[2] = 0

----le elbow target locke
elbow_tgt_lok.pos = elbow_tgt.pos
	
elbow_tgt.pos.controller.weight[1].controller.value = 100
elbow_tgt.pos.controller.weight[2].controller.value = 0

unhide point001
)	


fn elbow_target_selected =
(--if elbow_target selected
bn2.weight[1] = 0
bn2.weight[2] = 100
	
bn3.weight[1] = 0
bn3.weight[2] = 100

elbow_tgt.pos.controller.weight[1].controller.value = 0
elbow_tgt.pos.controller.weight[2].controller.value = 100
elbow_tgt.pos = elbow_tgt_lok.pos 

bn2.bezier_float.controller.value = bn2.float_script1.controller.value
bn3.bezier_float.controller.value = bn3.float_script1.controller.value	

hide a_cacher
)