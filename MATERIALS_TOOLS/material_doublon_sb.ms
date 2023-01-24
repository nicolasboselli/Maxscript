/* for m in scenematerials do
(
	refName = m.name
	format "m: %\n" m.name
) */

for i = scenematerials.count to 1 by - 1 do
(
	refMat = scenematerials[i]
	 
	for j = scenematerials.count to 1 by - 1 do
	(
		testMat = scenematerials[j]
		
		if i == j then continue
		else if refMat.name == testMat.name then
		(
			replaceInstances testMat refMat 
			format "i: % j: % refMat: % testMat: %\n" i j refMat testMat
		)
		else()
		
	)
	
)