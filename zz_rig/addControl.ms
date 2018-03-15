sel = selection as array

for s in sel do
(
	ctrl = circle radius: 1 transform: s.transform name: (s.name + "_ctrl")
	s.parent = ctrl
)

sel = selection as array
for s in sel do
(
	bakParent = s.parent
	zeroHlp = point transform: s.transform name: (s.name + "_zero") parent: bakParent
	s.parent = zeroHlp
)


$.objectoffsetpos
$.objectoffsetrot = (eulerangles 0 90 0) as quat
$.objectoffsetscale = [2,2,2]




