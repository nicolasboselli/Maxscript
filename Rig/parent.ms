-- sel = selection as array


-- scale value [1,1,1]
fn scale1 s = s.scale.controller.value = [1,1,1]
	
-- hide/ unhide each helpers
fn hideUnhideHlps =
(
	hlps = helpers as array
	
	if hlps.count > 0 then
	(
		if not hlps[1].ishidden then
		(
			for h in hlps do hide h
		)
		else for h in hlps do unhide h	
	)
)
-- hideUnhideHlps()

-- create one help on selection 
fn addOneHlp s =
(
	ctrl = point transform: s.transform name: (s.name + "_hlp") cross: false size: 20 wirecolor: green axis_tripod: true -- parent: s.parent
-- 	s.parent = ctrl
	ctrl
)

-- resize le box bone
fn resizeBoneBox s =
(
	childs = s.children 
	if childs.count == 1 then
	(
		-- 	res = in coordsys parent childs[1].position.z
			res = abs (in coordsys parent childs[1].position.z)
			-- assigner la valeur à la hauteur de la box
			s.height =res
			redrawViews() 
	)
	else(print "utiliser une autre méthode")
)

fn displayBones =
(
	bonesSel = for o in geometry where classof o == bonegeometry collect o
		
	if not bonesSel[1].ishidden then
	(
		for b in  bonesSel do hide b 
	)
	else for  b in  bonesSel do unhide b 
)

fn mayaGrpFN sel =
(
	daddy = point name: (sel[1].name + "_hlp")
	
	objsToGrp = #()

	for s in sel do
	(
		isNotParented = false
		parentInSel = false
		
		if s.parent == undefined then isNotParented = true
		/*
		res = finditem sel s.parent 
		if res == 0 then print "parent is not in selection" else parentInSel = true
		*/
		if isNotParented then append objsToGrp s
	)

-- 	select objsToGrp
	for s in objsToGrp do
	(
		s.parent = daddy
	)
)

-- insert group
fn insertGrp sel =
(
	daddy = point name: (sel[1].name + "_hlp")
	
	objsToGrp = #()
	BigDaddys = #()
	
	for s in sel do
	(
		res = finditem sel s.parent
		if res == 0 then
		(
			appendifunique objsToGrp s
			appendifunique BigDaddys s.parent
		)
	)
	
	if BigDaddys.count == 1 then 
	(
		for o in objsToGrp do
		(
-- 			format "parent % to %\n" o.name daddy.name
			o.parent = daddy
		)
-- 		format "parent % to %\n" daddy.name BigDaddys[1].name
		daddy.parent = BigDaddys[1]
	)
	BigDaddys
)



