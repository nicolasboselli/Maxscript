
-- collect spline without turntopoly
clearselection()
for o in objects do
(
	if classof o.baseobject == SplineShape and matchpattern  o.name pattern: "*_MDL" then
	(
		turnOk = false
		for m in o.modifiers do
		(
			if classof m == turn_to_poly then turnOk = true
		)
		if turnOk then format "Ok: %\n" o.name
		else if not turnOk then
		(
			format "NOT Ok: %\n" o.name
			selectmore o
		)
		else(print "Fail")
	)
	
)

for s in selection do
(
	for m in s.modifiers where classof m == Point_CacheSpacewarpModifier  do deletemodifier s m
	addmodifier s (turn_to_poly ()) before: 1
)

for s in selection do 
(
	xformPresent = false
	for m in s.modifiers where classof m == xform do xformPresent = true
	
	if xformPresent == false then addmodifier s (xform ())
)