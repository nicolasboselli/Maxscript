-- twist de l'avant bras

rootPoint = $.controller.position.controller.getnode 1
targetPoint = $.controller.rotation.controller.getnode 1

wire_temp = randomColor ()

pas = 0

-- contrainte de position
twistPointAr = for i = 1 to 4 collect
(
	pointTemp =  point name: (uniquename "twistPoint_") wirecolor: wire_temp size: 3 
	pointTemp.position.controller = position_constraint ()
	
	pointTemp.position.controller.appendTarget rootPoint (75 - pas)
	pointTemp.position.controller.appendTarget targetPoint (0 + pas)
	
	pointTemp.scale.controller = scaleXYZ ()
	pointTemp.scale.controller.x_scale.controller = float_script ()
	
	pointTemp.scale.controller.x_scale.controller.addnode "rootPoint" rootPoint
	pointTemp.scale.controller.x_scale.controller.addnode "targetPoint" targetPoint
	pointTemp.scale.controller.x_scale.controller.addconstant "refDist" ( distance rootPoint targetPoint )

	scaleXscript = stringstream ""
	format " (distance rootPoint targetPoint) / refDist " to: scaleXscript
	pointTemp.scale.controller.x_scale.controller.script = scaleXscript
	
	pas += 25
	pointTemp
)


$.scale.controller.x_scale.controller.addnode "rootPoint" rootPoint
$.scale.controller.x_scale.controller.addnode "targetPoint" targetPoint
$.scale.controller.x_scale.controller.addconstant "refDist" ( distance rootPoint targetPoint )

scaleXscript = stringstream ""
format " (distance rootPoint targetPoint) / refDist " to: scaleXscript
$.scale.controller.x_scale.controller.script = scaleXscript

-- contrainte de rotation
twistPointAr[1].rotation.controller = orientation_constraint ()	
twistPointAr[1].rotation.controller.appendTarget rootPoint 100

twistPointAr[4].rotation.controller = orientation_constraint ()	
twistPointAr[4].rotation.controller.appendTarget targetPoint 100

twistPointAr[3].rotation.controller = lookat_constraint ()	
twistPointAr[3].rotation.controller.appendTarget targetPoint 100
twistPointAr[3].rotation.controller.upnode_world = off
twistPointAr[3].rotation.controller.pickUpNode =targetPoint
twistPointAr[3].rotation.controller.upnode_ctrl = 1
twistPointAr[3].rotation.controller.viewline_length_abs = off

twistPointAr[2].rotation.controller = orientation_constraint ()	
twistPointAr[2].rotation.controller.appendTarget rootPoint 100
twistPointAr[2].rotation.controller.appendTarget twistPointAr[3] 100

-- creation des bones
twist_bn = for i = 1 to (twistPointAr.count - 1 ) collect
(
	BoneSys.createBone twistPointAr[i].pos twistPointAr[i+1].pos  [1,0,0]
)

for i = 1 to 3 do twist_bn[i].parent =  twistPointAr[i] 

-- accrochage des bones aux helpers
for i = 1 to 3 do
(
	twist_bn[i].boneFreezeLength = false
	twist_bn[i].position.controller = position_constraint ()
	twist_bn[i].position.controller.appendTarget twistPointsAr[i] 100
	
	twist_bn[i].rotation.controller = lookAt_constraint viewline_length_abs: false 
	twist_bn[i].rotation.controller.appendTarget twistPointsAr[i+1] 100
)

