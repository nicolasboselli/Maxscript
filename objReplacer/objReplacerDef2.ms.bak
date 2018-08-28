-- ref = selection as array

-- targets = selection as array

/*
bug: why local modffd doesn't work
*/

filein "createCtrlDef.ms"

fn checkReference sel =
(
-- 	sel = selection as array
	
	if (sel.count == 1) then
	(
		sel[1]
	)
	else if (sel.count > 1) then
	(
		local isgroup = False
		local tmpDummy
		
		for s in sel do 
			if (classof s == dummy) do 
			(
				tmpDummy = s
				isgroup = true
				break
			)
		
		if isgroup == true then
		(
			print "selection is a group" 
			return tmpDummy
		)
		else
		(
			return undefined
		)
	)
	
	else
	(
		print "select one object only."
		return undefined
	)
)

fn checkTargetSelectionFN =
(
	local tgtSel = selection as array
	return tgtSel
)

fn returnBBsize2 ref =
(
	-- get root
	root = ref.parent
	
	-- get size of ref:
	-- add group on selection with orientation of selection
	head = findHeadsOfHierarchy ref
	grp = createOrientedGroup #(ref) head 
	
	-- open group
	setGroupOpen grp true
	
	-- create dummy
	dum = copy grp
	bbsize = dum.boxsize
	
	-- reroot ref
	ref.parent = root
	
	delete grp
	delete dum
	
	bbsize
)

fn returnBBsize3 ref = 
(
	bb = nodeGetBoundingBox ref ref.transform

	xsize = distance ([bb[1].x,0,0]) ([bb[2].x,0,0])
	ysize = distance ([0, bb[1].y,0]) ([0,bb[2].y,0])
	zsize = distance ([0,0,bb[1].z]) ([0,0,bb[2].z])
	[xsize, ysize, zsize]
)

-- returnBBsize4
/*
sel = selection as array
head = findHeadsOfHierarchy sel

xValAr = #()
yValAr = #()
zValAr = #()

for s in sel do
(
	bbVal =  nodeGetBoundingBox s head[1].transform
	for o in bbVal do
	(
		append xValAr o.x
		append yValAr o.y
		append zValAr o.z
	)
-- 	format "bbVal: %\n" bbVal
)

bbGlobal = #([(amax xValAr), (amax yValAr), (amax zValAr)], [(amin xValAr), (amin yValAr), (amin zValAr)])
-- point pos: bbGlobal[1]
-- point pos: bbGlobal[2]

xsize = distance ([bbGlobal[1].x,0,0]) ([bbGlobal[2].x,0,0])
ysize = distance ([0, bbGlobal[1].y,0]) ([0,bbGlobal[2].y,0])
zsize = distance ([0,0,bbGlobal[1].z]) ([0,0,bbGlobal[2].z])
[xsize, ysize, zsize]

*/


fn replaceObject ref target =
(
	-- get ref size
	refSize = returnBBsize2 ref
	
	-- get target size:
	targetSize = returnBBsize2 target
	
	-- copy ref 
	maxOps.cloneNodes ref cloneType:#instance newNodes:&copyRef
	-- create point at center of ref 
	ctrlTmp = createOneCtrl 27 copyRef true
	
	-- calculate ratio ref/target
	ratio = targetSize/refSize

	-- align point on box ref center
	ctrlTmp.rotation = target.rotation
	ctrlTmp.position = target.position
	-- rescale point
	ctrlTmp.scale = ratio
	
	-- delete point
	delete ctrlTmp
	
	for h in copyRef where isOpenGroupHead h do setGroupOpen h false
	copyRef
)


fn replaceObject2 ref target  rescaleX: true rescaleY: true rescaleZ: true =
(
	-- get ref size
	refSize = returnBBsize2 ref
	
	-- get target size:
-- 	targetSize = returnBBsize2 target
	targetSize = returnBBsize3 target
	
	-- copy ref 
	maxOps.cloneNodes ref cloneType:#instance newNodes:&copyRef
	-- create point at center of ref 
	ctrlTmp = createOneCtrl 27 copyRef true
	
	-- calculate ratio ref/target
	ratio = targetSize/refSize

	-- align point on box ref center
	ctrlTmp.rotation = target.rotation
	ctrlTmp.position = target.position
	-- rescale point
	ctrlTmp.scale.x = if rescaleX then ratio.x else 1
	ctrlTmp.scale.y = if rescaleY then ratio.y else 1
	ctrlTmp.scale.z = if rescaleZ then ratio.z else 1
	
	-- delete point
	delete ctrlTmp
	
	for h in copyRef where isOpenGroupHead h do setGroupOpen h false
	copyRef
)


/*
hlps = helpers as array
for h in hlps where isOpenGroupHead h do setGroupOpen  h false
*/

/*
-- get ref
sel = selection as array
ref = checkReference sel

sel = selection as array
if ref != undefined do
(
	for s in sel do
	(
		replaceObject ref s
	)
-- 	returnBBsize2 ref
)
*/
-- head = findHeadsOfHierarchy $
-- createOrientedGroup #($) head 




-- sel = selection as array
-- for s in sel do
-- (
-- 	replaceObject ref s
-- )








