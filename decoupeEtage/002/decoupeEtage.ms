/*
memo:
	-- placer le plan de decoupe au dessus de l'etage, r0_bat au dessus du rdc
	-- penser à mettre les repères des coupe dans l'ordre croisant
	-- mettre le dernier repere au dessus du batiment
	
debug:
	-- de instancier

maj:
	Autoload 
		/- collecter les set de grilles automatiquement à partir du layer rep
			-- tagger les grilles pour les collecter automatiquement
			-- donner des noms string au set de selection(nom des batiments)
	
	cell
		-- générer toute l'aboresence des cell (placer dans un calque call batiment et dans le calque cell)
		
	plans
		x- tagguer les grille avec les noms des plans plutot que les plans avec les noms des grilles
		?- associer les plans avec les grilles à partir d'une selection
	
	Display:
		- decacher les calque parent général du batiment ou des cellules
		- incrementer l'apparition des plans et des cellules
		x- toggle sur le display des batiments
		x- associer des calques de cellules avec chaque reperes (à afficher et à activer)
		- centrer la vue sur la totalité des objets visibles ou memoriser le viewport ou resizer la grille par rapport à la selection en cours
		x- afficher les etages en dessous de le l'étage selectionné
			x-- mettre le plan en option
			x-- mettre les cellules en options
		x-- taguer les plans avec plusieurs nom de grilles
		x-- refresh de la partie wall assistant au changement de set
	
	
	decoupe
		-- conserver les objets decoupés sur un calque "sliced"
		
		1 -  de objets avec modifier edit_poly
			x-  collapser tout ce qui est en dessous et conserver les modifiers au dessus 
		
		2-  des spline avec modifier (sweep, shell, extrude)
			x- converttopoly  et decouper
			ou
			- decouper des splines en conservant les modificateurs dessus
			
		3-  les groupe
			x- ignorer les groupe
			x- ignorer les objets d'un groupe
			
			-- dupliquer les groupe et les slicer
			ou
			-- duppliquer le groupe fusionner tous les objets et slicer

		4 --  des raiclone
			x-- converttopoly et decoupe
			ou
			-- decouper la spline et dupliquer le railclone
	
		5 - modifier clone
			x-- converttopoly et decoupe
	
	auto add to layer
		4 -- raiclone 
			/- deplacer les spline des railclone dans le même calque que les railclone à l'autoadd to layer
			
	-- collapser les splines(?)

	
	-- determinier automatiquement s il faut faire une decoupe ou un auto load
		-- tester si un objet intersecte avec une grille
*/

-- classof $

fn sortbyname v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then
		d=-1
	else
		d=1
	
--compare les numeros entre eux et les classe	
	if (d < 0.) then -1
	else if (d > 0.) then 1
	else 0
)

fn moveItem oneAr idAr jump: 1 =
(
	sort idAr
	for i = idAr.count to 1 by -1 do
	(
		downed = oneAr[idAr[i] + jump]
		deleteitem oneAr (idAr[i]+ jump)
		insertitem downed oneAr idAr[i]
	)
)

