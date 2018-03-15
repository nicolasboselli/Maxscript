bn = $ as array
--bn = #($)
--bn_hlp = for o in bn collect in coordsys parent o.position.controller.getnode 1
--bn_pos_old = for o in bn_hlp collect o.pos

--bn_pos = for o in bn collect o.position

for i = 1 to (bn.count ) do 
(
bn[i].parent = undefined
bn[i].boneFreezeLength=false
bn[i].rotation.controller = euler_xyz ()
bn[i].position.controller  = position_xyz ()
pos_temp = bn[i].pos
bn[i].transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] pos_temp)
bn[i].wirecolor = color 27 177 27
)

for i = 2 to bn.count do bn[i].parent = bn[i-1]


/*
for i = 1 to bn.count do
(
bn[i].pos = bn_pos[i]
)
*/
--bn[i].parent = bn[i-1]
