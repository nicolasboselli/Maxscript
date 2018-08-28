-- plan duplicator

-- tool to create plane
-- tool copy material:
	-- transfer material
	-- transfer uv 
	-- transfer name
	-- 
	
fn createPlansLayer =
(
	LM = layermanager
	planLayer
	
	if (LM.getLayerFromName "plans") == undefined then planLayer = LM.newLayerFromName "plans"
	else planLayer = LM.getLayerFromName "plans"

	planLayer
)	

-- $.layer

fn copyPlan sel =
(
	local map1
	local obj1 = sel[1]
	local refLay = obj1.layer
		
	for modif in  obj1.modifiers where classof modif == UVWmap do map1 = modif
		
	format "obj1: %\n" obj1
	format "map1: %\n" map1

	for i = 2 to sel.count do
	(
		obj2 = sel[i]
		format "obj: %\n" obj2
		-- add on plans layer
-- 		lay = createPlansLayer()
-- 		lay.addnode obj2
		
		refLay.addnode obj2
		
		obj2.renderable = off
		obj2.backfacecull = on
		
		obj2.name = uniquename obj1.name
		
		obj2.material = obj1.material
		
		map2 = uvwmap()
		
		
		addmodifier   obj2 map2
		classof obj2 --hack to force stack update
		
		map2.maptype = map1.maptype 
		
		map2.uflip = map1.uflip
		map2.vflip = map1.vflip
		map2.wflip = map1.wflip
		
		map2.width = map1.width 
		map2.length = map1.length
		map2.height = map1.height 
		
		map2.gizmo.transform = (map1.gizmo.transform * obj1.objecttransform) * inverse obj2.objecttransform
	)
)

sel = selection as array
copyPlan sel