fn sliceObject b rep collapseSlice: false addEditPoly: false collapseRC: true =
(
	local tmpEP = EditPolyMod ()
		
	for i = 1 to ( rep.count  )do
	(
			
		-- creation de la copie
		local modCount
		local b2 = copy b
				
		-- suppression des modifiers
		modCount = b2.modifiers.count
		for i = 1 to modCount do deletemodifier b2 1
		
		-- reset x form au dessus du baseobject
		resetxform b2
		maxOps.CollapseNodeTo b2 1 true
		
		modCount = b2.modifiers.count
		
		if i <= rep.count and i > 1 then
		(
			format "etage: % traitement 1\n" rep[i].name
			b2.name = b.name +"_r" +  ((i - 1) as string)
			
			sl = SliceModifier name: "delete_down" Slice_Type:3
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_down"].slice_plane.position.z = in coordsys b2 rep[i - 1].position.z
			
			sl = SliceModifier name: "delete_up" Slice_Type:2
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_up"].slice_plane.position.z = in coordsys b2 rep[i].position.z
			
			l = layermanager.getLayerFromName  rep[i].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b2
		)
		else if i == 1 then
		(
			format "etage: % traitement 2\n" rep[i].name
			b2.name = b.name +"_r" +  ((i - 1) as string)
			
			sl = SliceModifier name: "delete_up" Slice_Type:2
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_up"].slice_plane.position.z = in coordsys b2 rep[i].position.z

			l = layermanager.getLayerFromName  rep[i].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b2
		)
		else if i == (rep.count + 1) then
		(
			format "etage: % traitement 3\n" rep[i].name
			b2.name = b.name +"_r" +  (i as string)
			
			sl = SliceModifier name: "delete_down" Slice_Type:3
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_down"].slice_plane.position.z = in coordsys b2 rep[i - 1].position.z
				
			l = layermanager.getLayerFromName  rep[i - 1].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b2
		)
		
		-- collapse du slice
		if collapseSlice then maxOps.CollapseNodeTo b2 1 true
		
		-- add edit_poly
		if addEditPoly then addmodifier b2 tmpEP
		
		-- suppression des objets sans faces
		if b2.numfaces == 0 then 
		(
			format "delete: %\n" b2.name
			delete b2
		)
		
		-- ajout des instances de modifiers
		-- copie des modifiers 
		if isvalidnode b2 then for i = 1 to b.modifiers.count do 
		(
			if i == 1 then addmodifier b2 b.modifiers[i] -- before: 1
			else addmodifier b2 b.modifiers[i] before: 1
		)
	)
)

fn sortbySize v1 v2 =
(
	-- qsort <array> sortbyname
-- 	vars
	local d
	
	if ( ( v1.zSize) < ( v2.zSize)) then 	d=-1
	else 	d=1
	
--compare les numeros entre eux et les classe	
	if (d < 0.) then -1
	else if (d > 0.) then 1
	else 0
)

fn autoAddObjToLayer rep sel =
(
	struct repST (obj, zSize)
	struct objST (obj, zSize)
-- 	sel = selection as array

	local repStAr = for r in rep collect  repST obj: r zSize: r.center.z
	local objSTAr =  for s in sel collect  objST obj: s zSize: s.center.z
		
	local allAr = repStAr + objSTAr
	local layerToAddOn

	qsort allAr sortbySize

	for i = allAr.count to 1 by - 1 do 
	(
		
		local a = allAr[i]
		
		if (iskindof a repST) then 
		(
			layerToAddOn = layermanager.getLayerFromName  a.obj.name
			if layerToAddOn == undefined then layerToAddOn = layermanager.newLayerFromName a.obj.name
		)
		else if (iskindof a objST) and layerToAddOn != undefined then
		(
			layerToAddOn.addnode a.obj
		)
		else()
	)
)

/*
fn checkPlan refName =
(
	local planesAr = #()
	for s in $plane_* do
	(
		local repName = getuserprop s "rep" 
		
		if repName != undefined then
		(
			-- tester si le nom est un array
-- 			format "repName: %\n" (execute repName)
			local testArray = execute repName
			-- si le nom est un nom seul le conditionner en array
			if  testArray == undefined and repName == refName then testArray = #(repName)
			
			-- traiter l'array
			if iskindof testArray array then
			(
-- 				format "testArray: % \n" testArray
				for o in testArray where o == refname do append planesAr s
			)
			else()
		)
	)
-- 	format "planesAr: %\n" planesAr 
	planesAr
)

fn tagPlan p newName =
(
	format "newName:%\n" newName
	local repName = getuserprop p "rep" 
-- 	format "repName:%\n" repName
	
	if repName == undefined or (execute repName) == undefined then
	(
-- 		print "check 1"
		-- initialiser l'array
		setuserprop p "rep" #(newName)
	)
	else
	(
		-- tester si on a un nom seul ou un array
		local testArray = execute repName
		
		-- si le nom est un nom seul le conditionner en array
-- 		if  testArray == undefined and repName == undefined then testArray = #(repName)
		
		-- ajouter un nom à l'array
		if iskindof testArray array then
		(
			testArray = makeuniquearray testArray
			appendifunique testArray newName
		)
			
		-- ecrire l'array
		setuserprop p "rep" testArray			
	)
	
	format "wrote: %\n" (getuserprop p "rep")
)

fn cleanTagPlan p =
(
	local repName = getuserprop p "rep" 
	if repName != undefined then
	(
		setuserprop p "rep" #()
	)
	else()
)

*/

