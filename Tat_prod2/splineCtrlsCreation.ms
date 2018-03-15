-- create point on knot spline
pointCreated = #()
oneLine = $
splineCount = numSplines oneLine

for i = 1 to splineCount do
(
	knotsCount = numKnots oneLine i
	for k = 1 to knotsCount do
	(
		-- ctrl pôur knot
		newSuf = "_" + (k as string) + "_RIG"
		ptName = substitutestring oneLine.name "_RIG" newSuf
		
		pos = getKnotPoint oneLine i k
		format "spline: %, knot:%, pos: %\n" i k pos
		
		pt = point pos: pos axistripod: false cross: false box: true center: false \
		name: ptName wirecolor: green size: ((curvelength oneline i)*0.1)
		append pointCreated pt
		
		-- ctrl pour tangent in 
		newSuf = "_" + (k as string) + "_TangentIn_RIG"
		ptName = substitutestring oneLine.name "_RIG" newSuf
		
		pos = getInVec oneLine i k
		format "spline: %, knotIn:%, pos: %\n" i k pos

		pt = point pos: pos axistripod: false cross: false box: true center: false \
		name: ptName wirecolor: green size: ((curvelength oneline i)*0.05)
		append pointCreated pt
		
		-- ctrl pour tangent out 
		newSuf = "_" + (k as string) + "_TangentOut_RIG"
		ptName = substitutestring oneLine.name "_RIG" newSuf
		
		pos = getOutVec oneLine i k
		format "spline: %, knotOut:%, pos: %\n" i k pos

		pt = point pos: pos axistripod: false cross: false box: true center: false \
		name: ptName wirecolor: green size: ((curvelength oneline i)*0.05)
		append pointCreated pt
		
	)
)
select pointCreated