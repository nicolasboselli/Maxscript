/*
maj:
	x- faire marcher le sort
	x-- initialiser les ids en scannant la sc�ne
	x-- faire marcher le display ids used only (inutile)
	
	
	x-- rajouter by layer pour l'id des arbres
	x-- rafraichir le count apr�s l'application d'ids � des objets
	

	
	-- interface render elements
	-- interface scene
		-- ajouter possibilit� de cr�er de nouvelles ids temporaire 
			x-- changer l'id d'un label
			x-- cr�er un nouveau label
	-- 		x-- renommer le label
			x- stocker le label dans une variable globale
				x- r�cup�rer le nom des lables � partir des passes cr��es
				x- utiliser le render element pour stocker les valeurs en temps r�els
			x- debug id obj dans la liste qui disparait quand on change l'id dans le spinner
	
	-- interface visiolab ids
		x- �diter les ids visiolab dans l'interface
			x- bug: le renommage ne fonctionne pas
			x- bug: le changement d'id ne focntionne pas
			x- ajouter une fonction delete
			x- cr�ation de la passe dans les render elements � la cr�ation de la passe
			
		x- stock�s les id dans un fichier Ini et rendre le fichier editable
	
	
	-- � l'ouverture collecte des ids et des labels, cr�ation systematique des render elements ?
	
	-- debug: erreur au sort avec les doublons de label, interroger au renommage, empecher le double emploi de label, auto rename
	
	-- ne pas cr�er la passe 0 dans les render elements
	
	-- mettre un mode auto select id, sur selection objet en checkbox
	
	-- faire une checkbox ignore id Zero?
	-- faire une checkbox used id only?

	
	
*/

/* visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
getINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr"
getINISetting visioIDsIni "VisiolabIDs" "VisioLabelsAr" */
	
fn collectIDobjectsFromScene =
(
	local allSceneOjectsIds = #()
	for o in geometry where o.gbufferChannel > 0 do
	(
		appendifunique allSceneOjectsIds o.gbufferChannel
	)
	allSceneOjectsIds
)	
-- test = collectIDobjectsFromScene()

fn collectIDfromRenderElements =
(
	local objIds = #()
	local objIdNames = #()
	
		-- collect des ids deja pose dans le render elements
	rem = MaxOps.GetCurRenderElementMgr ()
	num = rem.NumRenderElements ()

	elts_array = #()
	for i = 0 to (num - 1) do
	(
		elt = rem.GetRenderElement i

		if iskindof elt multimatteElement then
		(
			eltPartName = filterString elt.elementName "_"
			if not eltPartName.count == 3 and not eltPartName.count == 4 then continue 
				
			if not MatchPattern eltPartName[1] pattern: "ObjId" then continue
			else
			(
				append objIds (eltPartName[2] as integer)
				append objIdNames eltPartName[3]
				
				format "id: % name: %\n" (eltPartName[2] as integer) eltPartName[3]
			)
		)
	)
	
	#(objIds, objIdNames)
)	
-- collectIDfromRenderElements()

/* fn scanSceneObjects oneId =
(
	local objsById = for o in geometry where o.gbufferChannel == oneId collect o
	objsById
)	
-- scanSceneObjects 1 */



