undo on
(
	sel = selection as array
	for s in sel do
		(
			for m in s.modifiers do deletemodifier s m
		)
)
	
