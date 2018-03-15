/*
bug:
-- find parent of the selection before 
*/

fn findHeadsOfHierarchy sel =
(
	headsOfHierarchy = #()
	for s in sel do
	(
		-- if arent is undefined
		if s.parent == undefined then
		(
			appendifunique headsOfHierarchy s
		)
		-- if parent is not in selection 
		else
		(
			isNotHead = False
			
			for p in sel do
			(
				if s.parent == p do
				(
					isNotHead = True
					exit
				)
			)

			if isNotHead == False do appendifunique headsOfHierarchy s
		)
	)
	
	headsOfHierarchy
)

fn createOrientedGroup sel headsOfHierarchy resetScale:false =
(

	-- find parent of head of hierarchy
	format "heads : %\n" headsOfHierarchy
	format "sel : %\n" sel
	
	rootParent = #()
	
	for head in headsOfHierarchy do
	(
		appendifunique rootParent head.parent
	)
-- 	print rootParent.count
	
	if rootParent.count == 1 then
	(
		-- create helper with first selection orientation
-- 		lead = sel[1]
		lead = headsOfHierarchy[1]
		
		selMatrix = lead.transform
		orientHlpTmp = point name: "orientHlpTmp"  --transform: selMatrix
		
		if not resetScale then
		(
			orientHlpTmp.transform = selMatrix
		)
		else
		(
			orientHlpTmp.rotation = lead.rotation
			orientHlpTmp.position = lead.position
		)
		
		orientHlpTmp.parent = rootParent[1]
			
			-- parent heads of hierarchy on helper
		for h in headsOfHierarchy do
		(
			h.parent = orientHlpTmp
		)
			
			-- create group on selection
		tmpGrp = group sel
		
		format "tmpGrp:%\n" tmpGrp
			-- reroot group root parent
		tmpGrp.parent = rootParent[1]
			-- delete helper
		delete orientHlpTmp
			-- return group
		tmpGrp
	)
	else
	(
		print "selection uncorrect"
		undefined
	)
)

fn collectCtrlPosition tmpGrp =
(
	setGroupOpen  tmpGrp true
	-- get the group bounding box
	absbbCoord = nodeGetBoundingBox tmpGrp tmpGrp.transform
	append absbbCoord [0,0,0]

	posList = #()

	for i = 1 to 3 do
	(
		for j = 1 to 3 do
		(
			for k = 1 to 3 do
			(
				tmpPos = [absbbCoord[i][1], absbbCoord[j][2], absbbCoord[k][3]]
				append posList tmpPos
			)
		)
	)
	posList
)

/* create controller function */
fn createCtrl num posList tmpGrp hlpSize: 400 = 
(
	tmpPt = point pos: posList[num ] name: ("repere_" + (num  as string)) size: hlpSize wirecolor: green
		
	-- point matrix
	ptMatrix = tmpPt.transform.controller.value
	-- group matrix
	grpMatrix = tmpGrp.transform
		
	resMatrix = ptMatrix*grpMatrix
	tmpPt.transform.controller.value = resMatrix
-- 	in coordsys tmpGrp tmpPt.position = posList[num ]
	tmpPt
)

-- 	vars
-- 	rollout relative functions
fn createOneCtrl num sel state hlpSize: 400 =
(
	local ctrlTmp
	local tmpGrp = undefined
	
	undo on
	(
		
		-- find head of hierarchy of selection
		headsOfHierarchy = findHeadsOfHierarchy sel
-- 		format "head: %\n" headsOfHierarchy
-- 		format "sel: %\n" sel

		-- create group over the selection
		if state == true then
		(
			tmpGrp = createOrientedGroup sel headsOfHierarchy
		)
		else
		(
			tmpGrp = group sel
		)
		
		format "tmpGrp: %\n" tmpGrp
		
		if classof tmpGrp != dummy then
		(
			print "debug your selection"
		)
		else
		(
			-- collect positions for control
			posList = collectCtrlPosition tmpGrp
	-- 			print posList
			
			-- create up controller
			ctrlTmp = createCtrl num posList tmpGrp hlpSize: hlpSize
			
-- 			format "ctrlTmp: %\n" ctrlTmp
			root = tmpGrp.parent
	-- 		format "root: %\n" root
	-- 		format "head: %\n" headsOfHierarchy
			
			-- delete temporary group
			setGroupOpen tmpGrp false
			ungroup  tmpGrp
			
			-- parent selection to point
			for h in headsOfHierarchy do h.parent = ctrlTmp
			
			ctrlTmp.parent = root
		)
	)
	ctrlTmp
)