try(destroydialog gbufferChannelRLT)catch()
rollout gbufferChannelRLT ("Objects IDs Manager v." + ( getScriptVersion (getThisScriptFilename()) as string))
(
	
-- 	local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
	local VisioIdsAr = #()
	local VisioLabelsAr = #()
	
	local REidsAr = #()
	local RElabelsAr = #()
	
	
-- 	local VisioIdsAr = #(0,2,4,6,8,10,45,50,55)
-- 	local VisioLabelsAr = #("none", "Vitres", "Menuiserie" , "Cloture", "GC", "Haies", "Habillage", "Herbe", "Arbres")
	
	local params = #("typeSelBT","sortSelBT")
	
	global idsAr -- = #()
	global labelsAr -- = #()
	
	global labelsArBak -- = #()
	global idsArBak -- = #() 
	
	local objsById = #()
	
	-- UI
	group "working on:"
	(
		radiobuttons typeSelBT  labels:#("render elements", "scene ( all objects )", "visiolab iDs") default: 2 -- enabled: false
-- 		button refreshBT "refresh"
	)
	
	group "Objects IDs :"
	(
		radiobuttons sortSelBT "sort: " labels:#("by name", "by id") default: 1 -- enabled: false
		
-- 		checkbox idUsedOnlyCB "display IDs used only" enabled: false
		listbox idObjectsLB "objects IDs ( object label [ object render id ] ): "
		
		edittext objsIDNameET "ID label:" readonly: true 
		
		spinner idsSp "id" type: #integer range: [0,5000,0] across: 4
		button addLaberBT "add label"
		button openIniBT "open labels ini"
		button delLabelBT "del label" --enabled: false
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
	fn loadVisiolabIDs = 
	(
		local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
		VisioIdsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr")
		VisioLabelsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioLabelsAr")
	)
	
	fn writeVisiolabIDs =
	(
		local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
		
		setINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr" (with printAllElements on VisioIdsAr as string)
		setINISetting visioIDsIni "VisiolabIDs" "VisioLabelsAr" (with printAllElements on VisioLabelsAr as string)
	)
	
	
	fn init =
	(
		-- collecte des ids et les labels dans render elements
		local res = collectIDfromRenderElements()
		REidsAr = res[1]
		RElabelsAr = res[2] 
		
		-- collecte des ids et les labels visiolab
		loadVisiolabIDs()

		if typeSelBT.state == 1 then
		(
			-- collecte des noms id et des ids d'objets dans les render elements
			idsAr = for o in REidsAr collect o
			labelsAr =  for o in RElabelsAr collect o
-- 			format "idsAr: % labelsAr: %\n" idsAr labelsAr
		)
		if typeSelBT.state == 2 then
		(
			-- collecte des id d'objets dans la sc�ne
			idsAr = collectIDobjectsFromScene()
-- 			format "idsAr: %\nlabelsAr: %\n" idsAr labelsAr
			labelsAr = #()
			
			for i = 1 to idsAr.count do
			(
				-- pr�voir l'erreur si on ne trouve pas de correpondance dans les label visiolab
				-- tester l'id sur les visiolab ids
				if (finditem VisioIdsAr idsAr[i]) > 0 then
				(
					visioLabelID = finditem VisioIdsAr idsAr[i]
					labelsAr[i] = VisioLabelsAr[visioLabelID]
				)
				-- tester l'id sur les render elements
				else if (finditem REidsAr idsAr[i]) > 0 then
				(
					oneID = finditem REidsAr idsAr[i]
					if RElabelsAr[oneID] != undefined then labelsAr[i] = RElabelsAr[oneID] 
					else labelsAr[i] = "label_id" + (idsAr[i] as string)
				)
				else
				(
					labelsAr[i] = "label_id" + (idsAr[i] as string)
				) 
			)
		)
		else if typeSelBT.state == 3 then 
		(
			loadVisiolabIDs()
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
			addLaberBT.enabled = true
		)
		else if typeSelBT.state == 3 then
		(
			addLaberBT.enabled = true
		)

		-- collecte des noms
-- 		format "collect materials start\n"
		labelsToDisp = #()

		-- sort by name
		if sortSelBT.state == 1 then
		(
			-- cr�ation de l'array de travail des labels
			labelsArTmp = for o in labelsAr collect o
			sort labelsArTmp

			-- cr�ation de l'array de travail des ids
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
		)
		

		-- sort by ids
		else if sortSelBT.state == 2 then
		(
			-- cr�ation de l'array de travail des labels
			idsArTmp = for o in idsAr collect o
			sort idsArTmp

			-- cr�ation de l'array de travail des ids
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

		-- refreshui � partir de selection
		local idSel = idObjectsLB.selection
		format "idSel: %\n" idSel
		if idSel > 0 then 
			
		(
			objsById = for o in geometry where o.gbufferChannel == idsAr[idSel] collect o
			objectCountET.text = objsById.count as string
		
			objsIDNameET.text = labelsAr[idSel]
			idsSp.value = idsAr[idSel]
		
			-- s�curit� pour ne pas modifier les ids visiolab
	-- 		VisioIdsAr
			if (finditem VisioIdsAr idsAr[idSel]) == 0 or typeSelBT.state == 3 then 
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
		loadVisiolabIDs()
		loadRolloutParams gbufferChannelRLT params
		
		if idsAr == undefined then idsAr = #()
		if labelsAr == undefined then labelsAr = #()
		
		if idsArBak == undefined then idsArBak = #()
		if labelsArBak == undefined then labelsArBak = #()
		
		idObjectsLB.selection = 1
		
		init()
		refreshUIList()
	)
	
	on gbufferChannelRLT close do
	(
		writeRolloutParams gbufferChannelRLT params
	)
	
	on typeSelBT changed state do
	(
		init()
		refreshUIList()
-- 		format "state: %\n" state
	)
	
	on sortSelBT changed val do refreshUIList()
	
	on idObjectsLB selected val do refreshUIList()
	
	on objsIDNameET entered val do
	(
-- 		format "label: %\n" labelsAr[idObjectsLB.selection]
		
		labelsAr[idObjectsLB.selection] = val
		
		refreshUIList()
		
		addMultiMatByObjBT.pressed()
	)
	
	on idsSp entered do
	(
		local bakVal = idsAr[idObjectsLB.selection]
		applyChange = true
-- 		format "enter: True!\n"
		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
		
		-- tester la nouvelle valeur sur les ids deja appliquer dans la sc�ne et par visiolab
		if findItem VisioIdsAr idsSp.value > 0 then applyChange = false
		else if findItem idsAr idsSp.value > 0 then applyChange = false
		else()
		
		if typeSelBT.state == 3 then applyChange = true
		
		-- appliquer le nouvel id � tous les objects
		if applyChange then
		(
			for s in objsById do s.gbufferChannel = idsSp.value
				
			-- changer la valeur de l'id dans l'array
			idsAr[idObjectsLB.selection] = idsSp.value
			
			-- ne pas faire d'init pour conserver le nom? ou faire un backup avant de faire l'init?
			idsArBak = for l in idsAr collect l	
			labelsArBak = for l in labelsAr collect l
				
			addMultiMatByObjBT.pressed()
			
			if objsById.count > 0 then init()

			refreshUIList() 
		)
		else
		(
			idsSp.value = bakVal
			format "cette id est d�ja utilis�\n"
		)

		-- cas particulier de change d'id Visiolab
		if typeSelBT.state == 3 then 
		(
			VisioIdsAr = for id in idsAr collect id
			VisioLabelsAr = for label in labelsAr collect label
				
			writeVisiolabIDs()
			init()
			refreshUIList()
		)
	)
	
	on addLaberBT pressed do
	(
		newLabel = "label_" + ((idsAr.count + 1) as string) +"_id_" 
		format "new label: %\n" newLabel
		
 		if typeSelBT.state == 1 or typeSelBT.state == 2 then
		(
			append labelsAr newLabel
			append idsAr 100
		)
		else if typeSelBT.state == 3 then
		(
			append VisioLabelsAr newLabel
			append VisioIdsAr 100
			
			writeVisiolabIDs()
			
			format "VisioLabelsAr: %\n" VisioLabelsAr
			format "VisioIdsAr: %\n" VisioIdsAr
			init()
		) 
		
		refreshUIList()
	)  
	
	on openIniBT pressed do
	(
		local visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
		doscommand ("explorer " + visioIDsIni)
	)
	
	on delLabelBT pressed do
	(
		local idSel = idObjectsLB.selection
		
		if typeSelBT.state == 1 or typeSelBT.state == 2 then
		(
			-- suppression de l'id des objets
			for o in geometry where o.gbufferChannel == idsAr[idSel] do o.gbufferChannel = 0
				
			-- suppression de id de la liste de travail 
			deleteitem idsAr idSel
			deleteitem labelsAr idSel
			
			-- suppressions de l'id de la liste des render Element
			refreshUIList()
			addMultiMatByObjBT.pressed()
		)
		else if typeSelBT.state == 3 then
		(
			-- suppression de l'id des objets
			for o in geometry where o.gbufferChannel == idsAr[idSel] do o.gbufferChannel = 0
				
			-- suppression de id de la liste de travail 
			deleteitem idsAr idSel
			deleteitem labelsAr idSel
			
			
			VisioIdsAr = for id in idsAr collect id
			VisioLabelsAr = for label in labelsAr collect label
				
			writeVisiolabIDs()
			init()
			refreshUIList()
			
			-- suppressions de l'id de la liste des render Element
			addMultiMatByObjBT.pressed()
			
			-- suppressions de l'id de la liste des render Element
			-- suppression de l'id des objets
			-- suppression de l'id des visiolab id
		)
-- 		refreshUIList()
		
-- 		addMultiMatByObjBT.pressed()
	)
	
	on selectBT pressed do
	(
		objsById = for o in geometry where o.gbufferChannel == idsAr[idObjectsLB.selection] collect o
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
			local superName = "objId_" + (idsAr[i] as string) +  "_" + labelsAr[i]
			local matSel = multimatteElement elementName: superName R_gbufID: idsAr[i] G_gbufID: idsAr[i] B_gbufID: idsAr[i] MatID: false
			rem.AddRenderElement matSel
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
		
-- 		init()
-- 		refreshUIList()
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
		
-- 		init()
-- 		refreshUIList()
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
				
				-- application des r�glages de rendus
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
				
				-- setting des objets selectionn�s
-- 				oneID = 666
-- 				for s in sel do s.gbufferChannel = oneID

				-- creation de la passe
				rem = MaxOps.GetCurRenderElementMgr ()
-- 				format "check1\n"
				local superName = "objectsId_" + (oneID as string) --  + "_" + mat.name
-- 				format "check2\n"
				local matSel = multimatteElement elementName: superName R_gbufID: oneID G_gbufID: oneID B_gbufID: oneID MatID: false
-- 				format "check3\n"
				rem.AddRenderElement matSel
-- 				format "check4\n"

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