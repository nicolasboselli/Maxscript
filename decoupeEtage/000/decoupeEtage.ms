/*
memo:
	-- placer le plan de decoupe au dessus de l'etage, r0_bat au dessus du rdc
	-- penser à mettre les repères des coupe dans l'ordre croisant

maj:
	-- determiner automatiquement sur quel calque il faut ajouter les objets qui ne se découpe pas
	-- copier en instance les modifiers de l'objes d'origine
		-- lorsqu'il y a un modifier edit poly dans la pile, collapser tout ce qui est en dessous 
	-- collapser les slice en option
*/

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
fn sliceObject b rep =
(
	for i = 1 to ( rep.count  )do
	(
		-- creation de la copie
		local modCount
		local b2 = copy b
		
		-- reset x form au dessus du baseobject
		resetxform b2

		modCount = b2.modifiers.count
		xformMod = b2.modifiers[1]
		addmodifier b2 xformMod before: modCount
		deleteModifier b2 1
		maxOps.CollapseNodeTo b2 modCount true

		
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
		
		if b2.numfaces == 0 then 
		(
			format "delete: %\n" b2.name
			delete b2
		)
	)
	b.boxmode = true
	b.showFrozenInGray = true
	b.isfrozen = true
	b.wirecolor = (color 125 125 125)

	
)
-- rep


try(destroydialog decoupEtageRLT)catch()
rollout decoupEtageRLT "découpe etage"
(
	global rep -- = #()
	
	local validRep = undefined
	group "plans de découpe:"
	(
		multilistbox CutPlaneMLB "liste de plans:"  tooltip: "Les plans de découpe les plus hauts dans la scene sont les plus bas dans la liste.\n\nUn plan de découpe doit toujours être au dessus de l'étage découpé."
		edittext planeNameET "name:" readonly: true
		button addBT "add" across: 2
		button clearBT "clear"
		button upBT "^" across: 2 
		button dwBT "v"
		button sortBT "sort"
		button showHideBT "show/hide"
	)
	
	group "decoupe"
	(
		checkbox collapseCB "collapse slice" enabled: false
		button decoupeBT "decoupe"
	)
	
	group "layer"
	(
		button autoAddBT "auto add to layer" enbled: false
		button addToLayBT "add to layer"
	)
	
	
	fn refreshUI =
	(
		CutPlaneMLB.items = for c in rep collect c.name
			
		if isvalidnode validRep then
		(
			planeNameET.text = validRep.name 
			planeNameET.readonly = false
		)
		else 
		(
			planeNameET.text = "NONE"
			planeNameET.readonly = true
		)
	)
	
	on decoupEtageRLT open do
	(
		if rep == undefined then rep = #()
		refreshUI ()
	)
	
	on CutPlaneMLB selectionend do
	(
		selAr = CutPlaneMLB.selection as array
-- 		format "selId: %\n"  selId
		if selAr.count == 1  then
		(
			validRep = rep[selAr[1]]
		)
		else
		(
			validRep = undefined
		)
		refreshUI ()
		
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
	
	on showHideBT pressed do
	(
		local selAr = CutPlaneMLB.selection as array
-- 		format "selAr: %\n" selAr
		for i in selAr do
		(
			format "layer: %\n"  rep[i].name
			l = layermanager.getLayerFromName  rep[i].name
			if l != undefined then
			(
				l.ishidden = not l.ishidden
			)
-- 			if l == undefined then l = layermanager.newLayerFromName  rep[selAr[1]].name
		)
	)
	
	on decoupeBT pressed do
	(
		local sel = selection as array
		if rep.count > 0 then 
		(
			for s in sel do sliceObject s rep
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
	
)
createdialog decoupEtageRLT

