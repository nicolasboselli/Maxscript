-- gym fk bones
sel = selection as array

curFr = currenttime 
jump = 20
angX = -75
angY = 0
angZ = 0

for o in sel do
(
	animate on 
	(
		at time  curFr rotate o (eulerangles 0 0 0)
		at time  (curFr + jump ) in coordsys local rotate o (eulerangles -angX -angY -angZ)
		at time  (curFr + jump + 1) in coordsys local rotate o (eulerangles angX angY angZ)
	)
	curFr+= jump
)

-- gym tete biped

sel = selection as array

curFr = currenttime 
jump = 5


for o in sel do
(
	animate on 
	(
		at time  curFr rotate o (eulerangles 0 0 0)
		at time  (curFr + 5) in coordsys local rotate o (eulerangles 0 0 45)
		at time  (curFr + 6) in coordsys local rotate o (eulerangles 0 0 -45)
		at time  (curFr + 10) in coordsys local rotate o (eulerangles 0 0 -45)
		at time  (curFr + 11) in coordsys local rotate o (eulerangles 0 0 45)
		
	)
	curFr+= 10
)

res = in coordsys parent $.transform.rotation
res as eulerangles

$.transform.rotation

-- gym clavicule biped

-- gym neck bones
sel = selection as array

curFr = currenttime 
jump = 5
for o in sel do
(
	animate on 
	(
		at time  curFr rotate o (eulerangles 0 0 0)
		at time  (curFr + 5) in coordsys local rotate o (eulerangles -90 0 0)
		at time  (curFr + 6) in coordsys local rotate o (eulerangles 90 0 0)
	)
	curFr+= 5
)


sel = selection as array

for s in sel do s.scale = [1,1,1]