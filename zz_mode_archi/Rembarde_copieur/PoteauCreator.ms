-- instances
pointTemp = box  length: 5 width: 5 height: 80


lineSel = $

splineSelNum = numSplines lineSel

ecart =120

splineSegNumAr = for i = 1 to splineSelNum collect (numKnots lineSel i ) - 1

numKnotsAr = for i = 1 to splineSelNum collect (numKnots lineSel i )

-- pointTemp = point size: 20 cross: true box: false axis_tripod: false


for i = 1 to splineSelNum do
(
	local poteauNum
	
	for j = 1 to splineSegNumAr[i] do
	(
		startKnotPos = getKnotPoint lineSel i j
		endKnotPos = getKnotPoint lineSel i (j+1)
		
		distTemp =  (distance startKnotPos endKnotPos)
		poteauNum =  (int (floor (distTemp / ecart))) 
		
		percentCurInc = 1.0 / poteauNum
		percentCur= 0
		
		for h = 1 to (poteauNum - 1) do
		(
			percentCur = percentCur + percentCurInc
			posOnSpline = interpBezier3D lineSel i  j percentCur pathParam:true

			pointX1 = tangentBezier3D lineSel i j percentCur pathParam:true

			pointZ2 = [0,0,1]

			pointY =cross  pointZ2  pointX1

			pointZ1 = cross pointX1  pointY

			pointX2 = cross  pointY  pointZ2
				
				
			-- 	position parallèle à l'axe z du monde
			tempMatrix = matrix3 1
			tempMatrix.row1 = normalize pointX2
			tempMatrix.row2 = normalize pointY
			tempMatrix.row3 = normalize pointZ2
			tempMatrix.row4 = posOnSpline
			orthogonalize tempMatrix

	-- 		test = point axis_tripod: true cross: false size: 5  transform:tempMatrix  name: "test1" wirecolor: (color 0 0 255)
			pointPoint = instance pointTemp
			pointPoint.transform = tempMatrix
			pointPoint.position = posOnSpline
		)
		
	)

)

delete pointTemp



