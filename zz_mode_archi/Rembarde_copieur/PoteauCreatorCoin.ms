-- bug:	
	-- missing first or last post corner
	-- do not work on closed spliene

rollout potoCornerRLT "poteaux corner"
(
	local boxRef = undefined
	
-- 	pickbutton  poteauRefCB "ref"
	button addRefBT "ref>>"
	edittext refNameET "ref:" readonly: true
	button multiplyBT "Multiply!"
	
-- 	on poteauRefCB picked obj do
-- 	(
-- 		poteauRefCB.text = obj.name
-- 		boxRef = getNodebyname obj.name
-- 	)
-- 	
	on addRefBT pressed do
	(
		sel = selection as array
		if sel.count == 1 then
		(
			boxRef = sel[1]
			refNameET.text = boxRef.name
		)
		else
		(
			print "non conform selection"
		)
	)
	
	on multiplyBT pressed do
	(

		local boxOrigin = undefined
		
		if boxRef == undefined do 
		(
			boxOrigin =  box  length: 3 width: 3 height: 80 name: "post_inb_base"
			refNameET.text = boxOrigin.name
			boxRef = boxOrigin
		)

		local lineSel = undefined
		sel = selection as array
		
		for s in sel do
		(
			-- test spline shape class
			-- action on each element of the array
			lineSel = s
		)
		

		splineSel = 1
		splineSelNum = numSplines lineSel

		splineSeg = 2
		splineSegNumAr = for i = 1 to splineSelNum collect (numKnots lineSel i ) - 1

		percentCur = 0.99

		-- posOnSpline = interpBezier3D lineSel splineSel splineSeg percentCur pathParam:true
		copyBoxRef = copy boxRef
		
		posOnSplineAr = #()
		for splineNum = 1 to splineSegNumAr.count do 
		(
			for i = 1 to splineSegNumAr[splineNum] do
			(
				
				posOnKnot = 	getKnotPoint lineSel splineNum i
				
				posOnSpline = interpBezier3D lineSel splineNum  i percentCur pathParam:true
				
				pointX1 = tangentBezier3D lineSel splineNum i percentCur pathParam:true

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
				
				boxTemp = instance copyBoxRef
				boxTemp.transform = tempMatrix
				boxTemp.position = posOnKnot
			)
		)
		delete copyBoxRef
		
	)
)
createdialog potoCornerRLT


/*
splineSel = $selection as array

boxRef = box length: 5 width: 5 height: 100 name: "poteau"

for o in splineSel doG
(
	numSpline = numSplines o
	for i = 1 to numSpline do
	(
		numKnotsSpline = numKnots o i
		for j = 1 to numKnotsSpline do
		(
			boxTemp = instance boxRef
			boxTemp.position = (getKnotPoint o i j)
			
		)
	)
)

InstanceMgr.GetInstances boxRef &boxInstances

select boxInstances
delete boxRef
*/
/*
numKnots $
numSplines $
getKnotPoint $ 1 1
*/


-- points
/*
pointOne = point position:(interpBezier3D lineSel 1 splineSeg 0.50 pathParam:true) name: "pointOne" size: 1 axis_tripod: false cross: true

pointX1 = point position:((tangentBezier3D lineSel 1 splineSeg 0.50 pathParam:true) + pointOne.position) name: "pointX1" size: 1 axis_tripod: false cross: true

pointZ2 = point position:(pointOne.position + [0,0,1])  name: "pointZ2" size: 1 axis_tripod: false cross: true

pointY = point position:(pointOne.pos + (cross  (pointZ2.pos - pointOne.pos) (pointX1.pos - pointOne.pos) ))  name: "pointY" size: 1 axis_tripod: false cross: true

pointZ1 = point position: (pointOne.pos + (cross (pointX1.pos - pointOne.pos)  (pointY.pos - pointOne.pos)  ))  name: "pointZ1" size: 1 axis_tripod: false cross: true

pointZ2 =  point position: (pointOne.pos + (cross  (pointY.pos - pointOne.pos) (pointZ2.pos - pointOne.pos) ))  name: "pointZ2" size: 1 axis_tripod: false cross: true
*/

--coordonnées
/*
boxRef = box length: 5 width: 5 height: 100 name: "poteau"

lineSel = $

splineSel = 1
splineSelNum = numSplines lineSel

splineSeg = 2
splineSegNumAr = for i = 1 to splineSelNum collect (numKnots lineSel i ) - 1

percentCur = 0.99

-- posOnSpline = interpBezier3D lineSel splineSel splineSeg percentCur pathParam:true

posOnSplineAr = #()
for splineNum = 1 to splineSegNumAr.count do 
(
	for i = 1 to splineSegNumAr[splineNum] do
	(
		
		(
		posOnKnot = 	getKnotPoint lineSel splineNum i
		
		posOnSpline = interpBezier3D lineSel splineNum  i percentCur pathParam:true
		
		pointX1 = tangentBezier3D lineSel splineNum i percentCur pathParam:true

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
		
		boxTemp = instance boxRef
		boxTemp.transform = tempMatrix
		boxTemp.position = posOnKnot
		*/
		/*
		-- position suivant l'orientation de la spline
		tempMatrix = matrix3 1
		tempMatrix.row1 = normalize pointX1
		tempMatrix.row2 = normalize pointY
		tempMatrix.row3 = normalize pointZ1
		tempMatrix.row4 = posOnSpline
		orthogonalize tempMatrix

		test2 = point axis_tripod: true cross: false size: 5 transform:tempMatrix name: "test2" wirecolor: (color 0 255 0)
		*/
		/*
		)
	)
)

delete boxRef
*/

/*
<<<<<<< HEAD
=======
rollout potoCornerRLT "Posts Corner"
(
	local boxRef = undefined
	
-- 	pickbutton  poteauRefCB "ref"
	button addRefBT "ref>>"
	edittext refNameET "ref:" readonly: true
	button multiplyBT "Multiply!"
	
-- 	on poteauRefCB picked obj do
-- 	(
-- 		poteauRefCB.text = obj.name
-- 		boxRef = getNodebyname obj.name
-- 	)
-- 	
	on addRefBT pressed do
	(
		sel = $selection as array
		if sel.count == 1 then
		(
			boxRef = sel[1]
			refNameET.text = boxRef.name
		)
		else
		(
			print "non conform selection"
		)
	)
	
	on multiplyBT pressed do
	(
		if boxRef == undefined do 
		(
			boxRef = box length: 5 width: 5 height: 100 name: "poteau_base"
			refNameET.text = boxRef.name
		)
			
				
		lineSel = $
>>>>>>> origin/master

*/
