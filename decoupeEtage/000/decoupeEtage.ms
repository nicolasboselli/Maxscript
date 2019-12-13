/*
memo:
	-- placer le plan de decoupe au dessus de l'etage, r0_bat au dessus du rdc
	-- penser à mettre les repères des coupe dans l'ordre croisant
	-- mettre le dernier repere au dessus du batiment
	
debug:
	-- de instancier


maj:
	x- copier en instance les modifiers de l'objes d'origine
		-- lorsqu'il y a un modifier edit poly dans la pile, collapser tout ce qui est en dessous 
	-- decouper des splines en conservant les modificateurs dessus
	-- collapse des sweeps
	/- decouper les groupe
		x- ignorer les groupe
		-- dupliquer les groupe et les slicer
	x-- collapser les railclone
		debug: les railclone se deplace	-- collapser les splines
	
	-- autoload des railclone avec le spline
	
	-- determinier automatiquement s il faut faire une decoupe ou un auto load
	
rebuild
	x- dupliquer l'objet à découper avant de le decouper puis supprimer le treitement
	X- sortir les operation de freeze de la fonction de decoupe
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


-- arrayTest = for i = 1 to 10 collect i
-- arrayTest = arrayTest as bitarray
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
-- upItem arrayTest #(5,4,3,2,1) jump: 1
-- arrayTest

-- $.modifiers.count
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

-- rep
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
-- sel = selection as array
-- autoAddObjToLayer rep sel

try(destroydialog decoupEtageRLT)catch()
rollout decoupEtageRLT "découpe etage"
(
	local params = #("pos", "autoSelLayCB", "autoSelREpCB", "collapseCB", "addPolyModCB", "freezeOldCB", "boxOldCB")
	
	global rep -- = #()
	
	local validRep = undefined
	
-- 	local oneStage
	local onePlane
	local oneLayer
-- 	local oneGrid
	local newCell
	
	group "plans de découpe:"
	(
		multilistbox CutPlaneMLB "liste de plans:"  tooltip: "Les plans de découpe les plus hauts dans la scene sont les plus bas dans la liste.\n\nUn plan de découpe doit toujours être au dessus de l'étage découpé."
		edittext planeNameET "name:" readonly: true
		button addBT "add" across: 2
		button clearBT "clear"
		button upBT "^" across: 2 
		button dwBT "v"
		button sortBT "sort"
	)
	
	group "display"
	(
		checkbox autoSelLayCB  "autoSel Layer"
		checkbox autoSelREpCB  "autoSel Rep"
		button showHideBT "show/hide"
	)
	
	group "decoupe"
	(
		checkbox freezeOldCB "freeze old"
		checkbox boxOldCB "box old"
		checkbox collapseCB "collapse slice" -- enabled: false
		checkbox addPolyModCB "add edit poly" -- enabled: false
		button decoupeBT "decoupe"
	)
	
	group "layer"
	(
		button autoAddBT "auto add to layer" enbled: false
		button addToLayBT "add to layer"
	)
	
	group "wall assitant"
	(
		checkbox wallAssistOnCB "on/off" visible: false
		
		edittext gridET "grille:"
		edittext layerET "calque:"
		edittext planeET "plan:"
		
		button checkBT "check" visible: false
		button displayBT "display"
		
		checkbutton newCellCB "new cell"
	)
	
	
	fn refreshUI =
	(
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
		
		if isvalidnode onePlane then
		(
			planeET.text = onePlane.name
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
	)
	
	on decoupEtageRLT open do
	(
		loadRolloutParams decoupEtageRLT params
		if rep == undefined then rep = #()
		refreshUI ()
	)
	
	on decoupEtageRLT close do
	(
		writeRolloutParams decoupEtageRLT params
	)
	
-- 	layermanager.current.name
	
	on CutPlaneMLB selectionend do
	(
		local l
		
		-- retoune le repere selectionne
		selAr = CutPlaneMLB.selection as array
		if selAr.count == 1  then
		(
			validRep = rep[selAr[1]]
			if isvalidnode validRep then l = layermanager.getLayerFromName validRep.name
			if l != undefined then l.current = true
		)
		else
		(
			validRep = undefined
		)

		-- auto selection des objets d'un layer
		if autoSelLayCB.state then
		(
			if isvalidnode validRep then l = layermanager.getLayerFromName validRep.name
				
			if l != undefined then
			(
				l.nodes &tmpSel
				select tmpSel
			)
			else
			(
				clearselection()
			)
		)
		
		if autoSelRepCB.state and isvalidnode validRep then select validRep
		
		checkBT.pressed()
		
		refreshUI ()
	)
	
	on CutPlaneMLB doubleClicked arg do
	(
		local l = layermanager.getLayerFromName rep[arg].name
		if l != undefined then l.on = not l.on
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
	
	on clearBT pressed do
	(
		rep = #()
		refreshUI ()		
	)
--  refLayer.on = not refLayer.on
	
	on showHideBT pressed do
	(
		local selAr = CutPlaneMLB.selection as array
		format "selAr: %\n" selAr
		local tmpState

		-- toggle
		for i in selAr do
		(
			local l = layermanager.getLayerFromName  rep[i].name
			
			if l == undefined then ()
			else
			(
				if tmpState == undefined then 
				(
					tmpState = l.on
					l.on = not tmpState
				)
				else
				(
					l.on = not tmpState
				)
			)
		)
	)
	
	on decoupeBT pressed do
	(
		local sel = selection as array
		if rep.count > 0 then 
		(
			for s in sel do 
			(
				-- ignore group
				if iskindof s dummy then continue
					
				-- creation de la copy de securité
				local copySel
				maxOps.clonenodes s cloneType: #copy newNodes:&copySel
				local copyS = copySel[1]
			
				-- collapse railclone
				if iskindof copyS.baseobject railclone_pro then converttopoly copyS
							
				-- ecrasement  d'un edit poly
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
			)
		)
	)
	
	on autoAddBT pressed do
	(
		sel = selection as array
		autoAddObjToLayer rep sel
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
	
	on checkBT pressed do
	(
		if isvalidnode validRep then 
		(
			-- trouver le plan correpondant
			onePlane = getnodebyname ("plane_" + validRep.name)
			
			-- trouver le calque correspondant
			oneLayer = LayerManager.getLayerFromName validRep.name
			
-- 			format "onePlane: % oneLayer: %\n" onePlane.name  oneLayer.name
		)		
		else
		(
			onePlane = undefined
			oneLayer = undefined 
		)
		
		refreshUI()
	)
	
	on displayBT pressed do
	(
		-- activer la grille selectionnée se caler dessus
		activeGrid = validRep
		viewport.setType #view_grid
		viewport.setType #view_iso_user
		-- unhider le plan
		if oneLayer != undefined then oneLayer.on = true
		-- unhider l'etage
		if isvalidnode onePlane then onePlane.ishidden = false
	)
	
	on newCellCB changed arg do
	(
		
		if arg then
		(
			max modify mode

			newCell= SplineShape ()
			updateShape newCell
			newCell.vertexTicks = on

			addmodifier newCell (edit_poly ())

			select newCell
			
			modPanel.setCurrentObject newCell.baseobject 
			splineOps.startCreateLine newCell
		)
		else
		(
			showEndResult = true
			newCell.vertexTicks = off
			newCell.pivot = newCell.center
			newCell.xray = on
		)
		
		-- mettre en place un trigger qui reagit au clic droit douris pour comprendre que la creation est terminée
	)
	
	
)
createdialog decoupEtageRLT

