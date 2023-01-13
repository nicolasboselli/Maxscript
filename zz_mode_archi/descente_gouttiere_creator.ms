-- descente gouttiere creator
-- maj:
	-- creer une descente de gouttiere apres cahque knot
	-- rendre le declage editable

-- masse = $masse3

-- l = $
-- spCount = numSplines l
-- pointList = #()
-- l.name
-- s = splineShape() --create a spline shape

-- massePt = [20,20,20]
-- massePt.z = 0


fn createGouttiere  l masse Xshift: 50 Yshift1: -10 Yshift2: 10 Zshift1: 10 Zshift2: -10 Zshift3: -20  =
(
	local spCount = numSplines l
	local pointList = #()
-- 	l.name
	local s = splineShape() --create a spline shape

	for sp = 1 to spCount do
	(
		local knotCount = numKnots l sp
		
		-- decalage
-- 		local Xshift = 50	
-- 			
-- 		local Yshift1 = - 10
-- 		local Yshift2 =  10
-- 			
-- 		local Zshift1 = 10
-- 		local Zshift2 = - 10
-- 		local Zshift3 = - 20
		
		local Pt1pos = [Xshift, Yshift1, Zshift1]
		local Pt2pos = [Xshift, Yshift1, Zshift2]
		local Pt3pos = [Xshift, Yshift2, Zshift3]
		
		local massePos
		
		for k = 1 to (knotCount ) do
		(	
			format "sp: % knot: %\n" sp k
			-- 	local k1 = k
			local k2 = k + 1
			
			-- sur une spline fermée quand on arrive au dernier point repartir vers 1
			if k == knotCount then if isClosed l  sp then   k2 = 1 else continue
			
			local knotPos = getKnotPoint l sp k
			
			-- direction de la spline	
			local dirZ = [0,0,1]
			local dirX = normalize ((getKnotPoint l sp (k2)) - (getKnotPoint l sp k))
			local dirY = normalize (cross dirZ dirX)
				
			local TM = matrix3 dirX dirY dirZ knotPos
			
			-- tracer un rayon jusqu au sol
			local testRay = ray (Pt3pos * TM) [0,0,-1]
			if masse != undefined then
			(
				local masseImpact = intersectRay masse testRay
				massePos = (masseImpact.pos) + [0,0,-50]
			)
			else
			(
				massePos = (Pt3pos * TM) + [0,0,-50]
				massePos.z = -50
			)
			
			-- creation des points
			newSp = addNewSpline s

			addKnot s newSp #corner #line  (Pt1pos * TM) 
			addKnot s newSp #corner #line  (Pt2pos * TM) 
			addKnot s newSp #corner #line  (Pt3pos * TM) 
			addKnot s newSp #corner #line  massePos
		)
	)
	-- redrawviews()
	updateshape s
	tmpSweep = sweep  name: (uniquename "ep_line_")
	addmodifier s (sweep())
	redrawViews()
	
	s.sweep.CurrentBuiltInShape = 2
-- 	s.sweep[#Bar_Section].width = 10
	s.sweep.PivotAlignment = 4
)

try(destroydialog gouttiereRLT)catch()
rollout gouttiereRLT "descente gouttiere assistant"
(
	global masse
	
	group "masse"
	(
		button selectMasseBT "select masse"
		edittext masseNameET "masse:" readonly: true
	)
	
	group "options"
	(
		spinner XshiftSP "Xshift" type: #worldunits range:[-1000,1000,50]
		
		spinner Yshift1SP "Yshift1" type: #worldunits range:[-1000,1000,- 10]
		spinner Yshift2SP "Yshift2" type: #worldunits range:[-1000,1000,10]
		
		spinner Zshift1SP "Zshift1" type: #worldunits range:[-1000,1000,10]
		spinner Zshift2SP "Zshift2" type: #worldunits range:[-1000,1000,- 10]
		spinner Zshift3SP "Zshift3" type: #worldunits range:[-1000,1000,- 20]
		
	)
	
	button gouttiereBT "create"
	
	fn refreshUI =
	(
		if isvalidnode masse then masseNameET.text = masse.name
	)
	
	on gouttiereRLT open do
	(
		refreshUI()
	)
	
	on selectMasseBT pressed do
	(
		local sel = selection as array
		if sel.count == 1 then
		(
			if (superclassof sel[1] ==  GeometryClass) then masse = sel[1]
		)
		else(format "select only one object\n")
		
		refreshUI()
	)
	
	on gouttiereBT pressed do
	(
		local sel = selection as array
		for l in sel where isKindOf l SplineShape do createGouttiere l masse \
		Xshift: XshiftSP.value Yshift1: Yshift1SP.value Yshift2: Yshift2SP.value Zshift1: Zshift1SP.value Zshift2: Zshift2SP.value Zshift3: Zshift3SP.value
	)
)
createdialog gouttiereRLT
