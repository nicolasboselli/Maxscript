ikBridge = EmptyModifier name: "IK_Leg_bridge"


-- global IKFKDataTmp
attr = attributes "ikbridge"
(
	parameters param
	(
		ikStretch type:#float  default:0
		ikSquash type:#float default:0 
		tension type:#float default:1
		
		cuisseSize type:#float   default:0
		tibiaSize type:#float  default:0
	)
	
	on create do
	(
		ikStretch.controller = bezier_float()
		ikSquash.controller = bezier_float()
		tension.controller = bezier_float()
		cuisseSize.controller = bezier_float()
		tibiaSize.controller = bezier_float()
	)
)
custAttributes.add ikBridge attr
addmodifier $ ikBridge