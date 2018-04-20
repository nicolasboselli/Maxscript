-- ref = selection as array

-- targets = selection as array


filein "createCtrlDef.ms"

fn checkReference sel =
(
-- 	sel = selection as array
	
	-- si on a un objet seul
	if (sel.count == 1) then
	(
		sel[1]
	)
	-- si on a plusieurs objet
	else if (sel.count > 1) then
	(
		local isgroup = False
		local tmpDummy
		
-- 		local groupHead
		
		-- teste si la selection  est un groupe
		-- todo: test si un objet est group member
		for s in sel where isGroupHead s do 
		(
			tmpDummy = s
			isgroup = true
			exit
		)

		-- si la selection est un groupe
		if isgroup then
		(
			format "la selection est un groupe: %\n"  tmpDummy
			tmpDummy
		)
		else
		-- si la selection n est pas un groupe
		-- todo: prevoir un taitement, creer un groupe sur la selection
		(
			undefined
		)
	)
	
	else
	(
		format "select one object only."
		undefined
	)
)


fn checkReference2 sel =
(
	local checkedSel = #()
	local isgroup = False
	local tmpDummy
	
	for s in sel do
	(
		if not isGroupMember s then
		(
			append checkedSel s
		)
	)
	
	checkedSel
)


-- checkReference selection
-- for s in selection do format "s: %, isgroupMember: %, isgroupHead: %\n" s (isGroupMember s) (isGroupHead s)


fn checkTargetSelectionFN =
(
	local tgtSel = selection as array
	-- test si la selection fait partie d un groupe
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
-- returnBBsize2 dad[1]

fn returnBBsize3 ref = 
(
	bb = nodeGetBoundingBox ref ref.transform

	xsize = distance ([bb[1].x,0,0]) ([bb[2].x,0,0])
	ysize = distance ([0, bb[1].y,0]) ([0,bb[2].y,0])
	zsize = distance ([0,0,bb[1].z]) ([0,0,bb[2].z])
	[xsize, ysize, zsize]
)

-- ref = dad[1]
-- sel = #(ref)
-- for s in sel do
-- (
-- 	for c in s.children do append sel c
-- )
-- sel

-- sel = selection as array
-- dad = for s in sel where isgroupHead s collect s

fn returnBBsize4 ref = 
(
-- 	sel = selection as array
-- 	dads = findHeadsOfHierarchy2 sel
-- 	dad = dads[1]p
	
	sel = #(ref)
		
	xAr = #()
	yAr = #()
	zAr = #()
	
	for s in sel do
	(
		
		local BBtmp = nodeGetBoundingBox s ref.transform
		append xAr BBtmp[1].x
		append xAr BBtmp[2].x
		append yAr BBtmp[1].y
		append yAr BBtmp[2].y
		append zAr BBtmp[1].z
		append zAr BBtmp[2].z
		for c in s.children do append sel c
	)
	
	xsize = distance ([(amin xAr),0,0]) ([(amax xAr),0,0])
	ysize = distance ([0, (amin yAr),0]) ([0,(amax yAr),0])
	zsize = distance ([0,0,(amin zAr)]) ([0,0,(amax zAr)])
		
	[xsize, ysize, zsize]
	
)

-- returnBBsize4 dad[1]
-- amin xar

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



