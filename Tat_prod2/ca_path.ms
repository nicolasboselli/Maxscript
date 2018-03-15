ca = attributes ca
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
		percent Type:#float UI: percentSP Default:0.0
	)
	Rollout Params "Custom Attributes"
	(
		spinner percentSP "Path:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,0]
	)
)

-- Assign it to the first modifier on a selected object
-- custAttributes.add $.modifiers[1] d
-- Get the definition from the scene
sceneDef=custAttributes.getDef $.modifiers[1] 1
-- Check what classId it has
sceneDef.classId

-- Make the definition unique in the scene
custAttributes.makeUnique $.modifiers[1] 3
-- Get the new scene definition
newSceneDef=custAttributes.getDef $.modifiers[1] 1
-- Check the classId for it.
newSceneDef.classId