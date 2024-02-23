-- refs.dependents $

smeAr = ((sme.getview 1).GetSelectedNodes())

rootMat = smeAr[1].reference

nodesToRename = #(rootMat)

for o in nodesToRename do
(

	props = getPropNames o

	for p in props do
	(
		if p == #mapList then
		(
			mapList = getproperty o #mapList
			for m in mapList do
			(
				appendifunique nodesToRename m
-- 				format "m: %\n" m
			)
		)
		else
		(
			test = getproperty o p 
			
			if iskindof test textureMap then
			(
				appendifunique nodesToRename test
-- 				format "property %: % classof: %\n" p test (superclassof test)
			) 
		)
	)
) 

for o in nodesToRename do 
(
	format "o: %  classof: %\n" o  (classof o)
)

for i = 2 to nodesToRename.count do
(
	nodesToRename[i].name = (nodesToRename[1].name + ((random 1 10000)as string))
)