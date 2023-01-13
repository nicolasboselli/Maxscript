/*
maj: 
	-- AVEC LE PICKER SELECTIONner plusieurs materiaux avec Ctrl
	-- collapser les materiaux avec la même id dans la liste
	-- editer les materiaux dans le slate
	
	-- faire un vrai nettoyage de tous les materiaux id, ne pas passer par un getclassinstance sur le scenematerials
		-- ça veut dire prendre en compte les standard, bitmap et autre
	-- prendre en charge les multi mat et les materiaux composite
		-- une liste pour ces materiaux
	-- fonctionner avec les material id de max plutôt qu'avec les effect_id de vray finalement?
	-- ignore les passes d'id deja créées
	
	-- ne pas effacer automatiquement les passes deja créées
	
debug:
	x- lasso activer aprés des selections trop rapide

rebuild:
	-- tester de collecter tous les materiaux de la scene dans une library et d'interroger la libray, plutôt que 'utiliser le scene material ou un array de materiaux
	x- trouver une façon plus élégante d'imbriquer les fonctions, les callback et l'UI
 
 travailler avec les vray effect id sur les vray mat (pour le moment, ignorer les material id, les sur materiaux vray ou les mat standard)
	/- lister material id pour nettoyage

*/


filein "VraySelAlphaMask.ms"

fn sortbyname v1 v2 =
(
	-- 	vars
	local d
	
	if ( (toupper v1.name) < (toupper v2.name)) then
		d=1
	else
		d=-1
	
	--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): 1
		(d > 0.): -1
		default: 0
	)
)

fn sortbyId v1 v2 =
(
		-- 	vars
	local d
	
	if ( (v1.effect_id) < (v2.effect_id)) then
		d=1
	else
		d=-1
	
-- 	format "v1: % v2: % d:%\n" v1 v2 d
	--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): 1
		(d > 0.): -1
		default: 0
	)
)


fn collectSetMat oneSet =
(
	local oneMatAr

	-- collecte des materiaux du set d objet
	local matSel = #()
	for s in oneSet where s.material != undefined  do
	(
		appendifunique matSel s.material
	)
-- 	format "matSel.count: %\n" matSel.count
	
	-- collecte des vray mat du set
	oneMatAr = #()
	for m in matSel do
	(
		tmpMatAr = getclassinstances vrayMtl target: m
		for tmpM in tmpMatAr do appendifunique oneMatAr tmpM
-- 			format "tmpMatAr: %\n" tmpMatAr
-- 		windows.ProcessPostedMessages()
	)
-- 	format "oneMatAr.count: %\n" oneMatAr.count

	oneMatAr
)

fn collectVisibleMultiMat =
(
-- 	local oneMatAr

	-- travailler sur les materiaux des objets visiblesés
	local sel = for o in  $* where o.ishidden == false collect o

	-- collecte des materiaux du set d objet
	local matSel = #()
	for s in sel where s.material != undefined  do
	(
		appendifunique matSel s.material
	)
	
	for m in matSel where iskindof m multimaterial collect m
)
-- collectVisibleMultiMat()

/*
fn collectMatIDs =
(
	local idsAr = #()
	local matArTmp = getclassinstances vrayMtl target: scenematerials
	
-- 	local idsAr
	for m in matArTmp do appendifunique idsAr m.effect_id
	sort idsAr
	format "idsAr: %\n" idsAr
	idsAr
)
*/

-- clean materials id
fn cleaneffectsChannel =
(
	for m in scenematerials do
	(
		if iskindof m VRaySky then(format "ignore:%\n" m)
		else
		(	
			 m.effectsChannel = 0
			format "m: % id: %\n" m m.effectsChannel
		)
	)
)
-- cleaneffectsChannel()

fn cleanVrayEffectsChannel =
(
	for m in scenematerials do
	(
		if iskindof m VRayMtl then
		(
			m.effect_id = 0
			format "ignore:%\n" m
		)
		else()
	)
)

