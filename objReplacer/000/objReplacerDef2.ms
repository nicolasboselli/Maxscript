-- ref = selection as array

-- targets = selection as array


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
		
		for s in sel where classof s == dummy do 
		(
			tmpDummy = s
			isgroup = true
			exit
		)
		
		if isgroup == true then
		(
			format "selection is a group" 
			tmpDummy
		)
		else
		(
			undefined
		)
	)
	
	else
	(
		print "select one object only."
		undefined
	)
)

fn checkTargetSelectionFN =
(
	local tgtSel = selection as array
	tgtSel
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

fn replaceObjectOnPivot ref target =
(
	local copyRef
	maxOps.cloneNodes ref cloneType:#instance newNodes:&copyRef
	
	local groupHead = findHeadsOfHierarchy copyRef
	
	groupHead[1].transform = target.transform
	copyRef
)
