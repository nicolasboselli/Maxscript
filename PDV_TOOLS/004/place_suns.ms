/*
maj:
faire fonctionner le place sun même quand la target n'est pas à zero

*/


try(destroydialog placeSun2RLT)catch()
rollout placeSun2RLT "place sun 2"
(
	local cam 
	local sun 
	local sunAr = #()
	
	local x1
	local y1
		
	group "sun"
	(
		edittext sunNameET readonly: true 
		
-- 		button placeSunBT "place sun"
		slider sunSL "sun orientation" range: [-180,180,0] ticks: 4
		button transposeBT "transpose sun"
		button copySunBT "copy sun"
-- 		button testBT "test sun"
		button autoSunsBT "AUto Suns"
	)
	
	fn initSunNCam =
	(
		-- init cam
		if isValidNode (getActiveCamera()) then cam = getActiveCamera()
		

-- 		if isvalidnode (getNodeByName "vraysun001") then sun = getNodeByName "vraysun001"
		if not isvalidnode cam then return format "no cam"
		
		if isvalidnode (getNodeByName ( "VraySun_" + cam.name) ) then sun = getNodeByName ( "VraySun_" + cam.name)
		else if isvalidnode (getNodeByName "vraysun001") then sun = getNodeByName "vraysun001"
-- 		else sun = undefined
		else
		(
			dummy_target = Targetobject wirecolor: yellow name:"VRaySun001.target"
			sun = VRaySun name:"VRaySun001" pos:(point3 2000 2000 2000) isSelected:on size_multiplier: 1 enabled:on turbidity: 2.5 ozone: 0.35 sky_model: 4 target: dummy_target
			format "sun created\n"
		)
		
		-- init sun
		sunAr = for l in lights where iskindof l vraySun collect l
		
		-- extinction des suns
		for s in sunAr do s.enabled = false
		-- allumage du bon sun
		
		if isvalidnode sun then 
		(
			sunNameET.text = sun.name
			sun.enabled = true
		)
		else sunNameET.text = "NONE"
	)
	
	-- functions ui dependents
	fn placeSun =
	(
		initSunNCam()
				
		SunVc = sun.transform.row3
		
		-- calcul de l'angle de la camera
		CamVc = cam.transform.row3
		CamVc.z = 0
		
		-- placement du target sun dans l'angle de la camera
		viewTM = inverse(getViewTM())

		sceenPos = mapScreenToView (getViewSize()*[0.85,0.15]) (-1000)
		newTm = matrix3 1
		newTm.pos = sceenPos
			
		sun.target.pos =  (newTm*viewTM).pos
		
		-- 				
		multi = 50
		sun.pos.x =  CamVc.x*multi + sun.target.pos.x
		sun.pos.y =  CamVc.y*multi + sun.target.pos.y
		sun.pos.z = multi + sun.target.pos.z
	)
	
	fn transposeSun =
	(
		sunVc = sun.pos - sun.target.pos
		sunVc = normalize sunVc
		sun.target.pos = [0,0,0]
		
		multi = 5000
		sun.pos.x =  sunVc.x*multi + sun.target.pos.x
		sun.pos.y =  sunVc.y*multi + sun.target.pos.y
		sun.pos.z = sunVc.z*multi + sun.target.pos.z
	)
	
	-- action
	on sunSL buttondown do
	(
		placeSun()
		
		x1 = sun.pos.x - sun.target.pos.x
		y1 = sun.pos.y - sun.target.pos.y
	)	
	
	on sunSL changed val do
	(	
-- 		x1 = sun.pos.x - sun.target.pos.x
-- 		y1 = sun.pos.y - sun.target.pos.y
		initSunNCam()
		
		sun.pos.x = x1*(cos val) - y1*(sin val) + sun.target.pos.x
		sun.pos.y = x1*(sin val)+ y1*(cos val) + sun.target.pos.y
	)
	
	on sunSL buttonup do
	(
		sunSL.value = 0
		transposeSun()
	)	
	
	on copySunBT pressed do
	(
		initSunNCam()
		
		if not isvalidnode (getNodeByName ( "VraySun_" + cam.name) ) then 
		(
			maxOps.cloneNodes #(sun) cloneType: #copy newNodes:&copySun
			for s in copysun where not iskindof s Targetobject do s.name = ( "VraySun_" + cam.name)
		)
		else
		(
			format "% exists. No copy\n" sun.name
		)
		
		initSunNCam()
	)
	
/* 	on testBT pressed do
	(
		initSunNCam()
	) */
	on autoSunsBT pressed do
	(
		camsAr = for c in cameras where isKindOf c VRayPhysicalCamera collect c
			
		for c in camsAr do
		(
			
-- 			placeSun()
			
			initSunNCam()
			
			format "c:% sun: %\n" c.name sun.name
			
			if isvalidnode (getNodeByName ( "VraySun_" + c.name) ) then sun = getNodeByName ( "VraySun_" + c.name)
			else if isvalidnode (getNodeByName "vraysun001") then sun = getNodeByName "vraysun001"
			else sun = undefined
			
			format "c:% sun: %\n" c.name sun.name
			
			x1 = sun.pos.x - sun.target.pos.x
			y1 = sun.pos.y - sun.target.pos.y
			
			sun.pos.x = x1*(cos 30) - y1*(sin 30) + sun.target.pos.x
			sun.pos.y = x1*(sin 30) + y1*(cos 30) + sun.target.pos.y
			
			transposeSun()
			
			if not isvalidnode (getNodeByName ( "VraySun_" + c.name) ) then 
			(
				maxOps.cloneNodes #(sun) cloneType: #copy newNodes:&copySun
				for s in copysun where not iskindof s Targetobject do s.name = ( "VraySun_" + c.name)
			)
			else
			(
				format "% exists. No copy\n" sun.name
			)
			
		)			
		
	)
	
)
createdialog placeSun2RLT


