
-- appliquer une id de materiau au materiaux selectionné
sel = selection as array
matSel = for s in sel where s.material != undefined collect s.material
	
matAr = #()
for m in matSel do
(
	tmpMatAr = getclassinstances vrayMtl target: m
	for tmpM in tmpMatAr do appendifunique matAr tmpM
)
matAr

-- collecter les ids de materiau dans la scene
sceneMat = getclassinstances vrayMtl target: scenematerials
usedIds = #()
for m in sceneMat do
(
	appendifunique usedIds m.effectsChannel
)
usedIds

-- appliquer les ids de materiaux en evitant les ids deja attribuées
j = 0
for i = 1 to (matAr.count + j) do
(
	if matAr[i].effectsChannel != 0 then
	(
		res = finditem usedIds i
		format "deja assign: %, %, %\n" i matAr[i].name matAr[i].effectsChannel
	)
	else
	(
		format "assign: %, %\n" i matAr[i].name
	)

-- 	format "%, %\n" i matAr[i].name
-- 	matAr[i].effectsChannel = i
)



-- ajouter la couche vrayMtlID
	-- setter sur filtering et color


-- pour chaque chaque id de materiau créer un couche vray object selected