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
