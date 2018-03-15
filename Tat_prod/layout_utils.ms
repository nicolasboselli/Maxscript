-- 	selectionner des objets par pattern de nom
search = "*LAYOUT001"
sel = for o in objects where matchpattern o.name pattern: search collect o
select sel

--  substituer un pattern dans des nom d'objets de la scene / enlever Layout a la fin des noms
search = "_LAYOUT"
change = ""
sel = objects as array
-- sel = selection as array
for s in sel do
(
	if classof s != TAT_AnimNode then
	(
		oldName = s.name 
		s.name  = substituteString oldName search change
	)
)

-- ajouter layout a la fin des noms
sel = objects as array
-- sel = selection as array
for s in sel do
(
	if classof s != TAT_LayoutNode or s != TAT_AnimNode then
	(
		res = matchPattern s.name pattern:"*_LAYOUT"
		if res == false then
		(
			s.name  = s.name + "_LAYOUT"
			print s.name
		)
	)
)


-- rename tat node
sel = objects as array
-- sel = selection as array
for s in sel do
(
	if classof s == TAT_AnimNode then
	(
		s.name  = s.name + "_LAYOUT"
	)
)

-- rename ctrl oeil
objs = helpers as array
for o in objs do
(
	res = matchPattern o.name pattern:"*_?_Oeil_Scale_CTRL_LAYOUT"
	if res == true then print o
)

-- trouver facial control
facRoot = undefined
hlps = helpers as array
for h in hlps do
(
	res = matchPattern h.name pattern:"*_Facial_Root_RIG_LAYOUT"
	if res == true then facRoot = h
)
select facRoot


-- trouver ctrl oeil
yeux = #()
hlps = helpers as array
for h in hlps do
(
	res = matchPattern h.name pattern:"*_Oeil_RIG_LAYOUT"
	if res == true then
	(
		h.parent = facRoot
		newname = substitutestring h.name "_RIG_" "_CTRL_"
		h.name = newname
		append yeux h
	)
)
select yeux


-- find ctrl paupiere
paupRig = for h in helpers where matchPattern h.name pattern:"*_Paupiere*_Parent*_RIG_LAYOUT" collect h
select paupRig




-- rig oeil to delete
patternTodel = #(
"*_?_Oeil_Scale_CTRL_LAYOUT",
"*_?_Oeil_spaceFFD_RIG_LAYOUT",
"*_?_Oeil_ScaleForAnim_RIG_LAYOUT"
)

objsTodel = #()
objs = objects as array
for o in objs do
(
	for p in patternTodel do
	(
		res = matchPattern o.name pattern: p
		if res == true then
		(
			append objsTodel o
			print o
		)
	)
)
select objsTodel

-- rename parent arm
parentArm = #()
objs = objects as array
for o in objs do
(
	res = matchPattern o.name pattern:"*ParentArm*"
	if res == true then 
	(
-- 		o.name  = o.name + "_LAYOUT"
		append parentArm o
	)
)
select parentArm


-- delete skinmorph helpers
skinHlps = #()
hlps = helpers as array
for h in hlps do
(
	res = matchPattern h.name pattern:"*_skinmorph_*"
	if res == true then append skinHlps h
)
select skinHlps


-- replace bones in skin
sel = selection as array
for s in sel do
(
	skinAr = #()
	for c in s.children do append skinAr c
	append skinAr s
	fn_changeBoneToBoneInfluence nodelist: skinAr
	redrawviews ()
)

sel = selection as array
for s in sel do
(
	skinAr = #(s, s.parent)
	fn_changeBoneToBoneInfluence nodelist: skinAr
	redrawviews ()
)

skinAr = #($, $.parent)
fn_changeBoneToBoneInfluence nodelist: skinAr
redrawviews ()


-- rename LO
for s in selection do
(
	s.name = substitutestring s.parent.name "_RIG" "_LO"
)

-- retirer le suffixe "layout"
sel = objects as array
for s in sel do
(
	if classof s != TAT_AnimNode then
	(
		res = matchpattern s.name pattern: "*_LAYOUT"
		if res == true then s.name = substitutestring s.name "_LAYOUT" ""
	)
)

-- fn_changeBoneToBoneInfluence nodelist: sel


-- ############################ TRAITEMENT LAYOUT SAISON 2 ###################

-- trouve et renomme ROOT
nameAr = filterString  maxFileName "_"
basename = nameAr[1] + "_" + nameAr[2]

rootObj = getnodebyname (nameAr[1] + "_" + nameAr[2] + "_Layout")

-- rootObj = getnodebyname (nameAr[1] + "_" + nameAr[2] + "_LAYOUT")

if rootObj != undefined then
(
	if classof rootObj != TAT_LayoutNode then
	(
		rootObj.name = substitutestring rootObj.name "_Layout" "_ROOT_LAYOUT"
		print "rename root done"
	)
)
ptRoot = getnodebyname (nameAr[1] + "_" + nameAr[2] + "_ROOT_LAYOUT")




