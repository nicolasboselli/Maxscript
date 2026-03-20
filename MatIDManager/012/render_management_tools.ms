/*
maj:

displays = ColorPipelineMgr.GetDisplayList()
displays = ColorPipelineMgr.GetViewList()
ColorPipelineMgr.Locked = false


renderingSpaces = ColorPipelineMgr.GetRenderingColorSpaceList()
fileSpaces = ColorPipelineMgr.GetFileIOColorSpaceList()
displays = ColorPipelineMgr.GetDisplayList()
format "Display View Descriptions:\n"

for dsp in displays do (
    format "Display: %\n" dsp
    vs = ColorPipelineMgr.GetViewList dsp 
    for v in vs do(
        append views v    
        format "  view % : %\n" v (ColorPipelineMgr.GetDisplayViewDescription dsp v)    
    )
)

/autoManagement: fonction pour ajouter uniquement les ids présente dans la scene

x setuper tout le color management par scrpt

x rajouter les ids par default pour l'interieur

x vitre transparente

proposer les ids par defaut pour les materiaux
vitre sur 2
menuiserie sur 4

enduits sur les 100
beton sur les 200
herbes sur les 300
asphalte sur 400
tuiles sur les 500
bac acier sur les 600

avec fonctions pour rendre les ids uniques sur chaque serie ou ajouter cutom attribute sur material

tagguer la bibliothèque

*/
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
-- 			local superName = "objId_" + (VisioIdsAr[res] as string) + "_label" + ((random 0 1000) as string)
-- 			local objIDElt = multimatteElement elementName: superName R_gbufID: VisioIdsAr[res] G_gbufID: VisioIdsAr[res] B_gbufID: VisioIdsAr[res] MatID: false
-- 			rem.AddRenderElement objIDElt
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
		if ( appendifunique matIdsAr m.effect_id ) then ( append matNamesAr m.name )
	)
	
-- 	for i = 1 to matIdsAr.count do 
-- 	(
-- 		format "matIdsAr[i]: % matNamesAr[i]: %\n" matIdsAr[i] matNamesAr[i]
-- 	)
	
	-- supprimer les vielles passes d'ids d'objetsfor i = (eltsNum - 1) to 0 by -1 do
	rem =MaxOps.GetCurRenderElementMgr ()		
	eltsNum = rem.NumRenderElements()

	for i = (eltsNum - 1) to 0 by -1 do
	(
		elt = rem.GetRenderElement i
		if iskindof elt multimatteElement and elt.MatID then rem.RemoveRenderElement elt
	)

	-- créer les passes d'id materials
	for i = 1 to matIdsAr.count where matIdsAr[i] > 0 and  matNamesAr[i] != undefined do 
	(
-- 		format "matIdsAr[i]: % matNamesAr[i]: %\n" matIdsAr[i] matNamesAr[i]
		local superName = "matId_" + (matIdsAr[i] as string) +  "_" + matNamesAr[i]
		local matIDElt = multimatteElement elementName: superName R_gbufID: matIdsAr[i] G_gbufID: matIdsAr[i] B_gbufID: matIdsAr[i] MatID: true
		rem.AddRenderElement matIDElt
	-- 	format "superName: %\n" superName
	)
)


global saveAsPresetRLT = undefined
global passesManagementRLT = undefined

rollout saveAsPresetRLT "Save Preset As"
(
	local newPresetName
	local transferNewName = false
	
	edittext presetNameET "Preset Name:"
	button okBT "Save"
	
/* 	on presetNameET entered val do
	(
-- 		newPresetName = val
		transferNewName = true
		format "presetNameET: yes transferNewName: %\n" transferNewName
		destroydialog saveAsPresetRLT
	) */
	
	on  okBT pressed do
	(
-- 		newPresetName = presetNameET.text
		format "okBT: yes transferNewName: %\n" transferNewName
		transferNewName = true
		destroydialog saveAsPresetRLT
	)
	
 	on saveAsPresetRLT close  do
	(
		passesManagementRLT.presetName = presetNameET.text
		passesManagementRLT.saveNewPreset = transferNewName
		format "saveAsPresetRLT close: newPreset: % saveNewPreset: %\n" presetNameET.text transferNewName
	)
)

