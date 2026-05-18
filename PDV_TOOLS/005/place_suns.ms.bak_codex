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
	local z1
		
	group "sun"
	(
		edittext sunNameET readonly: true 
		
-- 		button placeSunBT "place sun"
		slider sunSL "sun orientation" range: [-180,180,0] ticks: 4
		spinner autoSunOffsetSP "auto sun offset" range: [-180,180,30] type: #float
		button transposeBT "transpose sun"
		button copySunBT "copy sun"
-- 		button testBT "test sun"
		button autoSunsBT "AUto Suns"
	)
	
	fn getSunByCam theCam =
	(
		local camSun = undefined
		if isValidNode theCam do camSun = getNodeByName ("VraySun_" + theCam.name)
		if isValidNode camSun then camSun
		else if isValidNode (getNodeByName "VRaySun001") then getNodeByName "VRaySun001"
		else if isValidNode (getNodeByName "vraysun001") then getNodeByName "vraysun001"
		else undefined
	)
	
	fn createDefaultSun =
	(
		local dummyTarget = Targetobject wirecolor: yellow name:"VRaySun001.target"
		VRaySun name:"VRaySun001" pos:(point3 2000 2000 1000) isSelected:on size_multiplier: 1 enabled:on turbidity: 2.5 ozone: 0.35 sky_model: 4 target: dummyTarget
	)
	
	fn initSunNCam =
	(
		if isValidNode (getActiveCamera()) then cam = getActiveCamera()
		if not isvalidnode cam then return format "no cam"
		
		sun = getSunByCam cam
		if not isValidNode sun do
		(
			sun = createDefaultSun()
			format "sun created\n"
		)
		
		sunAr = for l in lights where iskindof l vraySun collect l
		for s in sunAr do s.enabled = false
		
		if isvalidnode sun then 
		(
			sunNameET.text = sun.name
			sun.enabled = true
		)
		else sunNameET.text = "NONE"
	)
	
	fn rotateSunAroundTarget theSun angle =
	(
		if not isValidNode theSun or not isValidNode theSun.target then return false
		local dx = theSun.pos.x - theSun.target.pos.x
		local dy = theSun.pos.y - theSun.target.pos.y
		theSun.pos.x = dx*(cos angle) - dy*(sin angle) + theSun.target.pos.x
		theSun.pos.y = dx*(sin angle) + dy*(cos angle) + theSun.target.pos.y
		true
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
		if not isValidNode sun or not isValidNode sun.target then return false
		local targetPos = sun.target.pos
		local sunVc = normalize (sun.pos - targetPos)
		local multi = 5000
		sun.pos = targetPos + (sunVc * multi)
		true
	)
	
	-- action
	on sunSL buttondown do
	(
		placeSun()
		
		x1 = sun.pos.x - sun.target.pos.x
		y1 = sun.pos.y - sun.target.pos.y
		z1 = sun.pos.z - sun.target.pos.z
	)	
	
	on sunSL changed val do
	(	
-- 		x1 = sun.pos.x - sun.target.pos.x
-- 		y1 = sun.pos.y - sun.target.pos.y
		if isValidNode sun and isValidNode sun.target then
		(
			sun.pos.x = x1*(cos val) - y1*(sin val) + sun.target.pos.x
			sun.pos.y = x1*(sin val)+ y1*(cos val) + sun.target.pos.y
			sun.pos.z = z1 + sun.target.pos.z
		)
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
		local camsAr = for c in cameras where isKindOf c VRayPhysicalCamera collect c
		local baseSun = getSunByCam cam
		if not isValidNode baseSun do baseSun = getSunByCam (getActiveCamera())
		if not isValidNode baseSun do baseSun = createDefaultSun()
		
		for c in camsAr do
		(
			local camSunName = "VraySun_" + c.name
			local camSun = getNodeByName camSunName
			
			if not isValidNode camSun then
			(
				maxOps.cloneNodes #(baseSun) cloneType: #copy newNodes:&copySun
				for s in copySun where not iskindof s Targetobject do camSun = s
				if isValidNode camSun do camSun.name = camSunName
			)
			
			if isValidNode camSun then
			(
				camSun.enabled = true
				rotateSunAroundTarget camSun autoSunOffsetSP.value
				sun = camSun
				transposeSun()
			)
		)
		
		initSunNCam()
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