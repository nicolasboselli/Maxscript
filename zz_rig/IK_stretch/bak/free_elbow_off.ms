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