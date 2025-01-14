/*
maj:
	x- faire marcher le sort
	x-- initialiser les ids en scannant la scène
	x-- faire marcher le display ids used only (inutile)
	
	
	x-- rajouter by layer pour l'id des arbres
	x-- rafraichir le count aprés l'application d'ids à des objets
	

	
	-- ajouter possibilité de créer de nouvelles ids temporaire 
		x-- changer l'id d'un label
		x-- créer un nouveau label
		x-- renommer le label
		x- stocker le label dans une variable globale
			-- récupérer le nom des lables à partir des passes créées
	
	
	-- stockés les id dans un fichier Ini et rendre le fichier editable
	
	
*/

fn collectIDobjectsFromScene =
(
	local allSceneOjectsIds = #()
	for o in geometry where o.gbufferChannel > 0 do
	(
		appendifunique allSceneOjectsIds o.gbufferChannel
	)
	allSceneOjectsIds
)	
test = collectIDobjectsFromScene()



/* fn scanSceneObjects oneId =
(
	local objsById = for o in geometry where o.gbufferChannel == oneId collect o
	objsById
)	
-- scanSceneObjects 1 */



try(destroydialog gbufferChannelRLT)catch()
rollout gbufferChannelRLT "Objects IDs Manager"
(
	local VisioIdsAr = #(0,2,4,6,8,10,45,50,55)
	local VisioLabelsAr = #("none", "Vitres", "Menuiserie" , "Cloture", "GC", "Haies", "Habillage", "Herbe", "Arbres")
	
	global idsAr -- = #()
	global labelsAr -- = #()
	
	global labelsArBak -- = #()
	global idsArBak -- = #() 
	
	local objsById = #()
	-- UI
	
	group "working on:"
	(
		radiobuttons typeSelBT  labels:#("scene ( all objects )", "visiolab iDs") default: 2 -- enabled: false
-- 		button refreshBT "refresh"
	)
	
	group "Objects IDs :"
	(
		radiobuttons sortSelBT "sort: " labels:#("by name", "by id") default: 1 -- enabled: false
		
-- 		checkbox idUsedOnlyCB "display IDs used only" enabled: false
		listbox idObjectsLB "objects IDs ( object label [ object render id ] ): "
		
		edittext objsIDNameET "ID label:" readonly: true 
		
		spinner idsSp "id" type: #integer range: [0,5000,0] across: 2
		button addLaberBT "add label"
		button applyBT "apply objects ID to selection" height: 50
		editText objectCountET "objects count:" readonly: true across: 2
		button selectBT "select objets by ID"
	)
	
	group "Create render elements:"
	(
		button addMultiMatByObjBT "add all Object IDs passes" height: 50 across: 2
		button removeMultiMatByObjBT "remove Object IDs passes"
	)
	
	group "Render Mask:"
	(
		spinner samplingSP "render sampling:" type: #integer range: [1,16,4] across: 2
-- 		button AlphaSelRenderBT "selection" across: 2
		button objIdMaskBT "Render Objects Id Selected" height: 50
	)
	
	-- functions
	fn init =
	(
		

		if typeSelBT.state == 1 then
		(
-- 			labelsArBak = for l in labelsAr collect l
-- 			idsArBak = for l in idsAr collect l	
			
			idsAr = collectIDobjectsFromScene()
			format "idsAr: %\nlabelsAr: %\n" idsAr labelsAr
			labelsAr = #()
			for i = 1 to idsAr.count do
			(
				-- prévoir l'erreur si on ne trouve pas de correpondance dans les label visiolab
-- 				visioLabelID = finditem VisioIdsAr idsAr[i]
				if (finditem VisioIdsAr idsAr[i]) > 0 then
				(
					visioLabelID = finditem VisioIdsAr idsAr[i]
					labelsAr[i] = VisioLabelsAr[visioLabelID]
				)
				else if (finditem idsArBak idsAr[i]) > 0 then
				(
					oneID = finditem idsArBak idsAr[i]
					if labelsArBak[oneID] != undefined then labelsAr[i] = labelsArBak[oneID] 
					else labelsAr[i] = "label_id" + (idsAr[i] as string)
				)
				else
				(
					labelsAr[i] = "label_id" + (idsAr[i] as string)
				) 
			)
		)
		else if typeSelBT.state == 2 then
		(
			idsArBak = for l in idsAr collect l	
			labelsArBak = for l in labelsAr collect l
			
			idsAr = for o in VisioIdsAr collect o
			labelsAr =  for o in VisioLabelsAr collect o
		)
		else()
		
		format "init done\n\tidsAr: % \n\tlabelsAr: %\n" idsAr labelsAr
		
	)
	
	fn refreshUIList =
	(
		
		if typeSelBT.state == 1 then
		(
			addLaberBT.enabled = true
		)
		else if typeSelBT.state == 2 then
		(
			addLaberBT.enabled = false
		)
		
		
		-- collecte des noms
-- 		format "collect materials start\n"
		labelsToDisp = #()

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
			
			for i = 1 to labelsAr.count do 
			(
				append labelsToDisp ( labelsAr[i] + "  [" +  (idsAr[i] as string) + "]")
			)
-- 				format "labelsAr2: % idsAr2: %\n" labelsAr idsAr
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
			
			for i = 1 to labelsAr.count do 
			(
				append labelsToDisp ( "[" +  (idsAr[i] as string) + "]  " + labelsAr[i] )
			)
		)			
		
		idObjectsLB.items = labelsToDisp

		-- refreshui à partir de selection
		local idSel = idObjectsLB.selection
		format "idSel: %\n" idSel
		if idSel > 0 then 
			
		(
			objsById = for o in geometry where o.gbufferChannel == idsAr[idSel] collect o
			objectCountET.text = objsById.count as string
		
			objsIDNameET.text = labelsAr[idSel]
			idsSp.value = idsAr[idSel]
		
			-- sécurité pour ne pas modifier les ids visiolab
	-- 		VisioIdsAr
			if (finditem VisioIdsAr idsAr[idSel]) == 0 then 
			(
				objsIDNameET.readonly = false 
				idsSp.enabled = true
			)
			else
			(	
				
				objsIDNameET.readonly = true
				idsSp.enabled = false
			)
		)
		
	)
	
	-- actions
	on gbufferChannelRLT open do
	(
		if idsAr == undefined then idsAr = #()
		if labelsAr == undefined then labelsAr = #()
		
		if idsArBak == undefined then idsArBak = #()
		if labelsArBak == undefined then labelsArBak = #()
		
		idObjectsLB.selection = 1
		
		init()
		refreshUIList()
	)
	
	on typeSelBT changed state do
	(
		init()
		refreshUIList()
-- 		format "state: %\n" state
	)
	
	on sortSelBT changed val do
	(
		refreshUIList()
	)
	
	on idObjectsLB selected val do
	(
/* -- 		format "id: %\n" idsAr[idObjectsLB.selection]
		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
		objectCountET.text = objsById.count as string
		
		objsIDNameET.text = labelsAr[idObjectsLB.selection]
		idsSp.value = idsAr[idObjectsLB.selection]
		
		-- sécurité pour ne pas modifier les ids visiolab
-- 		VisioIdsAr
		if (finditem VisioIdsAr idsAr[val]) == 0 then 
		(
			objsIDNameET.readonly = false 
			idsSp.enabled = true
		)
		else
		(	
			
			objsIDNameET.readonly = true
			idsSp.enabled = false
		) */
		
		refreshUIList()
	)
	
	
	on objsIDNameET entered val do
	(
-- 		format "label: %\n" labelsAr[idObjectsLB.selection]
		
		labelsAr[idObjectsLB.selection] = val
		
		refreshUIList()
		/*
		format "label: %\n" labelsAr[idsAr[idObjectsLB.selected]]
		if not objsIDNameET.readonly then 
		(
			
			format "label: %\n" labelsAr[idsAr[idObjectsLB.selected]]
		)
		*/
	)
	
	on idsSp entered do
	(
		applyChange = true
-- 		format "enter: True!\n"
		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
		
		-- tester la nouvelle valeur sur les ids deja appliquer dans la scène et par visiolab
		if findItem VisioIdsAr idsSp.value > 0 then applyChange = false
		else if findItem idsAr idsSp.value > 0 then applyChange = false
		else()
		
		-- appliquer le nouvel id à tous les objects
		if applyChange then
		(
			for s in objsById do s.gbufferChannel = idsSp.value
				
			-- changer la valeur de l'id dans l'array
			idsAr[idObjectsLB.selection] = idsSp.value
			
			-- ne pas faire d'init pour conserver le nom? ou faire un backup avant de faire l'init?
			idsArBak = for l in idsAr collect l	
			labelsArBak = for l in labelsAr collect l

			init()
			refreshUIList() 
		)
		else(format "cette id est déja utilisé\n")
	)
	
