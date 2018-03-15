-- create skin box

sel = selection as array
for s in sel do
(
	skinBox = box transform: s.transform
	skinBox.length = s.length*.9
	skinbox.width = s.width*.9
	skinbox.height = s.height*.9
	skinBox.wirecolor = yellow -- s.wirecolor
	skinBox.objectoffsetrot = s.objectoffsetrot
	skinBox.parent = s
	
	if matchpattern s.name pattern: "*_CTRL" then skinbox.name = substitutestring s.name "CTRL" "SKIN"
	else if matchpattern s.name pattern: "*_BIP" then skinbox.name = substitutestring s.name "BIP" "SKIN"
	else skinBox.name = s.name + "SKIN"
	
-- 	skinbox.name = substitutestring s.name "BIP" "SKIN"
	skinBox.boxmode = true
)

$.objectoffsetrot =(quat -1 0 0 0)

-- skinbox = box length: ($.length*.9) width: ($.width*.9) height: ($.height*.9) wirecolor: $.wirecolor transform: $.transform boxmode: true name: (substitutestring $.name "BIP" "SKIN") 

-- create ref point
sel = selection as array
for s in sel do
(
	refhlp = point transform: s.transform axis_tripod: false cross: false box: true
	
	if classof s.baseobject == box then refhlp.size = s.length / 5
	else if classof s.baseobject == point then refhlp.size = s.size/2
	else()
	
	if matchpattern s.name pattern: "*_CTRL" then refhlp.name = substitutestring s.name "CTRL" "REF"
	else if matchpattern s.name pattern: "*_BIP" then refhlp.name = substitutestring s.name "BIP" "REF"
	else refhlp.name = s.name + "REF"
	
	refhlp.wirecolor = s.wirecolor
	refhlp.parent = s.parent
	s.parent = refhlp
	
-- 	for o in s.children do o.parent = refhlp
)

matchpattern $.name pattern: "*_CTRL"

-- defreeze transform
sel = selection as array
for s in sel do
(
	s.position.controller = position_xyz()
	s.rotation.controller = euler_xyz()
)

-- custom resize
sel = selection as array
sel[1].height = distance sel[1] sel[2]


-- $.children