/*
fn transfertPoseFN target source =
(
	target.rotation = in coordsys world source.rotation
	target.position = in coordsys world source.position
)
*/

selArr = $selection as array


fn mountSplineHierarchyFN selArr =
(
	hiRank = 0
	
	do
	(
		parentArr = #()

		for o in selArr do
		(
			if (o.parent != undefined)and (classof o == splineshape) do append  parentArr o.parent
		)
		selArr = parentArr

		if (selArr.count > 0) do
		(
			hiRank += 1
-- 			print hiRank
		)

	)while(selArr.count > 0)
	
	return hiRank

)

mountSplineHierarchyFN selArr