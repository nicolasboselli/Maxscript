try(destroydialog windowsResizerRLT)catch()
rollout windowsResizerRLT "windows resizer"
(
	local grouphead
	local xmax, xmin, ymax, ymin, zmax, zmin 	
	
	spinner moreXSP "+X" range:[-1000,1000,0] across: 2 type: #worldunits
	spinner lessXSP "-X" range:[-1000,1000,0] 			type: #worldunits
	spinner moreYSP "+Y" range:[-1000,1000,0] across: 2 type: #worldunits
	spinner lessYSP "-Y" range:[-1000,1000,0]			type: #worldunits
	spinner moreZSP "+Z" range:[-1000,1000,0] across: 2 type: #worldunits
	spinner lessZSP "-Z" range:[-1000,1000,0]			type: #worldunits
	
	
	on moreXSP buttondown do
	(

-- 		format "check1\n"
		sel = selection as array
		for i = sel.count to 1 by -1 do
		(
			if isgrouphead sel[i]  then
			(
				grouphead = sel[i]
				deleteItem sel i
				exit
			)
			else 
			(
				
			)
		)
-- 		format "check2\n"
		format "grouphead: %sel: %\n" grouphead sel
		
		xmax = -1000

		
		for s in sel do
		(
			onebb = (nodeGetBoundingBox s grouphead.transform)
			if onebb[1].x > xmax then xmax =  onebb[1].x
			if onebb[2].x > xmax then xmax =  onebb[2].x

		)	
	)
	
	on moreXSP changed val do
	(
-- 		format "val:%\n" val
		
		sel = selection as array
		xMaxRange = -15.0
				
		for s in sel where not iskindof s dummy do
		(
			vertPosList = #()
			vertBit = #()
			numVert = s.GetNumVertices ()

			-- test et deplacement de chaque vertex
			for i = 1 to numVert do
			(
-- 				format "i:%\n" i
				vPos = ((polyop.getvert s  i) * inverse groupHead.transform)
		
				-- determiner s'il doit y avoir un saut du vertex sur l'axe x
				if vPos.x >= xmax + xMaxRange and val >= xMaxRange then
				(
					append vertBit i
					append vertPosList ((vPos + [val, 0, 0])*grouphead.transform)
				)
				else(/*format "fail!\n"*/)
			)

			polyop.setvert s vertBit vertPosList
		)
	)
	
	on moreXSP buttonup do
	(
-- 		format "check6\n"
		moreXSP.value = 0.0
-- 		format "check7\n"
	) 
)
CreateDialog windowsResizerRLT width: 300


