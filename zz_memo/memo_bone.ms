bn = $ as array

bn_pts = for i = 1 to bn.count collect point ()

for i = 1 to bn_pts.count do
	( 
	bn_pts[i].pos = bn[i].pos
	bn[i].pos.controller = Position_xyz ()
	bn[i].pos.controller = Position_Constraint ()
	bn[i].pos.controller.constraints.appendtarget bn_pts[i] 100
--	bn[i].rotation.controller = Position_Constraint ()
	)
	

	
c = [0,0,0]


os = for i= 1 to (bn_pts.count-1) do (BoneSys.createBone bn_pts[i].pos  bn_pts[i+1].pos  c )

bn_pts[1].pos