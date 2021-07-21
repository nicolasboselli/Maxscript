$.pivot = [0,0,0]
$.pivot

-- transforme la position absolu du vertex en position relative par rapport au transform
transMatrix(($.pivot) * inverse $.transform) --node: $
$.pivot = (transMatrix([0,5,0]) * $.transform).translation

ref
sel = #()
for s in selection do
(
	if iskindof s dummy then
	(
		ref = s
	)
	else
	(
		converttopoly s
		append sel s
	)
)	

for s in sel do
(
	format "%\n" (in coordsys ref s.pivot)
)

fn testPivot =
(
	format "%\n" s.pivot
	/*
	if s.pivot.z >= zmax + zMaxRange then(format "youpi\n")
	else(format "hello world!\n")
	*/
)
--
bakpos = $.position
in coordsys parent $.rotation = (quat 0 0 0 1)
$.position = bakpos


rotate $ (eulerangles 0 0 90)
rotateZMatrix  90
$.parent.transform

$.transform = (rotateZMatrix  0) * $.transform 