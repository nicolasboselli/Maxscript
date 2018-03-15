try(destroyDialog rotationRLT)catch()

rollout rotationRLT "world rotation"
(
	fn rotateInWorld s ang X Y Z =
	(
		undo on
		(
			rotate s (angleAxis ang [x,y,z])
		)
	)
	
	group "X"
	(
		button X90BT "+90" across: 2
		button Xm90BT "-90"
	)
	group "Y"
	(
		button Y90BT "+90"  across: 2
		button Ym90BT "-90"
	)
	group "Z"
	(
		button Z90BT "+90"  across: 2
		button Zm90BT "-90"
	)
	
	on X90BT pressed do rotateInWorld $ 90 1 0 0
-- 	on Xm90BT pressed do rotate $ (angleAxis -90 [1,0,0])
	on Xm90BT pressed do rotateInWorld $ -90 1 0 0
-- 	on Y90BT pressed do rotate $ (angleAxis 90 [0,1,0])
	on Y90BT pressed do rotateInWorld $ 90 0 1 0
-- 	on Ym90BT pressed do rotate $ (angleAxis -90 [0,1,0])
	on Ym90BT pressed do rotateInWorld $ -90 0 1 0
-- 	on Z90BT pressed do rotate $ (angleAxis 90 [0,0,1])	
	on Z90BT pressed do rotateInWorld $ 90 0 0 1
-- 	on Zm90BT pressed do rotate $ (angleAxis -90 [0,0,1])
	on Zm90BT pressed do rotateInWorld $ -90 0 0 1

)

createDialog rotationRLT