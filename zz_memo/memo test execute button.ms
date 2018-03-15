rollout Copy_Paste_Pose "Copy Paste Pose" width:200 height:320
	(
	button record "record" pos:[10,50] width:80 height:30
	button listen "listen" pos:[100,50] width:80 height:30


	--local genila = $box004
	foo = for i = 1 to 10 collect "pose_" + (i as string)
		
		
	
	on record pressed  do
(

			--pose_1 = (execute "$box003")
			--execute ("print "dirladada"")
			--pose_1 = 5
			--execute ("pose_1") =execute ("5")
			pose_1 = execute "Copy_Paste_Pose.genila"
			-- execute ((pose_1 = test.name) as string)
			pose_2 = genila

		
		
)

on listen pressed do 
	(
	print pose_1
	print pose_2
	)
)
Createdialog Copy_Paste_Pose