-- getuserprop $ "planesAr "
fn checkTagGrid g =
(
	local plansAr = #()
	local userProp  = getuserprop g "planesAr"
	
	format "userProp: %\n"  userProp
	if userProp == undefined then()
	else
	(
		-- tester si le nom est un array
-- 			format "repName: %\n" (execute repName)
		local testArray = execute userProp
		-- traiter l'array
-- 		format "testArray: %\n"  testArray
		
		if iskindof testArray array then 
		(
			for t in testArray do
			(				
				local oneplan = getnodebyname t
				if isvalidnode oneplan do append plansAr oneplan
			)
		)
		else #()
	)
	plansAr
)
-- checkTagGrid $

fn tagGrid g planeName =
(
	local planesAr = getuserprop g "planesAr" 
	if planesAr == undefined or (execute planesAr) == undefined then
	(
		setuserprop g "planesAr" #(planeName)
	)
	else
	(
		local testArray = execute planesAr
		
		-- ajouter un nom à l'array
		if iskindof testArray array then
		(
			testArray = makeuniquearray testArray
			appendifunique testArray planeName
		)
			
		-- ecrire l'array
		setuserprop g "planesAr" testArray			
	)
	
	format "wrote: %\n" (getuserprop g "planesAr")
)

fn cleanTagGrid g =
(
	local repName = getuserprop g "planesAr" 
	if repName != undefined then
	(
		setuserprop g "planesAr" #()
	)
	else()
)


fn unHideLayerHierarchy oneLayer =
(
	local lar = #(oneLayer)

	for l in lar do
	(
		dad = l.getparent()
		if iskindof dad MixinInterface then append lar dad
	)

	for l in lar do l.on = true
)

global newCellCreatorRLT
global newWallCreatorRLT

rollout renameSetRLT "new Set Name"
(
	global newSetName
	edittext newSetET "set name:"
	button okBT "ok"
	
	on newSetET entered oneString do
	(		
		newSetName = oneString 
	)
	
	on okBT pressed do
	(
		destroydialog renameSetRLT
	)
)

try(closeRolloutFloater  sliceFloater)catch()
sliceFloater = newRolloutFloater "decoupe de batiments" 350 650 80 200

-- try(destroydialog decoupEtageRLT)catch()
rollout decoupEtageRLT "découpe etage"
(
	local RFPos = [0,0]
	local RFSIze = [350,800]
	
	local params = #("RFPos","RFSIze", "pos", "autoSelLayCB", "autoSelREpCB", "collapseCB", "addPolyModCB", "freezeOldCB", "boxOldCB", \
		"autoLayerCB","displayPlanCB","displayCellsCB","displayGridCB","alignGridCB","keepSelCB","incrementCB")

	global repAr
	global rep -- = #()
	
	global validRep = undefined
	
-- 	local oneStage
	local planesAr
	local onePlane
	local oneLayer
		
