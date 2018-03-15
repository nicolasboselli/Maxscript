sel = selection as array

for s in sel do
(
	in coordsys local s.position.y = - 1
)

-- random position
undo on
(
	for s in sel do
	(
		in coordsys local s.position.x = random -5 5
		in coordsys local s.position.y = 0
		in coordsys local s.position.z = random -5 5
	)
)

in coordsys  $.position.x = 1
-- $.controller.position.controller.value.x

test = #toto

if test == #toto do print test
	

print "yo\rtoto"


sel = selection as array
undo on
(
	for s in sel do
	(
		refAngle = in coordsys local s.controller.rotation as eulerangles
		in coordsys local s.controller.rotation = eulerangles refAngle.y (random -5.0 5.0) refAngle.z
	)
)


sel = selection as array
undo on
(
	for s in sel do
	(
		maxVal = 1.5
		minVal = 0.7
		scaleVar = s.controller.scale.y
		s.controller.scale.x = random minVal maxVal
-- 		scaleVar = in coordsys local s.controller.scale.y
-- 		print scaleVar
	)
)



s = $
jump = 15

copyAr = for i = 1 to 100 collect
(
	maxVal = 1.5
	minVal = 0.7
	c = copy s
	in coordsys local c.position.x = jump
	c.controller.scale.x = random minVal maxVal
	jump +=  random 10 20
	c
)
select copyAr
