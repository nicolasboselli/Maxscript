

rollout sceneTestContructorRLT "Scene Test Constructor"
(
-- vars
	local matSol = Arch___Design__mi name: "matSol" diff_color: (color 125 125 125)
	local matArray = for i = 1 to 5 collect Arch___Design__mi name: (uniquename "RandMat_"+ i as string) diff_color: (color (random 0 255)  (random 0 255)  (random 0 255))

	local solBox
	local testBox = #()
		
	button createSceneBT "Create Scene"
	button deleteBox "Delete Boxes"
	
	
	on createSceneBT pressed do
	(
		testBox = #()
		solBox = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:500 width:500 height:-10 mapcoords:on pos:[0,0,0] material: matSol

		testBox = for i = 1 to 20 collect
		(
			Box name: ( uniquename "testBox") lengthsegs:1 widthsegs:1 heightsegs:1 \
			length:50 width:50 height:50 mapcoords:on \
			rotation: (eulerAngles (random 0 360) (random 0 360) (random 0 360) ) \
			pos:[ (random -250 250) ,(random -250 250) ,0] \
			material: matArray[(random 1 5)]
		)
	)
	
	on deleteBox pressed do
	(
		delete solBox; delete testBox;
	)
)
createdialog sceneTestContructorRLT

