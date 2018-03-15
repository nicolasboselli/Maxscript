-- load createOrientedGroup from createCtrlDef.ms 
-- load  findHeadsOfHierarchy from   createCtrlDef.ms 


sel = selection as array
-- create group
head = findHeadsOfHierarchy sel
grp = createOrientedGroup sel head 
setGroupOpen grp true

-- get bounding box size
tea = nodeGetBoundingBox grp grp.transform

xSize = distance [tea[1].x, 0, 0] [tea[2].x, 0, 0]
ySize = distance [0, tea[1].y, 0] [0, tea[2].y, 0]
zSize = distance [0, 0, tea[1].z] [0, 0, tea[2].z]

-- create box
test = box  width: xSize  length: ySize height: zSize
test.transform
test.pivot = test.center

resetxform test
converttopoly test
test.transform

-- select all edges
polyop.setEdgeSelection test #all

-- create shape from edges
newName = uniquename "test"
test.createShape  newName  false test
delete test

ctrBox = getNodebyname newName

-- orient ctrl box
ctrBox.transform = grp.transform
ctrBox.position = grp.center

selToParent = findHeadsOfHierarchy sel

for o in selToParent do o.parent = ctrBox
delete grp