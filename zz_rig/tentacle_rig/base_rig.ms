-- point rotation: $.rotation position: $.position

sel = selection as array

for s in sel do
(
	pt = point rotation: s.rotation position: s.position name: (s.name + "_hlp")
	s.parent = pt
)

size = 160

-- contraint to path

l = $tentacle_line

ctrls = selection as array
ctrls.count
i = 0
part = 1.0/(ctrls.count-1)

for c in ctrls do 
(
	c.position.controller = path_constraint path: l percent: (i*part*100)
	i += 1
)

-- look at contraint

sel = selection as array

slave = sel[1]
target = sel[2]
upnode = sel[3]

look = lookat_constraint pickUpNode: upnode upnode_world: false viewline_length_abs: false
look.appendTarget target 100

slave.rotation.controller = look

-- resize 
sel = selection as array

for s in sel do s.size = 20
