sel = selection as array
format "bakTM:%\n" sel[2].transform
format "localTM:%\n" sel[1].transform
format "bakTM rotationpart:%\n" sel[2].transform.rotationpart
format "localTM rotationpart:%\n" sel[1].transform.rotationpart
format "bakTM rotation:%\n" sel[2].rotation
format "localTM rotation:%\n" sel[1].rotation

format "decay1:%\n" (sel[1].rotation - sel[2].rotation)
format "decay2:%\n" (sel[1].transform.rotationpart - sel[2].transform.rotationpart)


sel = selection as array
sel[1].rotation - sel[2].rotation 

$.rotation as eulerangles 

$.transform.rotationpart
inverse $.rotation


pt = $Point001
s = $Plane016
copyS = $Plane021

bakTM = s.transform
localTM = pt.transform
in coordsys pt s.rotation
in coordsys localTM s.transform
in coordsys localTM s.rotation
in coordsys localTM bakTM.rotationpart

res =  bakTM * localTM
res.rotation

s.rotation
pt.rotation

$.transform.controller.value

in coordsys parent $.transform
in coordsys world $.transform

pt1 = $Point004
pt2 = $Point002

xformMat pt1.transform pt2.transform

pt1.transform * inverse(pt2.transform)

bakTM.rotation.value

res = xformMat  bakTM localTM
$.modifiers[#xform].gizmo.rotation = (quat 0.5 -0.5 -0.5 0.5)

$Box002.transform - $Box001.transform

xformMat   $Point003.transform $Point002.transform

$Point003.transform - $Point002.transform

$.transform