try(destroydialog passesManagementRLT)catch()
rollout passesManagementRLT ("Passes Management v." + ( getScriptVersion (getThisScriptFilename()) as string))
(
	local presetName
	local saveNewPreset = false
	local renderPresetPath = @"M:\Biblio\Render_Presets\VisiolabPreset"
	
	local params = #("open")
	
	group "Fix Colour Management:"
	(
		button fixVrBmpBT "Fix Vray Bitmap for OCIO" across: 2
		button fixColourManagementBT "Fix OCIO colour Management"
		button gamma22BT "Gamma 2.2 Colour Management"
	)
	
	group "Render Settings Presets:"
	(
		listbox renderSettingsLB "Render Settings Presets List:"
		button loadSettingsBT "Load Preset" across: 4
		button savePresetBT "Save" enabled: false
		button savePresetAsBT "Save As" enabled: true
		button deletePresetBT "Delete" enabled: true
	)
		
	group "Render Elements Presets:"
	(

-- 		button arbresPassesBT "Load Arbres Passes"
		
		listbox renderElementsLB "Render Elements Presets List:"
-- 		
		button loadRenderEltsListBT "Load Preset" across: 4
		button saveREPresetBT "Save" enabled: false
		button saveREPresetAsBT "Save As" enabled: true
		button deleteREPresetBT "Delete" enabled: true
	)
	
	group "Render Elements Base :"
	(
		button cleanPassesBT "Clean Render Elements" 
		button extPassesBT "Load Default Visiolab Passes" across: 2
		button objIdsPassesBT "Load Default ObjIDs Passes"
		
		button addSceneObjIDsBT "Add scene Objects IDs Elements" across: 2
		button addSceneMatIDsBT "Add scene Materials IDs Elements"
	)
	
	fn loadPreset =
	(
-- 		format "%\n" (renderPresetPath + "\renderSettings\*.rps")
		local renderSettingstFiles = getFiles (renderPresetPath + "\\renderSettings\*.rps")
		local renderElementsFiles = getFiles (renderPresetPath + "\\renderElements\*.rps")
		
		renderSettingsLB.items = for f in renderSettingstFiles collect ( getFilenameFile f )
		renderElementsLB.items = for f in renderElementsFiles collect ( getFilenameFile f )
		
	)
	
	on passesManagementRLT open do
	(
		loadRolloutParams passesManagementRLT params
		loadPreset()
	)
	
	on passesManagementRLT close do
	(
		writeRolloutParams passesManagementRLT params 
	)
	
	on fixVrBmpBT pressed do
	(
		local fixVrBmpBT = 0
		local ignoredCount = 0
		
		format "fix vray bmp color space: started \n"
		VrBmpAr = getClassInstances VRayBitmap --target: sceneMaterials 
		for o in VrBmpAr do
		(
			if not o.color_space == 4 then
			(
				o.color_space = 4
				format "color_space fixed : % \n" o
				fixVrBmpBT +=1
			)
			else
			(
				ignoredCount += 1
			)
		)
		
		format "fix vray bmp color space: done - fixed: % ignored: % \n" fixVrBmpBT ignoredCount
	)
	
	on fixColourManagementBT pressed do
	(
		
		if not ColorPipelineMgr.Mode == #gamma then
		(
			local res = yesNoCancelBox "Vous allez repasser le Colour Management en OCIO. En êtes vous sûr ? "
-- 			
			if res == #yes then
			(
				ColorPipelineMgr.Mode  = #OCIO_Default 
				format "ColorPipelineMgr.Mode  : %\n" ( ColorPipelineMgr.Mode  )
				
				ColorPipelineMgr.RenderingColorSpace = "scene-linear Rec.709-sRGB"
				ColorPipelineMgr.SetDefaultOutputConversion  #ColorSpaceConversion colorSpace: "sRGB"
				format "ColorPipelineMgr.SetDefaultOutputConversion : %\n" ( ColorPipelineMgr.SetDefaultOutputConversion  #ColorSpaceConversion colorSpace: "sRGB" )
			)
			else()
		)
		else 
		( 
-- 			format "ColorPipelineMgr.Mode : %\n" ( ColorPipelineMgr.Mode )
			vfbControl #srgb true
		)
	)
	
	on gamma22BT pressed do
	(
		ColorPipelineMgr.Mode = #gamma
	)
		
	on loadSettingsBT pressed do
	(		
		local tmpFileName = (renderPresetPath + "\\renderSettings\\" + renderSettingsLB.selected + ".rps")
		
		if doesFileExist tmpFileName then
		(			
			format "load render Settings - renderpresets.Load % : % \n" tmpFileName (renderpresets.Load 0 tmpFileName #{32})
		)
		
		fixColourManagementBT.pressed()
	)
	
	on savePresetBT pressed do
	(

	)
	
	on savePresetAsBT pressed do
	(
		CreateDialog saveAsPresetRLT width: 400 modal: true
		
		if not presetName == undefined and  presetName.count > 0 and saveNewPreset then 
		(
			newPresetPath = renderPresetPath + "\\renderSettings\\" + presetName + ".rps"
			if doesFileExist  newPresetPath then
			( 
				-- warning si le preset va etre ecrasé
				local res = yesNoCancelBox ("Le fichier existe déjà. Voulez vous l'écraser ?\n\n " + newPresetPath ) beep: true -- icon: #warning
				if not res == #yes then saveNewPreset = false
			)
			
			if saveNewPreset then
			(
				local res = renderpresets.save 0 newPresetPath #{32}
				format "renderpresets.save : % : %\n" presetName res
				loadPreset()
			)
			else 
			(
				format "renderpresets.save : % : %\n" presetName saveNewPreset
			)
		)
		else format "presetName : uncorrect \n" 

		presetName = undefined
		saveNewPreset = false
	)
	
	on deletePresetBT pressed do
	(
		local tmpFileName = (renderPresetPath + "\\renderSettings\\" + renderSettingsLB.selected + ".rps")
		
		local res = yesNoCancelBox ("Voulez vous vraiment supprimer ce fichier ?:\n " + tmpFileName ) beep: true --icon: #warning
		
		if res == #yes then 
		(
			local resDel = deletefile tmpFileName
			format "rps to delete: % : %\n" tmpFileName resDel
		)
		else()
		
		loadPreset()
	)		
	
	

	
	
	
	on loadRenderEltsListBT pressed do
	(
-- 		format "renderSettingsLB.selected: % renderSettingsLB.selection: %\n" renderElementsLB.selected renderElementsLB.selection
		
		local loadTest
		
		local tmpFileName = (renderPresetPath + "\\renderElements\\" + renderElementsLB.selected + ".rps")
		if doesFileExist tmpFileName do
		(
			format "load render elements Settings - renderpresets.Load % : % \n" tmpFileName (renderpresets.Load 0 tmpFileName #{4})
		)
		
-- 		if loadTest then format "render Elements List Loaded : %\n " tmpFileName
-- 		else format "render Elements List NOT Loaded : %\n " tmpFileName
		fixColourManagementBT.pressed()
	)
	
	on saveREPresetBT pressed do
	(
		-- query box "are you sure"
	)
	
	on saveREPresetAsBT pressed do
	(
		-- 
		CreateDialog saveAsPresetRLT width: 400 modal: true
		
		if not presetName == undefined and  presetName.count > 0 and saveNewPreset then 
		(
			newPresetPath = renderPresetPath + "\\renderElements\\" + presetName + ".rps"
			if doesFileExist  newPresetPath then
			( 
				-- warning si le preset va etre ecrasé
				local res = yesNoCancelBox ("Le fichier existe déjà. Voulez vous l'écraser ?\n\n " + newPresetPath ) beep: true -- icon: #warning
				if not res == #yes then saveNewPreset = false
			)
			
			if saveNewPreset then
			(
				local res = renderpresets.save 0 newPresetPath #{4}
				format "renderpresets.save : % : %\n" presetName res
				loadPreset()
			)
			else 
			(
				format "renderpresets.save : % : %\n" presetName saveNewPreset
			)
		)
		else format "presetName : uncorrect \n" 

		presetName = undefined
		saveNewPreset = false
	)
	
	on deleteREPresetBT pressed do
	(
		local tmpFileName = (renderPresetPath + "\\renderElements\\" + renderElementsLB.selected + ".rps")
		
		local res = yesNoCancelBox ("Voulez vous vraiment supprimer ce fichier ?:\n " + tmpFileName ) beep: true --icon: #warning
		
		if res == #yes then 
		(
			local resDel = deletefile tmpFileName
			format "rps to delete: % : %\n" tmpFileName resDel
		)
		else()
		
		loadPreset()
	)
	
		on cleanPassesBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		
		-- nettoyage render elements lists
		eltsNum = rem.NumRenderElements()

		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			rem.RemoveRenderElement elt
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

		
		-- add default passes
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
			VRayObjectID output_type: 1, \
			VRayMtlID output_type: 1, \
			
			VRayDenoiser()
			)
		

		for elt in extElts do rem.AddRenderElement elt
		
		-- add object ids
		local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
		VisioIdsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr")
		VisioLabelsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioLabelsAr")
				
		for i = 1 to  VisioIdsAr.count do
		(
			local superName = "objId_" + (VisioIdsAr[i] as string) + "_" + VisioLabelsAr[i]
			local objIDElt = multimatteElement elementName: superName R_gbufID: VisioIdsAr[i] G_gbufID: VisioIdsAr[i] B_gbufID: VisioIdsAr[i] MatID: false
			rem.AddRenderElement objIDElt
		)
	)
	
	on objIdsPassesBT pressed do
	(
-- 		-- add object ids
		-- nettoyage multimatte render elements lists
		rem =MaxOps.GetCurRenderElementMgr ()		
		eltsNum = rem.NumRenderElements()
		
		-- supprimer exlusivement les passes d'objects ids
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt multimatteElement and not elt.MatID then rem.RemoveRenderElement elt
		)
		
		-- add objectID render element
		local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
		VisioIdsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr")
		VisioLabelsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioLabelsAr")
		
		format "VisioIdsAr: % VisioLabelsAr: %\n" VisioIdsAr VisioLabelsAr
			
		for i = 1 to  VisioIdsAr.count do
		(
			local superName = "objId_" + (VisioIdsAr[i] as string) + "_" + VisioLabelsAr[i]
			local objIDElt = multimatteElement elementName: superName R_gbufID: VisioIdsAr[i] G_gbufID: VisioIdsAr[i] B_gbufID: VisioIdsAr[i] MatID: false
			rem.AddRenderElement objIDElt
		)
	)
	
	
	on addSceneMatIDsBT pressed do
	(
		updateMatIDeElts()
	)
	
	on addSceneObjIDsBT pressed do
	(
		updateObjectsIDsElts()
	)
)
-- createdialog passesManagementRLT width: 400




	