-- 	local oneGrid
	local newCell
	local cellLayer
	
	group "slice grids:"
	(
-- 		dropdownlist  setRepDL "sets:"
		listbox  setRepDL "sets:" height: 5
		
		button autoLoadBT "autoLoad" across: 4
		button newSetBT "new" -- across: 3
		button loadSetBT "load" -- across: 2
		button delSetBT "del"
		
		multilistbox CutPlaneMLB "grilles:"  tooltip: "Les plans de découpe les plus hauts dans la scene sont les plus bas dans la liste.\n\nUn plan de découpe doit toujours être au dessus de l'étage découpé."
		edittext planeNameET "name:" readonly: true
		button addBT "add" across: 7
		button clearBT "clear"
		button newGridBT "new"
		button oneMoreBT "+"
		button upBT "^" -- across: 2
		button dwBT "v"
		button sortBT "sort"
	)
	
	group "display settings:"
	(
		checkbox autoSelLayCB  "autoSel Layer" across: 3
		checkbox autoSelREpCB  "autoSel Grid"
		checkbox autoLayerCB  "auto active layer" checked: true -- enabled: false 
-- 		button showHideBT "show/hide selected"
		checkbox displayPlanCB "show plan" across: 2 checked: true --enabled: false
		checkbox displayCellsCB "show cell" checked: true --enabled: false
		checkbox displayGridCB "show grid"  across: 2  checked: true --enabled: false
		checkbox displayBatCB "show bat" checked: true --enabled: false
		
		checkbox alignGridCB "align view on grid"  across: 3 checked: true -- enabled: false
		checkbox keepSelCB "keep selection" checked: false --enabled: false
		checkbox incrementCB "incremental" checked: false --enabled: false

		button displayBT "display selected"
	)
	
	group "slice:"
	(
		checkbox freezeOldCB "freeze old" across: 4
		checkbox boxOldCB "box old"
		checkbox collapseCB "collapse slice" -- enabled: false
		checkbox addPolyModCB "add edit poly" -- enabled: false
		button autoAddBT "auto add to layer" across:3 --enabled: false 
		button addToLayBT "add to layer"
		button decoupeBT "slice" 
	)
	
	group "grid infos:"
	(
-- 		button checkBT "check" enabled: false
		edittext gridET "grille:" 
		edittext layerET "layer:"
	)
	
	group "plans assistant:"
	(
		edittext planeET "planes list:" --across: 2
-- 		edittext gridTagET "grid tags:" --across: 2
		button tagBT "add tag" across: 2
		button clearTagBT "clear tag"
	)
	
	group "cells assitant:"
	(
		button createCellLayerBT "create all cells layer"
		edittext cellET "cells layer:" 
-- 		radiobuttons layerRB "active layer:" labels:#("murs", "cellules")
	)
		
	fn check =
	(
		if isvalidnode validRep then 
		(
			-- trouver les plans correpondants
			-- par le nom du repère
			onePlane = getnodebyname ("plane_" + validRep.name)
			-- par les tags
-- 			planesAr = checkPlan validRep.name
			planesAr = checkTagGrid validRep
			--par tags des grilles
			
			-- ajout du premier plan si valide
			if isvalidnode onePlane then appendifunique planesAr onePlane
			
-- 			format "planesAr: %\n" planesAr
			
			-- trouver le calque correspondant à la grille selectionnée
			oneLayer = LayerManager.getLayerFromName validRep.name
			
			-- trouver le calque de cell correspondant à la grille selectionnée
			cellLayer =  LayerManager.getLayerFromName ("cell_"+ validRep.name)
		)		
		else
		(
			onePlane = undefined
			oneLayer = undefined 
		)
	)
	
	fn refreshUI =
	(
		setRepDL.items = for i = 1 to repAr.count collect (i as string)

		rep = for r in rep where isvalidnode r collect r
		CutPlaneMLB.items = for c in rep collect c.name
		
		
		if isvalidnode validRep then
		(
			planeNameET.text = validRep.name 
			planeNameET.readonly = false
			gridET.text = validRep.name 
			gridET.readonly = false
		)
		else 
		(
			planeNameET.text = "NONE"
			planeNameET.readonly = true
			gridET.text =  "NONE"
			gridET.readonly = false
		)
		
		
		if planesAr.count > 0 then
		(
			local str = stringstream ""
			format "%" planesAr to: str
-- 			print str
-- 			layerET.text = oneLayer.name
			planeET.text = (str as string)
			
-- 			planeET.text = onePlane.name
		)
		else
		(
			planeET.text = "NONE"
		)
		
		if oneLayer != undefined then
		(
			layerET.text = oneLayer.name
		)
		else
		(
			layerET.text = "NONE"
		)
		
		if cellLayer != undefined then
		(
			cellET.text = cellLayer.name
		)
		else
		(
			cellET.text = "NONE"
		)
		
		
	)
	
	on decoupEtageRLT open do
	(
		loadRolloutParams decoupEtageRLT params
		try(sliceFloater.pos =  RFPos)catch()
		try(sliceFloater.size =  RFSIze)catch()
		
		
		if planesAr == undefined then planesAr = #()
		if repAr == undefined then repAr = #()
		if rep == undefined then rep = #()
		refreshUI ()
	)
	
	on decoupEtageRLT close do
	(
		RFPos = sliceFloater.pos
		RFSIze = sliceFloater.size
		
		writeRolloutParams decoupEtageRLT params
	)
	
