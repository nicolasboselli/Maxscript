

rollout addSub360RLT "Ajouter Supprimer 360 degres"
(
-- 	function
	function ctrlChangeValFN s RotCtrl CtrlVal =
	(	
		local keyRotSel = #()
		
		local rotControl = s.rotation.controller.zero_euler_XYZ.controller
		
		local rotControlTrack = case RotCtrl of
		(
			1 :   rotControl.x_rotation.controller
			2 :   rotControl.y_rotation.controller
			3 :   rotControl.z_rotation.controller
		)
		print rotControlTrack
		
		local turnVal = case CtrlVal of
		(
			1: 180
			2: -180
		)
		print turnVal
		
		local allControlKey =  numKeys rotControlTrack
		print allControlKey
		
		for i = 1 to allControlKey do 
		(
			if ((isKeySelected rotControlTrack i) == true) then
			(
				append keyRotSel i
			)
		)
		print keyRotSel

		keyToMod = for o in keyRotSel collect getKey rotControlTrack o
		print keyToMod
			
		for o in keyToMod do
		(
			print o.value
			o.value = o.value  + turnVal
			print o.value
		)
	)
	
-- 	UI
	button rotXNegBT "x - 180" across: 2
	button rotXPlusBT "x + 180"
	button rotYNegBT "y - 180" across: 2
	button rotYPlusBT "y + 180"
	button rotZNegBT "z - 180" across: 2
	button rotZPlusBT "z + 180"

-- 	events
	on rotXNegBT pressed do
	(
		if ($selection as array).count == 1 then 
		(
		ctrlChangeValFN $ 1 2
		)
		else messagebox "selectionner un seul objet"
	)
	
	on rotXPlusBT pressed do
	(
		if ($selection as array).count == 1 then 
		(
		ctrlChangeValFN $ 1 1
		)
		else messagebox "selectionner un seul objet"
	)
	
	on rotYNegBT pressed do
	(
		if ($selection as array).count == 1 then 
		(
		ctrlChangeValFN $ 2 2
		)
		else messagebox "selectionner un seul objet"
	)
	
	on rotYPlusBT pressed do
	(
		if ($selection as array).count == 1 then 
		(
		ctrlChangeValFN $ 2 1
		)
		else messagebox "selectionner un seul objet"
	)
	
	on rotZNegBT pressed do
	(
		if ($selection as array).count == 1 then 
		(
		ctrlChangeValFN $ 3 2
		)
		else messagebox "selectionner un seul objet"
	)
	
	on rotZPlusBT pressed do
	(
		if ($selection as array).count == 1 then 
		(
		ctrlChangeValFN $ 3 1
		)
		else messagebox "selectionner un seul objet"
	)
	
)

createdialog addSub360RLT

/*
numSelKeys  rotControl.x_rotation.controller
numSelKeys  rotControl.y_rotation.controller
numSelKeys  rotControl.z_rotation.controller

*/