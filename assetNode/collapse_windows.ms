Content_Node_Attr = attributes "Collapse_windows" 
(
	parameters main --rollout: allContentRLT
	(	
		mdlList type: #nodeTab tabSizeVariable:true
		ctrlList type: #intTab tabSizeVariable:true
		sizeList type: #intTab tabSizeVariable:true
		nameList type: #stringTab tabSizeVariable:true
	)
	
	rollout windowsRLT "windows"
	(
		button collapseBT "collapse"
	)
)

collapse_windows_mod = EmptyModifier name: "Collapse_windows"
custAttributes.add collapse_windows_mod Content_Node_Attr
addmodifier $ collapse_windows_mod



mdlArr = #()
r = $A_FenetreDouble_ROOT
for s in selection do
(
	local id = finditem r.modifiers["content_Node"].allContentList s
	append mdlArr id
)
with printAllElements on mdlArr as string
	
ctrlArr = #()
r = $A_FenetreDouble_ROOT
for s in selection do
(
	local id = finditem r.modifiers["content_Node"].allContentList s
	append ctrlArr id
)
with printAllElements on ctrlArr as string