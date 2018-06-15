undo on
(
	for s in selection do
	(
		
		format "name: % s.scale: % scale.value: % \n" s.name s.scale s.scale.controller.value

			s.scale.controller.value = [1,1,1]

	)
)

