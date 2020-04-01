/*
 faire travailler au choix sur la scene, les objets visibles ou la selection d'objet ou les multimaterial
 
 travailler avec les vray effect id sur les vray mat (pour le moment, ignorer les material id, les sur materiaux vray ou les mat standard)
	- lister material id pour nettoyage
	
 x une interface pour appliquer des effect id aux materiaux
	 x un tool pour publier les multi mat
		rammasser tous les materiaux composé et pas seulement les multimat
	 x assign id en random sur un set de vray mat 
		en respectant les ids deja affectes
		faire fonctionner sur la selection
	x assigner un id non utilisé sur une selection de materiaux
 
 x--une interface pour manager les ids(retrouver les objets par ids, publier les materiaux avec le même ids)
	 /une interface pour parametrer la passe material id et les passes vrayobjectselect et les multimatteelement
	  passer la liste d'id en multilist
	  créer les passes des id selectionnées

*/

-- appliquer une id de materiau aux materiaux des object selectionnés

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

fn collectVisibleMat =
(
	-- travailler sur les materiaux des objets selectionnés
-- 		sel = selection as array
	local oneMatAr

	-- travailler sur les materiaux des objets visiblesés
	local sel = for o in  $* where o.ishidden == false collect o

	-- collecte des materiaux du set d objet
	local matSel = #()
	for s in sel where s.material != undefined  do
	(
		appendifunique matSel s.material
	)

	-- collecte des vray mat du set
	oneMatAr = #()
	for m in matSel do
	(
		tmpMatAr = getclassinstances vrayMtl target: m
		for tmpM in tmpMatAr do appendifunique oneMatAr tmpM
-- 			format "tmpMatAr: %\n" tmpMatAr
		windows.ProcessPostedMessages()
	)

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


fn returnCleanId =
(
	-- collecter les ids de materiaux deja affecter dans la scene
	local usedIds = collectMatIDs()

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
		if turn > 50 then exit
	)
	format "clean id:%\n" j
	j
)
-- returnCleanId()


