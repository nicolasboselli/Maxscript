/* 
-- maj:
-- envoyer des rendus dans pulze
-- prise en charge de l'opacité
-- faire un rendu noir et blanc ou générer une passe multimat?
-- nettoyer le vfb
*/

fn findVray  =
(
	local goodR
	for r in rendererClass.classes do
	(
-- 		format "r: %\n" r
		if matchPattern  (r as string)  pattern: "V_Ray_Adv*" then
		(
			goodR = r
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_Next*" then
		(
			goodR = r
			exit
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_5*" then 
		(
			goodR = r
			exit
		)
		else if matchPattern  (r as string)  pattern: "V_Ray_6*" then 
		(
			goodR = r
		)
		else()
	)
-- 	format "good r: %\n" goodR
	 goodR
)

-- findVray()

fn setVrayAlpha =
(	
	(findVray()) \
	imageSampler_type: 1 \
	twoLevel_baseSubdivs: 1 twoLevel_fineSubdivs: 100 \
	filter_on: false \
	options_maps: true \
	gi_on: false \
	options_lights: false options_defaultLights: 0 \
	colorMapping_type: 0 colorMapping_darkMult: 1 colorMapping_brightMult: 1 colorMapping_gamma: 1  \

	options_reflectionRefraction: false options_overrideMtl_on: false \

	system_raycaster_memLimit: 0 system_region_x: 16 system_region_y: 16
)
-- setVrayAlpha()

try(destroydialog VrayAlphaMaskRLT)catch()
-- rollout
rollout VrayAlphaMaskRLT "Vray passes render"
(
	
-- UI
	group "preset"
	(
		checkbutton VRAlphaPresetCB "Vray Alpha Preset" 
-- 		button VRbasePresetBT "Restore Vray Preset" enabled: false --across: 2

	)
	
	group "Render Alpha 2:"
	(
		button AlphaSelRenderBT2 "Object Selected" -- across: 2
		button MatSelRenderBT2 "Material Selected" -- across: 2
-- 		button BatchAlphaSelRenderBT "On Selected BatchRender"
	)
	
	group "Render Alpha 3:"
	(
		button AlphaSelRenderBT3 "Object Selected" -- across: 2
		button MatSelRenderBT3 "Material Selected" -- across: 2
-- 		button BatchAlphaSelRenderBT "On Selected BatchRender"
	)
	
	on VrayAlphaMaskRLT open do
	(
		holdMaxFile ()
	)
	
	on VrayAlphaMaskRLT close do
	(
		fetchMaxFile quiet: true
	)
	
	on VRAlphaPresetCB changed state do
	(
		if state == true do
		(
-- 			holdMaxFile ()
-- 			max render last
			try
			(
				format "start vray night\n"
				-- -- passer les reglages de rendus en noir
				renderers.current =  setVrayAlpha()
				useEnvironmentMap = false
				sceneExposureControl.exposureControl = undefined 
-- 				format "check1\n"
				rem = maxOps.GetCurRenderElementMgr ()
-- 				format "check2\n"
-- 				re.setElementsActive false
				
				eltsNum = rem.NumRenderElements()
				for i = (eltsNum - 1) to 0 by -1 do --rem.RemoveRenderElement elt
				(
					elt = rem.GetRenderElement i
					rem.RemoveRenderElement elt
				)
-- 				format "check3\n"
				for o in cameras where iskindof o Vrayphysicalcamera do o.exposure = false
-- 				format "check4\n"
				backgroundColor = color 0 0 0
				
				
				format "vray night done\n"
			)
			catch
			(
				format "VRAY NIGHT FAIL!\n"
				VRAlphaPresetCB.checked = false
				fetchMaxFile quiet: true
			)
		)
		if state == false do
		(
			fetchMaxFile quiet: true
		)
	)
	
	on AlphaSelRenderBT2 pressed do
	(		
		try
		(
			sel = selection as Array
			-- backup du materiaux
			bakMaterial = for s in sel collect s.material
			
			-- passer le materiau en blanc
			
			for s in sel do s.material = ( vraylightmtl twoSided: true name: (uniquename "autoIllum"))
								
			render ()
			
			-- reapplication des materiaux
			for i = 1 to bakMaterial.count do
			(
				sel[i].material = bakMaterial[i]
			)
		)
		catch
		(
			format "RENDER FAIL!\n"
			fetchMaxFile quiet: true
		)
	)
	
	on MatSelRenderBT2 pressed do
	(
		try
		(
			mat = undefined
			if sme.IsOpen() then
			(
				-- collecte pour slate material editor
				oneView = sme.GetView (sme.activeView)
				sel = oneView.GetSelectedNodes()
				refMat = sel[1]
				mat = refMAt.reference
			)
			else if MatEditor.isOpen() then
			(
				mat = getMeditMaterial activeMeditSlot 
			)
			else()
			
			format "mat: %\n" mat
			bakMat = copy mat
			vrLightMat = vraylightmtl twoSided: true name: (uniquename "autoIllum")
			replaceInstances mat vrLightMat
				
			render ()
			replaceInstances vrLightMat bakMat
		)
		catch
		(
			format "RENDER FAIL!\n"
			fetchMaxFile quiet: true
		)
			
			
		-- faire fonctionner dur meditmaterial et slate material editor
-- 		holdMaxFile ()

		-- passer le materiau en blanc
		-- faire le rendu
-- 		fetchMaxFile quiet: true
	)
	
	on AlphaSelRenderBT3 pressed do
	(
	)
	
	on MatSelRenderBT3 pressed do
	(
		
		try
		(
			mat = undefined
			if sme.IsOpen() then
			(
				-- collecte pour slate material editor
				oneView = sme.GetView (sme.activeView)
				sel = oneView.GetSelectedNodes()
				refMat = sel[1]
				mat = refMAt.reference
			)
			else if MatEditor.isOpen() then
			(
				mat = getMeditMaterial activeMeditSlot 
			)
			else()
			
			format "mat: %\n" mat
			rem = MaxOps.GetCurRenderElementMgr ()
			
			oneID = 666
			mat_override_effect_id_bak = mat.override_effect_id
			mat_effect_id_bak = mat.effect_id
						
			mat.override_effect_id = on
			mat.effect_id = oneID
			
			local superName = "matId_" + (oneID as string) + "_" + mat.name
			local matSel = multimatteElement elementName: superName R_gbufID: oneID G_gbufID: oneID B_gbufID: oneID MatID: true
			rem.AddRenderElement matSel
						
/* 			bakMat = copy mat
			vrLightMat = vraylightmtl twoSided: true name: (uniquename "autoIllum")
			replaceInstances mat vrLightMat */
				
-- 			max quick render
			render ()
			format "check1\n"
			mat.override_effect_id = mat_override_effect_id_bak
			mat.effect_id = mat_effect_id_bak
			
			eltsNum = rem.NumRenderElements()
			for i = (eltsNum - 1) to 0 by -1 do 
			(
				elt = rem.GetRenderElement i
				rem.RemoveRenderElement elt
			)
			
-- 			replaceInstances vrLightMat bakMat
		)
		catch
		(
			format "RENDER FAIL!\n"
			fetchMaxFile quiet: true
		)

		
		
	)
	
)

createdialog VrayAlphaMaskRLT