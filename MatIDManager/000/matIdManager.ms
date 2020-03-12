/*
 faire travailler au choix sur la scene, les objets visibles ou la selection d'objet ou les multimaterial
 
 travailler avec les vray effect id sur les vray mat (pour le moment, ignorer les material id, les sur materiaux vray ou les mat standard)
 
 une interface pour appliquer des effect id aux materiaux
 
 une interface pour manager les ids(retrouver les objets par ids, publier les materiaux avec le même ids)
 
 un tool pour publier les multi mat
 
 assign id en random sur un set de vray mat en respectant les ids deja affectes
 
 une interface pour parametrer la passe material id et les passes vrayobjectselect et les multimatteelement
 
 trier par ordre alphabetique
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
	for m in matArTmp do
	(
		appendifunique idsAr m.effect_id
	)
	-- travailler sur les materiaux des objets visiblesés
	sort idsAr
	format "idsAr: %\n" idsAr
	idsAr
)



try(destroydialog matIdManagerRLT)catch()
rollout matIdManagerRLT "material ids manager"
(
	local matAr
	local multiMatAr
	local matArToDisp
	local multiMatArToDisp
	local matListSel = #()
	
	radiobuttons typeSelBT "selection: " labels:#("scene", "visible", "selection") default: 2 enabled: false
	button refreshBT "refresh"
	
	listbox multiMatLB "multi material list" height: 15
	button editMultiMatBT "edit multi mat" enabled: false
	button selectMultiMatObjBT "select object" enabled: false
	
	multilistbox materialListMLB "vray material list:" height: 30
	button editMatBT "edit multi mat" enabled: false
	button selectMatObjBT "select object" enabled: false
	
	editText matCountET "material count" readonly: true
	spinner matIdSP "material id" type: #integer
	button randomIdBT "random ids" enabled: false
	
	fn refreshUI =
	(
		-- list de materiaux			
		multiMatArToDisp = multiMatAr
		qsort  multiMatArToDisp sortbyname
		multiMatLB.items = for m in multiMatArToDisp collect m.name
			
		matArToDisp = matAr
		qsort  matAr sortbyname
		materialListMLB.items = for m in matArToDisp collect m.name
		
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

try(destroydialog matIdExplorerRLT)catch()
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
		button editMatBT "edit material" enabled: false
		button selObjBT "select object"  enabled: false
	)
	
	group "render elements:"
	(
		button matIdEltBT "material id element"
		button objSelEltBT "object select element"
		button multiEltBT "multimatte element" enabled: false
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
		try(destroydialog matIdManagerRLT)catch()
		createdialog matIdManagerRLT
	)
	
	on refreshIdsBT pressed do
	(
		idsAr = collectMatIDs()
		refreshUI()
	)
		
	on matIdLB selected val do
	(
-- 		sameIdMatAr = collectMatByIds val
-- 		print "et oui"
		idSel = matIdLB.selected as integer
-- 		format "idSel: %\n" idSel
		sceneMat = getclassinstances vrayMtl target: scenematerials
		sameIdMatAr = for m in sceneMat where m.effect_id == idSel collect m
-- 		format "sameIdMatAr: %\n" sameIdMatAr
		refreshUI()
	)
	
	on matMLB selectionEnd do
	(
		matListSel = for i in matMLB.selection collect sameIdMatAr[i] 
-- 		matIdLB.selected = 0
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
		
		-- selection des nom de materiaux
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
	
)
createdialog matIdExplorerRLT

/*

-- assign de maniere incrementale des id au materiaux en evitant d'appliquer plusieurs fois des id et en evitant de changer les id deja affecter
-- collecter les ids de materiaux deja affecter dans la scene
-- collecter les vray mat de la scenes
sceneMat = getclassinstances vrayMtl target: scenematerials
-- sceneMat.count
usedIds = #()
for m in sceneMat do
(
	format "channel id: % mat name: %\n" m.effect_id m.name
	appendifunique usedIds m.effect_id
)
usedIds

-- appliquer les ids de materiaux en evitant les ids deja attribuées
j = 0
j += 1
jAr = #()
append jAR j
forceID = false
usedids = #(1,2,3,4)
turn = 0

for id in jAr do
(
	turn +=1 
	local res = finditem usedIds id
	format "id: % res:%\n" id res
	
	if res > 0 then 
	(
		j += 1
		append jAR j
	)
	
	if turn > 50 then exit
)


for i = 1 to matAr.count do
(
	-- générer une id
	j =+ 1
		-- si l'idée est déja affecter >> passer
	
	-- récupérer l'id du materiaux testé
	
	-- verifier l'id déja affecté 
	local res = finditem usedIds i
	
	-- si l'id est deja affecter passer
	if res > 0 and not forceID then continue
			
	-- si une id est déja affecter au materiaux
	if matAr[i].effect_id != 0 and not forceID then
	(
			-- eviter de l'affecter ailleurs
			-- 
		format "i: % deja assign: % id: %\n" i matAr[i].name matAr[i].effect_id
	)
	else
	(
		matAr[i].override_effect_id = on
		matAr[i].effect_id = i
		format "id: % assign: %\n" i matAr[i].name
	)
)

-- pour chaque chaque id de materiau créer un couche vray object selected
-- ajouter la couche vrayMtlID
rem =MaxOps.GetCurRenderElementMgr ()
vrMtlID = VRayMtlID filterOn: true output_type: 1
rem.AddRenderElement vrMtlID

-- setter sur filtering et color
rem =MaxOps.GetCurRenderElementMgr ()
sceneMat = getclassinstances vrayMtl target: scenematerials
for m in sceneMat do
(
	if m.effect_id > 0 then
	(
		format "channel id: % mat name: %\n" m.effect_id m.name
		vrObjSelElt = VRayObjectSelect elementName: ("idMat_" + m.name) mode: 1 object_id: m.effect_id  use_material_id: true consider_for_antialiasing: true
		rem.AddRenderElement vrObjSelElt
	)
)

-- retourner les passes VRayObjectSelect du render element pour les supprimer



*/

