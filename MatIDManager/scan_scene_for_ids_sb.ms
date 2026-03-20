-- collecte des ids d'objets pas defaut de visiolab
fn updateObjectsIDsElts =
(
	-- add object ids
	local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"

	local VisioIdsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr")
	local VisioLabelsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioLabelsAr")
		
	-- trouver les ids d'objets de la scène
	local allSceneOjectsIds = #()
		
	for o in geometry where o.gbufferChannel > 0 do
	(
		appendifunique allSceneOjectsIds o.gbufferChannel
	)
-- 	allSceneOjectsIds
		
	-- supprimer les vielles passes d'ids d'objets
	local rem =MaxOps.GetCurRenderElementMgr ()		
	eltsNum = rem.NumRenderElements()

	-- test = rem.GetRenderElement 30
	-- showproperties test.MatID

	-- supprimer exlusivement les passes d'objects ids
	for i = (eltsNum - 1) to 0 by -1 do
	(
		elt = rem.GetRenderElement i
		if iskindof elt multimatteElement and not elt.MatID then rem.RemoveRenderElement elt
	)

	-- créer les passes d'id d'objets
	for id in allSceneOjectsIds do
	(
		local res = finditem VisioIdsAr id
		
		if res > 0 then 
		(
	-- 		format "VisioIdsAr: % VisioLabelsAr: %\n" VisioIdsAr[res] VisioLabelsAr[res]
			local superName = "objId_" + (VisioIdsAr[res] as string) + "_" + VisioLabelsAr[res]
			local objIDElt = multimatteElement elementName: superName R_gbufID: VisioIdsAr[res] G_gbufID: VisioIdsAr[res] B_gbufID: VisioIdsAr[res] MatID: false
			rem.AddRenderElement objIDElt
		)
		else if res == 0 then
		(
			local superName = "objId_" + (VisioIdsAr[res] as string) + "_label" + ((random 0 1000) as string)
			local objIDElt = multimatteElement elementName: superName R_gbufID: VisioIdsAr[res] G_gbufID: VisioIdsAr[res] B_gbufID: VisioIdsAr[res] MatID: false
			rem.AddRenderElement objIDElt
		)
		else()

	)
)

fn updateMatIDeElts =
(
	-- trouver les ids de materials de la scene
	sceneVrayMatAr = getClassInstances VRayMtl target: scenematerials

	-- collecter un array d'id mat avec un array de noms
	matIdsAr = #()
	matNamesAr = #()
	for m in sceneVrayMatAr do
	(
		if ( appendifunique matIdsAr m.effect_id ) then ( appendifunique matNamesAr m.name )
	)

	-- supprimer les vielles passes d'ids d'objetsfor i = (eltsNum - 1) to 0 by -1 do
	rem =MaxOps.GetCurRenderElementMgr ()		
	eltsNum = rem.NumRenderElements()

	for i = (eltsNum - 1) to 0 by -1 do
	(
		elt = rem.GetRenderElement i
		if iskindof elt multimatteElement and elt.MatID then rem.RemoveRenderElement elt
	)

	-- créer les passes d'id materials
	for i = 1 to matIdsAr.count where matIdsAr[i] > 0 do 
	(
		local superName = "matId_" + (matIdsAr[i] as string) +  "_" + matNamesAr[i]
		local matIDElt = multimatteElement elementName: superName R_gbufID: matIdsAr[i] G_gbufID: matIdsAr[i] B_gbufID: matIdsAr[i] MatID: true
		rem.AddRenderElement matIDElt
	-- 	format "superName: %\n" superName
	)
)

updateObjectsIDsElts()
updateMatIDeElts()