fn parentFN sel =
(
	undo on
	(
		daddy = sel[sel.count]
		
		for i = 1 to (sel.count - 1) do
		(
			
			parentable = true
			parentInSel = false
			-- test parent dans la selection
			for j = 1 to (sel.count - 1) do
			(
-- 				tmpParent = sel[j].parent
				if isvalidnode  sel[i].parent and i != j then
				(
-- 					format "i: %, parent: % ,j: %\n" sel[i].name sel[i].parent.name sel[j].name
					if sel[i].parent == sel[j] then 
					(
						
						parentable = false
						parentInSel = true
						exit
					)
				)
				else if  i != j then 
				(
-- 					format "i: %, parent: % ,j: %\n" sel[i].name sel[i].parent sel[j].name
					exit
				)
				
-- 				if parentable ==  false then 
			)
			
			if classof sel[i] == RailClone_Pro then  parentable = false
			
			if not parentInSel then
			(
				-- test appartenance à un groupe 
				if isGroupMember sel[i] and not isGroupHead sel[i]  then parentable = false
			)
			
			-- prent
			try
			(
				if parentable then 
				(
					format "i: %, groupHead: %, groupmember: %, parent: %, parentable:%, parentinsel: % \n" sel[i].name (isGroupHead sel[i])  (isGroupMember sel[i]) sel[i].parent parentable parentInSel
					sel[i].parent = daddy
				)
			)catch(format "FAIL: % , ERROR: %\n"  sel[i].name (getcurrentexception())
		)
	)
)

fn createSymCopy s =
(
	-- create copy
	SCopy = copy s
	SCopy.wirecolor = s.wirecolor
	-- create helper au centre du monde
	centerSym = point ()
	-- parenter selection avec helper centre 
	SCopy.parent = centerSym
	-- scale -1 sur le parent
	centerSym.scale.controller.value.x = -1
	-- delete parent
	delete centerSym
	
	
	-- resetscale sur copy
	resetscale SCopy
-- 	s.objectoffsetscale = [1,1,1]
-- 	s.objectoffsetrot =(quat -1 0 0 0)
)

fn findHead sel =
(
	local heads= #()
	sel = sel as array
	for s in sel do
	(
		res = finditem sel s.parent
		if res == 0 then append heads s
	)
	heads
)

fn createSymCopy2 sel =
(
	maxOps.CloneNodes  sel expandHierarchy: false newNodes: &SCopy
	format "scopy: %\n" SCopy
	heads = findHead SCopy
	
	centerSym = point ()
	for h in heads do h.parent = centerSym
		
	centerSym.scale.controller.value.x = -1

	delete centerSym
-- 	select SCopy
-- 	for s in SCopy do resetscale s
)

fn selectAllChildren sel=
(
	for obj in sel do
		(
		if obj.children != undefined do
		(
			selectmore obj.children
		)
	)
)

fn unParent sel=
(
	for s in sel do s.parent = undefined
)

fn addUpperPoint obj =
(
	upPt = point name: (obj.name + "_hlp") axis_tripod: false
	upPt.transform = obj.transform
	obj.parent = upPt
)


fn addBoneBox s =
(
	newBone = undefined
	if s.count == 1 and classof s[1].baseobject == box then
	(
		dad = s[1]
		newBone = box transform: dad.transform parent: dad boxmode: on wirecolor: dad.wirecolor name: (uniquename dad.name) \
		height: dad.height width: dad.width length: dad.length
		newBone.position.controller.value.z = dad.height
	)
	newBone
)

-- sel = selection as array
-- addBoneBox sel

fn copyCleanBaseMesh s=
(
	copyS = copy s
	for i = 1 to copyS.modifiers.count do deletemodifier copyS 1
	copyS
)


try(destroyDialog hierarchyRLT)catch()

rollout hierarchyRLT "hierarchy"  width: 400
(
	group "groups:"
	(
		button mayaGrpBT "maya group" across:2 
		button insertGrpBT "insert group"
	)
	group "parents:"
	(
		button parentBT "parent" across:3 
		button unParentBT "unparent"
		button selectChidrenBT "select children"
	)
	
	/*
	group "display:"
	(
		button displayHelpersBT "hide/unhide helpers"
		button displayBonesBT "hide/unhide bones"
	)
	*/
	group "scale tools:"
	(
		button scale1BT "scale value [1,1,1]" 
	)
	
	group "helpers:"
	(
		button addHlpBT1 "create on selection"  across: 2
		button addHlpBT2 "create as parent" enabled: false
		button addHlpBT3 "create as children" enabled: false  across: 2
		button addHlpBT4 "insert as parent" enabled: false
		button transAttrBT "transfer attribute" 
	)
		
	group "bones:"
	(
		button addBoxBoneBT "add" across: 3
		button resizeBoxBoneBT "resize" 
		button boxmodeToggleBT "boxmode" 
	)
	
	group "symmetry:"
	(
		button createSymBT "create symetry"  across: 2
		button resetScaleBT "reset scale" 
	)
	
	group "base mesh:"
	(
		button cleanCopyBT "create clean copy"  -- across: 2
	)
	
	on mayaGrpBT pressed do mayaGrpFN (selection as array)
	on insertGrpBT pressed do insertGrp (selection as array)
	on parentBT pressed do parentFN (selection as array)
	
	on scale1BT pressed do
	(
		sel = selection as array
		for s in sel do scale1 s
	)
	
	on selectChidrenBT pressed do selectAllChildren (selection as array)
	on unParentBT pressed do unParent (selection as array)
	
	on displayHelpersBT pressed do hideUnhideHlps()
	on displayBonesBT pressed do displayBones()
	
	on addHlpBT1 pressed do
	(	
		sel = selection as array
		for s in sel do
		(
			hlp = addOneHlp s
			select hlp
		)
	)
	
	on transAttrBT pressed do
	(
		sel = selection as array
		model = sel[1]
		
		for i = 2 to sel.count do
		(
			sel[i].size = model.size
			sel[i].wirecolor = model.wirecolor
			sel[i].cross = model.cross
			sel[i].axis_tripod = model.axis_tripod
			sel[i].box = model.box
			
		)
	)
	
	on addBoxBoneBT pressed do
	(
		sel = selection as array
		addBoneBox sel
	)
	
	on  boxmodeToggleBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			s.boxmode = not s.boxmode
		)
	)
	
	on resizeBoxBoneBT pressed do
	(
		sel = selection as array
		for s in sel do	resizeBoneBox s
	)
	
	on resetScaleBT pressed do
	(
		sel = selection as array
		for s in sel do resetscale s
	)
	
	on createSymBT pressed do
	(
		sel = selection as array
-- 		for s in sel do createSymCopy2 s
		createSymCopy2 sel
	)
	
	on cleanCopyBT pressed do
	(
		sel = selection as array
		res = for s in sel collect copyCleanBaseMesh s
		select res
	)
)

createdialog hierarchyRLT