try(destroydialog matIdManagerRLT)catch()
rollout matIdManagerRLT "material ids manager" width: 200
(
	local matAr
	local multiMatAr
	local matArToDisp
	local multiMatArToDisp
	local matListSel = #()
	
	group "selection:"
	(
		radiobuttons typeSelBT "selection: " labels:#("scene", "visible", "selection") default: 2 enabled: false
		button refreshBT "refresh"
	)
	
	group "multimaterials:"
	(
		listbox multiMatLB "multi material list" height: 15
		button editMultiMatBT "edit multi mat" enabled: false
		button selectMultiMatObjBT "select object" enabled: false
	)
	
	group "vray materials:"
	(
		multilistbox materialListMLB "vray material list:" height: 30
		editText matCountET "material count" readonly: true
		button editMatBT "edit mat" -- enabled: false
		button selectMatObjBT "select object" -- enabled: false
		
		spinner matIdSP "material id" type: #integer
		button addFreeIdBT "add free id to sel" 
		button randomIdBT "random all ids" --enabled: false
	)
	
	fn refreshUI =
	(
		-- list de materiaux			
		multiMatArToDisp = multiMatAr
		qsort  multiMatArToDisp sortbyname
		multiMatLB.items = for m in multiMatArToDisp collect m.name
			
		matArToDisp = matAr
		qsort  matAr sortbyname
		matNameArToDisp = #()
		for m in matArToDisp do
		(
			if m.effect_id == 0 then
			(
				append matNameArToDisp (m.name)
			)
			else
			(
				append matNameArToDisp (m.name + "  [" +  (m.effect_id as string) + "]")
			)
		)			
		materialListMLB.items =matNameArToDisp
		
		-- material count
		matCountET.text = matAr.count as string
-- 		
		if matListSel.count > 0 then
		(
			local idAr = #()
			for m in matListSel do appendifunique idAr m.effect_id
			if idAr.count == 1 then matIdSP.value = idAr[1] else matIdSP.value = 0
		)
	)		
	
	on refreshBT pressed do
	(
		matAr = collectVisibleMat()
		multiMatAr = collectVisibleMultiMat()
		multiMatLB.selection = 0
		refreshUI()
	)
	
	on matIdManagerRLT open do
	(
		matAr = collectVisibleMat()
		multiMatAr = collectVisibleMultiMat()
		refreshUI()
	)
	
	on multiMatLB selected arg do
	(
		matAr = getclassinstances vrayMtl target: multiMatAr[arg]
		refreshUI()
	)
	
	on materialListMLB selectionEnd do
	(
-- 		format "selection:% \n" materialListMLB.selection
		matListSel = for i in materialListMLB.selection collect matAr[i] 
-- 		format "matListSel:%\n" matListSel
		refreshUI()
	)
	
	on editMatBT pressed do
	(
		print "youhou2"
		for i = 1 to matListSel.count do
		(
			meditMaterials[i] = matListSel[i]
		)
	)	
	
	on selectMatObjBT pressed do
	(
		local setToSel = #()
		
-- 		format "youhou\n"
		if matListSel.count > 0 then
		(
			for m in matListSel do
			(
				format "mat:%\n" m.name
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
		)
		select setToSel
	)
	
	on matIdSP changed val do
	(
		if matListSel.count > 0 then
		(
			for m in matListSel do
			(
				m.override_effect_id = on
				m.effect_id = val
			)
		)
		refreshUI()
	)
	
	on addFreeIdBT pressed do
	(
		local newId = returnCleanId()
		for m in matListSel do
		(
			m.effect_id = newId
		)
		
		refreshUI()
	)
	
	on randomIdBT pressed do
	(
		-- assign de maniere incrementale des id au materiaux en evitant d'appliquer plusieurs fois des id et en evitant de changer les id deja affecter
		-- collecter les ids de materiaux deja affecter dans la scene
		local forceID = true
		for i = 1 to matArToDisp.count do
		(
			-- si une id est deja affecté passer
			if matArToDisp[i].effect_id != 0 and not forceID then continue
			-- générer une id
			returnCleanId()

			matArToDisp[i].override_effect_id = on
			matArToDisp[i].effect_id = (returnCleanId())
			format "id: % assign: %\n" i matAr[i].name
		)
		refreshUI()
	)
)
-- createdialog matIdManagerRLT

fn collectMatByIds id =
(
	local sceneMat = getclassinstances vrayMtl target: scenematerials
	local sameIdMatAr = for m in sceneMat where m.effect_id == id collect m
	sameIdMatAr
)
-- collectMatIDs()

matIdExplorerRF = newRolloutFloater "Materials id explorer" 250 500
try(destroydialog matIdExplorerRF)catch()
-- try(destroydialog matIdExplorerRLT)catch()
rollout matIdExplorerRLT "materials id explorer"
(
	local idSel = 0
	local idsAr = #()
	local sameIdMatAr = #()
	local matListSel = #()
	local sceneMat
	
	group "tools"
	(
		button matManagerBT "manager visible materials"
	)
	
	-- UI
	group "material ids:"
	(
		listbox matIdLB "materials ids:"
		button refreshIdsBT "refresh"
		multilistbox matMLB "scene materials:"
		spinner reassignSP "reassign id:" type: #integer
		button editMatBT "edit material" --enabled: false
		button selObjBT "select object"  -- enabled: false
	)
	
	group "render elements:"
	(
		button matIdEltBT "material id element"
		button objSelEltBT "object select element"
		button multiEltBT "multimatte element" -- enabled: false
	)
	
	-- functions UI dependant
	fn refreshUI =
	(
		matIdLB.items = for id in idsAr collect (id as string)
		
		if sameIdMatAr.count > 0  then matMLB.items = for m in sameIdMatAr collect m.name
			
		reassignSP.value = idSel
	)
	
	-- Actions
	on matIdExplorerRLT open do
	(
		idsAr = collectMatIDs()
		refreshUI()
	)
	
	on matManagerBT pressed do
	(
		matIdManagerRF = newRolloutFloater "Materials id manager" 250 500
		try(destroydialog matIdManagerRF)catch()
		addrollout matIdManagerRLT matIdManagerRF
	)
	
	on refreshIdsBT pressed do
	(
		idsAr = collectMatIDs()
		refreshUI()
	)
		
	on matIdLB selected val do
	(
-- 		sameIdMatAr = collectMatByIds val
		idSel = matIdLB.selected as integer
-- 		format "idSel: %\n" idSel
		sceneMat = getclassinstances vrayMtl target: scenematerials
		sameIdMatAr = for m in sceneMat where m.effect_id == idSel collect m
		qsort sameIdMatAr sortByName
-- 		format "sameIdMatAr: %\n" sameIdMatAr
		refreshUI()
	)
	
	on matMLB selectionEnd do
	(
		matListSel = for i in matMLB.selection collect sameIdMatAr[i] 
-- 		matIdLB.selected = 0
	)
	
	on editMatBT pressed do
	(
		for i = 1 to matListSel.count do
		(
			meditMaterials[i] = matListSel[i]
		)
	)
	
	on selObjBT pressed do
	(
		local setToSel = #()
		
-- 		format "youhou\n"
		if matListSel.count > 0 then
		(
			for m in matListSel do
			(
				format "mat:%\n" m.name
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
		)
		select setToSel
	)
	
	on reassignSP entered  do
	(
		-- reassignation de l'id de mat
		format "val:%\n" reassignSP.value
		if matListSel.count > 0 then
		(
			for m in matListSel do
			(
				m.override_effect_id = on
				m.effect_id = reassignSP.value
			)
		)
		
		-- recollecte aprés assignation
		idsAr = collectMatIDs()
		format "idsAr:%\n" idsAr

		idSel = reassignSP.value
-- 		idSel = matIdLB.selected as integer
		format "idSel: % %\n" idSel (classof idSel)
-- 		local sceneMat = getclassinstances vrayMtl target: scenematerials
		sameIdMatAr = for m in sceneMat where m.effect_id == idSel collect m
		format "sameIdMatAr: %\n" sameIdMatAr
		
		refreshUI()
-- 		format "idSel: % %\n" idSel (classof idSel)
-- 		print "ça passe par là?"
		matIdLB.selection= idSel
-- 		refreshUI()
	)
	
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
		
		-- suppression de la passe material id
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt VRayObjectSelect then rem.RemoveRenderElement elt
		)
		
		-- collecte des vray mat
		sceneMat = getclassinstances vrayMtl target: scenematerials
			
		-- creation des passes
		for id in idsAr do
		(
			-- creation du nom
			sameIdMatAr = for m in sceneMat where m.effect_id == id collect m
			superName = ""
			for m in sameIdMatAr do 
			(
				format "%\n" (superName += ("/" + m.name))
				superName = substring superName 1 40
			)
			
			if id > 0 then
			(
-- 				format "channel id: % mat name: %\n" m.effect_id m.name
				vrObjSelElt = VRayObjectSelect elementName: ("id_" + (id as string) + superName) mode: 1 object_id: id  use_material_id: true consider_for_antialiasing: true
				rem.AddRenderElement vrObjSelElt
			)
		)
	)
	
	on multiEltBT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		
		-- suppression des passes multimat
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt multimatteElement then rem.RemoveRenderElement elt
		)
		
		-- collecte des vray mat
		sceneMat = getclassinstances vrayMtl target: scenematerials
			
		-- creation des passes
		for i=1 to  idsAr.count by 3 do
		(
			format "idsAr[i]: %\n" idsAr[i]
			-- creation du nom
			sameIdMatAr = #()
			for m in sceneMat do
			(
				if m.effect_id == 0 then continue
				if m.effect_id == idsAr[i] then append sameIdMatAr m
				if m.effect_id == idsAr[i+1] then append sameIdMatAr m
				if m.effect_id == idsAr[i+2] then append sameIdMatAr m
			)
			
			-- 
			superName = ""
			for m in sameIdMatAr do 
			(
				superName += ("[" +(m.effect_id as string)+"]" + m.name + " ")
				format "%\n" superName
-- 				superName = substring superName 1 60
			)
			
			-- 
			local R_gbufID, G_gbufID, B_gbufID
			
			-- 
			if idsAr[i] != undefined then R_gbufID = idsAr[i] else R_gbufID = 0
			if idsAr[i+1] != undefined then G_gbufID = idsAr[i+1] else G_gbufID = 0
			if idsAr[i+2] != undefined then B_gbufID = idsAr[i+2] else B_gbufID = 0
			
-- 			if idsAr[i] > 0 then
			(
				format "%\n" superName
				local matSel = multimatteElement elementName: (superName) R_gbufID: R_gbufID G_gbufID: G_gbufID B_gbufID: B_gbufID MatID: true
				rem.AddRenderElement matSel
			)
		)
	)
)
-- createdialog matIdExplorerRLT

addrollout  matIdExplorerRLT matIdExplorerRF

