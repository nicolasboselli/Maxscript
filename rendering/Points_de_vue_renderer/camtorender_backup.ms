-- creation du custom attribute
def = attributes ca
(
	parameters main
	(
		camToRender type: #nodeTab 
	)
)
camToRenderMod = EmptyModifier ()

custAttributes.add camToRenderMod def
addmodifier $ camToRenderMod

-- acces au custom attribute
$.modifiers[1].ca.camtorender

-- recuperation du point de backup dans la scene

