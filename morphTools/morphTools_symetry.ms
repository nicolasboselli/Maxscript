-- copy clean base object
-- copyS = copy $
-- for i = 1 to copyS.modifiers.count do deletemodifier copyS 1
-- select copyS

sel = selection as array
morphObj = sel[sel.count]
skinWrapObj = copy morphObj

-- sur la destination creer un morph 
tmorph = morpher()
addmodifier morphObj tmorph

-- ajouter toutes les meshes dans le morph
for i = 1 to (sel.count - 1) do
(
	WM3_MC_BuildFromNode tmorph i sel[i]
)


-- liste des canaux à symetriser:
mmorph = morphObj.modifiers["Morpher"]

channelList = #()
for i = 1 to 100 do
(
	res1 = WM3_MC_HasData mmorph i
	res2 = WM3_MC_HasTarget  mmorph i
	if res1 or res2 then append channelList i
)
format "morph num end: %\n" channelList

-- symetrise base morpher
morphObj.scale.controller.value = [-1,1,1]
morphObj.boxmode = true

-- create symetric skinwrap sur la base
addmodifier skinWrapObj (skin_wrap ()) 
sw = skinWrapObj.modifiers[#skin_wrap]
sw.meshList = #(morphObj)
sw.falloff  = 0.1
sw.distance  = 0.1
sw.weightAllVerts = on
	
-- extract morph symmetric
morphList = #()
-- 	c = 1
for c in channelList do
(
		-- pousser la target a 100
	WM3_MC_SetValue mmorph c 100.0
	newName = WM3_MC_GetName mmorph c
		-- dupliquer la mesh
	newMesh = snapshot skinWrapObj
	newMesh.name = uniquename newName
	WM3_MC_SetValue   mmorph c 0.0
	append morphList newMesh
)
select morphList

-- delete morphList


