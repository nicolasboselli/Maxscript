-- return morph target
sel = WM3_MC_GetTarget $.modifiers[2] 1
select sel

-- return lookat upnode
select $.rotation.controller.pickUpNode 

select $.rotation.controller[3].pickupnode


-- return orientation target
ctrl = $.rotation.controller
ctrl = $.rotation.controller[1].controller

res = for i = 1 to ctrl.getNumTargets() collect ctrl.getNode i
select res-- find path in path constraint

-- select spline of path constraint
select  $.position.controller[2].controller.path

	

-- find biped controller value
/*
$.transform.controller[1].bipscalelist[1].y_scale = 100
$.transform.controller[1].bipscalelist[1].x_scale = 100
$.transform.controller[1].bipscalelist[1].controller.value
classof $.transform.controller[1].bipscalelist[1].controller

ref = $.position.controller.position_xyz.controller
*/

-- select controller instance
ref = $.scale.controller

ref = $.rotation.controller[2].controller

objAr = objects as array
instObj = #()

for o in objAr do
(
	try
	(
-- 		res = o.scale.controller
		res = o.rotation.controller[2].controller
		if res == ref then append instObj o
	)
	catch()
)
select instObj

-- find biped scale on subanim and reset
geomAr = geometry as array
bipAr = #()
for o in geomAr do
(
	
	isBip = false
	try
	(
		res = o.transform.controller[1].bipscalelist[1].controller

		if classof res == ScaleXYZ then
		(
			format "bip:%, scale:%\n" o res.value
			isBip = true
		)
	)
	catch()
	
	if isBip == true then append bipAr o
)

select bipAr

for b in bipAr do
(
	b.transform.controller[1].bipscalelist[1].controller.value = [1,1,1]
)

-- find pivot offset

$.objectoffsetpos 
$.objectoffsetscale
$.objectoffsetrot

nodeLocalBoundingBox $


-- exposetm nodes
selectmore $.exposeNode 
selectmore $.localReferenceNode 

-- sym
$.pos
$.rotation.z

$.scale.controller.value = [1,1,1]

sym = copy $

refPos = $.position
refRot = $.rotation

sym.rotation = (quat refRot.w refRot.z refRot.y refRot.x)
sym.pos = [(refpos.x*-1), refpos.y, refpos.z]

$.scale

$.scale = [-1,-1,-1]

$.scale = [1,1,1]

$.material = undefined


sel = selection as array

for s in sel do
(
	s.scale = [1,1,1]
	format "obj: %, scale: %\n" s.name s.scale
)