-- substituteString "toto.tata" "toto.tata" ("toto.tata" + "_" + "youpi")


-- cam = getActiveCamera()
-- camTM = cam.transform

-- bb = box transform: (newTm*camTM)

-- getViewSize()*[0.8,0.2]

-- viewTM = inverse(getViewTM())

-- sceenPos= [200,100,-500]

-- sceenPos = mapScreenToView (getViewSize()*[0.85,0.15]) (-1000)
-- newTm = matrix3 1
-- newTm.pos = sceenPos
	
-- sun.target.pos =  (newTm*viewTM).pos

-- bb.transform = (newTm*viewTM)
	
-- select bb
-- cam = $PhysCamera001
-- sun = $VRaySun001

-- calcul de l'angle
-- SunVc = sun.pos - sun.target.pos
-- CamVc = cam.pos - cam.target.pos
-- SunVc.z = 0
-- CamVc.z = 0
-- SunVc = normalize SunVc
-- CamVc = normalize CamVc
-- shift = acos (dot SunVc CamVc)

-- placement du sun
-- sun.target.pos =  (newTm*viewTM).pos

-- position de reference
-- x1 = sun.pos.x - sun.target.pos.x
-- y1 = sun.pos.y - sun.target.pos.y

-- position de reference

-- rotation
-- sun.pos.x = x1*(cos shift) - y1*(sin shift) + sun.target.pos.x
-- sun.pos.y = x1*(sin shift) + y1*(cos shift) + sun.target.pos.y

-- multi = 50
-- sun.pos.x =  CamVc.x*multi + sun.target.pos.x
-- sun.pos.y =  CamVc.y*multi + sun.target.pos.y
-- sun.pos.z = multi + sun.target.pos.z




/*

bb.transform = camTM
bb.transform = (newTm*camTM)
	
inverse(getViewTM())
viewport.getFov()
viewport.zoom 0.5

getViewSize()

viewport.GetScreenScaleFactor 

getScreenScaleFactor [0,0,-100]
in coordsys local bb.pos = [109.9,-15.0753,300]
*/