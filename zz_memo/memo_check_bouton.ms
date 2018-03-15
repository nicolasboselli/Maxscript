p2 = $point002.pos.controller

rollout check "Untitled" width:162 height:300
(
	checkButton test "test" checked: false pos:[29,59] width:103 height:68
	on test changed state do

  if state == on then 
	  
(
p2.weight[1] = 100
p2.weight[2] = 0
	)

  else 

(
p2.position_xyz.controller.value = p2.position_script.controller.value
p2.weight[1] = 0
p2.weight[2] = 100
	)

)

createdialog check
