

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- CREATION DE LA SPLINE
-- creation de la spline
s = splineshape ()
knot_pos = #([0,0,50], [50, 0, 0], [100, 0, 50])
addnewspline s

for i = 1 to knot_pos.count do addknot s 1 #smooth #curve knot_pos[i]
updateshape s	

for i = 1 to knot_pos.count do setKnotType s 1 i #bezier
updateshape s	

-- creation du parent de la spline
hlp_s_pos = point rotation: s.rotation pos: s.position name: (uniquename "hlp_s_pos")
s.parent = hlp_s_pos

-- apparition des controller knots
animatevertex s #all


-- creation des assistants de position

num_knots = numknots s


knot_pos = for i = 1 to (num_knots*3) collect s[4][8][i]

hlp_knot = for o in knot_pos collect point size: 5 name: (uniquename "hlp_knot")

for i = 1 to (num_knots*3) do in coordsys hlp_s_pos hlp_knot[i].position = knot_pos[i].value


-- contrainte aux assistants de position
for i = 1 to knot_pos.count do
(
s[4][8][i].controller = bezier_point3 ()
s[4][8][i].controller = point3_script ()

s[4][8][i].addconstant "spline_pos" hlp_s_pos
s[4][8][i].addconstant "hlp_pos" hlp_knot[i]
s[4][8][i].script = "in coordsys spline_pos hlp_pos.pos"
)

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- CREATION DES POINTS TEST
/*
-- contrainte de point sur la spline
test = test_rot_dw
for i = 1 to test.count do
(

test[i].controller.position.controller = path_constraint ()
test[i].position.controller.constraints.appendTarget s 50
deletekeys test[i].pos.controller #allkeys


test[i].pos.controller.PERCENT.controller = float_list ()
test[i].pos.controller.PERCENT.controller.available.controller = float_script ()
percent = 0.2 * i
test[i].pos.controller.PERCENT.controller.float_script.controller.addconstant "percent" percent
test[i].pos.controller.PERCENT.controller.float_script.controller.script = "percent"
test[i].pos.controller.loop = off
test[i].pos.controller.PERCENT.controller.weight[1] = 0
)
*/

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
/*

-- creation des points test de position
test = for i = 1 to 5 collect 	point name: (uniquename "aaa")

-- creation des points test de rotation
test_rot_dw = for i = 1 to 5 collect 	point name: (uniquename "aaa_dw")

for o in test_rot_dw do o.axistripod = on

for i =  1 to test_rot_dw.count do 
(
test_rot_dw[i].position.controller = Position_constraint ()
test_rot_dw[i].position.controller.constraints.appendTarget test[i] 50
)

for i =  2 to test_rot_dw.count do 
(

test_rot_dw[i].rotation.controller = Euler_xyz ()
test_rot_dw[i].rotation.controller = LookAt_Constraint ()
test_rot_dw[i].rotation.controller.constraints.appendTarget test_rot_dw[i-1] 50
test_rot_dw[i].rotation.controller.viewline_length_abs = off
test_rot_dw[i].rotation.controller.target_axis = 2
test_rot_dw[i].rotation.controller.target_axisFlip = on

test_rot_dw[i].rotation.controller.upnode_world = off
test_rot_dw[i].rotation.controller.pickUpNode = test_rot_dw[i-1]
test_rot_dw[i].rotation.controller.upnode_ctrl = 1

test_rot_dw[i].rotation.controller.upnode_axis = 1
test_rot_dw[i].rotation.controller.StoUP_axis = 1
)

-- test_rot_dw = for i = 1 to 5 collect 	point name: (uniquename "aaa_dw")
-- for o in test_rot_dw do o.axistripod = on
*/
/*
-- positionnement des points test de rotation
test_pos_ctr = for o in test collect o.pos.controller 
for i = 1 to test.count do
(
test_rot_up[i].pos.controller = position_xyz ()
test_rot_up[i].pos.controller = copy test_pos_ctr[i]
test_rot_dw[i].pos.controller = position_xyz ()
test_rot_dw[i].pos.controller = copy test_pos_ctr[i]
)
*/
-- orientation des points de rotation down

/*

select hlp_spline
test = $ as array
for o in test do print o.name
	
select $point003
*/