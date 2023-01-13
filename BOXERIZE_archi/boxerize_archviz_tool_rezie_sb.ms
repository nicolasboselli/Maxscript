fn resizeGabarit s size: 35 =
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
)


sel = selection as Array

for s in sel do
(
	resizeGabarit s
)
redrawViews()



