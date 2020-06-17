/*
maj: 
	-- faire un vrai nettoyage de tous les materiaux id, ne pas passer par un getclassinstance sur le scenematerials
		-- ça veut dire prendre en compte les standard, bitmap et autre
	-- prendre en charge les multi mat et les materiaux composite
		-- une liste pour ces materiaux
	-- fonctionner avec les material id de max plutôt qu'avec les effect_id de vray finalement?
	
debug:
	-- lasso activer aprés des selections trop rapide

rebuild:
	-- trouver une façon plus élégante d'imbriquer les fonctions, les callback et l'UI
 
 travailler avec les vray effect id sur les vray mat (pour le moment, ignorer les material id, les sur materiaux vray ou les mat standard)
	/- lister material id pour nettoyage

*/

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
	
	format "v1: % v2: % d:%\n" v1 v2 d
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

	-- collecte des vray mat du set
	oneMatAr = #()
	for m in matSel do
	(
		tmpMatAr = getclassinstances vrayMtl target: m
		for tmpM in tmpMatAr do appendifunique oneMatAr tmpM
-- 			format "tmpMatAr: %\n" tmpMatAr
-- 		windows.ProcessPostedMessages()
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
		if turn > 50 then exit
	)
	format "clean id:%\n" j
	j
)
-- returnCleanId()

try(closeRolloutFloater matIdExplorerRF)catch()
matIdExplorerRF = newRolloutFloater "Materials id explorer" 250 500
-- try(destroydialog matIdExplorerRLT)catch()
rollout matIdExplorerRLT "materials id explorer"
(
	local RFPos = [0,0]
	local RFSIze = [350,800]
	
	local params = #("RFPos","RFSIze", "typeSelBT", "ignoreIDO", "sortSelBT")
	
	local idSel = #()
-- 	local idsAr = #()
	local sameIdMatAr = #()
	local matListSel = #()
	local sceneMat
		
	local matAr
	local multiMatAr
	local matArToDisp
	local multiMatArToDisp
	local matListSel = #()
	
	group "tools"
	(
		button cleanIdMatBT "clean all id mat"
-- 		button matManagerBT "materials id manager"
	)
	
	group "selection:"
	(
		radiobuttons typeSelBT "selection: " labels:#("scene", "visible", "selection") default: 2 --enabled: false
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
		button selAllBT "select All" across:3
		button editMatBT "edit material"  -- across:2-- enabled: false
		button selectMatObjBT "select object" -- enabled: false
	)
	
	group "vray effect channel:"
	(
		spinner matIdSP "material id" type: #integer
		button addFreeIdBT "add free id to sel" across:2
		button randomIdBT "random ids on sel" --enabled: false
	)
		
	-- UI
	group "create render elements:"
	(
		button matIdEltBT "VRayMtlID" --across: 3
		button objSelEltBT "VRayObjectSelect" tooltip: "Création d'une passe 'vrayObjectSelect' pour chaque id de material selectionné."
-- 		button multiEltBT "all MultiMatteElement"  tooltip: "création de toutes les passes MultiElement"
		button multiElt2BT "MultiMatteElement"  tooltip: "création de toutes les passes MultiElement"
	)
		
-- functions UI dependant
	fn refreshUIList =
	(
		-- collecte des noms
		matNameArToDisp = #()
		
		for m in matArToDisp do
		(
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
			
		-- spinner id 		
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
			qsort  matArToDisp sortbyname
		)
		else if sortSelBT.state == 2 then
		(
			qsort  matArToDisp sortbyId
		)
	)
		
	fn init =
	(
		local sel = #()
		if typeSelBT.state == 1 then
		(
			sel =  for o in  $* collect o
		)
		else if typeSelBT.state == 2 then
		(
			sel = for o in  $* where o.ishidden == false collect o
		)
		else if typeSelBT.state  == 3 then
		(
			sel = selection as array
		)
		else()
		
		-- collecte des materiaux à partir de la selection d'objet
		matArToDisp = collectSetMat sel
		
		-- ignore id 0
		if ignoreIDO.checked then matArToDisp = for mat in matArToDisp where mat.effect_id != 0 collect mat
		
		sortMatAr()
		refreshUIList()
		refreshUI1()
	)

	-- Actions
	on matIdExplorerRLT open do
	(
		loadRolloutParams matIdExplorerRLT params
		try(matIdExplorerRF.pos =  RFPos)catch()
		try(matIdExplorerRF.size =  RFSIze)catch()
		
		init()
		
		callbacks.addScript #nodeHide "matIdExplorerRLT.init()" id: #printSelVisTest
		callbacks.addScript #nodeUnHide "matIdExplorerRLT.init()" id: #printSelVisTest2
		callbacks.addScript #selectionSetChanged "matIdExplorerRLT.init()" id: #printSelTest
		
-- 		init()
	)
	
	on matIdExplorerRLT close do
	(
		RFPos = matIdExplorerRF.pos
		RFSIze = matIdExplorerRF.size
		
		writeRolloutParams matIdExplorerRLT params
		
		callbacks.removeScripts id:#printSelTest
		callbacks.removeScripts id:#printSelVisTest
		callbacks.removeScripts id:#printSelVisTest2
	)
	
	on cleanIdMatBT pressed do
	(
		cleaneffectsChannel()
		cleanVrayEffectsChannel()
		init()
	)
	
	on typeSelBT changed state do init()
	
	on sortSelBT changed val do
	(
-- 		init()
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
		
		-- suppression de la passe material id
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt VRayObjectSelect then rem.RemoveRenderElement elt
		)
		
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
	
	on multiElt2BT pressed do
	(
		rem =MaxOps.GetCurRenderElementMgr ()
		
		-- suppression des passes multimat
		eltsNum = rem.NumRenderElements()
		for i = (eltsNum - 1) to 0 by -1 do
		(
			elt = rem.GetRenderElement i
			if iskindof elt multimatteElement then rem.RemoveRenderElement elt
		)

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
)
-- createdialog matIdExplorerRLT

addrollout  matIdExplorerRLT matIdExplorerRF

