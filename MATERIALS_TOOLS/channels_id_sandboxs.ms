/*
 faire travailler au choix sur la scene, les objets visibles ou la selection d'objet
*/


-- appliquer une id de materiau aux materiaux des object selectionnés
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
-- sceneMat.count
usedIds = #()
for m in sceneMat do
(
	
	format "channel id: % mat name: %\n" m.effect_id m.name
	appendifunique usedIds m.effect_id
)
usedIds

-- appliquer les ids de materiaux en evitant les ids deja attribuées
-- j = 0
forceID = false
for i = 1 to matAr.count do
(
	-- verifier l'id déja affecté 
	local res = finditem usedIds i
	
	-- si l'idée est deja affecter passer
	if res > 0 and not forceID then continue
	
	-- si une id est déja affecter au materiaux
	if matAr[i].effect_id != 0 and not forceID then
	(
			-- eviter de l'affecter ailleurs
			-- 
		format "i: % deja assign: % id: %\n" i matAr[i].name matAr[i].effect_id
	)
	else
	(
		matAr[i].override_effect_id = on
		matAr[i].effect_id = i
		format "id: % assign: %\n" i matAr[i].name
	)
)

-- pour chaque chaque id de materiau créer un couche vray object selected
-- ajouter la couche vrayMtlID
rem =MaxOps.GetCurRenderElementMgr ()
vrMtlID = VRayMtlID filterOn: true output_type: 1
rem.AddRenderElement vrMtlID

-- setter sur filtering et color
rem =MaxOps.GetCurRenderElementMgr ()
sceneMat = getclassinstances vrayMtl target: scenematerials
for m in sceneMat do
(
	if m.effect_id > 0 then
	(
		format "channel id: % mat name: %\n" m.effect_id m.name
		vrObjSelElt = VRayObjectSelect elementName: ("idMat_" + m.name) mode: 1 object_id: m.effect_id  use_material_id: true consider_for_antialiasing: true
		rem.AddRenderElement vrObjSelElt
	)
)

-- retourner les passes VRayObjectSelect du render element pour les supprimer
rem =MaxOps.GetCurRenderElementMgr ()
eltsNum = rem.NumRenderElements()
for i = 0 to (eltsNum - 1) do
(
	elt = rem.GetRenderElement i
	if iskindof elt VRayObjectSelect then
	(
		if elt.use_material_id then
		(
			format "%\n"	(rem.GetRenderElement i).elementName
		)
	)
)