-- trouver le pelvis
pelvis = undefined
searchPelvis = #("Pelvis","Hanche", "Bassin","Queue")
sel = geometry as array
for s in sel do
(
	for p in searchPelvis do
	(
		if pelvis == undefined then
		(
			res2 = matchPattern s.name pattern: ("*_" + p + "_*")
			if res2 == true then pelvis = s
	-- 		if res != undefined then append bipAr res
		)
	)
)
select pelvis


-- trouver le spine1
spine = undefined
searchSpine = #("Spine", "Spine1", "Spine2")
sel = geometry as array
for s in sel do
(
	for p in searchSpine do
	(
		if spine == undefined then
		(
			res2 = matchPattern s.name pattern: ("*_" + p + "_*")
			if res2 == true then spine = s
	-- 		if res != undefined then append bipAr res
		)
	)
)
select spine

select pelvis
selectmore spine

-- pelvis = $

-- creation du parent_ctrl
-- ptRoot = point name: (basename + "_ROOT") wirecolor: (color 14 255 2)  size: 50 box: on cross: off axistripod: off centermarker: off
ptParent = point name: (basename + "_Parent_CTRL_LAYOUT") wirecolor: (color 225 198 87) size: ptRoot.size box: off cross: on axistripod: off centermarker: off
ptParent.parent = ptRoot

ptParent.position = pelvis.position
pelvis.parent = ptParent
spine.parent = ptParent


-- assigner le ctrl au layer et rename du layer
persoLayer = undefined
res = LayerManager.getLayerFromName (basename + "_Layout")
(
	if res == undefined then
	(
		if nameAr[1] == "P" then persoLayer = LayerManager.getLayerFromName "P_Persos_Layout"
		else if nameAr[1] == "A" then persoLayer = LayerManager.getLayerFromName "A_Props_Layout"
		if persoLayer != undefined then
		(
			persoLayer.setName (basename + "_LAYOUT")
			if ptParent != undefined then persoLayer.addNode ptParent
		)
	)
	else print "exist"
)

-- !!!!!!!!!!! active LO
-- !!!!!!!!!!! CHECK RECORD CTRL
-- !!!!!!!!!!! CHECK RECORD ROOT

-- !!!!!!!!!!! FREEZE TRANSFORM



-- trouver bip control
bipAr = #()
CtrlAr = #()

BipTagsAr = #("Bip001", "Footsteps", "Pelvis", "Spine", "Spine1", "Spine2", "Spine3", "Neck", "Neck1", "Clavicle", \
"UpperArm", "Forearm", "Hand", "Finger0", "Clavicle", "UpperArm", "Forearm", \
"Hand", "Finger0", "Head", "Thigh", "Calf", "Foot", "Toe0", "Toe01", "Toe02", "Thigh", "Calf" ,"Foot" ,"Toe0", "Toe01" ,"Toe02")

sel = geometry as array
for s in sel do
(
	for b in BipTagsAr do
	(
		res2 = matchPattern s.name pattern: ("*_" + b + "_*")
		if res2 == true then append bipAr s
-- 		if res != undefined then append bipAr res
	)
)
select bipAr

-- tri bip et ctrl
sel = objects as array
for s in sel do
(
	res = matchPattern s.name pattern:"*_BIP_LAYOUT"
	if res == true then append bipAr s
		
	res2 = matchPattern s.name pattern:"*_CTRL_LAYOUT"
	if res2 == true then append CtrlAr s
)

select bipAr
select ctrlAr

-- !!!!!!!!!!!!!!!!!!!!!!!!!!! MIRROR Z sur Bip
-- !!!!!!!!!!!!!!!!!!!!!!!!!!! test MIRROR


-- change framerate
frameRate = 24


--  Locker ctrl en scale et translation
-- selectionner ctrl
fn lockCtrls ctrl =
(
	bakSel = ctrl
	for s in selection do selectmore s.children
	sel = selection as array
	for s in sel do setTransformLockFlags s #{1..3,7..9}
	setTransformLockFlags bakSel #{7..9}
)

lockCtrls $

--  RENAME layout
sel = geometry as array
for s in sel do s.name = substituteString s.name "_Layout" "_LAYOUT"


-- !!!!!!!!!!! RENAME CHARACTER si necessaire
-- !!!!!!!!!!! SAVE Fichier avec le bon nom

-- rename materiaux
for i = 1 to scenematerials.count do  meditmaterials[i] = scenematerials[i]

for m in scenematerials do
(
	resMat = matchPattern m.name pattern: (basename + "_*_LD")
	if resMat == false then
	(
		m.name = substitutestring m.name (basename + "_") ""
		m.name = substitutestring m.name "_LD" ""
		m.name = substitutestring m.name "_ANM" ""
		m.name = basename  + "_" +  m.name + "_LD"
	)		
-- 	print m.name
)

-- collect bad materials
badMatAr = #()
for m in scenematerials do
(
	res = matchpattern m.name pattern: "A_EchafaudageElephant_*LD"
	if res != true then append badMatAr m
		
)
print badMatAr
for i = 1 to badMatAr.count do  meditmaterials[i] = badMatAr[i]

$.material = undefined


-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! POCPOC

	

-- test clear
if (objects as array).count == 0 then print "youpi" else print "bouh"
