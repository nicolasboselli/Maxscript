-- créer une spline sur os contraint
os = $ as array

os_pos = for o in os collect in coordsys parent o.pos

test = line ()
addnewspline test
for i = 1 to os.count do 
addknot test 1 #corner #line os_pos[i]
updateshape test

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- créer une spline sur os libre

os = $ as array

os_pos = for o in os collect o.pos

test = line ()
addnewspline test
for i = 1 to os.count do 
addknot test 1 #smooth #curve os_pos[i]
updateshape test

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
test1 =point ()
test1_pos = interpBezier3D $line004 1 1 0
test1.pos = test1_pos

test2 =point ()
test2_pos = interpBezier3D $line004 1 2 1
test2.pos = test2_pos

test3 = point ()
test3_pos = interpBezier3D $line004 1 4 1
test3.pos = test3_pos

tn = point ()
tn_pos = tangentBezier3D $line004 1 1 0
tn.pos = test1_pos + tn_pos * 100

tn2 = point ()
tn2_pos = tangentBezier3D $line004 1 2 1
tn2.pos = test2_pos + tn2_pos * 100

tn3 = point ()
tn3_pos = tangentBezier3D $line004 1 2 1
tn3.pos = test2_pos - tn2_pos * 100

tn4 = point ()
tn4_pos = tangentBezier3D $line004 1 4 1
tn4.pos = test3_pos - tn4_pos * 100

deleteKnot $line004 1 2

deleteKnot $line004 1 3

--setSegmentType 
--setknottype test 1 2 #bezier

--test.pos

boness= $ as array
boness_pos = for o in boness collect (in coordsys world o.pos)
boness_pos2 = for o in boness collect  o.pos
boness[3]

hlps = $ as array
hlps_pos = for o in hlps collect (in coordsys world o.pos)
hlps_pos2 = for o in hlps collect o.pos
	
os[1].pos.controller