-- 	layermanager.current.name
	on autoLoadBT pressed do
	(
		repAr = #()
-- 		LayerManager.count
		repLayer = LayerManager.getLayerFromName "rep"
		childNum = repLayer.getNumChildren()
		for i = 1 to childNum do
		(
		-- 	format "%\n" (repLayer.getChild i).name
			Ltmp = repLayer.getChild i
			Ltmp.nodes &repsTmp
			format "%\n" repsTmp
			append repAr repsTmp
		)
		refreshUI()
	)
	
	on newSetBT pressed do
	(
		append repAr rep
		refreshUI ()
	)
	
	on loadSetBT pressed do
	(
		format "set: %\n" (setRepDL.selection as integer)
		rep = repAr[setRepDL.selection as integer]
		refreshUI()
		CutPlaneMLB.selectionend()
	)
	
	on delSetBT pressed do
	(
		deleteitem repAr (setRepDL.selection as integer)
		refreshUI()
	)
	
	on setRepDL doubleClicked  id do
	(
		loadSetBT.pressed()
	)
	
	
	on CutPlaneMLB selectionend do
	(
		local l
		
		-- retoune le repere selectionne et le calque de travail
		local selAr = CutPlaneMLB.selection as array
		
		if selAr.count == 1  then
		(
			validRep = rep[selAr[1]]
			if isvalidnode validRep then l = layermanager.getLayerFromName validRep.name
-- 			if l != undefined then l.current = true
		)
		else
		(
			validRep = undefined
		)

		-- auto selection des objets d'un layer
		if autoSelLayCB.state or  autoSelRepCB.state then clearselection()
		
		if autoSelLayCB.state then
		(
			for i in selAr do 
			(
				local l = layermanager.getLayerFromName rep[i].name
				if l == undefined then ()
				else
				(
					l.nodes &tmpSel
					selectmore tmpSel
				)
			)
		)
		
		-- auto selection de repère
		if autoSelRepCB.state then
		(
			for i in selAr do selectmore rep[i]
		)
		
		check()
		refreshUI ()
	)
	
	on CutPlaneMLB doubleClicked arg do
	(
-- 		local l = layermanager.getLayerFromName rep[arg].name
-- 		if l != undefined then l.on = not l.on
		displayBT.pressed()
	)
	
	on planeNameET entered val do
	(
		format "val: %\n" val
		if isvalidnode validRep then validRep.name = val
		refreshUI ()
	)
	
	on upBT pressed do
	(
		local jump = -1
		local curArray = CutPlaneMLB.selection as array
		local newSel = for i in curArray collect i + jump
		
		format "newsel: %\n" newsel
		
		if (amin newSel) >= 1 then
		(
			moveItem rep curArray jump: jump
			CutPlaneMLB.selection = newSel as bitarray
		)
		refreshUI()
	)
	
	on dwBT pressed do
	(		
		local jump = 1
		local curArray = CutPlaneMLB.selection as array
		local newSel = for i in curArray collect i + jump
			
		if (amax newSel) <= rep.count then
		(
			moveItem rep curArray jump: jump
			CutPlaneMLB.selection = newSel as bitarray
		)
		refreshUI()
	)
	
	on sortBT pressed do
	(
		qsort rep sortbyname
		refreshUI ()
	)
	
	on addBT pressed do 
	(
		for s in selection do appendifunique rep s
-- 		qsort rep sortbyname
		refreshUI ()
	)
	
	on newGridBT pressed do
	(
		sel = selection as array
		createdialog renameSetRLT modal: true
-- 		basename = "batD"
		newGrid = grid name: (newSetName + "_r00") rotation: sel[1].rotation position: sel[1].position length: 500 width: 500

		repBasename = "rep"

		repLayer = layermanager.getLayerFromName repBasename
		if repLayer == undefined then repLayer = layermanager.newLayerFromName  repBasename
			
		oneRepLayer = layermanager.getLayerFromName  (repBasename+ "_" +newSetName)
		if oneRepLayer == undefined then oneRepLayer = layermanager.newLayerFromName (repBasename+ "_" +newSetName)

		oneRepLayer.setParent repLayer

		oneRepLayer.addnode newGrid
	)
	
	on oneMoreBT pressed do
	(
		local curArray = CutPlaneMLB.selection as array
		local newRep
		for id in curArray do
		(
			format "rep: %\n" rep[id].name
			local l = rep[id].layer
			newRep = copy rep[id]
			l.addnode newRep
			newRep.wirecolor = rep[id].wirecolor
			move newRep [0,0,250]
			append rep newRep
		)
		refreshUI ()
	)
	
	on clearBT pressed do
	(
		rep = #()
		refreshUI ()		
	)
