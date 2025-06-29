/* 
-- maj:
	-- envoyer des rendus dans pulze
	x- prise en charge de l'opacité
	x- faire un rendu noir et blanc ou générer une passe multimat? multimat
	-- nettoyer le vfb:
		
		vfbLayers=(vfbControl #getLayerMgr)[1]
		layerIDs = vfbLayers.getAllLayerIDs()
		for i = layerIDs.count to 1 by -1 do 
		( 
			format "layerIDs[i]: %\n" layerIDs[i]
			layerA = vfbLayers.getLayer layerIDs[i]
			vfbLayers.deleteLayer layerA
		)
		
		
	x- securiser le fetch/hold, on eput effacer des scène en passant d'une instance de max à l'autre, rendre la sauvegarde obligatoire
	x- sortir la passe sur un bitmap
	-- faire fonctionner:
		x avec les ids du ids material manager
		x avec les ids du ids objects manager
		x avec le materiau selectionné
		xavec l'objet selectionné

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
		else if matchPattern  (r as string)  pattern: "V_Ray_7*" then 
		(
			goodR = r
		)
		else()
	)
-- 	format "good r: %\n" goodR
	 goodR
)

	
try(destroydialog VrayAlphaMaskRLT)catch()
-- rollout
rollout VrayAlphaMaskRLT "Render Masks"
(
	
-- UI
	local idsAr = #(2,4,6,8,10,45,50,55)
	local labelsAr = #("2_Vitres", "4_Menuiserie" , "6_Cloture", "8_GC", "10_Haies", "45_Habillage", "50_Herbe", "55_Arbres")

	group "Render Setting:"
	(
		spinner samplingSP "sampling:" type: #integer range: [1,16,4]
	)
	
	group "Render Mask:"
	(
		button AlphaSelRenderBT3 "Object Selected" across: 2
		button MatSelRenderBT3 "Material Selected" -- across: 2
	)
		
	on AlphaSelRenderBT3 pressed do
	(
		
		sel = selection as array
		if sel.count > 0 then
		(
			try
			(
				holdMaxFile ()
				
				-- application des réglages de rendus
				format "start vray night\n"
				
				-- -- passer les reglages de rendus en noir
				renderers.current =  (findVray()) ()
				rc = renderers.current
				
				rc.imageSampler_type =  1
				rc.twoLevel_baseSubdivs = samplingSP.value
				rc.twoLevel_adaptiveEnable = false
				
				rc.filter_on = false
				
				rc.options_maps = true
				rc.gi_on = false 
				rc.options_displacement = false
				rc.options_lights = false 
				rc.options_defaultLights = 0 
				rc.options_shadows = false 
				
				rc.colorMapping_type = 0 
				rc.colorMapping_darkMult = 1 
				rc.colorMapping_brightMult = 1 
				rc.colorMapping_gamma = 1

				rc.options_reflectionRefraction = false 
				rc.options_overrideMtl_on = false 

-- 				rc.system_region_x = 16 
-- 				rc.system_region_y = 16
				
				useEnvironmentMap = false
				sceneExposureControl.exposureControl = undefined 
				rem = maxOps.GetCurRenderElementMgr ()
	-- 				re.setElementsActive false
				
				-- nettoyage de la fenetre de render elements
				eltsNum = rem.NumRenderElements()
				for i = (eltsNum - 1) to 0 by -1 do --rem.RemoveRenderElement elt
				(
					elt = rem.GetRenderElement i
					rem.RemoveRenderElement elt
				)
				
	-- 			-- parametrage de la camera sans exposure
				for o in cameras where iskindof o Vrayphysicalcamera do o.exposure = false
				backgroundColor = color 0 0 0
				
				format "vray night done\n"
				
				-- setting des objets selectionnés
				oneID = 666
				for s in sel do s.gbufferChannel = oneID

				-- creation de la passe
				rem = MaxOps.GetCurRenderElementMgr ()
				local superName = "objectsId_" + (oneID as string) --  + "_" + mat.name
				local matSel = multimatteElement elementName: superName R_gbufID: oneID G_gbufID: oneID B_gbufID: oneID MatID: false
				rem.AddRenderElement matSel

				-- render
				render ()
				vfbControl #setchannel 2
				vfbControl #duplicate
				
				fetchMaxFile quiet: true
			)
			catch
			(
				format "RENDER FAIL!\n"
				fetchMaxFile quiet: true
			)
		)
		else(format "selectionner un objet \n")
		
	)
	
	on MatSelRenderBT3 pressed do
	(
		
		try
		(
			mat = undefined
			-- collecte du materiau selectionné
			
			if sme.IsOpen() then
			(
				-- collecte pour slate material editor
				oneView = sme.GetView (sme.activeView)
				sel = oneView.GetSelectedNodes()
				if sel.count > 0 then
				(
					refMat = sel[1]
					mat = refMAt.reference
				)
			)
			else if MatEditor.isOpen() then
			(
				mat = getMeditMaterial activeMeditSlot 
			)
			else()
			
			if mat != undefined and isKindOf mat vraymtl then 
			(
				-- sauvegarde de la scene
				holdMaxFile ()
				
				-- application des réglages de rendus
				format "start vray night\n"
				
				-- -- passer les reglages de rendus en noir
				renderers.current =  (findVray()) ()
				rc = renderers.current
				
				rc.imageSampler_type =  1
				rc.twoLevel_baseSubdivs = samplingSP.value
				rc.twoLevel_adaptiveEnable = false
				
				rc.filter_on = false
				
				rc.options_maps = true
				rc.gi_on = false 
				rc.options_displacement = false
				rc.options_lights = false 
				rc.options_defaultLights = 0 
				rc.options_shadows = false 
				
				rc.colorMapping_type = 0 
				rc.colorMapping_darkMult = 1 
				rc.colorMapping_brightMult = 1 
				rc.colorMapping_gamma = 1

				rc.options_reflectionRefraction = false 
				rc.options_overrideMtl_on = false 

-- 				rc.system_region_x = 16 
-- 				rc.system_region_y = 16
				
				useEnvironmentMap = false
				sceneExposureControl.exposureControl = undefined 
				rem = maxOps.GetCurRenderElementMgr ()
	-- 				re.setElementsActive false
				
				-- nettoyage de la fenetre de render elements
				eltsNum = rem.NumRenderElements()
				for i = (eltsNum - 1) to 0 by -1 do --rem.RemoveRenderElement elt
				(
					elt = rem.GetRenderElement i
					rem.RemoveRenderElement elt
				)
				
	-- 			-- parametrage de la camera sans exposure
				for o in cameras where iskindof o Vrayphysicalcamera do o.exposure = false
				backgroundColor = color 0 0 0
				
				format "vray night done\n"
				format "mat: %\n" mat
				
				rem = MaxOps.GetCurRenderElementMgr ()
				-- application de la vray id
				oneID = 666
							
				mat.override_effect_id = on
				mat.effect_id = oneID
				
				-- creation de la passe
				local superName = "matId_" + (oneID as string) + "_" + mat.name
				local matSel = multimatteElement elementName: superName R_gbufID: oneID G_gbufID: oneID B_gbufID: oneID MatID: true
				rem.AddRenderElement matSel
					
	-- 			max quick render
				render ()
				vfbControl #setchannel 2
				vfbControl #duplicate
								
				fetchMaxFile quiet: true
			)
			else(format "selectionner un vray_material \n")
		)
		catch
		(
			format "RENDER FAIL!\n"
			fetchMaxFile quiet: true
		)
		
	)
	
)


-- createdialog VrayAlphaMaskRLT