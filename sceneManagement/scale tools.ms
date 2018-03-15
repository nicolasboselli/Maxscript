fn printscale =
(
	for s in selection do
	(
		format "obj: %, scale: %, value: %, offset: % \n" s.name s.scale s.scale.controller.value s.objectoffsetscale
	)
)
printscale()


resetscale $
$.objectoffsetscale = [1,1,1]