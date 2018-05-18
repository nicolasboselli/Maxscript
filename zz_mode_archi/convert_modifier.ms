for s in selection do
(
	for m in s.modifiers do
	(
		if classof m == extrude or classof m == shell do
		(
			deletemodifier s m
			addmodifier s (edit_poly())
		)
	)
)