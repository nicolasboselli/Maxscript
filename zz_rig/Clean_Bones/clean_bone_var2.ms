--bn = $ as array
bn = #($)
bn_hlp = for o in bn collect in coordsys parent o.position.controller.getnode 1
bn_pos_old = for o in bn_hlp collect o.pos
	
for o in bn do 
(
o.boneFreezeLength=false
o.rotation.controller = euler_xyz ()
o.position.controller  = position_xyz ()
o.parent = undefined
)

for i = 1 to bn.count do
(
bn[i].pos = bn_pos_old[i]
)