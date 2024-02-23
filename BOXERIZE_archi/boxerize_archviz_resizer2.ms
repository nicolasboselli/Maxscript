/*
CONDITIONS pour executer le script:
- la selection est en mesh
- la selection est isgabarit

*/

sel = selection as Array
for s in sel do
(
	convertToMesh s
	facesCount = meshop.getNumfaces s
	refNormal= s.transform.row1
	goodBitAr = #{}
	for i = 1 to facesCount do
	(
		oneNormal = meshop.getFaceRNormals s i
-- 		format "refNormal: %  oneNormal: %\n" refNormal oneNormal[1]
		local testAngle
		
		if (meshop.getFaceArea s i) < 1 then
		(
-- 			format "i: % s.facearea: %\n"  i (meshop.getFaceArea s i)
			testAngle = 0
		)
		else if ((dot oneNormal[1] refNormal) < -1.0) then
		(
-- 			format "i: % dot oneNormal[1] refNormal = %\n" i (dot oneNormal[1] refNormal)
			testAngle = 180.0
-- 			format "testAngle: %\n" testAngle
		)
		else
		(
			testAngle = ((((acos(dot oneNormal[1] refNormal))*100)as integer)as float)/100
-- 			format "i: % testAngle: %\n" i testAngle
		)
	 		
	 	
		if testAngle > 179 and testAngle < 181 then append goodBitAr i
-- 		format "goodBitAr: %\n" goodBitAr
	)
	
	vxBitAr = meshop.getVertsUsingFace  s goodBitAr
	format "vxBitAr: % \n" vxBitAr 
			
	-- calcul du decalage à appliquer
	vertsCount = meshop.getNumVerts s
	vertsList = (for i = 1 to vertsCount collect i)as bitarray

	xmax = -1000
	xmin = 1000
	size = 35
	for v in vertsList do
	(
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)
		if localPos.translation.x < xmin then xmin = localPos.translation.x
		if localPos.translation.x > xmax then xmax = localPos.translation.x
	)
	format "xmax: % xmin: %\n" xmax xmin 
	res35 = distance (point3 xmax 0 0) (point3 xmin 0 0)
	shift = res35 - size
	
	format "vxBitAr: % shift: %\n" vxBitAr shift
	
-- 	move s.faces[goodBitAr]  [5,0,0]
	
	for v in vxBitAr do
	(
		
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)

		localPos.translation.x = localPos.translation.x + shift
		newPos = localPos * s.transform
		meshop.setVert s v newPos.translation
		
		format "v:% newPos.translation: %\n" v newPos.translation
	)
	redrawViews()
	
)


-- b = #{2, 4, 6, 8}
-- for i in b do print i

/* fn resizeGabarit s size: 35 =
(
	converttomesh s
	vertsCount = meshop.getNumVerts s
	vertsList = (for i = 1 to vertsCount collect i)as bitarray

	-- calcul du decalage
	xmax = -1000
	xmin = 1000
	for v in vertsList do
	(
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)
		if localPos.translation.x < xmin then xmin = localPos.translation.x
		if localPos.translation.x > xmax then xmax = localPos.translation.x
	)
	res35 = distance (point3 xmax 0 0) (point3 xmin 0 0)
	shift = res35 - size
	
	-- deplacement les vertex negatif
	for v in vertsList do
	(
		oneVMat = copy s.transform
		oneVMat.translation = meshop.getVert s v 
		localPos = (oneVMat * inverse s.transform)
		if localPos.translation.x <(xmax - 1) then 
		(
			localPos.translation.x = localPos.translation.x + shift
			newPos = localPos * s.transform
			meshop.setVert s v newPos.translation
		)
	)
	redrawViews()
) */



-- getFaceNormal 

-- (dot [-0.932616,0.360871,0] [0.932616,-0.360871,0]) < -1.0


-- acos -0.999999
-- move $.baseObject.mesh.faces[#{7..8}] [-35,0,0]
