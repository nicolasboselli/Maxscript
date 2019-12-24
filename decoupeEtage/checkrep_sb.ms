fn checkPlan refName =
(
	local planesAr = #()
	for s in $plane_* do
	(
		local repName = getuserprop s "rep" 

		if repName != undefined then
		(
		
			if  repName == refName then 
			(
				format "s: % repName: %\n" s.name repName
				append planesAr s
			)
		)
	)
	planesAr
)

checkPlan "batAB_r01"

for r in rep do
(
	local l = layermanager.getLayerFromName r.name
	l.on = false
)	