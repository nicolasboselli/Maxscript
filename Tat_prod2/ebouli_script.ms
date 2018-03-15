sel= geometry as array

-- sel = selection as array
-- clearselection()


-- pat = "*_MDL"
pat = "*_LO"
-- select sel
for s in sel do
(
	res = matchpattern s.name pattern: pat
	if res == true then
	(
-- 		coord = nodeGetBoundingBox s
		selectmore s
	)
)

-- parentCtrl = $A_Ebouli_Parent_PLOT

fn addPlot s parentCtrl = 
(
	lo = getNodebyname (substitutestring s.name "_MDL" "_LO")
	coord = nodeLocalBoundingBox s

	coord = nodeGetBoundingBox s s.transform
	w = distance [coord[1].x, 0, 0] [coord[2].x, 0, 0]
	l = distance [0, coord[1].y, 0] [0, coord[2].y, 0] 
	h = distance [0,0,coord[1].z] [0,0, coord[2].z]

	-- ctrlPos = s.center

	ctrl = box length: l width: w height: h
	addmodifier ctrl (xform())
	-- $.modifiers[#xform].gizmo.position = [0,0,coord[1].z]

	ctrl.name = substitutestring s.name "_MDL" "_PLOT"

	ctrl.rotation = s.rotation
	ctrl.center = s.center
	ctrl.pivot = s.pivot

	-- reset position
	ctrl.modifiers[#xform].gizmo.rotation = ctrl.objectoffsetrot 
	ctrl.objectoffsetrot = (quat 0 0 0 1)	

	ctrl.modifiers[#xform].gizmo.position = ctrl.objectoffsetpos 
	ctrl.objectoffsetpos = [0,0,0]

	ctrl.modifiers[#xform].gizmo.scale = ctrl.objectoffsetscale
	ctrl.objectoffsetscale = [1,1,1]
	
	/*
	-- parent
	s.parent = ctrl
	if lo != undefined do lo.parent = ctrl
	ctrl.boxmode = true
	if parentCtrl != undefined do	ctrl.parent = parentCtrl
	*/
	
	-- ajout de ctrl modifier
-- 	addmodifier ctrl (EmptyModifier name: "PLOT")
)

-- parentCtrl = $Point001
sel = selection as array
for s in sel do
(
	addPlot s parentCtrl
)



-- rename ctrl
geom = geometry as array
for g in geom do
(
	res = matchpattern g.name pattern: "*_PLOT"
	if res == true do addmodifier g (EmptyModifier name: "PLOT")
)

geom = geometry as array
-- select geom
for g in geom do
(
	res = matchpattern g.name pattern: "*_MDL"
	if res == true then
	(
		print g
		lo = getNodebyname (substitutestring g.name "_MDL" "_LO")
		if lo == undefined do selectmore g
	)
		
)



-- update xform position
$.modifiers[#xform].gizmo.position =  $.modifiers[#xform].gizmo.position + $.objectoffsetpos
$.objectoffsetpos = [0,0,0]