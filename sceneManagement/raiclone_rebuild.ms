sel = geometry as array
for s in sel where classof s == railclone_pro do
(
	if s.autoUpdate == off then
	(
		s.autoUpdate = on
		redrawviews ()
		s.autoUpdate = off
	)
	else()
)


