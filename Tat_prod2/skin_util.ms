 -- select in scene bone selected in skin modifier
m = modPanel.getCurrentObject() 
if classof m == skin then
(
	boneId = skinOps.GetSelectedBone m
	res = skinOps.GetBoneName m boneId 0
	select (getnodebyname res)
)
else(print "fail")

$.pivot = $.center

$.material = undefined

-- select vertex by bone selected in skin modifier
fn selVertByBones =
(
	m = modPanel.getCurrentObject() 
	if classof m == skin then
	(
		-- collecter le bone selectionner
		boneId = skinOps.GetSelectedBone m
		-- recuperer le nombre vertex de la mesh
		vxCount = $.editablepoly.GetNumVertices ()

		goodVxAr = #()
		for i = 1 to vxCount do
		(
		-- pour chaque vertex
			-- trouver le nombre d'influence
			maxInf = skinOps.GetVertexWeightCount m i
			
			for id = 1 to maxinf do
			(
				res = skinOps.GetVertexWeightBoneID m i id
				-- si le bone selectionner est dans les influence du vertex collecter le numero du vertex
				if res == boneId do append goodVxAr i
			)
		)
		-- selectionner les vertex collectés
		skinOps.SelectVertices m goodVxAr
	)
	else(print "fail")
)

selVertByBones()


-- keep selection
selAr =#()
m = modPanel.getCurrentObject() 
vxCount = $.editablepoly.GetNumVertices ()


vxSelAr = #()
for i = 1 to vxCount do
(
	if (skinOps.IsVertexSelected  m i) == 1 then append vxSelAr i
)
append selAr vxSelAr

-- print vxSelAr

print selAr

skinOps.SelectVertices m selAr[1]
redrawviews()

$.scale


/* transfer weight skin */

sel = selection as array
-- selectionner le bone source
src = sel[1]
-- selectionner le bone target
tgt = sel[2]
-- selectionner la mesh avec le skin
m = sel[3].modifiers["skin"]
-- recupérer le nombre de vertex de la mesh
vxCount = sel[3].editablepoly.GetNumVertices ()
-- activer le modifier skin
modPanel.setCurrentObject m

m = modPanel.getCurrentObject() 
-- tester si le bone source est dans le skin
bnsNum = skinOps.GetNumberBones m

for i = 1 to bnsNum do
(
	res = skinOps.GetBoneName m i 0
	n = getNodeByName res
	print res
)


-- pour chaque bone du skin comparer avec le bone source
srcId = undefined
tgtId = undefined
for i = 1 to bnsNum do
(
	res = skinOps.GetBoneName m i 0
	if src.name == res then
	(
		-- si on trouve le bone source conserver le boneID
		format "youpi! source: %, current: %; boneID: %\n" src.name res i
		srcId = i
	)
	else if tgt.name == res then
	(
		-- si on trouve le bone target conserver le boneID
		format "youpi! target: %, current: %; boneID: %\n" tgt.name res i
		tgtId = i
	)
)
srcId
tgtId


if tgtId == undefined then
(
	-- ajouter le bone au skin avec un poids de zero
	-- recuperer l'id
	--
)

-- dans le skin pour chaque vertex
for id = 1 to vxCount do
(
	-- skinOps.unNormalizeVertex true
	-- chercher le nombre d'influence
	-- pour chaque influence comparer avec l'id du bone source
		-- si l'id  est trouvée
			-- sauver l influence du bone source
			-- mettre l'influence du bone source à zero
			-- sauver l'influence du bone target
			-- ajouter l'influence source à l'influence target
	-- 	skinOps.unNormalizeVertex false
)
	
/*
skinOps.GetVertexWeight <Skin> <vertex_integer> <vertex_bone_integer> 
skinOps.GetVertexWeightBoneID <Skin> <vertex_integer> <vertex_bone_integer> 
skinOps.GetVertexWeightCount <Skin> <vertex_integer> 
skinOps.SelectVertices <Skin> \ ( <vertex_integer> | <vertex_array > | <<vertex_bitarray> ) 
*/

$.scale = [1,1,1]
$.material = undefined

-- remove unused bones

$.showVertexColors = off

-- skinOps.GetVertexWeightBoneID m i id

-- skinOps.removebone <Skin><BoneID_integer> 
-- skinOps.GetBoneName m 95 0

m = modPanel.getCurrentObject() 
skinOps.multiRemove m

-- replace bipskin
geom = geometry as array
bsAr = #()

for g in geom do
(
	res = findstring g.name "_BIPSKIN"
	if res != undefined then append bsAr g
)
select bsAr

bipAr = #()
for bs in bsAr do
(
	bipName = substitutestring bs.name "_BIPSKIN" "_BIP"
	res = getnodebyname bipName
	append bipAr res
)
select bipAr
selectmore bsAr

-- TRANSFERT skin weight
sel = selection as array

for s in bsAr do
(
-- s = $
skinAr = #(s, s.parent)
fn_changeBoneToBoneInfluence nodelist: skinAr
redrawviews ()

-- replace skinbip parent
dad = s.parent
childs = for c in s.children collect c
for c in childs do c.parent = dad

s.wirecolor = green 

setTransformLockFlags s #{}
)
select bsAr


-- find head of selection
sel = selection as array
for s in sel do
(
	search = finditem sel s.parent
	if search != 0 then deselect  s
-- 	print search
)







skinOps.saveEnvelopeAsASCII $.modifiers["skin"] @"C:\Users\TAT\Documents\3dsMax\Skin\ElephantB.env"
skinOps.loadEnvelopeAsASCII $.modifiers["skin"] @"C:\Users\TAT\Documents\3dsMax\Skin\ElephantB.env"
