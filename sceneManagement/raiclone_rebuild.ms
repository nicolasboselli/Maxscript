sel = geometry as array
for s in sel where classof s == railclone_pro do
(
	format "rc: %\n" s.name
	if s.autoUpdate == off then
	(
		
		s.autoUpdate = on
		select s
		redrawviews ()
		s.autoUpdate = off
	)
	else()
)


