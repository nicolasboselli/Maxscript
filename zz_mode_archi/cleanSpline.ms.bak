fn cleanspline s =
(
	spCount = numSplines   s

	-- getKnotPoint  $ 1 1
	tres = 0.1

	for sp = 1 to spCount do
	(
		knCount =numknots s sp
		
		if knCount > 2 then
		(
			-- test de tous les points sauf le premier et le dernier
			for i  = (knCount - 1 ) to 2 by -1 do
			(	
				pt1 = getKnotPoint  s sp (i - 1)
				pt2 = getKnotPoint  s sp i
				pt3 = getKnotPoint s sp (i + 1)
			-- 	format "pt1:%, pt2:%, pt3:%\n" pt1 pt2 pt3
				
				vec1 = normalize( pt2 - pt1 )
				vec2 = normalize (pt3 - pt1)
			-- 	format "vec1: %, vec2: % \n" vec1 vec2
				
				ang = acos (dot vec1 vec2)
				
				
				if ang< tres then 
				(
					format "knot to del # i: %, ang: % \n" i ang
					deleteKnot s sp i
				)
				else format "knot to keep # i: %, ang: % \n" i ang
			)
	-- 		updateShape  s
			
			-- test du premier points
			knCount =numknots s sp
			if knCount > 2 then
			(
				pt1 = getKnotPoint  s sp  (knCount - 1)
				pt2 = getKnotPoint  s sp knCount
				pt3 = getKnotPoint s sp 1
				
				vec1 = normalize( pt2 - pt1 )
				vec2 = normalize (pt3 - pt1)
			-- 	format "vec1: %, vec2: % \n" vec1 vec2
				
				ang = acos (dot vec1 vec2)
				
				
				if ang< tres then 
				(
					format "knot to del # i: %, ang: % \n" knCount ang
					deleteKnot s sp knCount
				)
				else format "knot to keep # i: %, ang: % \n" knCount ang
			)
	-- 		updateShape  s
			
			-- test du dernier points
			knCount =numknots s sp
			(
				pt1 = getKnotPoint  s sp  knCount
				pt2 = getKnotPoint  s sp 1
				pt3 = getKnotPoint s sp 2
				
				vec1 = normalize( pt2 - pt1 )
				vec2 = normalize (pt3 - pt1)
			-- 	format "vec1: %, vec2: % \n" vec1 vec2
				
				ang = acos (dot vec1 vec2)
				
				
				if ang< tres then 
				(
					format "knot to del # i: %, ang: % \n" 1 ang
					deleteKnot s sp 1
				)
				else format "knot to keep # i: %, ang: % \n" 1 ang
			)
		)
	)
	
	updateShape  s
	format "spline clean done: %\n" s.name
)

sel = selection as array
for s in sel do cleanspline s


