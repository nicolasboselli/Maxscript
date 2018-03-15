fn postInbeetweenDef boxref postNum: 5 distTreshold: 15 =
(
	local lineSel = $
	local splineSelNum = numSplines lineSel

-- 	local ecart =20

	local splineSegNumAr = for i = 1 to splineSelNum collect (numKnots lineSel i ) - 1

	local numKnotsAr = for i = 1 to splineSelNum collect (numKnots lineSel i )

	local poteauNum = postNum

	for i = 1 to splineSelNum do
	(
		
		for j = 1 to splineSegNumAr[i] do
		(
			poteauNum = postNum
			startKnotPos = getKnotPoint lineSel i j
			endKnotPos = getKnotPoint lineSel i (j+1)
			
			distTemp =  (distance startKnotPos endKnotPos)
			postTreshold =  (int (floor (distTemp / distTreshold))) 
			print postTreshold
-- 			poteauNum = 5
			if postTreshold < poteauNum do poteauNum = postTreshold
			
			print poteauNum
			
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
				pointPoint = instance boxref
				pointPoint.transform = tempMatrix
				pointPoint.position = posOnSpline
			)
			
		)

	)
)


try(destroydialog potoCornerRLT)catch()
rollout potoCornerRLT "posts inbeetween"
(
	-- 	vars
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	
	local boxRef = undefined
	local postNum
	
-- 	pickbutton  poteauRefCB "ref"
	button addRefBT "ref>>"  across: 2
	button clearBT "clear"
	edittext refNameET "ref:" readonly: true text: "[NONE]"
	spinner postNumSP "post number max:" type: #integer range:[1,1000,5]
	spinner postTresholdSP "dist treshold:" type: #worldunits range:[0.1,1000,15]
	button multiplyBT "Multiply!" 
	
	fn checkBoxRef =
	(
		-- test if boxref exists
		if  boxRef != undefined do
		(
			try
			(
				classof boxRef
				boxRef
			)			
			catch
			(
				boxRef = undefined
				format "*** % ***\n" (getCurrentException())
			)
		)
		
		-- if boxref doesn t exists create it
		if boxRef == undefined do 
		(
			boxOrigin =  box  length: 3 width: 3 height: 80 name: "post_inb_base"
			refNameET.text = boxOrigin.name
			boxRef = boxOrigin
		)
		
		boxRef

	)
	
	on potoCornerRLT open do
	(
		-- load ini file
		try
		(
			postNumSP.value =  		(getINISetting armadasScriptsIni "postsInBeetween" "postNum") 		as integer
			postTresholdSP.value = 			(getINISetting armadasScriptsIni "postsInBeetween" "postTresh") 	as float
		)
		catch
		( 	
			postNumSP.value = 5
			postTresholdSP.value = 15
			format "*** % ***\n" (getCurrentException())
		)
	)
	
	on potoCornerRLT close do
	(
		-- maj ini file
		setINISetting armadasScriptsIni "postsInBeetween" "postNum" 			(postNumSP.value as string)
		setINISetting armadasScriptsIni "postsInBeetween" "postTresh" 		(postTresholdSP.value as string)
		print "maj ini done"
	)
	
	on addRefBT pressed do
	(
		if selection.count == 1 then 
		(
			boxRef = selection[1]
			refNameET.text = boxRef.name
		)
		else
		(
			print "non conform selection"
		)
	)
	
	on clearBT pressed do
	(
		boxRef = undefined
		refNameET.text = "[NONE]"
	)
	
	on multiplyBT pressed do
	(
		local boxOrigin = undefined
		
		/*
		if boxRef == undefined do 
		(
			boxOrigin =  box  length: 3 width: 3 height: 80 name: "post_inb_base"
			refNameET.text = boxOrigin.name
			boxRef = boxOrigin
		)
		*/
		boxRef = checkBoxRef()
		
		local boxCopy = copy boxRef
		undo on
		(
			postInbeetweenDef boxCopy postNum: postNumSP.value distTreshold: postTresholdSP.value
		)
		delete boxCopy
		if boxOrigin != undefined do delete boxOrigin
	)
	
)

createdialog potoCornerRLT

test = $
classof test
