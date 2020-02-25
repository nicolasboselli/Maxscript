fn checkPlan refName =
(
	local planesAr = #()
	for s in $plane_* do
	(
		local repName = getuserprop s "rep" 
		
		if repName != undefined then
		(
			-- tester si le nom est un array
			local testArray = execute repName
			
			-- si le nom est un nom seul le conditionner en array
			if  testArray == undefined and repName == refName then testArray = #(repName)
			
			-- traiter l'array
			if iskindof testArray array then
			(
				format "testArray: % \n" testArray
				for o in testArray where o == refname do append planesAr s
			)
			else()
		)
	)
	format "planesAr: %\n" planesAr 
	planesAr
)
-- checkPlan "batB_r00"



fn tagPlan p newName =
(
	local repName = getuserprop s "rep" 
	
	if repName == undefined then
	(
		-- initialiser l'array
		setuserprop p "rep" #(newName)
	)
	else
	(
		-- tester si on a un nom seul ou un array
		local testArray = execute repName
			
		-- si le nom est un nom seul le conditionner en array
		if  testArray == undefined and repName == refName then testArray = #(repName)
		
		-- ajouter un nom à l'array
		if iskindof testArray array then append testArray newName
			
		-- ecrire l'array
		setuserprop p "rep" testArray			
	)
)



foo = getuserprop $ "rep" 
classof #()
execute foo