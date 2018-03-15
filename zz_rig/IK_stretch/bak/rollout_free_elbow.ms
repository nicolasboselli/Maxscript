def = attributes boton

(	
parameters main rollout:free_elbow
	(
)
--ROLLOUT
 rollout free_elbow "free elbow!" width:162 height:300  

  (
	checkButton ckb1 "liberer le coude!"pos:[32,56] width:105 height:54 
		 on ckb1 changed state do  

-- etat du coude libéré
 if state == on then  
	(
		
--variable
bone002 =  os[2] 
bone003 =  os[3] 
point001 = free_elbow_target 
point7 =  free_elbow_target_hlp 
epaule =  points[1] 
poignet = points[3] 

 bn2 = bone002.pos.controller.x_position.controller 
 bn3 = bone003.pos.controller.x_position.controller   

 bn2_pos = 	bone002.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.backup.controller  
 bn3_pos =   bone003.transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller.backup.controller	
		
		
		
		
	  elbow_keys = bn2_pos.keys  
	 free_elbow_pos = point001.pos.track  
	 deletekeys free_elbow_pos #allkeys 

-- collecte des positions du coude au point clés
 anim_free_elbow = for o in elbow_keys collect at time o.time in coordsys Point7  bone002.pos 
	  
--collage des positions du coude au point clés
 animate on
	 (for i = 1 to elbow_keys.count  do at time elbow_keys[i].time point001.pos.track.value = anim_free_elbow[i])
  

----le free_elbow_controleur recupère la position du coude
 animate on
	 point001.pos = bone002.pos
  
----le coude suit le free_elbow_target
	
	--nettoyer les courbes de poids des os
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

-- coude captif
--nettoyer les courbes de poids des os

 (deletekeys bn2.weight #allkeys 
 deletekeys bn3.weight #allkeys 

-- nettoyer les piste  de position x des os avant bras et biceps

 deletekeys bn2_pos #allkeys 
 deletekeys bn3_pos #allkeys 
-- transférer animation du controleur de position du free_elbow vers les controleur  de position en x des os.
---- récupérer les numéros de frame des points clés sur la piste de position du free_elbow_target
 free_elbow_keys = point001.pos.controller.keys 
	
----  recuperer taille os avant bras : position en x de $bone 003 = distance entre $free elbow et $point003
---- taille os du biceps : position en x de $bone002 =  distance entre $free elbow et $point002
 anim_bn_2 = for o in free_elbow_keys collect at time o.time distance point001 epaule  
 anim_bn_3 = for o in free_elbow_keys collect at time o.time distance point001 poignet  
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
	  bn2.weight[4] = 0
	  
 bn3.weight[1] = 0
	  bn3.weight[2] = 100
	  bn3.weight[3] = 0 
	  bn3.weight[4] = 0
	 )
	 ) 
 )
 
 modPanel.addModToSelection (emptymodifier ()) ui:on
 custAttributes.add $.modifiers[#'Attribute Holder'] def
 
 -- createdialog free_elbow

