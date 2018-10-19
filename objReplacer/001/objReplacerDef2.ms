-- ref = selection as array

-- targets = selection as array

/*
maj: 
	pour faire correctement fonctionner le returnBBsize4, donc sans créer de groupe ni de parenter il faut retourner:
		-- une bounding box
		-- un centre de la selection
		-- une orientation (headof group si présent)
*/


filein "createCtrlDef.ms"


fn findHeadsOfHierarchy2 sel =
(
	local headsOfHierarchy = for s in sel where (finditem sel s.parent) == 0 collect s
	makeuniquearray headsOfHierarchy
	headsOfHierarchy
)

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
-- 	local isgroup = False
-- 	local tmpDummy
	
	for s in sel do
	(
		if isvalidnode s then
		(
			if not isGroupMember s or isGroupHead s then
			(
				append checkedSel s
			)
		)
	)
	
	format "checkedSel: %\n" checkedSel
	checkedSel
)


-- checkReference2 (selection as array)
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
	format "ref: % scale: %\n" ref.name  [xsize, ysize, zsize]
	
	[xsize, ysize, zsize]
)
-- $.transform

fn returnBBsize4 sel = 
(
	/*
	faire focntionner la fonction sur les groupes ou les selections d'objects
	*/
	
	-- fonctionne sur les selection d'objets
	ref = sel[1]
		
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


-- sel = selection as array
-- for s in sel do
-- (
-- 	for c in s.children do append sel c
-- )

fn returnBBsize5 ref = 
(
	-- fonctionne sur les groupes

	sel = #(ref)
	
	-- collecter tous les membres du groupe
	for s in sel do
	(
		for c in s.children do append sel c
	)
		
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


fn replaceObject2 ref target  rescaleX2: true rescaleY: true rescaleZ: true copyType: 1 aligntype: 2 =
(
-- 	memo:
	-- fonctionne sur les objets seul ou sur les groupe(dummy)
	-- s il y a une tete de groupe dans la selection c'est cet objet qui devient ref
	-- sinon c'est le premier objet de la selection
		-- ou une matrix construite sur le centre de la selection et l'orientation du premier objet
	
-- 	format "rescaleX2: %\n" rescaleX2
-- 	if rescaleX2 then format "x yeaH!!!\n"
	
	local ctrlTmp
	local copyRef
	
	-- get ref size
-- 	refSize = returnBBsize4 #(ref)
	refSize = returnBBsize3 ref
	
	-- get target size:
-- 	targetSize = returnBBsize2 target
	targetSize = returnBBsize3 target
	
	
	-- copy ref 
	if copyType == 1 then
	(
		maxOps.cloneNodes ref cloneType: #copy newNodes:&copyRef
	)
	else if copyType == 2 then
	(
		maxOps.cloneNodes ref cloneType: #instance newNodes:&copyRef
	)
	else()
	
	-- create point at center of copyref 
-- 	ctrlTmp = createOneCtrl 27 copyRef true
	copyHead = findHeadsOfHierarchy2 copyRef
	if copyHead.count == 1 then ctrlTmp = copyHead[1]
		
	-- calculate ratio ref/target
	ratio = targetSize/refSize
	format "ratio: %\n" ratio

	-- rescale point
-- 	if rescaleX2 then format "x yeaH2 !!!\n"
	if rescaleX2 then 
	(
-- 		format "x yeah!\n"
		ctrlTmp.scale.x = ratio.x 
	)
	else 
	(
-- 		format "x fail!\n"
		ctrlTmp.scale.x = 1
	)
	
	if rescaleY then
	(
-- 		format "y yeah!\n"
		ctrlTmp.scale.y = ratio.y 
	)
	else 
	(
-- 		format "y fail!\n"
		ctrlTmp.scale.y = 1
	)

	if rescaleZ then 
	(
-- 		format "z yeah!\n"
		ctrlTmp.scale.z = ratio.z
	)
	else 
	(
-- 		format "z yeah!\n"
		ctrlTmp.scale.z = 1
	)
	
	-- align rotation
	ctrlTmp.rotation = target.rotation
	
	-- align position
	if alignType == 1 then	ctrlTmp.position = target.position
	else if alignType == 2 then	ctrlTmp.position = target.center
	else if alignType == 3 then	ctrlTmp.center = target.position
	else if alignType == 4 then	ctrlTmp.center = target.center
	else()

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



