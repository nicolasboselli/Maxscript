-- camera_tools
/*
- redresser les verticales
$.auto_vertical_tilt_correction = on
- changer un format 
- placer le soleil ‡ droite ou ‡ gche

*/
-- changer le format du rendu
bakState = renderSceneDialog.isopen()
if bakState then renderSceneDialog.close()
renderWidth  = 1500
renderHeight = 925
if bakState then renderSceneDialog.open()



-- redresser les verticale de la camera
cam = getActiveCamera()
if cam != undefined then
(
	if superclassof cam == physical then
	(
		cam.auto_vertical_tilt_correction = on
		cam.auto_vertical_tilt_correction = off
	)
	else()
)
else()


cam.target

-- placer le sun par rapport ‡ la camera
vcCam =  normalize (cam.position - cam.target.position)

-- sun placer
	-- determiner un vecteur entre le sun et sa cible
	-- recalculer la position du vecteur en changeant le vecteur
	-- determiner un vecteur entre la camera et sa cible
sun = $VRaySun001
tgt = $Target001

in coordsys tgt sun.position
in coordsys tgt sun.rotation = (eulerAngles 0 0 -180)

sun.position
tgt.position

vcSun = normalize (sun.position - tgt.position)

pt = $Point003
pt.dir = vcSun

t = $Teapot001
t.rotation
t.dir


$.rotation as eulerangles
$.rotation as matrix3

oneRot = (eulerAngles 0 0 -90)
oneRotMat = onerot as matrix3

$.transform = $.transform * (onerot as matrix3)
$.transform as quaternion
inverse $.transform

$.transform = xformMat oneRotMat $.transform


-- rotation d'un vecteur
sun = $VRaySun001
x1 =  sun.pos.x
y1 = sun.pos.y

cos x1

B = "angle de rotation en z"
x2=cosﬂx1-sinﬂy1
y2=sinﬂx1+cosﬂy1