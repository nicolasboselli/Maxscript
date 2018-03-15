copyS = copy $
for i = 1 to copyS.modifiers.count do deletemodifier copyS 1
select copyS

-- source
src = $P_LeLoup_MDL
-- destination
dest = $P_LeLoup_MDL001

-- créer un skinwrap sur la destination

-- pour chaque target du morph de la source:
mmorph = src.modifiers["Morpher"]


channelMax = 0
for i = 1 to 100 do
(
	res1 = WM3_MC_HasData mmorph i
	res2 = WM3_MC_HasTarget  mmorph i
	if res1 or res2 then channelMax = i
)
format "morph num end: %\n" channelMax



morphList = #()
for i = 1 to channelMax do
(
		-- pousser la target a 100
	WM3_MC_SetValue   mmorph i 100.0
		-- dupliquer la mesh
	newMesh = snapshot dest
	WM3_MC_SetValue   mmorph i 0.0
	append morphList newMesh
)
select morphList


-- sur la destination creer un morph 

tmorph = morpher()
addmodifier dest tmorph

-- ajouter toutes les meshes dans le morph
for i = 1 to morphList.count do
(
	WM3_MC_BuildFromNode tmorph i morphList[i]
)
delete morphList

-- 
res = copy $
for i = 1 to res.modifiers.count do deletemodifier $ 1 
