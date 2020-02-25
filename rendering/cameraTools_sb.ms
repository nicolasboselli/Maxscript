-- camera_tools
/*
- redresser les verticales
$.auto_vertical_tilt_correction = on
- changer un format 
- placer le soleil à droite ou à gche
	x- effectuer la rotation par rapport à un point dans la scene
	x- partir de la camera comme position 0
	- savoir si l'angle est positf ou negatif
- freezz camera
- faire fonctionner sur vraycam
- faire apparaitre le soleill au premier plan le temps du reglage
*/




try(destroydialog sunOrientRLT)catch()
rollout sunOrientRLT "sun orientation"
(
	local cam = $PhysCamera001
	local sun = $VRaySun001
	
	local x1
	local y1
	
	group "cam"
	(
		button verticalTiltBT "vertical tilt"
		button frameSizeBT "frame size"
		button selectCamTargetBT "select cam target"
		button freezeBT "freeze cam"
	)
	
	group "sun"
	(
		button placeSunBT "place sun"
		slider sunSL "sun orientation" range: [-90,90,0] ticks: 4
	)
	
	on verticalTiltBT pressed do
	(
		-- redresser les verticale de la camera
		cam = getActiveCamera()
		format "cam: %\n" cam.name
		if cam != undefined then
		(
			if classof cam == physical then
			(
				cam.auto_vertical_tilt_correction = on
				cam.auto_vertical_tilt_correction = off
			)
			else()
		)
		else()
	)
	
	on frameSizeBT pressed do
	(
		bakState = renderSceneDialog.isopen()
		if bakState then renderSceneDialog.close()
		renderWidth  = 1500
		renderHeight = 925
		if bakState then renderSceneDialog.open()
	)
	
	on selectCamTargetBT pressed do
	(
		--select cam target
-- 		cam = getActiveCamera()
		select cam.target
	)
		
	on placeSunBT pressed do
	(
		-- prendre en compte la position de la target
		-- trouver la bonne orientation
		
		-- calcul de l'angle
		SunVc = sun.pos - sun.target.pos
		CamVc = cam.pos - cam.target.pos
		SunVc.z = 0
		CamVc.z = 0
		SunVc = normalize SunVc
		CamVc = normalize CamVc
		shift = acos (dot SunVc CamVc)
		
		-- placement du sun
		multi = 5000
		sun.pos.x =  CamVc.x*multi + sun.target.pos.x
		sun.pos.y =  CamVc.y*multi + sun.target.pos.y
		sun.pos.z = multi + sun.target.pos.z
				
		-- placement du sun
-- 		x1 = sun.pos.x - sun.target.pos.x
-- 		y1 = sun.pos.y - sun.target.pos.y
				
-- 		sun.pos.x = x1*(cos shift) - y1*(sin shift) + sun.target.pos.x
-- 		sun.pos.y = x1*(sin shift) + y1*(cos shift) + sun.target.pos.y
		
-- 		sun.pos.x =  CamVc.x*x1 + sun.target.pos.x
-- 		sun.pos.y =  CamVc.y*y1 + sun.target.pos.y
		
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
		
		sun.pos.x = x1*(cos val) - y1*(sin val) + sun.target.pos.x
		sun.pos.y = x1*(sin val)+ y1*(cos val) + sun.target.pos.y
	)
	
	on sunSL buttonup do
	(
		sunSL.value = 0
	)	
	
	on sunSl rightClick do
	(
-- 		sunSL.value = 0
-- 		sun.pos.x = x1
-- 		sun.pos.y = y1
	)	
)
createdialog sunOrientRLT
