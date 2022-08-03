

camsAr = for c in cameras where isKindOf c VRayPhysicalCamera collect c
			
for c in camsAr do
(
	local sun
	local cam = c
	
	-- collecte du sun de la camera
	if isvalidnode (getNodeByName ( "VraySun_" + cam.name) ) then continue
	else if isvalidnode (getNodeByName "vraysun001") then 
	(
		sun = getNodeByName "vraysun001"
		-- placement du sun
		CamVc = cam.transform.row3
		CamVc.z = 0
		
		multi = 5000
		sun.pos.x =  CamVc.x*multi + sun.target.pos.x
		sun.pos.y =  CamVc.y*multi + sun.target.pos.y
		sun.pos.z = multi + sun.target.pos.z
		
		
		x1 = sun.pos.x - sun.target.pos.x
		y1 = sun.pos.y - sun.target.pos.y
		
		sun.pos.x = x1*(cos 30) - y1*(sin 30) + sun.target.pos.x
		sun.pos.y = x1*(sin 30) + y1*(cos 30) + sun.target.pos.y
		
		-- copie du sun
		maxOps.cloneNodes #(sun) cloneType: #copy newNodes:&copySun
		for s in copysun where not iskindof s Targetobject do s.name = ( "VraySun_" + c.name)
	)
	else (format "NO SUN! NO SUN AT ALL!\n")
)	