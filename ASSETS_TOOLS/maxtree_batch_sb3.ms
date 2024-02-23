-- $.material.material1.option_opacityMode = 1

format "convert opacity to clip mode\n"
vrMatAr = getClassInstances VRayMtl 
for m in vrMatAr do m.option_opacityMode = 1

format "remove 2sided mat\n"
-- trouver les VRay2SidedMtl
sideAr = getClassInstances VRay2SidedMtl 
for s in sideAr do
(
	-- trouver le slot du multimaterial où est branché le vray2sided
	deps = refs.dependents s -- immediateOnly: true
	local multiMat


	for d in deps where iskindof d Multimaterial do
	(
		multiMat = d
		format "d:% classof: % \n" d (classof d)
	)

	idToReconnect = finditem  multiMat.materialList  s


	-- trouver le slot du vray2sided où est branché le vraymat front
	s.frontMtl

	-- connecter le vraymat dans le slot 2 du multimat
	multiMat.materialList[idToReconnect] = s.frontMtl
)