fn returnCleanId =
(
	-- collecter les ids de materiaux deja affecter dans la scene
	local usedIds = #()
	local matArTmp = getclassinstances vrayMtl target: scenematerials

-- 	local idsAr
	for m in matArTmp do appendifunique usedIds m.effect_id
	sort usedIds
	
-- 	local usedIds = idsAr

	-- appliquer les ids de materiaux en evitant les ids deja attribuées
	local j = 0
	j += 1
	local jAr = #(j)

	local turn = 0

	-- determination d'une id disponible
	for id in jAr do
	(
		-- test de l'id			
		local res = finditem usedIds id
-- 		format "id: % res:%\n" id res
		
		-- si l'idée est dé
		if res > 0 then 
		(
			j += 1
			append jAR j
		)
		
		-- sécurité anti boucle
		turn +=1 
		if turn > 100 then exit
	)
	format "clean id:%\n" j
	j
)
returnCleanId()

try(closeRolloutFloater matIdExplorerRF)catch()
matIdExplorerRF = newRolloutFloater "Materials id explorer" 500 700
matIdExplorerRF.lockWidth = false
matIdExplorerRF.autoLayoutOnResize = true
-- try(destroydialog matIdExplorerRLT)catch()
rollout matIdExplorerRLT "materials id explorer"
(
	local RFPos = [0,0]
	local RFSIze = [250,600]
	
	local params = #("RFPos","RFSIze", "typeSelBT", "ignoreIDO", "sortSelBT")
	
	local sceneMat
		
-- 	local matAr
	local multiMatAr
	local matArToDisp
	local multiMatArToDisp
	local matListSel = #()
	
	local pickedMat
	
	
	
	
-- 	UI
	group "working on:"
	(
		radiobuttons typeSelBT  labels:#("scene ( all objects )", "selection") default: 1 --enabled: false
-- 		button refreshBT "refresh"
	)
	/*
	group "multimaterials:"
	(
		listbox multiMatLB "multi material list" height: 5 --enabled: true
		button editMultiMatBT "edit multi mat" enabled: false
		button selectMultiMatObjBT "select object" enabled: false
	)
	*/
	group "vray materials:"
	(
		radiobuttons sortSelBT "sort: " labels:#("by name", "by id") default: 1 -- enabled: false
		checkbox ignoreIDO "ignore id 0" -- enabled: false
		multilistbox materialListMLB "vray material list:" --height: 30
		
		editText matCountET "material count" readonly: true
		button selAllBT "select All" across:4
		button editMatBT "edit material"  -- across:2-- enabled: false
		button selectMatObjBT "select object" -- enabled: false
		checkbutton pickMatCB "pick material" -- enabled: false
	)
	
	group "vray effect channel:"
	(
		
		spinner matIdSP "material id" type: #integer
		button addFreeIdBT "add free id to sel" across:3
		button randomIdBT "random ids on sel" --enabled: false
		button cleanIdMatBT "clean all id mat"
	)
		
	-- UI
	group "create render elements:"
	(
		button matIdEltBT "VRayMtlID" --across: 3
		button objSelEltBT "add VRayObjectSelect" across: 2 tooltip: "Création d'une passe 'vrayObjectSelect' pour chaque id de material selectionné."
		button delobjSelEltBT "del VRayObjectSelect" -- tooltip: "Création d'une passe 'vrayObjectSelect' pour chaque id de material selectionné."
-- 		button multiEltBT "all MultiMatteElement"  tooltip: "création de toutes les passes MultiElement"
		button multiElt2BT "add MultiMatteElt"  across: 2 tooltip: "création de toutes les passes MultiElement"
		button delmultiElt2BT "delete MultiMatteElt"  -- tooltip: "création de toutes les passes MultiElement"
	)
	
	group "alpha render v.0 (à utiliser avec précaution)"
	(
		button AlphaSelRenderBT "selection" across: 2
		button MatSelRenderBT "material"
	)
	
		
	
	
-- functions UI dependant
	fn refreshUIList =
	(
		-- collecte des noms
-- 		format "collect materials start\n"
-- 		t1 = timestamp()
		matNameArToDisp = #()
		
-- 		local collectMax = 100
		for i = 1 to matArToDisp.count do
		(
-- 			if i > collectMax then
-- 			(
-- 				format "end collect\n"
-- 				exit
-- 			)
			
			local m = matArToDisp[i]
-- 			format "% %\n" m.name m.effect_id
			if m.effect_id == 0 then
			(
				append matNameArToDisp (m.name)
			)
			else if sortSelBT.state == 1 then
			(
-- 				format "youpi 1 \n"
				append matNameArToDisp (m.name + "  [" +  (m.effect_id as string) + "]")
			)
			else if sortSelBT.state == 2 then
			(
-- 				format "youpi 2 \n"
				append matNameArToDisp ( "[" +  (m.effect_id as string) + "]  " + m.name )
			)			
		)	
		
		
		materialListMLB.items = matNameArToDisp
-- 		format "collect materials done: % s\n" (((timestamp()) - t1)/1000)
		-- changer la selection en fonction du changement de postion de la selection dans la liste
		-- material count
		matCountET.text = matArToDisp.count as string
	)
	
	fn refreshUI1 =
	(
		-- collecte de de la liste de multimaterial
		/*
		multiMatArToDisp = multiMatAr
		qsort  multiMatArToDisp sortbyname
		multiMatLB.items = for m in multiMatArToDisp collect m.name
		*/
			
		-- refresh spinner id 		
		if matListSel.count > 0 then
		(
			local idAr = #()
			for m in matListSel do appendifunique idAr m.effect_id
			if idAr.count == 1 then matIdSP.value = idAr[1] else matIdSP.value = 0
		)
	)	
		
	fn sortMatAr =
	(
		if sortSelBT.state == 1 then
		(
			local t0 = timestamp()
			qsort  matArToDisp sortbyname  --start: 1 end: 300
			local t1 = timestamp()
			format "sortbyname done: % s\n" (((t1 - t0)as float)/1000)
		)
		else if sortSelBT.state == 2 then
		(
			local t0 = timestamp()
-- 			qsort  matArToDisp sortbyId  -- start: 1 end: 300
			idsArray = #()
			for m in matArToDisp do 
			(
				test = idsArray[m.effect_Id + 1]
				if test == undefined then insertItem #(m) idsArray (m.effect_Id + 1)
				else insertItem m idsArray[m.effect_Id + 1] 1
			)	
			idsArray.count

			matArToDisp = #()
			for a in idsArray where a != undefined do 
			(
				join matArToDisp a
			)
			matArToDisp.count
						
			local t1 = timestamp()
			format "sortbyId done: % s\n" (((t1 - t0)as float)/1000)
		)
	)
		
	fn init =
	(
		-- collecte du set d'objet
		local sel = #()
		if typeSelBT.state == 1 then
		(
			sel =  for o in  $* collect o
		)
		else if typeSelBT.state == 666 then
		(
			sel = for o in  $* where o.ishidden == false collect o
		)
		else if typeSelBT.state  == 2 then
		(
			sel = selection as array
		)
		else()
		
		-- collecte des materiaux à partir de la selection d'objet
		
-- 		local t0 = timestamp()
		matArToDisp = collectSetMat sel
		
		-- ignore id 0
		if ignoreIDO.checked then matArToDisp = for mat in matArToDisp where mat.effect_id != 0 collect mat
		
-- 		local t1 = timestamp()
-- 		format "collectMat done: % s\n" (((t1 - t0)as float)/1000)
		
		sortMatAr()
-- 		local t2 = timestamp()
-- 		format "sortMatAr done: % ms\n" (((t2 - t1)as float)/1000)
		
		refreshUIList()
-- 		local t3 = timestamp()
-- 		format "refreshUIList done: % ms\n" (((t3 - t2)as float)/1000)
		
		refreshUI1()
-- 		local t4 = timestamp()
-- 		format "refreshUI1 done: % ms\n" (((t4 - t3)as float)/1000)
	)

	
	
-- TOOLS	
	tool pickMaterialTool
	(
		
		local snapNode
		
		on mousePoint clickno do
		(
			if clickno > 1 then
			(
-- 				format "clickno: %\n"clickno
				local theNearestObj
				local theShortestDist = 10000000
				
				local viewTM = (inverse(getViewTM())).translationpart
				local myRay = mapScreenToWorldRay viewPoint
				local res = intersectRayScene myRay
					
				for o in res where not o[1].ishidden do
				(
	-- 				format "ishidden: %\n" o[1].ishidden
					if (distance o[2].pos viewTM) < theShortestDist do
					(
						theNearestObj = o[1]
						theShortestDist = distance o[2].pos viewTM
					)
				)
				
				if isvalidnode theNearestObj then
				(
					meshModForMatID = edit_mesh name: "meshModForMatID "
					addmodifier theNearestObj meshModForMatID
					
					local impact = intersectRayEx theNearestObj myRay
					
-- 					format "theNearestObj: % impact: %\n" theNearestObj.name impact
					
					local pickedId = (getFaceMatID theNearestObj impact[2])
-- 					format "matID: %\n" pickedId
	-- 				select theNearestObj
					
					if iskindof  theNearestObj.material MultiMaterial then
					(
						format "mat: %\n" theNearestObj.material[pickedId]
						pickedMat = theNearestObj.material[pickedId]
						format "%\n" (finditem matArToDisp pickedMat)
						materialListMLB.selection = (finditem matArToDisp pickedMat)
					)
					else
					(
						format "mat: %\n" theNearestObj.material
						pickedMat = theNearestObj.material
						format "%\n" (finditem matArToDisp pickedMat)
						materialListMLB.selection = (finditem matArToDisp pickedMat)
					)
					
					deleteModifier theNearestObj meshModForMatID
				)
				
	-- 			format "res:%\n" res
			)

		)
	)
	
	-- Actions
	on matIdExplorerRLT open do
	(
		loadRolloutParams matIdExplorerRLT params
		try(matIdExplorerRF.pos =  RFPos)catch()
-- 		try(matIdExplorerRF.size =  RFSIze)catch()
		
		init()
		
-- 		callbacks.addScript #nodeHide "matIdExplorerRLT.init()" id: #printSelVisTest
-- 		callbacks.addScript #nodeUnHide "matIdExplorerRLT.init()" id: #printSelVisTest2
		callbacks.addScript #selectionSetChanged "matIdExplorerRLT.init()" id: #printSelTest
		
-- 		init()
	)
	
	on matIdExplorerRLT close do
	(
		RFPos = matIdExplorerRF.pos
		RFSIze = matIdExplorerRF.size
		
		writeRolloutParams matIdExplorerRLT params
		
		callbacks.removeScripts id:#printSelTest
-- 		callbacks.removeScripts id:#printSelVisTest
-- 		callbacks.removeScripts id:#printSelVisTest2
	)
	
	on cleanIdMatBT pressed do
	(		
		if (queryBox  "Voulez vous supprimer toutes les vray ids de matériaux ?") then
		(
			cleaneffectsChannel()
			cleanVrayEffectsChannel()
			init()
		)
		else()
		

	)
	
	on typeSelBT changed state do init()
	
	on sortSelBT changed val do
	(
-- 		init()
-- 		local t1 = timestamp()		
		sortMatAr()
-- 		local t2 = timestamp()
-- 		format "sortMatAr done: % ms\n" (((t2 - t1)as float)/1000)
		
		sortMatAr()
		refreshUIList()
		refreshUI1()
	)
	
	on ignoreIDO changed val do init()
	
	on materialListMLB selectionEnd do
	(
-- 		format "selection:% \n" materialListMLB.selection
		matListSel = for i in materialListMLB.selection collect matArToDisp[i] 
-- 		format "matListSel:%\n" matListSel
		refreshUI1()
	)
	
	on selAllBT pressed do
	(
-- 		format "%\n" materialListMLB.items.count
		materialListMLB.selection = ((for i = 1 to materialListMLB.items.count collect i) as bitarray)
-- 		format "selAr: %\n" selAr
	)
	
	on editMatBT pressed do
	(
-- 		print "youhou2"
-- 		for i = 1 to matListSel.count do
		local j = 0
		for i in materialListMLB.selection do
		(
			j+=1
			meditMaterials[j] = matArToDisp[i]
			if j == 24 then exit
		)
	)	
	
	on selectMatObjBT pressed do
	(
		local setToSel = #()
		
-- 		format "youhou\n"
-- 		if matListSel.count > 0 then
-- 		(
-- 			for m in matListSel do
			for i in materialListMLB.selection do
			(
				m =  matArToDisp[i]
-- 				format "mat:%\n" m.name
				local deps = refs.dependents m
				for d in deps do
				(
-- 					format "d: % classof: % isvalinode: %\n" d (classof d) (isvalidnode d)
					if isvalidnode d then
					(
-- 						format "d: % isvalinode: % \n" d  (isvalidnode d)
						append setToSel d
					)
				)
			)
-- 		)
		select setToSel
	)
	
	on pickMatCB changed state do
	(
		if state == true do
		(
			continueTool = true
			while continueTool == true do
			(
				continueTool = starttool pickMaterialTool
			)
			pickMatCB.state = false
		)
	)
	
	on matIdSP changed val do
	(
-- 		if matListSel.count > 0 then
-- 		(
			for i in materialListMLB.selection do
-- 			for m in matListSel do
			(
				m =  matArToDisp[i]
				m.override_effect_id = on
				m.effect_id = val
			)
-- 		)
		
-- 		init()
		
		sortMatAr()
		refreshUIList()
		refreshUI1()
	)
	
	on addFreeIdBT pressed do
	(
		local newId = returnCleanId()
		
		for i in materialListMLB.selection do
-- 		for m in matListSel do
		(
			m =  matArToDisp[i]
			m.override_effect_id = on
			m.effect_id = newId
		)
		
-- 		init()
		sortMatAr()
		refreshUIList()
		refreshUI1()
	)
	
	on randomIdBT pressed do
	(
		-- assign de maniere incrementale des id au materiaux en evitant d'appliquer plusieurs fois des id et en evitant de changer les id deja affecter
		-- collecter les ids de materiaux deja affecter dans la scene
		local forceID = true
				
		for i in materialListMLB.selection do
-- 		for m in matListSel do
		(
			m =  matArToDisp[i]
			-- si une id est deja affecté passer
			if m.effect_id != 0 and not forceID then continue

			m.override_effect_id = on
			m.effect_id = (returnCleanId())
			format "id: % assign: %\n" i m.name
		)
		
-- 		init()
		sortMatAr()
		refreshUIList()
		refreshUI1()
	)
	
	--############################ render elements
	
	on matIdEltBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		-- suppression de la passe material id
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt VRayMtlID then rem.RemoveRenderElement elt
		)
		-- ajout de la passe material id
		vrMtlID = VRayMtlID filterOn: true output_type: 1
		rem.AddRenderElement vrMtlID	
	)
	
	on objSelEltBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		/*
		-- suppression de la passe material id
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt VRayObjectSelect then rem.RemoveRenderElement elt
		)
		*/
		
		local usedIds = #()
		for i in materialListMLB.selection do
		(
			 -- collecte des id deja publiées
			local testId = finditem usedIds matArToDisp[i].effect_id
			appendifunique usedIds matArToDisp[i].effect_id
			 
			 -- evite de faire deux fois la même couche
			if testId > 0 then continue
			else if matArToDisp[i].effect_id == 0 then continue
			else
			(
				local superName = "effectId_" + (matArToDisp[i].effect_id as string) +  "_" + matArToDisp[i].name
				
				local vrObjSelElt = VRayObjectSelect elementName: superName mode: 1 object_id: matArToDisp[i].effect_id   use_material_id: true consider_for_antialiasing: true
				rem.AddRenderElement vrObjSelElt
			)
		)	
	)
	
	on delobjSelEltBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		
		-- suppression de la passe material id
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt VRayObjectSelect then rem.RemoveRenderElement elt
		)
	)
	
	on multiElt2BT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()

		local usedIds = #()
		for i in materialListMLB.selection do
		(
			 -- collecte des id deja publiées
			local testId = finditem usedIds matArToDisp[i].effect_id
			appendifunique usedIds matArToDisp[i].effect_id
			 
			 -- evite de faire deux fois la même couche
			if testId > 0 then continue
			else if matArToDisp[i].effect_id == 0 then continue
			else
			(
				local superName = "matId_" + (matArToDisp[i].effect_id as string) +  "_" + matArToDisp[i].name
				local matSel = multimatteElement elementName: superName R_gbufID: matArToDisp[i].effect_id G_gbufID: matArToDisp[i].effect_id B_gbufID: matArToDisp[i].effect_id MatID: true
				rem.AddRenderElement matSel
			)
		)			
	)
	
	on delmultiElt2BT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		
		
		-- suppression des passes multimat
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt multimatteElement then rem.RemoveRenderElement elt
		)
		
	)
	
	
	on AlphaSelRenderBT pressed do
	(
		-- backup material selection
		local SelToAlpha = selection as array
		
		Material_Bak = for o in SelToAlpha collect o.material
		for o in SelToAlpha do o.material = copy AutoIllumMat
		
		-- backup des parametres de rendu
		backupRenderDef()
		
		try
		(
			-- applications des params de rendus alpha
			setVrayNight()
			backgroundColor = color 0 0 0
			
			-- rendus
			max quick render
			
			-- recup des materiaux originaux de la selection
			for i = 1 to SelToAlpha.count do SelToAlpha[i].material = Material_Bak[i]
			
			-- recup des preset de rendu
			restoreRenderDef()
		)
		catch(restoreRenderDef())
	)
	
	on MatSelRenderBT pressed do
	(
		format "coucou\n"
		global matArToAlpha = #()
		global matArToRestore = #()
		global autoIllumMatAr = #() 
				
		for i in materialListMLB.selection do
-- 		for m in matListSel do
		(
			append matArToAlpha  matArToDisp[i]
			matArToRestore = copy matArToAlpha #noMap
		)
		format "matArToAlpha1: %\n" matArToAlpha
		format "matArToRestore1: %\n" matArToRestore
		
-- 		/*
		try
		(
						
			-- backup des parametres de rendu
			backupRenderDef()
			
			-- passage des materiaux auto illum
			for m in matArToAlpha do
			(
				AutoIllumMatTmp = makeAutoIllumMat()
				format "AutoIllumMatTmp: %\n" AutoIllumMatTmp
				if m.texmap_opacity != undefined then
				(
					AutoIllumMatTmp.opacity_texmap = copy m.texmap_opacity
					AutoIllumMatTmp.opacity_multiplyColor = on
					AutoIllumMatTmp.opacity_texmap_on = on
				)
				format "check1\n" 
				replaceinstances m AutoIllumMatTmp
				format "check2\n" 
				append autoIllumMatAr AutoIllumMatTmp
				format "check3\n" 
			)
			
			format "matArToAlpha2: %\n" matArToAlpha
			format "matArToRestore2: %\n" matArToRestore
			format "autoIllumMatAr: %\n" autoIllumMatAr

			
			-- applications des params de rendus alpha
			setVrayNight()
			backgroundColor = color 0 0 0
			-- rendus
			max quick render
			
			-- restauration des materiaux d'origine
			for i = 1 to matArToAlpha.count do
			(
				
				replaceinstances autoIllumMatAr[i] matArToRestore[i]
			)
			
			-- recup des preset de rendu
			restoreRenderDef()
			format "render done \n"
-- 			*/
			
			/*
			
			Material_Bak = meditMaterials[activeMeditSlot]
			AutoIllumMatTmp = copy AutoIllumMat
			if Material_Bak.texmap_opacity != undefined then
			(
	-- 			format "AutoIllumMatTmp: %\n" AutoIllumMatTmp
				AutoIllumMatTmp.opacity_texmap = copy Material_Bak.texmap_opacity
				AutoIllumMatTmp.opacity_multiplyColor = on
				AutoIllumMatTmp.opacity_texmap_on = on
			)
	-- 		meditMaterials[1] = copy AutoIllumMatTmp
			replaceinstances meditMaterials[activeMeditSlot] AutoIllumMatTmp
			
			-- backup des parametres de rendu
			backupRenderDef()
			
			-- applications des params de rendus alpha
			setVrayNight()
			backgroundColor = color 0 0 0
			-- rendus
			max quick render
			
			replaceinstances meditMaterials[activeMeditSlot] Material_Bak
			
			-- recup des preset de rendu
			restoreRenderDef()
			*/
		)
		catch
		(
			format "CRASHHHHH!\n"
			restoreRenderDef()
		)
-- 		*/
	)
	
)
-- createdialog matIdExplorerRLT 

addrollout  matIdExplorerRLT matIdExplorerRF

DestroyDialog matIdExplorerRLT