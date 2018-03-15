-- sel = selection as array

-- hide/ unhide each helpers
fn hideUnhideHlps =
(
	hlps = helpers as array
	
	if not hlps[1].ishidden then
	(
		for h in hlps do hide h
	)
	else for h in hlps do unhide h	
)
-- hideUnhideHlps()

fn addOneHlp s =
(
	ctrl = point transform: s.transform name: (s.name + "_hlp") -- parent: s.parent
-- 	s.parent = ctrl
	ctrl
)


fn displayBones =
(
	bonesSel = for o in geometry where classof o == bonegeometry collect o
		
	if not bonesSel[1].ishidden then
	(
		for b in  bonesSel do hide b 
	)
	else for  b in  bonesSel do unhide b 
	print "done"
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
			sel[i].parent = daddy
		)
	)
)

fn createSymCopy s =
(
	-- create copy
	SCopy = copy s
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
)

-- createSymCopy $
/*
-- deselect $

sel = selection as array
for s in sel do
(
	res = finditem sel s.parent
	if res != 0 then deselect s
)
*/

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


try(destroyDialog hierarchyRLT)catch()

rollout hierarchyRLT "hierarchy"
(
	group "groups:"
	(
		button mayaGrpBT "maya group"
		button insertGrpBT "insert group"
	)
	group "parents:"
	(
		button parentBT "parent"
		button unParentBT "unparent"
	)
	button selectChidrenBT "select children"
	group "display:"
	(
		button displayHelpersBT "hide/unhide helpers"
		button displayBonesBT "hide/unhide bones"
	)
	
	group "helpers:"
	(
		button addHlpBT1 "create on selection" 
		button addHlpBT2 "create as parent" enabled: false
		button addHlpBT3 "create as children" enabled: false
		button addHlpBT4 "insert as parent" enabled: false
	)
	
	group "symetry:"
	(
		button createSymBT "create symetry"
	)
	
	on mayaGrpBT pressed do mayaGrpFN (selection as array)
	on insertGrpBT pressed do insertGrp (selection as array)
	on parentBT pressed do parentFN (selection as array)
	
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
	
-- 	on addHlpBT2 pressed do
-- 	(
-- 		
-- 	)
)

createdialog hierarchyRLT