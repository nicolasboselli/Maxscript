fn cleanFaceBorder s facesel tres: 0.1 = 
(
-- 	local faceSel  = polyop.getFaceSelection s

	for f in facesel do
	(
		vertTodel = #()
		vertSel  = polyop.getFaceVerts s f
-- 		format "face: %, vert sel:%\n" f vertSel
		
		for i  = 1 to  (vertSel.count) do
		(
			if i == 1 then 
			(
				pt1 = s.editablePoly.GetVertex vertSel[vertSel.count]
				pt2 = s.editablePoly.GetVertex vertSel[i]
				pt3 = s.editablePoly.GetVertex vertSel[i + 1]
			)
			else if i == vertSel.count then
			(
				pt1 = s.editablePoly.GetVertex vertSel[i - 1]
				pt2 = s.editablePoly.GetVertex vertSel[i]
				pt3 = s.editablePoly.GetVertex vertSel[1]
			)
			else
			(
				pt1 = s.editablePoly.GetVertex vertSel[i - 1]
				pt2 = s.editablePoly.GetVertex vertSel[i]
				pt3 = s.editablePoly.GetVertex vertSel[i + 1]
			)
				
	-- 		format "v1:%, v2:%, v3:%\n" pt1 pt2 pt3
			
			vec1 = normalize( pt2 - pt1 )
			vec2 = normalize (pt3 - pt1)
			-- 	format "vec1: %, vec2: % \n" vec1 vec2

			ang = acos (dot vec1 vec2)

			if ang< tres then append vertTodel vertSel[i]
			else 
			(
-- 				format "vert to keep # i: %, ang: % \n" i ang
			)
		)
		
		format "vert to del # i: %\n" vertTodel
		polyop.setVertSelection  s vertTodel
		s.editablePoly.remove  selLevel: #vertex
	)
)
cleanFaceBorder $ (polyop.getFaceSelection $)

-- polyop.deleteVerts s vertTodel