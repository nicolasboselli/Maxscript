-- todo : symetriser deformation sur controls box


-- parent objects to last selected
fn parentSel sel =
(
	if sel.count > 1 then
	(
		daddy = sel[sel.count]
		for i = 1 to (sel.count - 1) do sel[i].parent = daddy
	)else (print "changer votre selection")
)

try(destroydialog parentRLT )catch()
rollout parentRLT "parent"
(
	button parentBtn "parent"
	on parentBtn pressed do 
	(
		sel = selection as array
		parentSel sel
	)
)
createdialog parentRLT




-- rebuild parents chain
sel = selection as array
for i = 1 to (sel.count - 1) do
(
	format "parent % to % \n" sel[i].name sel[i+1].name
	sel[i].parent = sel[i+1]
)

-- rescale ctl to [1,1,1]

sel = selection as array
for s in sel do print s.scale

$.scale.controller.value

 = [1,1,0.597129]
$.scale.controller.value = [1,0.999999,0.339]

$.objectoffsetscale
-- scale à [1,1,1]

sel = selection as array
for s in sel do
(
	s.scale.controller.value = [1,1,1]
)

--  symetriser scale sur controls box
sel = selection as array

$.material = undefined

undo on
(
	if sel.count == 2 then
	(
		sel[2].scale.controller.value = sel[1].scale.controller.value
-- 		sel[2].position.controller.value = sel[1].position.controller.value
		print "done"
	)
	redrawViews() 
)

-- symmetriser la position
sel = selection as array

undo on
(
	if sel.count == 2 then
	(
		
		sel[2].position = sel[1].position
		print "done"
	)
	redrawViews() 
)

$.scale = [1,1,1]

in coordsys parent $.position

/* TRANSFERT MODIFIERS */
-- transfer modifiers

sel = selection as array
undo on
(
	if sel.count == 2 then
	(
		tgt = sel[2]
		src = sel[1]

		/*
		-- recuperer les modifiers de source
		modAr = src.modifiers
		
		select tgt
		-- colle les moifiers sur la target 
		for i = modAr.count to 1  by -1 do
		(
			modPanel.addModToSelection modAr[i]
-- 			addmodifier tgt  modAr[i]
		)
		*/
		
		-- rename target and source
		tgt.name = src.name
		src.name = src.name + "_bak"
	)
	else(print "fail")
)

$.size = 1

$.material = undefined

$.scale

-- resize box used as bone
-- trouver la distance en z de l'enfant de la box selectionnée

sel = selection as array
for s in sel do
(
	childs = s.children 
	if childs.count == 1 then
	(
	-- 	res = in coordsys parent childs[1].position.z
		res = in coordsys parent childs[1].position.x
		-- assigner la valeur à la hauteur de la box
		s.height =res
		redrawViews() 
	)
	else(print "utiliser l'autre méthode")
)

sel = selection as array
childs = sel[1].children 
res = findItem childs sel[2]
if res>0 then sel[1].height =  abs(in coordsys parent sel[2].position.z)

-- if res>0 then sel[1].height =  abs(in coordsys parent sel[2].position.x)

-- transfert box size
sel = selection as array
sel[2].length = sel[1].length
sel[2].width = sel[1].width
sel[2].height = sel[1].height


-- Copy/paste control instance
-- sel = selection as array

fn connectControl sel =
(
	src = sel[1]
	dest = sel[2]
	
	setTransformLockFlags  src #none
	setTransformLockFlags  dest #none
	
	dest.position.controller[2].controller = src.position.controller[2].controller
	dest.rotation.controller[2].controller = src.rotation.controller[2].controller
)



sel = selection as array
connectControl sel

-- resize helper
for s in selection do s.size = 10
	
-- patch boxbip
for s in selection do
(
	s.wirecolor = (color 177 88 27)
	s.boxmode = true
	s.name = substituteString s.name "BOXBIP" "_BOXBIP"
)

-- orientation constraint
select ($.rotation.controller[3].getNode 1)


-- pos constraint 
sel = selection as array

slave = sel[sel.count]
slave.position.controller  =  position_constraint ()
for i = 1 to (sel.count - 1) do
(
	slave.position.controller.appendTarget sel[i] 100
)

-- look at constraint
sel = selection as array
slave = sel[sel.count]
slave.rotation.controller = lookat_constraint upnode_world: off 
for i = 1 to (sel.count - 1) do
(
	slave.rotation.controller.appendTarget sel[i] 100
)
slave.rotation.controller.pickUpNode = sel[1]

select $.rotation.controller[2].pickUpNode
select $.rotation.controller.pickUpNode

--
$.cross = off

$.scale = [1,1,1]

$.scale

$.transform

distance selection[1] selection[2]