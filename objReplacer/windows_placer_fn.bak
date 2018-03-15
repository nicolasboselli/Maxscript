/*
bug: why local modffd doesn't work
*/


fn replaceRefFN ref tgt=
(
	modFFD

	infoStr = stringstream ""
	format "% replace %" ref tgt to: infoStr
	print(infoStr as string)
	
	-- collect x,y and z max on target
	vertNum = tgt.GetNumVertices ()
	maxX = -1000
	minX = 1000
	maxY = -1000
	minY = 1000
	maxZ = -1000
	minZ = 1000

	for i = 1 to vertNum do
	(
		posTmp = tgt.getvertex i
		
		if posTmp.x > maxX do maxX = posTmp.x
		if posTmp.x < minX do minX = posTmp.x
		if posTmp.y > maxY do maxY = posTmp.y
		if posTmp.y < minY do minY = posTmp.y
		if posTmp.z > maxZ do maxZ = posTmp.z
		if posTmp.z < minZ do minZ = posTmp.z
	)

	xsize = maxX- minX
	ySize = maxY - minY
	zSize = maxZ - minZ
	
	tgtSizeStr = stringstream ""
	format "target: \t%, %, %"  xsize ySize zSize to: tgtSizeStr
	print(tgtSizeStr as string)

	-- get ref ffd size
	
	if classof ref == dummy then
	(
		modFFD = ref.children[1].modifiers[#FFD_2x2x2]
	)
	else
	(
		for oneMod in ref.modifiers do 
		(
			if (classof onemod == FFD_2x2x2) do
			modFFD = oneMod
			break
		)
-- 		modFFD =  ref.modifiers[#FFD_2x2x2]
	)
	
	print modFFD
	animateVertex  modFFD #all
	print modFFD.control_point_1
-- 	modFFD.Control_Point_2

	-- calculate ffd size
	local boundMax, boundMin
	
	if classof ref == dummy then
	(
		boundMax = getModContextBBoxMax  ref.children[1] modFFD
		boundMin = getModContextBBoxMin  ref.children[1] modFFD
	)
	else
	(
		boundMax = getModContextBBoxMax  ref modFFD
		boundMin = getModContextBBoxMin  ref modFFD
	)
	xffd = boundMax.x - boundMin.x
	yffd = boundMax.y - boundMin.y
	zffd = boundMax.z - boundMin.z

	refSizeStr = stringstream ""
	format "ref: \t%, %, %"  xffd yffd zffd to: refSizeStr
	print (refSizeStr as string)
	

	-- calculate ratio
		-- apply ratio to ffd position or object scale?
	xRatio = xsize/xffd
	yratio = ysize/yffd
	zratio = zsize/zffd
	
	ratioStr = stringStream ""
	format "ratio: \t%, %, %"  xRatio yratio zratio to: ratioStr
	print(ratioStr as string)
	
	-- resize ffd

	if classof modFFD == FFD_2x2x2 do
	(		
		print "youpi"
		ctrlPtsNum = 8
		for i = 1 to ctrlPtsNum do
		(
			tmpPt = stringstream ""
			format "modFFD.Control_point_%" i to: tmpPt
			tmpPos = execute (tmpPt as string)
			print tmpPos
			
			if tmpPos.x != 0 do tmpPos.x = xRatio
			if tmpPos.y != 0 do tmpPos.y = yRatio
			if tmpPos.z != 0 do tmpPos.z = zRatio
				
-- 			print tmpPos
			newCtrlPtPosStr = stringstream ""
			format "modFFD.control_point_% = tmpPos" i to: newCtrlPtPosStr
			execute (newCtrlPtPosStr as string)
			
		)
	)

	-- duplicate ref
	
	if classof ref == dummy then
	(
		maxOps.cloneNodes ref cloneType:#copy newNodes:&newGrpArr
		select newGrpArr
		
		local isGroup = False
		for n in newGrpArr do if classof n == dummy do 
		(
			n.pivot = n.center
			n.rotation = tgt.rotation 
			n.center = tgt.center
			return n
		)
	)
	else
	(
	maxOps.cloneNodes ref cloneType:#copy newNodes:&newGrpArr
	copyRef = newGrpArr[1]
	copyRef.rotation = tgt.rotation 
	copyRef.center = tgt.center
	copyRef.pivot = copyRef.center	
		/*
	copyRef = copy ref
	-- replace target
	copyRef.rotation = tgt.rotation 
	copyRef.center = tgt.center
	copyRef.pivot = copyRef.center
		*/
	return copyRef
	)
	
	
	
)