bn = $ as array
bn_hlp = for o in bn collect in coordsys parent o.position.controller.getnode 1
bn_pos_old = for o in bn_hlp collect o.pos

for o in bn do 
(
o.boneFreezeLength=false
o.rotation.controller = euler_xyz ()
o.position.controller  = position_xyz ()
)

-- realign bone
-- reset stretch bone

bn_new_pos = for o in bn collect o.pos
-- move from new to old position

for i = 1 to bn.count do
(
bn_move = bn_pos_old[i] - bn_new_pos[i]
move bn[i] bn_move
bn_new_pos = for o in bn collect o.pos
)
