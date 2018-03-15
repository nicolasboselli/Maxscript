in coordsys $hlp_dw_005 $hlp_up.rotation.z
	
in coordsys $point007 $point006.rotation.x

($hlp_up.rotation as eulerangles)

$ExposeTransform001.localEulerX

$.rotation

(quat 0.402671 -0.506496 0.251283 0.719844) - (quat -0.142332 0.682157 0.394085 0.59925)

(eulerAngles 87.6709 -44.8605 -109.901) - (eulerAngles -78.9688 31.7914 -64.894)

in coordsys world $.rotation
	
v1= normalize ($B.pos - $A.pos)
v2 = normalize ($C.pos - $A.pos)
acos (dot v1 v2)