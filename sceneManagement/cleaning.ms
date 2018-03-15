/*
maj: faire un check du fichier qui marque dans les files properties
	- s il y a des railclone dans la scene
	- s il y a des multi materiaux dans la scene
*/


-- collapse railclone
objs = objects as array
-- objs = selection as array

i = 0
for o in objs where classof o.baseobject == railclone_pro do
(
	format "railclone:%\n" o.name
	o.rendermode = off
	o.weld = off
	o.weldth = 0

	o.vmesh = 0
	o.faceType = 1
	i = i +1
)

sel = #()
for o in objs where classof o.baseobject == railclone_pro do
(
	append sel o
)
-- select sel

for o in objs where classof o.baseobject == railclone_pro do
(
	converttopoly o
	format "convert done:%\n" o.name
)



-- collapse sweep
objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
	local atLeastOneConvertion = false
	for m in o.modifiers where classof m == sweep do
	(
		atLeastOneConvertion = true
		format "obj: %, mod: %\n" o m
		converttopoly o
	)
	
	if not atLeastOneConvertion then format "Pas de modifiers clone à collapser."

)

-- collapse clone 
sel = #()
objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
-- 	local atLeastOneConvertion = false
	for m in o.modifiers where classof m == clone do
	(
		atLeastOneConvertion = true
		format "obj: %, mod: %\n" o m
		append sel o
		converttopoly o
	)
	
-- 	if not atLeastOneConvertion then 
)
if sel.count == 0 then format "Pas de modifiers clone à collapser.\n"
	

-- select sel

-- find edit poly
/*
col= #()
objs = objects as array
for o in objs where o.modifiers.count >= 1 do
(
	for m in o.modifiers where classof m == edit_poly do
	(
		format "obj: %, mod: %\n" o m
		append col o
	)
)
*/
-- select col


-- VRayEdgesTex ()
-- meditMaterials[21].texmap_bump.widthType = 0
-- meditMaterials[21].texmap_bump.thickness = 0.2

-- vrEdge = VRayEdgesTex widthType: 0 thickness: 0.2
-- meditMaterials[activeMeditSlot].texmap_bump = vrEdge