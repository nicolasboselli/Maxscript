-- $.scale

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
-- layermanager.newLayerFromName  rep[1].name
-- l = layermanager.getLayerFromName  "r01_bat"
-- l.addnode $

-- $.numfaces



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