
try(destroydialog passesManagementRLT)catch()
rollout passesManagementRLT "Passes Management"
(
	
	local renderPresetPath = @"M:\Biblio\Render_Presets\VisiolabPreset"
	
	group "Fix Colour Management:"
	(
		button fixVrBmpBT "Fix Vray Bitmap" across: 2
		button fixColourManagementBT "Fix Colour Management"
	)
	
	group "Render Settings:"
	(
		listbox renderSettingsLB "Render Settings List:"
		
		button loadSettingsBT "Load Settings"
	)
		
	group "Render Elements:"
	(
		button extPassesBT "Load Exterieur Passes" across: 2 
		button intPassesBT "Load Interio Passes"
		
		listbox renderElementsLB "Render Elements List:"
		
		button loadRenderEltsListBT "Load Render Elements"
	)
	
	group "Arbres Settings:"
	(
		
		-- parametrer les objets en by layer et id 55
		-- parametrer le calque en non visble to camera
		-- parametrer vray en rende mask layer
	)
	
	fn loadPreset =
	(
-- 		format "%\n" (renderPresetPath + "\renderSettings\*.rps")
		local renderSettingstFiles = getFiles (renderPresetPath + "\\renderSettings\*.rps")
		local renderElementsFiles = getFiles (renderPresetPath + "\\renderElements\*.rps")
		
		renderSettingsLB.items = for f in renderSettingstFiles collect ( getFilenameFile f )
		renderElementsLB.items = for f in renderElementsFiles collect ( getFilenameFile f )
		
-- 		format "renderSettingstFiles: % renderElementsFiles: %\n" renderSettingstFiles renderElementsFiles

/* 		for f in renderSettingstFiles do
		(
			cat = renderPresets.LoadCategories f
			for c in cat do
			(
				format "%: %\n" c (renderpresets.MapIndexToCategory f c)
			)
		) */
	)
	
	on passesManagementRLT open do
	(
		loadPreset()
	)
	
	on fixVrBmpBT pressed do
	(
		VrBmpAr = getClassInstances VRayBitmap --target: sceneMaterials 
		for o in VrBmpAr do o.color_space = 2
	)
	
	on fixColourManagementBT pressed do
	(
		ColorPipelineMgr.SetDefaultOutputConversion  #ColorSpaceConversion colorSpace: "sRGB"
	)
		
	on loadSettingsBT pressed do
	(
		format "renderSettingsLB.selected: % renderSettingsLB.selection: %\n" renderSettingsLB.selected renderSettingsLB.selection
		
		local tmpFileName = (renderPresetPath + "\\renderSettings\\" + renderSettingsLB.selected + ".rps")
		
		if doesFileExist tmpFileName then
		(
/* 			format "tmpFileName: %\n" tmpFileName
			
			cat = renderPresets.LoadCategories tmpFileName
			for c in cat do
			(
				format "%: %\n" c (renderpresets.MapIndexToCategory tmpFileName c)
			) */
			
			renderpresets.Load 0 tmpFileName #{32}
			
		)
	)
	
	on extPassesBT pressed do
	(
		
		rem =MaxOps.GetCurRenderElementMgr ()
		
		-- nettoyage render elements lists
		eltsNum = rem.NumRenderElements()

		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			rem.RemoveRenderElement elt
		)

		-- rem.AddRenderElement (VRayDenoiser())	
		-- rem.AddRenderElement (VRayDiffuseFilter())	
		
/* 		vue003_PROJET
vue003_PROJET.Alpha
vue003_PROJET.objId_8_GC
vue003_PROJET.matId_4_dalles_balcons ou éléments marquant du projet (Corten ou autre)
vue003_PROJET.objId_2_Vitres
vue003_PROJET.objId_4_Menuiserie
vue003_PROJET.objId_6_Cloture
vue003_PROJET.objId_8_GC
vue003_PROJET.objId_10_Haies
vue003_PROJET.objId_25_Plantes
vue003_PROJET.objId_45_Habillage
vue003_PROJET.objId_50_Herbe
vue003_PROJET.objId_55_Arbres
vue003_PROJET.VRayAO
vue003_PROJET.VRayDiffuseFilter
vue003_PROJET.VRayRawGlobalIllumination
vue003_PROJET.VRayRawLighting
vue003_PROJET.VRayRawReflection
vue003_PROJET.VRayRawReflectionFilter
vue003_PROJET.VRayRawRefraction
vue003_PROJET.VRayRawRefractionFilter
vue003_PROJET.VRayRawShadow
vue003_PROJET.VRayRawTotalLighting
vue003_PROJET.VRayRenderID
vue003_PROJET.VRayWireColor */
		

		local extElts = 	#( VRayAlpha (), \
			VRayDiffuseFilter (), \
			VRayAO(), \
			VRayRawDiffuseFilter(), \
			VRayRawGlobalIllumination(), \
			VRayRawLighting(), \
			VRayRawReflection(), \
			VRayRawReflectionFilter(), \
			VRayRawRefraction(), \
			VRayRawRefractionFilter(), \
			VRayRawShadow(), \
			VRayRawTotalLighting(), \
			VRayRenderID(), \
			VRayWireColor(), \
			
			VRayDenoiser()
			)
		
