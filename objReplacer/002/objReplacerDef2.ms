-- ref = selection as array

-- targets = selection as array

/*
maj: 
	pour faire correctement fonctionner le returnBBsize4, donc sans créer de groupe ni de parenter il faut retourner:
		-- une bounding box
		-- un centre de la selection
		-- une orientation (headof group si présent)
*/


fn findHeadsOfHierarchy2 sel =
(
	local headsOfHierarchy = for s in sel where (finditem sel s.parent) == 0 collect s
	makeuniquearray headsOfHierarchy
	headsOfHierarchy
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





fn returnBBsize3 ref = 
(
	bb = nodeGetBoundingBox ref ref.transform

	xsize = distance ([bb[1].x,0,0]) ([bb[2].x,0,0])
	ysize = distance ([0, bb[1].y,0]) ([0,bb[2].y,0])
	zsize = distance ([0,0,bb[1].z]) ([0,0,bb[2].z])
	format "ref: % scale: %\n" ref.name  [xsize, ysize, zsize]
	
	[xsize, ysize, zsize]
)

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

fn replaceObject3 ctrlTmp target  rescaleX2: true rescaleY: true rescaleZ: true aligntype: 2 =
(
-- 	memo:
	-- fonctionne sur les objets seul ou sur les groupe(dummy), ne fonctionne pas sur les selection multiples sans groupe
	
	-- get ref size
	refSize = returnBBsize3 ctrlTmp
	
	-- get target size:
	targetSize = returnBBsize3 target
		
	-- calculate ratio ref/target
	ratio = targetSize/refSize
	format "ratio: %\n" ratio

	-- rescale point
	if rescaleX2 then ctrlTmp.scale.x = ratio.x 
	else	ctrlTmp.scale.x = 1
	
	if rescaleY then ctrlTmp.scale.y = ratio.y 
	else ctrlTmp.scale.y = 1

	if rescaleZ then  		ctrlTmp.scale.z = ratio.z
	else 	ctrlTmp.scale.z = 1
	
	-- align rotation
	ctrlTmp.rotation = target.rotation
	
	-- align position
	if alignType == 1 then	ctrlTmp.position = target.position
	else if alignType == 2 then	ctrlTmp.position = target.center
	else if alignType == 3 then	ctrlTmp.center = target.position
	else if alignType == 4 then	ctrlTmp.center = target.center
	else()

	ctrlTmp
)




