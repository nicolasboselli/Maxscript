-- creation centre selection/depart de la découpe
/*
faceCenterArray = $.editablePoly.getselection #face as array

total = [0,0,0]
for o in faceCenterArray do
(

	total = (polyop.getSafeFaceCenter  $ o) + total
)

centerPos = total/faceCenterArray.count

depart = point name: ( uniquename "dep_decoupe_") parent: $ rotation: $.rotation position: centerPos
fin  = point name: ( uniquename "fin_decoupe_") parent: $ rotation: $.rotation position: (centerPos + [50,0,0])
*/
-- creation bounding box de la selection

fn createBBoxFN = 
(

sourceSel = $

$.EditablePoly.ConvertSelection #face #vertex
vertSel = $.editablePoly.getselection #vertex as array
vertSelPos = for o in vertSel collect $.editablePoly.getvertex o

-- definition de la taille de la bounding box
selXMax = -20000 ; selXMin = 20000 ; selYMax =-20000 ; 
selYMin = 20000 ; selZMax = -20000 ; selZMin = 20000;

for i = 1 to  vertSelPos.count do 
(
	if vertSelPos[i].x > selXMax then selXMax = vertSelPos[i].x
	if vertSelPos[i].x <  selXMin then selXMin = vertSelPos[i].x
	
	if vertSelPos[i].y > selYMax then selYMax = vertSelPos[i].y
	if vertSelPos[i].y < selYMin then selYMin = vertSelPos[i].y
	
	if vertSelPos[i].z > selZMax then selZMax = vertSelPos[i].z
	if vertSelPos[i].z < selZMin then selZMin = vertSelPos[i].z
)

selXMin ; selXMax; selYMax ; selYMin ; selZMax ; selZMin

distX = distance [selXMin,0,0] [selXMax,0,0]
distY = distance [selYMax,0,0] [selYMin,0,0]
distZ = distance [selZMax,0,0] [selZMin,0,0]

boundingSel = Box lengthsegs:1 widthsegs:1 heightsegs:1 \
length: distY width:distX height:distZ mapcoords:on pos:[0,0,0]

-- placement de la bounding box
boundingSel.pivot = boundingSel.min

	-- rotation
boundingSel.rotation = sourceSel.rotation

	-- parent
boundingSel.parent = sourceSel

	-- position
		-- determination du point le plus bas de la selection
lowerPoint = [10000, 10000, 10000]

for o in vertSelPos do
(
	if o.x < lowerPoint.x then  lowerPoint.x = o.x 
	if o.y < lowerPoint.y then  lowerPoint.y = o.y
	if o.z < lowerPoint.z then  lowerPoint.z = o.z
)

in coordsys parent boundingSel.pos = lowerPoint 

return boundingSel

)

/*
-- determination de la distance de la decoupe en entre les repères de départ et de fin en x y et z
depart = point name: ( uniquename "dep_decoupe_") rotation: source.rotation position: boundingSel.center
fin  = point name: ( uniquename "fin_decoupe_") rotation: source.rotation position: boundingSel.center

in coordsys local move fin [50,0,0]
*/

createBBoxFN ()