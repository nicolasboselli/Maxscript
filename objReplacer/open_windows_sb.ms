bakpos = $.position
in coordsys parent $.rotation = (quat 0 0 0 1)
$.position = bakpos


rotate $ (eulerangles 0 0 90)


getUserProp 
setUserProp $ "pivotFenetre" "true"

sel = selection as array
-- ouverture de la fenetre
for s in sel do
(
	local res
	try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = false)
	if res then
	(
		rotate s (eulerangles 0 0 90)
	)
)

-- femeture de la fenetre
for s in sel do
(
	local res
	try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = false)
	if res then
	(
		bakpos = s.position
		in coordsys parent s.rotation = (quat 0 0 0 1)
		s.position = bakpos
	)
)