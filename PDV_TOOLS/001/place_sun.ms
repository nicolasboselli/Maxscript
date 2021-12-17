/*
maj:
faire fonctionner le place sun même quand la target n'est pas à zero

*/


try(destroydialog placeSun2RLT)catch()
rollout placeSun2RLT "place sun 2"
(
	local cam 
	local sun 
	
	local x1
	local y1
		
	group "sun"
	(
		button placeSunBT "place sun"
		slider sunSL "sun orientation" range: [-90,90,0] ticks: 4
		button transposeBT "transpose sun"
	)
	
	fn initSunNCam =
	(
		if isValidNode (getActiveCamera()) then cam = getActiveCamera()
		for l in lights where iskindof l vraySun do sun = l
	)
	
	on placeSunBT pressed do
	(
		initSunNCam()
		
-- 		SunVc = sun.pos - sun.target.pos
-- 		SunVc = normalize SunVc
		
		SunVc = sun.transform.row3
		
		
		-- calcul de l'angle de la camera
/* 		CamVc = cam.pos - cam.target.pos
		CamVc.z = 0
		CamVc = normalize CamVc */
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
	
	
	on sunSL buttondown do
	(
		placeSunBT.pressed()
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
		transposeBT.pressed()
	)	
	
	on transposeBT pressed do
	(
		sunVc = sun.pos - sun.target.pos
		sunVc = normalize sunVc
		sun.target.pos = [0,0,0]
		
		multi = 5000
		sun.pos.x =  sunVc.x*multi + sun.target.pos.x
		sun.pos.y =  sunVc.y*multi + sun.target.pos.y
		sun.pos.z = sunVc.z*multi + sun.target.pos.z
	)
	
)
createdialog placeSun2RLT


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