def = attributes ca
(
	parameters main rollout: params
	(
		hitPoints type: #float ui:youpiSP default:10
	)
	
	rollout params "param"
	(
		spinner youpiSP "youpi!"
	)
)

md = EmptyModifier ()
modPanel.addModToSelection md
CustAttributes.add md def #unique

genClassID ()

plugin modifier  youpiMod
name:"youpi mod"
classID:#(0x176ff8dd, 0x7fe8a441)
version:2
(
	parameters main rollout: params
	(
		hitPoints type: #float ui:youpiSP default:10
		hitPoints2 type: #float  ui: youpiSP2 default:10
	)
	
	rollout params "param"
	(
		spinner youpiSP "youpi!"
		spinner youpiSP2 "youpi!2"
		button youpiBT "ploufe"
	)
)
