
-- ##### create spline controls with skin modifier

fn skinSpline ligne =
(
-- 	ligne = $
	-- recuperation des numeros de knots important
	local knotsCount = numKnots ligne

	local helpAr = #()
	-- create controls on knots
	for i = 1 to knotsCount do
	(
		newPos = getKnotPoint ligne 1 i
		format "point % : % \n" i newpos
		newHlp = point rotation: ligne.rotation pos: newPos cross: false box: true axis_tripod: true size: 10
		append helpAr newHlp
	)

	select helpAr
	-- add skin on spline 
	select ligne
	oneSkin = skin()
	modPanel.addModToSelection oneSkin ui:on
		
	-- add control on skin
	for i = 1 to helpAr.count  do
	(
		if i == helpAr.count then	skinOps.addbone ligne.skin helpAr[i] 0
		else skinOps.addbone ligne.skin helpAr[i] -1
	)
	
	-- skin vertices
	modPanel.setCurrentObject oneSkin

	verts = skinOps.GetNumberVertices  oneSkin
	bns = skinOps.GetNumberBones oneSkin
	-- (bns-1)*3 + 1
	for i = 1 to bns do
	(
		format "vertice % to bone %\n" ((i-1)*3 + 1) i 
		skinOps.ReplaceVertexWeights  oneSkin  ((i-1)*3 + 1) i  1
		
		format "vertice % to bone %\n" ((i-1)*3 + 2) i 
		skinOps.ReplaceVertexWeights  oneSkin  ((i-1)*3 + 2) i  1
		
		format "vertice % to bone %\n" ((i-1)*3 + 3) i 
		skinOps.ReplaceVertexWeights  oneSkin  ((i-1)*3 + 3) i  1
	)
	
	
	helpAr
)
skinSpline $

-- apply tunage de bones
sel = selection as array
ctrls = bonesTuning sel
select ctrls

-- tunage de box
ctrls = selection as array
--#################### create control spline
-- oneLine = $tuyau_spline
-- oneLine = $line001
-- oneLine = $tentacle_spline
oneLine = $

part = 100.0/(ctrls.count-1)

--####################### create orientation spline
-- duplicate line 
upLine = copy oneLine

-- clean copy
for i = 1 to upLine.modifiers.count do deletemodifier upLine 1

-- move line on z
move upline [0,0,10]


-- duplicate helpers
upHlps = #()
for ctr  in ctrls do
(
	upHlp = copy ctr
	upHlp.pos.controller = Position_XYZ ()
	upHlp.rotation.controller = Euler_XYZ ()
	move upHlp [0,0,5]
	upHlp.name = uniquename "upHelper_"
	append upHlps upHlp
)
select upHlps

-- constraint copies on line 
percent = 0
for h in upHlps do
(
	h.pos.controller = Position_XYZ ()
	h.pos.controller = position_list ()
	h.pos.controller.available.controller = Path_Constraint ()
	h.pos.controller.Path_Constraint.controller.path = upLine
	h.pos.controller.Path_Constraint.controller.percent = percent
	h.pos.controller.Path_Constraint.controller.loop = off
	percent = percent + part
	deleteKeys h.pos.controller #allKeys
)


-- ##################  CONSTRAINTS HELPERS ON SPLINE
-- contraints helper on line
-- add position contraint
percent = 0
for ctrl in ctrls do
(
	ctrl.pos.controller = Position_XYZ ()
	ctrl.pos.controller = position_list ()
	ctrl.pos.controller.available.controller = Path_Constraint ()
	ctrl.pos.controller.Path_Constraint.controller.path = oneLine
	ctrl.pos.controller.Path_Constraint.controller.percent = percent
	ctrl.pos.controller.Path_Constraint.controller.loop = off
	percent = percent + part
	deleteKeys ctrl.pos.controller #allKeys
)

-- add look at contsraint
for i= 1 to (ctrls.count - 1) do
(
	-- add lookat
	-- 
	ctrls[i].rotation.controller = Euler_XYZ ()
	ctrls[i].rotation.controller = rotation_list ()
	
	ctrls[i].rotation.controller.available.controller = LookAt_Constraint ()
	ctrls[i].rotation.controller.LookAt_Constraint.controller.constraints.appendTarget ctrls[i+1] 100
	ctrls[i].rotation.controller.LookAt_Constraint.controller.upnode_world = off
	ctrls[i].rotation.controller.LookAt_Constraint.controller.pickUpNode = upHlps[i]
	ctrls[i].rotation.controller.LookAt_Constraint.controller.upnode_ctrl = 0
	ctrls[i].rotation.controller.LookAt_Constraint.controller.viewline_length_abs = off


)

-- upnode on orientation control

/*
-- ############## CREATE original helpers Control
-- create spline_ik_control on spline
splineCtrl = spline_ik_control ()

select oneLine
modPanel.addModToSelection splineCtrl ui:on

knotsCount = splineCtrl.getKnotCount() 
splineCtrl.noLinking()
splineCtrl.createHelper knotsCount
crtlsList = splineCtrl.spline_ik_control.helper_list


-- for each spline ctrl create controller
for i = 1 to knotsCount do
(
	format "point %: %\n" i (getKnotPoint  oneLine 1 i)
)


-- ############## CREATE copies helpers Control
-- create spline_ik_control on spline
splineCtrl = spline_ik_control ()

select upLine
modPanel.addModToSelection splineCtrl ui:on

knotsCount = splineCtrl.getKnotCount() 
splineCtrl.noLinking()
splineCtrl.createHelper knotsCount
upsList = splineCtrl.helper_list 
*/
-- parent orientation controls to bones lines
crtlsList = skinSpline oneLine
upsList  = skinSpline upLine

for i = 1 to crtlsList.count do
(
	upsList[i].parent = crtlsList[i]
)

-- package rig
-- add controller

-- crtlsList = selection as array

circlesAr = #()
for ctr in crtlsList do
(
	c = circle transform: ctr.transform radius: 10
	converttosplineshape c
	c.objectOffsetRot = (eulerangles 90 0 0) as quat
	
	ctr.parent = c
	append circlesAr c
)

select circlesAr
-- freeze controller


-- param helper on copy helpers

-- color controls
sel = selection as array

for s in sel do
(
	s.wirecolor = yellow
)

-- fix parent
sel = selection as array

for i = 2 to sel.count do
(
	sel[i].parent = sel[i-1]
	print sel[i]
)

-- fix ctrol size
sel = selection as array
for s in sel do s.size = 5
