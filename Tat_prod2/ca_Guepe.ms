-- genClassID()

------------------------------------------------ /* custom attributes de l'oeil */
-- creation
ca = attributes Guepe attribID:#(0x537d97c, 0x522f049b)
(
	Parameters main
	(
	)
)
addmodifier $ (EmptyModifier())
custAttributes.add $.modifiers[1] ca

-- update
ca = custattributes.getDef $.modifiers[1] 1
attributes Guepe
Redefine:ca
(
	Parameters main rollout:params
	(
		Squash Type:#float UI:SquashSP Default:0.0
-- 		StretchOeil Type:#float UI:StretchOeilSP Default:0.0
	)
	Rollout Params "Custom Attributes"
	(
		spinner SquashSP "Squash:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,0]
-- 		spinner StretchOeilSP "Stretch:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,0]
	)
)
	
$.modifiers[1].Araignee.Squash.controller = bezier_float()
	
target = #($P_Guepe_D_EyeSquash_CTRL)

