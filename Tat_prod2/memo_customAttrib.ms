def = custattributes.getDef $.modifiers[1] 1
-- def.attribID
def.classID

def.name = #Araignee

genClassID()

custattributes.makeUnique $.modifiers[1] 1

for s in selection do custattributes.makeUnique s.modifiers[1] 1
for s in selection do
(
	def = custattributes.getDef s.modifiers[1] 1
	-- def.attribID
	format "%\n" def.classID
)

custattributes.getDefSource def
custAttributes.delete  $.modifiers[1] 2

custAttributes.getSceneDefs () 


-- recupère definition
sel = selection as array
for s in sel do
(
	def = custattributes.getDef s.modifiers[1] 1
	custattributes.makeUnique s.modifiers[1] 1
	custattributes.getDefSource def
)



-- example de definition
ca = attributes testAt 
(
	Parameters main 
	(
	)
)
addmodifier $ (EmptyModifier())
custAttributes.add $.modifiers[1] ca

ca = custattributes.getDef $.modifiers[1] 1
attributes ca
Redefine:ca
(
	Parameters main rollout:params
	(
		autoStretch Type:#float UI: autostretchSP Default:0.0
		sortiePatte Type:#float UI: sortiepatteSP Default:1.0
	)
	Rollout Params "Custom Attributes"
	(
		spinner autostretchSP "auto stretch:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,0]
		spinner sortiepatteSP "sortie patte:" Width:160 Height:16 Align:#Center Offset:[0,0] Type:#float Range:[0,100,100]
	)
)


$.modifiers[1].ca.percent
