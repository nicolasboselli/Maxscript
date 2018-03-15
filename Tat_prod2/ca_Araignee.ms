-- genClassID()

------------------------------------------------ /* custom attributes de l'oeil */
-- creation
ca = attributes Araignee attribID:#(0x4785ea81, 0x7f462b3c)
(
	Parameters main
	(
	)
)
addmodifier $ (EmptyModifier())
custAttributes.add $.modifiers[1] ca

-- update
ca = custattributes.getDef $.modifiers[1] 1
attributes ca
Redefine:ca
(
	Parameters main rollout:params
	(
		SortieOeil Type:#float UI:SortieOeilSP Default:0.0
		StretchOeil Type:#float UI:StretchOeilSP Default:0.0
	)
	Rollout Params "Custom Attributes"
	(
		spinner SortieOeilSP "Sortie Oeil:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,0]
		spinner StretchOeilSP "Stretch:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,0]
	)
)
	
$.modifiers[1].Araignee.SortieOeil.controller = bezier_float()
$.modifiers[1].Araignee.StretchOeil.controller = bezier_float()
	
target = #($P_Araignee_D_Oeil_CTRL, $P_Araignee_G_Oeil_CTRL)


--------------------------------------------------- /* custom attributes des pattes */

-- creation
ca = attributes Araignee attribID:#(0x72e0af73, 0x76d0abd2)
(
	Parameters main
	(
	)
)
addmodifier $ (EmptyModifier())
custAttributes.add $.modifiers[1] ca

-- update
ca = custattributes.getDef $.modifiers[1] 1
attributes ca
Redefine:ca
(
	Parameters main rollout:params
	(
		autoStretch Type:#float UI: autostretchSP Default:0.0
		sortiePatte Type:#float UI: sortiepatteSP Default:100.0
	)
	Rollout Params "Custom Attributes"
	(
		spinner autostretchSP "auto stretch:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,0]
		spinner sortiepatteSP "sortie patte:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,100]
	)
)

$.modifiers[1].Araignee.autoStretch.controller = bezier_float()
$.modifiers[1].Araignee.sortiePatte.controller = bezier_float()

target = #($P_Araignee_D_PattesA_BIP, $P_Araignee_G_PattesA_BIP, $P_Araignee_D_PattesB_BIP, $P_Araignee_G_PattesB_BIP)

	
	