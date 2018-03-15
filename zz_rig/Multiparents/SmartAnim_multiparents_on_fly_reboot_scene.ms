wireColRed = color 255 0 0
wireGreen = color 0 255 0

fn randomAngleFN =
(
	(eulerangles (random 0 90) (random 0 90) (random 0 90) ) 
)

fn randomPosFN =
(
	[(random -50 50), (random -50 50), 0]
)

ctrAr = for i = 1 to 3 collect circle radius: 5 rotation: (randomAngleFN ()) position: (randomPosFN()) wirecolor: wireColRed
	
for o in  ctrAr do 
(
	convertTosplineshape o
	updateshape o 
	point  rotation: o.rotation position: o.pos wirecolor: wireGreen parent: o size: 5 axiwtripod: false cross: true box: true
)

box rotation: ctrAr[1].rotation position: ctrAr[1].position length: 5 width: 5 height: 5 parent: ctrAr[1].children[1]




