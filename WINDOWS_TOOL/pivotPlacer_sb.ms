


-- ########## resetXform de la fenetre

-- collecte du groupe
sel = selection as Array
groupHead
groupMembers = #()
-- sList = #()
sParentList = #()

for s in sel do
if isgrouphead s then
(
	groupHead = s
)
else if isGroupMember s then
(
	append groupMembers s
	append sParentList s.parent
)


format "groupMembers: %\nsParentList: %\n" groupMembers sParentList


-- eclater le Group
-- detachNodesFromGroup groupMembers
for s in groupMembers do setGroupMember s false
-- déparenter
for s in groupMembers do s.parent = undefined
-- resetxform
groupHead.transform = (scaleMatrix (point3 1 -1 1))*groupHead.transform
-- reparenter
for i = 1 to groupMembers.count do
(
	groupMembers[i].parent = sParentList[i]
)

attachNodesToGroup  groupMembers groupHead


/* sel = selection as array
for s in sel do 
(
	format "s: % s.scale: % scalepart: %\n" s.name s.scale s.transform.scalepart 
) */




-- resetXform de la fenetre
/*
eclater le Group
déparenter
resetxform
reparenter
*/


-- identity $.transform
-- isidentity $.transform

/* $.pivot = point3 0 0 0

(nodeLocalBoundingBox s asBox3: false)[1].y 
s.pivot.y = (nodeLocalBoundingBox s)[2].y

s.pivot = (point3 0 50 0)

s.objectoffsetpos
s.objectoffsetpos = (point3 0 0 0)


-- bbVal[2].y
-- s.objectoffsetpos = (point3 0 0 0)
s.objectoffsetpos = (point3 0 -bbVal[2].y 0)
in coordsys local move s (point3 0 bbVal[2].y 0) */

-- o.pivot = (transMatrix([pvtPosXShift,pvtPosYShift,pvtPosZShift]) * o.transform).translation
-- o.pivot = (transMatrix([pvtPosXShift,pvtPosYShift,pvtPosZShift]) * o.transform).translation


/* 
s = $
bbVal = nodeGetBoundingBox s s.transform
s.pivot = ( transMatrix(point3 0 (bbVal[2].y) 0) * s.transform).translation */
