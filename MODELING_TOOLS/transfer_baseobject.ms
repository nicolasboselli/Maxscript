sel = selection as array
for i = 2 to sel.count do
(
	sel[i].baseobject = sel[1].baseobject
)