-- 		matSel = multimatteElement elementName: superName R_gbufID: matArToDisp[i].effect_id G_gbufID: matArToDisp[i].effect_id B_gbufID: matArToDisp[i].effect_id MatID: true
		for elt in extElts do rem.AddRenderElement elt
		
		local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
		VisioIdsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr")
		
		
		for oneID in VisioIdsAr do
		(
			local superName = "objectsId_" + (oneID as string) --  + "_" + mat.name
-- 				format "check2\n"
			local objIDElt = multimatteElement elementName: superName R_gbufID: oneID G_gbufID: oneID B_gbufID: oneID MatID: false
			rem.AddRenderElement objIDElt
		)
		
	)
	
	on renderElementsLB selected v do
	(
		format "arg: %\n" v
	)
	
	on loadRenderEltsListBT pressed do
	(
		format "renderSettingsLB.selected: % renderSettingsLB.selection: %\n" renderElementsLB.selected renderElementsLB.selection
		
		local tmpFileName = (renderPresetPath + "\\renderElements\\" + renderElementsLB.selected + ".rps")
		
		if doesFileExist tmpFileName do
		(
/* 			 format "tmpFileName: %\n" tmpFileName

			cat = renderPresets.LoadCategories tmpFileName
			for c in cat do
			(
				format "%: %\n" c (renderpresets.MapIndexToCategory tmpFileName c)
			) */
			
			renderpresets.Load 0 tmpFileName #{4}
		)
	)
)
createdialog passesManagementRLT width: 400




	

	
/*
passe_interieures

INT_M05 02
INT_M05 02_.Alpha
INT_M05 02_.PASSE_Arbre
INT_M05 02_.PASSE_cloture
INT_M05 02_.PASSE_GC
INT_M05 02_.PASSE_haie
INT_M05 02_.PASSE_herbe
INT_M05 02_.PASSE_Menuiserie
INT_M05 02_.PASSE_chaises
INT_M05 02_.PASSE_terrasse
INT_M05 02_.PASSE_sol
INT_M05 02_.PASSE_plafond
INT_M05 02_.VRayDiffuseFilter
INT_M05 02_.VRayExtraTex ou AO
INT_M05 02_.VRayRawGlobalIllumination
INT_M05 02_.VRayRawLighting
INT_M05 02_.VRayRawReflection
INT_M05 02_.VRayRawReflectionFilter
INT_M05 02_.VRayRawRefraction
INT_M05 02_.VRayRawRefractionFilter
INT_M05 02_.VRayRawShadow
INT_M05 02_.VRayRawTotalLighting
INT_M05 02_.VRayRenderID
INT_M05 02_.VRayWireColor

passe exterieures
vue003_PROJET
vue003_PROJET.Alpha
vue003_PROJET.objId_8_GC
vue003_PROJET.matId_4_dalles_balcons ou éléments marquant du projet (Corten ou autre)
vue003_PROJET.objId_2_Vitres
vue003_PROJET.objId_4_Menuiserie
vue003_PROJET.objId_6_Cloture
vue003_PROJET.objId_8_GC
vue003_PROJET.objId_10_Haies
vue003_PROJET.objId_25_Plantes
vue003_PROJET.objId_45_Habillage
vue003_PROJET.objId_50_Herbe
vue003_PROJET.objId_55_Arbres
vue003_PROJET.VRayAO
vue003_PROJET.VRayDiffuseFilter
vue003_PROJET.VRayRawGlobalIllumination
vue003_PROJET.VRayRawLighting
vue003_PROJET.VRayRawReflection
vue003_PROJET.VRayRawReflectionFilter
vue003_PROJET.VRayRawRefraction
vue003_PROJET.VRayRawRefractionFilter
vue003_PROJET.VRayRawShadow
vue003_PROJET.VRayRawTotalLighting
vue003_PROJET.VRayRenderID
vue003_PROJET.VRayWireColor

Les passe pour les Arbres :

parametrer les objets en by layer et id 55
parametrer le calque en non visble to camera
parametrer vray en rende mask layer


vue003_ARBRES.Alpha
vue003_ARBRES
vue003_ARBRES.VRayAO
vue003_ARBRES.objId_55_Arbres
vue003_ARBRES.VRayRawLighting
vue003_ARBRES.VRayRawShadow
vue003_ARBRES.VRayRawReflection
vue003_ARBRES.VRayRenderID
vue003_ARBRES.VRayWireColor
*/
