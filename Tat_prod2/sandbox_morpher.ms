-- return morph target

m = $.modifiers["Morpher #"]
m = modPanel.getCurrentObject() 
sel = WM3_MC_GetTarget m 1
select sel

-- return lookat upnode
select $.rotation.controller.pickUpNode 

-- return orientation target
ctrl = $.rotation.controller
res = for i = 1 to ctrl.getNumTargets() collect $.rotation.controller.getNode i
select res

-- select in scene bone selected in skin modifier
boneId = skinOps.GetSelectedBone $.modifiers[1]
res = skinOps.GetBoneName $.modifiers[1] boneId 0
select (getnodebyname res)

-- find path in path constraint

select  $.position.controller[2].controller.path

-- appliquer un modification par offset

sel = selection as array
srce = sel[1]
dest = sel[2]

undo on
(
	m = morpher ()
	addmodifier dest m
	redrawviews()
	WM3_MC_BuildFromNode m 1 srce
	WM3_MC_SetValue  m 1 100.0
	redrawviews()
	convertTopoly dest
	print "done"
)


--
m = modPanel.getCurrentObject() 
WM3_MC_Rebuild  m 1


WM3_MC_IsValid m 1
WM3_MC_GetTarget m 1
WM3_MC_SetName 

showproperties 
m.numSubs
m[50]

WM3_RefreshChannelListUI m


