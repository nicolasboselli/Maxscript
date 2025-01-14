/*
maj:
	x- faire marcher le sort
	-- faire marcher le display ids used only
	-- ajouter des ids
*/
fn scanSceneObjects oneId =
(
	local objsById = for o in geometry where o.gbufferChannel == oneId collect o
	objsById
)	
-- scanSceneObjects 1



try(destroydialog gbufferChannelRLT)catch()
rollout gbufferChannelRLT "Objects IDs Manager"
(
	local idsAr = #(0,2,4,6,8,10,45,50,55)
	local labelsAr = #("none", "Vitres", "Menuiserie" , "Cloture", "GC", "Haies", "Habillage", "Herbe", "Arbres")
	local objsById = #()
	-- UI
	
	group "working on:"
	(
		radiobuttons typeSelBT  labels:#("scene ( all objects )", "visiolab iDs") default: 2 enabled: false
-- 		button refreshBT "refresh"
	)
	
	group "Objects IDs :"
	(
		radiobuttons sortSelBT "sort: " labels:#("by name", "by id") default: 1 -- enabled: false
		
		checkbox idUsedOnlyCB "display IDs used only" enabled: false
		listbox idObjectsLB "objects IDs ( object label [ object render id ] ): "
		button applyBT "apply objects ID to selection"
		editText objectCountET "objects count:" readonly: true across: 2
		button selectBT "select objets by ID"
	)
	
	group "Create render elements:"
	(
		button addMultiMatByObjBT "add all Object IDs passes" across: 2
		button removeMultiMatByObjBT "remove Object IDs passes"
	)
	
	group "Render Mask:"
	(
		spinner samplingSP "render sampling:" type: #integer range: [1,16,4] across: 2
-- 		button AlphaSelRenderBT "selection" across: 2
		button objIdMaskBT "Render Objects Id Selected"
	)
	
	-- functions
	fn refreshUIList =
	(
		-- collecte des noms
-- 		format "collect materials start\n"
-- 		t1 = timestamp()
		labelsToDisp = #()
		
-- 		local collectMax = 100
		for i = 1 to labelsAr.count do
		(
			-- sort by name
			if sortSelBT.state == 1 then
			(
				-- création de l'array de travail des labels
				labelsArTmp = for o in labelsAr collect o
				sort labelsArTmp

				-- création de l'array de travail des ids
				idsArTmp = #()
				-- classement des ids par label
				for i = 1 to labelsArTmp.count do
				(
					newPlace = finditem labelsArTmp labelsAr[i]
					idsArTmp[newPlace] = idsAr[i]
				)
				
				idsAr = for id in idsArTmp collect id
				labelsAr = for lab in labelsArTmp collect lab
				
				append labelsToDisp ( labelsAr[i] + "  [" +  (idsAr[i] as string) + "]")
			)
			-- sort by ids
			else if sortSelBT.state == 2 then
			(
				-- création de l'array de travail des labels
				idsArTmp = for o in idsAr collect o
				sort idsArTmp

				-- création de l'array de travail des ids
				labelsArTmp = #()
				-- classement des ids par label
				for i = 1 to idsArTmp.count do
				(
					newPlace = finditem idsArTmp idsAr[i]
					labelsArTmp[newPlace] = labelsAr[i]
				)
				
				idsAr = for id in idsArTmp collect id
				labelsAr = for lab in labelsArTmp collect lab
				
				append labelsToDisp ( "[" +  (idsAr[i] as string) + "]  " + labelsAr[i] )
			)			
		)	
		
		idObjectsLB.items = labelsToDisp
	)
	
	-- actions
	on gbufferChannelRLT open do
	(
		refreshUIList()
	)
	
	on sortSelBT changed val do
	(
		refreshUIList()
	)
	
	on idObjectsLB selected val do
	(
-- 		format "id: %\n" idsAr[idObjectsLB.selection]
		objsById = for o in geometry where o.gbufferChannel == idsAr[val] collect o
		objectCountET.text = objsById.count as string
-- 		objectCountET.text = ""
	)
	
	on selectBT pressed do
	(
		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
-- 		format "id % : %\n" idsAr[idObjectsLB.selection] objsById
		select objsById
-- 		objectCountET.text = objsById.count as string
	)
	
	on applyBT pressed do
	(
		sel = selection as Array
-- 		format "id: %\n" idsAr[idObjectsLB.selection]
		for s in sel do s.gbufferChannel = idsAr[idObjectsLB.selection]
	)
	
	on addMultiMatByObjBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()

		for i = 1 to idsAr.count do
		(
			objsById = for o in geometry where o.gbufferChannel == idsAr[i] collect o
			if objsById.count == 0 then continue
			else
			(
				local superName = "objId_" + (idsAr[i] as string) +  "_" + labelsAr[i]
				local matSel = multimatteElement elementName: superName R_gbufID: idsAr[i] G_gbufID: idsAr[i] B_gbufID: idsAr[i] MatID: false
				rem.AddRenderElement matSel
			)
		)		
	)
	
	on removeMultiMatByObjBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		
		-- suppression des passes multimat
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt multimatteElement then 
			(
				if not elt.MatID then rem.RemoveRenderElement elt
			)
		)
	)
	
	on objIdMaskBT pressed do
	(
		oneId = idsAr[idObjectsLB.selection]
		
		if oneID > 0 then
		(
			try
			(
				format "oneId: %\n" oneId
				
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
-- 				oneID = 666
-- 				for s in sel do s.gbufferChannel = oneID

				-- creation de la passe
				rem = MaxOps.GetCurRenderElementMgr ()
				format "check1\n"
				local superName = "objectsId_" + (oneID as string) --  + "_" + mat.name
				format "check2\n"
				local matSel = multimatteElement elementName: superName R_gbufID: oneID G_gbufID: oneID B_gbufID: oneID MatID: false
				format "check3\n"
				rem.AddRenderElement matSel
				format "check4\n"

				-- render
				render ()
				vfbControl #setchannel 2
				vfbControl #duplicate
				
				fetchMaxFile quiet: true
				
				format "render mask objects done\n"
			)
			catch
			(
				format "render FAIL!\n"
			)
		)
	)
	
	
)
-- createdialog gbufferChannelRLT