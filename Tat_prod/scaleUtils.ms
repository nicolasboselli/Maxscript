-- print scale
fn printScaleInfo =
(
	for s in selection do
	(
		try
		(
		format "name: %, scale: %, value: %, offset: %\n" s.name s.scale s.scale.controller.value s.objectoffsetscale
		)
		catch(format "name: %, FAIL\n" s.name)
	)
)
printscaleInfo()

-- keep^non conform in selection
for s in selection where s.scale.controller.value == [1,1,1] do deselect s

$.scale.controller.value == [1,1,1]
$.scale.controller.value.z == 1

for s in selection do
(
	format "name: %, rotation: %, value: %, offset: %\n" s.name s.rotation s.rotation.controller.value s.objectoffsetrot
)

$.modifiers[#xform].gizmo.rotation.controller.value

$.rotation
$.rotation.controller.value

[0.48314,0.48314,0.48314]

sel = selection as array
sel[2].scale.controller.value = sel[1].scale.controller.value 

$.scale
$.objectoffsetscale = [1,1,1]
$.objectoffsetrot =(quat -1 0 0 0)
$.objectoffsetrot =(quat 0 0 0 1)
$.objectoffsetpos = [0.000237465,0.300432,1.85429]
$.scale.controller.value = [1,1,1]

-- transfert scale
sel = selection as array
sel[2].scale.controller.value = sel[1].scale.controller.value 

superclassof $
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

$.modifiers[#xform].gizmo.controller.scale = [0.69,0.69,0.69]

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

$.rotation.controller[1].value = in coordsys parent  $.rotation
$.rotation.controller[2].value = (quat 0 0 0 1)

$.rotation.controller[1].value
$.rotation.controller[2].value

$.rotation
in coordsys parent  $.rotation

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

$.scale = [1,1,1]
$.scale.controller.value = [1,1,1]

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

$.transform.controller[1].bipscalelist[1].controller.value
$.transform.controller[1].bipscalelist[1].controller.value = [1,1,1]
$.transform.controller[1].bipscalelist[1].controller.value.x = 0.8

showproperties $.transform.controller[1]
$.transform.controller.Biped_SubAnim.controller

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

$.material = undefined

-- bipskin reperes
bsRoot = $P_ElephantA_BIPSKINref_ROOT

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