--  refLayer.on = not refLayer.on

	on decoupeBT pressed do
	(
		local sel = selection as array
		if rep.count > 0 then 
		(
			for s in sel do 
			(
				-- ignore group
				if isGroupHead s or isGroupMember s then 
				(
					format "ignore % is group member\n" s.name
					continue
				)
				
				if iskindof s dummy or iskindof s VRayLight or iskindof s grid then continue
					
				-- creation de la copy de securité pour traiter les instances
				local copySel
				maxOps.clonenodes s cloneType: #copy newNodes:&copySel
				local copyS = copySel[1]
			
				-- collapse railclone
				if iskindof copyS.baseobject railclone_pro then converttopoly copyS
							
				-- ecrasement  d'un modifier edit poly, sweep ou clone
				local epId = 0
				local collapseMode = false
				for i = 1 to copyS.modifiers.count do
				(
					-- traitement des edit_poly
					if iskindof copyS.modifiers[i] edit_poly then collapseMode = true
					-- traitement des sweep
					else if iskindof copyS.modifiers[i] sweep then collapseMode = true
					-- traitement des clones
					else if iskindof copyS.modifiers[i] clone then collapseMode = true
					else if iskindof copyS.modifiers[i] extrude then collapseMode = true
					else if iskindof copyS.modifiers[i] poly_select then collapseMode = true
						
					if collapseMode then 
					(
						format "m: %, i: %\n" copyS.modifiers[i] i
						maxOps.CollapseNodeTo copyS i false
						exit
					)
				)
				
				-- 	decoupage
				sliceObject copyS rep collapseSlice: collapseCB.state addEditPoly: addPolyModCB.state
				
				-- suppression de la copy
				delete copyS
				
				-- traitement de la source
				if boxOldCB.state then s.boxmode = true
				
				if freezeOldCB.state then
				(
					s.showFrozenInGray = true
					s.isfrozen = true
					s.wirecolor = (color 125 125 125)
				)
				
				-- backup de la source
				local l = s.layer
				local newLayerName =  l.name + "[sliced]"
				local newL = LayerManager.getLayerFromName newLayerName
				if newL == undefined then 
				(
					newL = LayerManager.newLayerFromName newLayerName
					newL.setparent l
				)
				newL.addnode s
				
				
			)
		)
	)
	
	on autoAddBT pressed do
	(
		local sel = selection as array
		autoAddObjToLayer rep sel
		-- traiter les spline des railclones deplacer
		for s in sel where iskindof s railclone_pro do
		(
			for o in  s.banode do s.layer.addnode o
			-- recuperer la spline
		)
	)

	on addToLayBT pressed do
	(
		local selAr = CutPlaneMLB.selection as array
		if selAr.count == 1 then
		(
			format "layer: %\n"  rep[selAr[1]].name
			l = layermanager.getLayerFromName  rep[selAr[1]].name
			if l == undefined then l = layermanager.newLayerFromName  rep[selAr[1]].name
			for s in selection do 
			(
				format "addnode: % on layer: %\n" s.name l.name
				l.addnode s
			)
		)
	)
	
	on createCellLayerBT pressed do
	(
		for r in rep do 
		(
			local testLayer =  LayerManager.getLayerFromName ("cell_"+ r.name)
			format "r:% testLayer:%\n" r testLayer
			if testLayer == undefined then  layermanager.newLayerFromName ("cell_"+ r.name)
		)
	)
	
	on tagBT pressed do
	(
		local sel = selection as array
		for s in sel do 
		(
-- 			tagPlan s validRep.name
-- 			setuserprop s "rep" validRep.name
			tagGrid validRep s.name
		)
		check()
		refreshUI()
	)
	
	on clearTagBT pressed do
	(
		/*
		local sel = selection as array
		for s in sel do 
		(
			cleantagPlan s
-- 			setuserprop s "rep" validRep.name
		)
		*/
		
		cleanTagGrid validRep
		check()
		refreshUI()
	)
	
	on displayBT pressed do
	(
		local bakSel =selection as array
		-- activer la grille selectionnée se caler dessus
		activeGrid = validRep
		if alignGridCB.checked then
		(
			viewport.setType #view_grid
			viewport.setType #view_iso_user
		)
		
		local idSel =  ((CutPlaneMLB.selection)as array)[1]
-- 		format "CutPlaneMLB.selection: %\n" id

		-- cacher les layers batiments
		for i = 1 to rep.count do
		(
			-- cacher le calque batiments
			local l = layermanager.getLayerFromName rep[i].name
			if l != undefined then l.ishidden = true
		)

		-- decacher les layers batiments si incremental selectionné
		if incrementCB.checked then
		(
			for i = 1 to idSel do
			(
				-- cacher le calque batiments
				local l = layermanager.getLayerFromName rep[i].name
				if l != undefined then l.ishidden = false
			)
		)

		-- decacher le calque etage
		if displayBatCB.checked and oneLayer != undefined then 
		(
			unHideLayerHierarchy oneLayer
			oneLayer.ishidden = false
		)
			
		-- activation du calque de travail du batiment
		if 	autoLayerCB.state and oneLayer != undefined then oneLayer.current = true else()

		-- cacher tous les layers cellules
		for i = 1 to rep.count do
		(
			-- cacher le calque cellules
			local cl = layermanager.getLayerFromName ("cell_" + rep[i].name)
			if cl != undefined then cl.ishidden = true
		)		
		-- décacher les calques cellules correspondants à la grille selectionnée
		if displayCellsCB.checked and cellLayer != undefined then cellLayer.ishidden = false

		-- cacher tous les plans
		for p in $plane_* do p.ishidden = true
		-- décacher les plans selectionnés
		if displayPlanCB.checked then
		(
			-- decacher les plans selectionnés
			for p in planesAr where isvalidnode p do
			(
				-- decache
				p.ishidden = false
				-- move plans
				p.position.z = validRep.position.z - 50
			)
		)
		
		-- cacher les grilles
		local gridLayer = layermanager.getLayerFromName "rep"
		if not gridLayer == undefined then gridlayer.ishidden = not displayGridCB.checked
		
		-- maj du cell creator rollout
		if newCellCreatorRLT == undefined then(/*format "newCellCreatorRLT undefined\n"*/)
		else if newCellCreatorRLT.open then 
		(
			if newCellCreatorRLT.open then newCellCreatorRLT.init()
		)
		
		-- maj du duplicate_floor rollout
		if incNameRLT == undefined then(/*format "incNameRLT undefined\n"*/)
		else if incNameRLT.open then 
		(
			if incNameRLT.open then incNameRLT.init()
			if incNameRLT.open then incNameRLT.refreshUI()
		)
		
		if keepSelCB.checked then select baksel
	)
)
-- createdialog decoupEtageRLT width: 400

rollout sliceToolsRLT "slice tools"
(
	button cellCreatorBT "cell creator" across: 3 --enabled: false 
	button wallCreatorBT "wall creator" --enabled: false
	button duplicateFloorBT "duplicate floor" --enabled: false
	
	on cellCreatorBT pressed do
	(
		filein "newCellCreator.ms"
	)

	on wallCreatorBT pressed do
	(
		filein "wallCreator2.ms"
	)
	
	on duplicateFloorBT pressed do
	(
		filein "duplicate_etage.ms"
	)
)


addRollout sliceToolsRLT sliceFloater --rolledUp:false
addRollout decoupEtageRLT sliceFloater --rolledUp:false

sliceFloater.title =  sliceFloater.title +" v." + ((getScriptVersion (getThisScriptFilename())) as string)