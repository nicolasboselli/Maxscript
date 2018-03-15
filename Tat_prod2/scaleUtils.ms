-- print scale info
fn printScaleInfo =
(
	for s in selection do
	(
		try
		(
		format "name: %, scale: %, egalité réelle à 1: %, value: %, scale offset: %, rot offset: % \n " s.name s.scale (s.scale == [1,1,1]) s.scale.controller.value s.objectoffsetscale s.objectoffsetrot
		)
		catch(format "name: %, FAIL\n" s.name)
	)
)
printscaleInfo()


-- print rotation info
for s in selection do
(
	format "name: %, rotation: %, value: %, offset: %\n" s.name s.rotation s.rotation.controller.value s.objectoffsetrot
)

-- select object avec scale different de [1,1,1]
sel = selection as array
clearselection()
for s in sel do
(
	scale1 = false

	if close_enough s.scale.x 1.0 6 and close_enough s.scale.y 1.0 6 and close_enough s.scale.z 1.0 6 then scale1 = true
	
	if not scale1 do 
	(
		format "s: %, scale: %, scale1:%\n" s.name s.scale scale1
		selectmore s
	)
)



-- select object avec offset de  scale different de [1,1,1]
sel = selection as array
clearselection()
for s in sel do
(
	offsetClean = false
	
	if close_enough s.objectoffsetscale.x 1.0 6 and close_enough s.objectoffsetscale.y 1.0 6 and close_enough s.objectoffsetscale.z 1.0 6 then offsetClean = true

	if not offsetClean do
	(
		format "s: %, scaleOffset:%, offsetClean: %\n" s.name s.objectoffsetscale offsetClean
		selectmore s
	)
)

-- clean offset
sel = selection as array
for s in sel do
(
	doclean = false
	scale1 = false
	offsetClean = false
	
	if not close_enough s.objectoffsetscale.x 1.0 6 or not close_enough s.objectoffsetscale.y 1.0 6 or not close_enough s.objectoffsetscale.z 1.0 6 then offsetClean = false
	if close_enough s.scale.x 1.0 6 and close_enough s.scale.y 1.0 6 and close_enough s.scale.z 1.0 6 then scale1 = true
	
	if scale1 and not offsetClean then	doClean = true

	if s.modifiers["xform"] != undefined then
	(
		s.modifiers["xform"].gizmo.position = s.modifiers["xform"].gizmo.position * s.objectoffsetscale
		format "CLEAN scale offset : %, class: % \n" s.name (classof s.modifiers["xform"])
-- 		print "done"
	)
	
	if not doClean then
	(
		format "DEJA CLEAN scale offset : %, class: %\n" s.name (classof s.baseobject)
	)
	else if classof s.baseobject == SplineShape then
	(
		xf = xform ()
		addmodifier s xf
		xf.gizmo.scale = s.objectoffsetscale
		s.objectoffsetscale = [1,1,1]
		format "NOT CLEAN scale offset : %, class: % \n" s.name (classof s.baseobject)
	)
	else if classof s.baseobject == Editable_Poly then
	(
		xf = xform ()
		addmodifier s xf
		xf.gizmo.scale = s.objectoffsetscale
		s.objectoffsetscale = [1,1,1]
		format "CLEAN scale offset : %, class: % \n" s.name (classof s.baseobject)
	)
	else if classof s.baseobject == box and doClean then
	(
		s.length = s.length * s.objectoffsetscale.x
		s.width = s.width * s.objectoffsetscale.y
		s.height = s.height * s.objectoffsetscale.z
		
		s.objectoffsetscale = [1,1,1]
		format "CLEAN scale offset : %, class: % \n" s.name (classof s.baseobject)
	)
	else if classof s.baseobject == point and doClean then
	(
		if s.objectoffsetscale.x > 0 then s.size = s.size * s.objectoffsetscale.x
		s.objectoffsetscale = [1,1,1]
		format "CLEAN scale offset : %, class: % \n" s.name (classof s.baseobject)
	)
	else
	(
		format "NOT CLEAN scale offset : %, scale: % , class: % \n" s.name s.objectoffsetscale (classof s.baseobject)
	)
)

