-- $.scale
-- placer le plan de decoupe au dessus de l'etage, r0_bat au dessus du rdc




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
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)

-- $.modifiers.count
fn sliceObject b rep =
(
	for i = 1 to ( rep.count  )do
	(
		local modCount
		local b2 = copy b
		format "copy: %\n" b2.name
		resetxform b2
		format "resetxform\n" 
		converttomesh b2
		format "converttomesh\n" 
		update b2
		
		if i <= rep.count and i > 1 then
		(
			format "etage: % traitement 1\n" rep[i].name
-- 			b2 = copy b
			b2.name = b.name +"_r" +  ((i - 1) as string)
	-- 		print "check 1"
			
			sl = SliceModifier name: "delete_down" Slice_Type:3
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_down"].slice_plane.position.z = in coordsys b2 rep[i - 1].position.z
	-- 		print "check 2"
			
			sl = SliceModifier name: "delete_up" Slice_Type:2
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_up"].slice_plane.position.z = in coordsys b2 rep[i].position.z
	-- 		print "check 3"
			
			l = layermanager.getLayerFromName  rep[i].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b2
			
-- 			if b2.numfaces == 0 then delete b2
	-- 		print "check 4"
		)
		else if i == 1 then
		(
			format "etage: % traitement 2\n" rep[i].name
-- 			b1 = copy b
			b2.name = b.name +"_r" +  ((i - 1) as string)
	-- 		print "check1"
			
			sl = SliceModifier name: "delete_up" Slice_Type:2
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_up"].slice_plane.position.z = in coordsys b2 rep[i].position.z
	-- 		print "check2"

			l = layermanager.getLayerFromName  rep[i].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b2
			
-- 			if b2.numfaces == 0 then delete b2
	-- 		print "check3"
		)
		else if i == (rep.count + 1) then
		(
			format "etage: % traitement 3\n" rep[i].name
-- 			b3 = copy b
			b2.name = b.name +"_r" +  (i as string)
			
			sl = SliceModifier name: "delete_down" Slice_Type:3
			modCount = b2.modifiers.count
			addmodifier b2 sl before: modCount
			b2.modifiers["delete_down"].slice_plane.position.z = in coordsys b2 rep[i - 1].position.z
				
			l = layermanager.getLayerFromName  rep[i - 1].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b2
			
-- 			if b2.numfaces == 0 then delete b2
		)
		if b2.numfaces == 0 then 
		(
			format "delete: %\n" b2.name
			delete b2
		)
	)
	b.boxmode = true
	
)
-- rep

try(destroydialog decoupEtageRLT)catch()
rollout decoupEtageRLT "découpe etage"
(
	global rep -- = #()
	group "plans de découpe:"
	(
		multilistbox CutPlaneMLB "liste de plans:"
		button addBT "add" across: 2
		button clearBT "clear"
-- 		button sortBT "sort"
	)
	
	button decoupeBT "decoupe"
	button addToLayBT "add to layer"
	
	fn refreshUI =
	(
		CutPlaneMLB.items = for c in rep collect c.name
	)
	
	on decoupEtageRLT open do
	(
		if rep == undefined then rep = #()
	)
	
	on addBT pressed do 
	(
		for s in selection do appendifunique rep s
		qsort rep sortbyname
		refreshUI ()
	)
	
	on clearBT pressed do
	(
		rep = #()
		refreshUI ()		
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



-- layermanager.newLayerFromName  rep[1].name
-- l = layermanager.getLayerFromName  "r01_bat"
-- l.addnode $

-- $.numfaces

/*
rep = $R*_bat as array
rep.count

-- b = $Box13701

sel = selection as array
for b in sel do
(
-- 	b = $
	firstDone = false
	lastDone = false
	for i = 1 to ( rep.count  )do
	(
		if i <= rep.count and i > 1 then
		(
			format "etage: % traitement 1\n" rep[i].name
			b2 = copy b
			b2.name = b.name +"_r" +  ((i - 1) as string)
	-- 		print "check 1"
			
			sl = SliceModifier name: "delete_down" Slice_Type:3
			addmodifier b2 sl
			b2.modifiers["delete_down"].slice_plane.position.z = in coordsys b rep[i - 1].position.z
	-- 		print "check 2"
			
			sl = SliceModifier name: "delete_up" Slice_Type:2
			addmodifier b2 sl
			b2.modifiers["delete_up"].slice_plane.position.z = in coordsys b rep[i].position.z
	-- 		print "check 3"
			
			l = layermanager.getLayerFromName  rep[i].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b2
			
			if b2.numfaces == 0 then delete b2
	-- 		print "check 4"
		)
		else if i == 1 then
		(
			format "etage: % traitement 2\n" rep[i].name
			b1 = copy b
			b1.name = b.name +"_r" +  ((i - 1) as string)
	-- 		print "check1"
			
			sl = SliceModifier name: "delete_up" Slice_Type:2
			addmodifier b1 sl
			b1.modifiers["delete_up"].slice_plane.position.z = in coordsys b rep[i].position.z
	-- 		print "check2"

			l = layermanager.getLayerFromName  rep[i].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b1
			
			if b1.numfaces == 0 then delete b1
	-- 		print "check3"
		)
		else if i == (rep.count + 1) then
		(
			format "etage: % traitement 3\n" rep[i].name
			b3 = copy b
			b3.name = b.name +"_r" +  (i as string)
			
			sl = SliceModifier name: "delete_down" Slice_Type:3
			addmodifier b3 sl
			b3.modifiers["delete_down"].slice_plane.position.z = in coordsys b rep[i - 1].position.z
				
			l = layermanager.getLayerFromName  rep[i - 1].name
			if l == undefined then l = layermanager.newLayerFromName  rep[i].name
			l.addnode b3
			
			if b3.numfaces == 0 then delete b3

		)
	)
	b.boxmode = true
)
*/


/*4
for i = 1 to rep.count do
(
	raySize
	baseRay = polyop.getSlicePlane b size:&raySize
	baseRay.position.z = rep[i].position.z

-- 	polyop.setSlicePlane b baseRay raySize
	polyop.slice b #all baseRay
)
redrawViews ()
*/