macroScript sc_toggleBoneDisplay 
category:"ArmadasScripts" 
Buttontext:"Toggle Bone Display" 
tooltip:"Toggle Bone Display" 

(
	on execute do
	(
		fn hideBoneToggle =
		(
			bakSel = selection as array
			select geometry
			hideByCategory.bones = NOT ( hideByCategory.bones )
			if bakSel.count > 0 then select bakSel
			else clearselection()
		)
		hideBoneToggle()
	)
)