-- init xform modifier
fn resetScaleXform s =
(
	undo on
	(
		resetscale s
		count = s.modifiers.count
		addmodifier s (xform()) before: count
		s.modifiers[#xform].gizmo.scale = s.objectoffsetscale
		s.objectoffsetscale = [1,1,1]
-- 		converttopoly s
	)
)
for s in selection do resetScaleXform s

-- rescale helpers
fn rescaleHelperXform s=
(
	undo on
	(
		resetscale s
		s.objectoffsetscale = [1,1,1]
	)
)
for s in selection do rescaleHelperXform s

-- rescale helpers negatif en scale
-- $.scale = [-1,-1, -1]
s = $
bakChilds = for c in s.children collect c
for c in bakChilds do c.parent = undefined

s.scale.controller.value = [-1, -1,  -1]
s.objectoffsetscale = [1,1,1]

for c in bakChilds do c.parent = s


-- unpdate freeze transform values
fn updateFreezeTransform s =
(
	s.position.controller[1].value = s.position.controller[1].value + s.position.controller[2].value
	s.position.controller[2].value = [0,0,0]
	
	/*
	s.rotation.controller[1].value = in coordsys parent  s.rotation
	s.rotation.controller[2].value = (quat 0 0 0 1)
	*/
)
for s in selection do updateFreezeTransform s



for s in selection do 
(
	resetScaleXform s
	updateFreezeTransform s
)

-- reset scale in selection
for s in selection do resetscale s


-- rescale to 1, except biped
for s in selection do
(
	res = findstring  s.name "BIP"
	if res == undefined then
	(
		s.scale =  [1,1,1]
	)
)

for s in selection do
(
	res = findstring  s.name "BIP"
	if res == undefined then
	(
		s.scale.controller.value = [1,1,1]
-- 		s.objectoffsetscale = [1,1,1]
	)
)


fn resetInPlace s =
(
	bakparent = s.parent
	bakChilds = for c in s.children collect c
		
	tmpPt = point rotation: s.rotation position: s.position name: (s.name + "_tmpPt")
	s.parent = tmpPt
	for c in bakChilds do c.parent = undefined
	resetxform s
	
	s.parent = bakparent
	for c in bakChilds do c.parent = s
		
	delete tmpPt
)

sel = selection as array
for s in sel do resetInPlace s

-- insert offsetscale rig
fn insertNCorrectScaleOffset s =
(
	undo on
	(
		-- collecter parent et enfant de sel
		bakparent = s.parent
	-- 	bakChilds = for c in s.children collect c
		s.parent = undefined
		-- creer point
	-- 	tmpPt = point rotation: s.rotation position: s.position scale: s.scale.controller.value name: (substitutestring s.name "_CTRL" "_ScaleOffset_RIG")
		tmpPt = point rotation: s.rotation position: s.position scale: s.scale.controller.value name: (substitutestring s.name "_CTRL" "_Parent_RIG") \
		wirecolor:green box: false cross: true
		s.parent = tmpPt
		redrawViews() 
		tmpPt.parent = bakparent
	)

)
for s in selection do insertNCorrectScaleOffset s



-- Biped scale
for s in selection do s.transform.controller[1].bipscalelist[1].controller.value = [1,1,1]
 

for s in selection do 
(
	try (s.transform.controller[1].bipscalelist[1].controller.value = [1,1,1])catch()
)

for s in selection do 
(
	try (s.transform.controller[1].bippositionlist[1].controller.value = [0,0,0])catch()
)

-- transfert scale
sel = selection as array
sel[2].scale.controller.value = sel[1].scale.controller.value


-- change bipskin
bsAr = #()
geom = geometry as array
for g in geom do
(
	res = findstring g.name "_BIPSKIN"
	if res != undefined then append bsAr g
)
select bsAr

bxAr = #()
geom = geometry as array
for g in geom do
(
	res = findstring g.name "_BOXBIP"
	if res != undefined then append bxAr g
)
select bxAr

bipAr = #()
for bs in bsAr do
(
	search = substitutestring bs.name "_BIPSKIN" "_BIP"
	res = getnodebyname search
	if res != undefined then append bipAr res
)
select bipAr
selectmore bsAr

-- reparent
for s in selection do
(
	dad = s.parent
	for c in s.children do c.parent = dad
)

-- switch _bipskin to _rig
for s in selection do
(
	switchPt = point rotation: s.rotation position: s.position scale: s.scale name: (substitutestring s.name "_BIPSKIN" "_Offset_RIG")
	dad = s.parent
	switchPt.parent = s.parent
	for c in s.children do c.parent = switchPt
)


-- find offset scale 
offsAr = #()
geom = helpers as array
for g in geom do
(
	res = findstring g.name "_Offset_RIG"
	if res != undefined then append offsAr g
)
select offsAr

bbpAr = #()
for offs in offsAr do
(
	search = substitutestring offs.name "_Offset_RIG" "_BOXBIP"
	res = getnodebyname search
	if res != undefined then append bbpAr res
)
select bbpAr
selectmore offsAr


-- transfert parent
for o in offsAr do
(
	search = substitutestring o.name "_Offset_RIG" "_BOXBIP"
	res = getnodebyname search
	if res != undefined then
	(
		format "parent: %, boxbip: %, offset: %\n" o.parent.name res.name o.name
		res.parent = o.parent
	)
	else(format "fail: % \n" o.name)
-- 	delete o
)

for o in offsAr do
(
	if  o.children.count == 0 do selectmore o
)

-- bipskin reperes
bsRepAr = #()
for b in bsar do
(
	bsPt = point  rotation: b.rotation pos: b.position name: (b.name + "_rep")
	bsPt.parent = bsRoot
	append bsRepAr bsPt 
)
select bsRepAr
selectmore bsAr

distance selection[1] selection[2]


-- remove xform

for s in selection do
(
	modTodel = s.modifiers[#xform]
	if modTodel != undefined then deleteModifier s modTodel
)

--
for s in selection do
(
	modTodel = s.modifiers[#xform]
	if modTodel == undefined then addmodifier s (xform ())
)

sel = selection as array
for s in sel do
(
	s.transform = s.transform * (scaleMatrix [-1,1,1])
	resetscale s
)


$.transform.controller[1].bipscalelist[1].controller.value
$.transform.controller[1].bipscalelist[1].controller.value = [1,1,1]
$.transform.controller[1].bipscalelist[1].controller.value.x = 0.8

showproperties $.transform.controller[1]
$.transform.controller.Biped_SubAnim.controller

$.rotation = (quat 1 0 0 0)

$.scale == [1,1,1]
$.scale.controller.value = [1,1,1]

$.scale.z as IntegerPtr 

2 as double

$.scale = [-1,-1,-1]

$.modifiers["xform"].gizmo.scale = [-1,-1,-1]

$.rotation.controller[1].value = in coordsys parent  $.rotation
$.rotation.controller[2].value = (quat 0 0 0 1)

$.rotation.controller[1].value
$.rotation.controller[2].value

$.rotation
in coordsys parent  $.rotation
	


$.modifiers[#xform].gizmo.rotation.controller.value

$.rotation
$.rotation.controller.value

$.scale.controller.value = [1,1,1]
$.scale.controller.value.z == 1

sel = selection as array
sel[2].scale.controller.value = sel[1].scale.controller.value 

$.scale = [-1,-1,-1]

$.modifiers["xform"].gizmo.scale =  $.objectoffsetscale
$.objectoffsetscale  = [1,1,1]

resetscale $

for s in selection do resetscale s

var = 100017.911 

floor($.scale.z) == 1

close_enough $.scale.z 1.0 6

$.scale.z == 1.00000006

$.scale.controller.value == [1,1,1]
$.scale == [1.0,1.0,1.0]
$.objectoffsetscale == [1,1,1]

$.scale = [1,1,1]
$.scale = [2,2,3]

$.objectoffsetscale = [1,1,1]
$.objectoffsetscale = [-1,-1,-1]

$.objectoffsetrot =(quat 0 0 0 1)
$.objectoffsetrot =(quat -1 0 0 0)

$.objectoffsetrot

$.objectoffsetrot =(quat 0 0 0 1)
$.objectoffsetpos = [0.000237465,0.300432,1.85429]
$.scale.controller.value = [1,1,1]

-- transfert scale
sel = selection as array
sel[2].scale.controller.value = sel[1].scale.controller.value 

superclassof $