-- 	on idsSp changed val do
-- 	(
-- 	)
	
	on addLaberBT pressed do
	(
		newLabel = "label_" + ((idsAr.count + 1) as string) +"_id_" 
		format "new label: %\n" newLabel
		
		append labelsAr newLabel
		append idsAr 100
		
		refreshUIList()
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
		for s in sel do 
		(
			s.gbufferChannel = idsAr[idObjectsLB.selection]
-- 						s.gbufferChannel = 55
			if s.gbufferChannel == 55 then s.renderByLayer = true
		)
		
		-- refresh UI
		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
		objectCountET.text = objsById.count as string
	)
	
	on addMultiMatByObjBT pressed do
	(
		removeMultiMatByObjBT.pressed ()
		
		rem =MaxOps.GetCurRenderElementMgr ()

		for i = 1 to idsAr.count do
		(
/* 			objsById = for o in geometry where o.gbufferChannel == idsAr[i] collect o
			if objsById.count == 0 then continue
			else
			( */
				local superName = "objId_" + (idsAr[i] as string) +  "_" + labelsAr[i]
				local matSel = multimatteElement elementName: superName R_gbufID: idsAr[i] G_gbufID: idsAr[i] B_gbufID: idsAr[i] MatID: false
				rem.AddRenderElement matSel
-- 			)
		)
		
		for i = 1 to VisioIdsAr.count do
		(
			
				res = finditem idsAr VisioIdsAr[i] 
				if res == 0 then
				(
					local superName = "objId_" + (VisioIdsAr[i] as string) +  "_" + VisioLabelsAr[i]
					local matSel = multimatteElement elementName: superName R_gbufID: VisioIdsAr[i] G_gbufID: VisioIdsAr[i] B_gbufID: VisioIdsAr[i] MatID: false
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
-- createdialog gbufferChannelRLT width: 500